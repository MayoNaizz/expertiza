describe "check 'Begin review' showing up before due date and 'Assign grade' after due date" do
  let(:team) { build(:assignment_team, id: 1, name: 'team1') }
  it "Begin review" do

    instructor6 = create(:instructor)   #create instructor6
    assignment_test = create(:assignment, name: 'E1968', course: nil) #create an assignment without course
    create(:deadline_type, name: "submission")
    create(:deadline_type, name: "review")
    create(:assignment_due_date, deadline_type: DeadlineType.where(name: "submission").first, due_at: DateTime.now.in_time_zone + 10.day)
    create(:assignment_due_date, deadline_type: DeadlineType.where(name: "review").first, due_at: DateTime.now.in_time_zone + 20.day)

    expect(assignment_test.instructor_id).to eql(instructor6.id)
    expect(assignment_test.course_id).to eql(nil)
    student_test = create(:student, name: "student6666", email: "stu6666@ncsu.edu") #create a student for test

    visit(root_path)
    fill_in('login_name', with: 'instructor6')
    fill_in('login_password', with: 'password')
    click_button('Sign in')
    expect(current_path).to eql("/tree_display/list")
    expect(page).to have_content('Manage content')

    visit("/participants/list?id=#{assignment_test.id}&model=Assignment")
    expect(page).to have_content("E1968")
    fill_in("user_name", match: :first, with: instructor6.name)
    click_button("Add", match: :first)
    expect(page).to have_content(instructor6.name)
    expect(page).to have_content(instructor6.email)
    click_button("Submit", match: :first)



    visit("/participants/list?id=#{assignment_test.id}&model=Assignment")
    expect(page).to have_content("E1968")
    fill_in("user_name", match: :first, with: student_test.name)
    click_button("Add", match: :first)
    expect(page).to have_content(student_test.name)
    expect(page).to have_content(student_test.email)

    user_id = User.find_by(name: 'student6666').id
    participant_student = Participant.where(user_id: user_id)
    participant_id = participant_student.first.id
    parent_id = participant_student.first.parent_id
    team_student = Team.where(parent_id: parent_id)
    team_user = create(:team_user, user_id: user_id)

    visit("/assignments/list_submissions?id=#{assignment_test.id}")

    visit "/assignments/#{assignment_test.id}/edit"
    check("team_assignment")
    click_button 'Save'

    visit("/assignments/list_submissions?id=#{assignment_test.id}")
    expect(page).to have_link('Begin review', exact:true)

  end

  it "Assign grade" do
    instructor6 = create(:instructor)   #create instructor6
    assignment_test = create(:assignment, name: 'E1968', course: nil) #create an assignment without course
    create(:deadline_type, name: "submission")
    create(:deadline_type, name: "review")
    create(:assignment_due_date, deadline_type: DeadlineType.where(name: "submission").first, due_at: DateTime.now.in_time_zone.day)
    create(:assignment_due_date, deadline_type: DeadlineType.where(name: "review").first, due_at: DateTime.now.in_time_zone + 20.day)

    expect(assignment_test.instructor_id).to eql(instructor6.id)
    expect(assignment_test.course_id).to eql(nil)
    student_test = create(:student, name: "student6666", email: "stu6666@ncsu.edu") #create a student for test

    visit(root_path)
    fill_in('login_name', with: 'instructor6')
    fill_in('login_password', with: 'password')
    click_button('Sign in')
    expect(current_path).to eql("/tree_display/list")
    expect(page).to have_content('Manage content')

    visit("/participants/list?id=#{assignment_test.id}&model=Assignment")
    expect(page).to have_content("E1968")
    fill_in("user_name", match: :first, with: instructor6.name)
    click_button("Add", match: :first)
    expect(page).to have_content(instructor6.name)
    expect(page).to have_content(instructor6.email)
    click_button("Submit", match: :first)



    visit("/participants/list?id=#{assignment_test.id}&model=Assignment")
    expect(page).to have_content("E1968")
    fill_in("user_name", match: :first, with: student_test.name)
    click_button("Add", match: :first)
    expect(page).to have_content(student_test.name)
    expect(page).to have_content(student_test.email)

    user_id = User.find_by(name: 'student6666').id
    participant_student = Participant.where(user_id: user_id)
    participant_id = participant_student.first.id
    parent_id = participant_student.first.parent_id
    team_student = Team.where(parent_id: parent_id)
    team_user = create(:team_user, user_id: user_id)

    visit("/assignments/list_submissions?id=#{assignment_test.id}")

    visit "/assignments/#{assignment_test.id}/edit"
    check("team_assignment")
    click_button 'Save'

    visit("/assignments/list_submissions?id=#{assignment_test.id}")
    expect(page).to have_link('Begin review', exact:true)
  end


end