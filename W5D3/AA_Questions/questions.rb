require 'sqlite3'
require 'singleton'
require 'byebug'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end

class User
    attr_accessor :id, :fname, :lname
    def self.find_by_id(id)
        user = QuestionsDatabase.instance.get_first_row(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        return nil if user.nil?
        User.new(user)
      end
      
      def self.find_by_name(fname, lname)
      user = QuestionsDatabase.instance.get_first_row(<<-SQL, fname, lname)
          SELECT
              *
          FROM
              users
          WHERE
              fname = ? AND lname = ?
      SQL
      return nil if user.nil?
      User.new(user)
      end

      def initialize(options)
          @id = options['id']
          @fname = options['fname']
          @lname = options['lname']
      end

      def authored_questions
            raise "not in database" unless self.id
            questions = QuestionsDatabase.instance.execute(<<-SQL, self.id)
                SELECT
                    *
                FROM
                    questions
                WHERE
                    user_id = ?
            SQL
            questions.map {|question_instance| Question.new(question_instance)}
      end

      def authored_replies
            raise "not in database" unless self.id
            replies = QuestionsDatabase.instance.execute(<<-SQL, self.id)
                SELECT
                    *
                FROM
                    replies
                WHERE
                    user_id = ?
            SQL
            replies.map {|reply_instance| Reply.new(reply_instance)}
      end
end

class Question
  attr_accessor :id, :title, :body, :user_id
  def self.find_by_id(id)
      question = QuestionsDatabase.instance.get_first_row(<<-SQL, id)
          SELECT
              *
          FROM
              questions
          WHERE
              id = ?
      SQL
      return nil if question.nil?
      Question.new(question)
  end

  def self.find_by_user_id(user_id)
    question = QuestionsDatabase.instance.get_first_row(<<-SQL, user_id)
        SELECT
            *
        FROM
            questions
        WHERE
            user_id = ?
    SQL
    return nil if question.nil?
    Question.new(question)
  end
    
  def self.find_by_title(title)
      question = QuestionsDatabase.instance.get_first_row(<<-SQL, title)
          SELECT
              *
          FROM
              questions
          WHERE
              title = ?
      SQL
      return nil if question.nil?
      Question.new(question)
  end

  def initialize(options)
      @id = options['id']
      @title = options['title']
      @body = options['body']
      @user_id = options['user_id']
  end
end

class Question_follows
  attr_accessor :id, :user_id, :question_id
  def self.find_by_id(id)
      question_follow = QuestionsDatabase.instance.get_first_row(<<-SQL, id)
          SELECT
              *
          FROM
              question_follows
          WHERE
              id = ?
      SQL
      return nil if question_follow.nil?
      Question_follows.new(question_follow)
  end

  def initialize(options)
      @id = options['id']
      @user_id = options['user_id']
      @question_id = options['question_id']
  end
end

class Reply
  attr_accessor :id, :body, :question_id, :user_id, :parent_id
  def self.find_by_id(id)
      reply = QuestionsDatabase.instance.get_first_row(<<-SQL, id)
          SELECT
              *
          FROM
              replies
          WHERE
              id = ?
      SQL
      return nil if reply.nil?
      Reply.new(reply)
  end

  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.get_first_row(<<-SQL, user_id)
        SELECT
            *
        FROM
            replies
        WHERE
            user_id = ?
    SQL
    return nil if reply.nil?
    Reply.new(reply)
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.get_first_row(<<-SQL, question_id)
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?
    SQL
    return nil if reply.nil?
    Reply.new(reply)
  end

  def initialize(options)
      @id = options['id']
      @body = options['body']
      @question_id = options['question_id']
      @user_id = options['user_id']
      @parent_id = options['parent_id']
  end
end

class Question_likes
  attr_accessor :id, :user_id, :question_id
  def self.find_by_id(id)
      question_like = QuestionsDatabase.instance.get_first_row(<<-SQL, id)
          SELECT
              *
          FROM
              question_likes
          WHERE
              id = ?
      SQL
      return nil if question_like.nil?
      Question_likes.new(question_like)
  end

  def initialize(options)
      @id = options['id']
      @user_id = options['user_id']
      @question_id = options['question_id']
  end
end

