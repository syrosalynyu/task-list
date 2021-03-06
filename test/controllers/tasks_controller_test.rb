require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test", completed_at: Time.now + 5.days
  }
  
  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path
      
      # Assert
      must_respond_with :success
    end
    
    it "can get the root path" do
      # Act
      get root_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)
      
      # Assert
      must_respond_with :success
    end
    
    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)
      
      # Assert
      must_respond_with :redirect
    end
  end
  
  describe "new" do
    it "can get the new task page" do
      # Act
      get new_task_path
      
      # Assert
      must_respond_with :success
    end
  end
  
  describe "create" do
    it "can create a new task" do
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed_at: nil,
        },
      }
      
      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1
      
      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed_at).must_equal task_hash[:task][:completed_at]
      
      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end
  
  describe "edit" do
    before do
      @task = Task.create(name: "sample task", description: "this is an example for a test", completed_at: nil)
    end

    it "can get the edit page for an existing task" do 
      # Act
      get edit_task_path(@task.id)
      # Assert
      must_respond_with :success
      
    end
    
    it "will respond with redirect when attempting to edit a nonexistant task" do
      # Act
      get edit_task_path(-1)
      # Assert
      must_respond_with :missing
    end
  end
  
  describe "update" do
    before do
      @task = Task.create(name: "sample task", description: "this is an example for a test", completed_at: nil)
    end
    let(:updated_params) {
      {
        task: {
          name: "task 1",
          description: "here's the description for task 1",
          completed_at: nil,
        },
      }
    }
    
    it "can update an existing task" do
      task = Task.first
      expect { 
        patch task_path(task.id),
        params: updated_params
      }.wont_change "Task.count"

      must_redirect_to task_path

      task.reload
      expect(task.name).must_equal updated_params[:task][:name]
      expect(task.description).must_equal updated_params[:task][:description]
      expect(task.completed_at).must_equal updated_params[:task][:completed_at]
    end
    
    it "will redirect to the root page if given an invalid id" do
      patch task_path(-1)

      must_redirect_to root_path
    end

    # TODO
    # Note: If there was a way to fail to save the changes to a task, that would be a great thing to test.
  end
  
  # Complete these tests for Wave 4
  describe "destroy" do
    before do
      @task = Task.create(name: "sample task", description: "this is an example for a test", completed_at: nil)
    end
    
    it "task count will decrease by 1 after destroying a book from the database" do
      task = Task.first
      expect{delete task_path(task.id)}.must_change "Task.count", 1

      must_respond_with :redirect
    end

    it "will redirect to the task_path (aka index page) if given an invalid id " do
      delete task_path(-1)
      must_respond_with :missing
    end

  end
  
  # Complete for Wave 4
  describe "Mark Complete using the existing update action in the controller" do
    before do
      @task = Task.create(name: "sample task", description: "this is an example for a test", completed_at: nil)
    end
    
    it "can update an existing task" do
      task = Task.first
      mark_complete_params = {
        task: {
          name: task.name, 
          description: task.description, 
          completed_at: Time.now.utc.to_datetime,
        }
      }

      expect { 
        patch task_path(task.id),
        params: mark_complete_params
      }.wont_change "Task.count"

      must_redirect_to task_path

      task.reload
      expect(task.name).must_equal mark_complete_params[:task][:name]
      expect(task.description).must_equal mark_complete_params[:task][:description]
      expect(task.completed_at).wont_be_nil
    end
    
    it "will redirect to the root page if given an invalid id" do
      patch task_path(-1)

      must_redirect_to root_path
    end
  end
end
