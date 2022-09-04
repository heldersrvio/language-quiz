status =
    quiz: null
    question: 0
    score: 0

getQuiz = (code) ->
    Quizzes.filter((quiz) -> quiz.code == code).map(
        (quiz) ->
            code: quiz.code,
            name: quiz.name,
            questions: quiz.questions.sort((a, b) -> Math.random() > 0.5)
    )[0]

getCurrentQuestion = () ->
    status.quiz.questions[status.question]

startQuiz = (code) ->
    status =
        quiz: getQuiz(code)
        question: 0
        score: 0
    status

answerQuestion = (index, answer) ->
    status.score = if answer == getCurrentQuestion().meaning then status.score + 1 else status.score
    if question == status.quiz.questions.length
        endQuiz()
    else
        status.question += 1

endQuiz = () ->
    status.question = 0

generateView = () ->
    if status.quiz == null
        quizQuestion = document.getElementById('quiz-question')
        quizEnd = document.getElementById('quiz-end')
        quizQuestion.classList.add('hidden')
        quizEnd.classList.add('hidden')

        languages = document.getElementById('languages')
        languages.classList.remove('hidden')
        Quizzes.forEach((quiz) ->
            button = document.createElement('button')
            button.appendChild(document.createTextNode(quiz.name))
            button.addEventListener('click', () ->
                startQuiz(quiz.code)
            )
            languages.appendChild(button)
        )

generateView()
        