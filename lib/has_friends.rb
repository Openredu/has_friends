require 'friendship'

module Friends
  def self.included(base)
    base.extend Friends::ClassMethods
  end

  module ClassMethods
    def has_friends
      include Friends::InstanceMethods

      has_many :friendships,
               class_name: 'Friendship'
      has_many :friends, -> { where(["friendships.status = 'accepted'"]) },
               through: :friendships,
               source: :friend
      has_many :friends_pending, -> { where(["friendships.status = 'pending'"]) },
               through: :friendships,
               source: :friend

      before_destroy :destroy_all_friendships
    end
  end

  module InstanceMethods
    def be_friends_with(friend)
      # no user object
      return nil, Friendship::STATUS_FRIEND_IS_REQUIRED unless friend

      # should not create friendship if user is trying to add himself
      return nil, Friendship::STATUS_IS_YOU if is?(friend)

      # should not create friendship if users are already friends
      return nil, Friendship::STATUS_ALREADY_FRIENDS if friends?(friend)

      # retrieve the friendship request
      friendship = self.friendship_for(friend)

      # let's check if user has already a friendship request or have removed
      request = friend.friendship_for(self)

      # friendship has already been requested
      return nil, Friendship::STATUS_ALREADY_REQUESTED if friendship && friendship.requested?

      # friendship is pending so accept it
      if friendship && friendship.pending?
        friendship.accept!
        request.accept!

        return friendship, Friendship::STATUS_FRIENDSHIP_ACCEPTED
      end

      # we didn't find a friendship, so let's create one!
      friendship = self.friendships.create(friend_id: friend.id, status: 'requested')

      # we didn't find a friendship request, so let's create it!
      request = friend.friendships.create(friend_id: id, status: 'pending')

      return friendship, Friendship::STATUS_REQUESTED
    end

    def friends?(friend)
      if friends.loaded?
        friends.include?(friend)
      else
        friendship = friendship_for(friend)
        friendship && friendship.accepted?
      end
    end

    def friendship_for(friend)
      if friendships.loaded?
        friendships.select{ |friendship| friendship.friend_id == friend.id }.first
      else
        friendships.where(friend_id: friend.id).first
      end
    end

    def is?(friend)
      self.id == friend.id
    end

    def friends_in_common_with(user)
      self.friends & user.friends
    end

    def friends_not_in_common_with(user)
      self.friends.where("users.id NOT IN (?)",
                         user.friends.collect(&:id) << user.id)
    end

    def friends_of_friends
      friends_ids = self.friends.collect(&:id)
      fof_ids = Friendship.select("friend_id").
          where("user_id IN (?)"" AND friend_id NOT IN (?)",
                friends_ids, friends_ids << self.id)

      User.where("id IN (?)", fof_ids.collect(&:friend_id))
    end

    # Destroyes (in both ways) the friendship
    def destroy_friendship_with(friend)
      friendship = friendship_for(friend)
      other_friendship = friend.friendship_for(self)
      friendship.try(:destroy)
      other_friendship.try(:destroy)
    end

    private

    # Destroyes all friendships of user
    def destroy_all_friendships
      Friendship.destroy_all({user_id: id})
      Friendship.destroy_all({friend_id: id})
    end
  end
end

ActiveRecord::Base.send(:include, Friends)
