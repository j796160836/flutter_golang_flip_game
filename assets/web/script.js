class Card {
  constructor(id, value, content) {
    this.id = id;
    this.value = value;
    this.content = content;
    this.flipped = false;
    this.bingo = false;
  }
  bingoed() {
    this.bingo = true;
  }
  flip() {
    this.flipped = true;
  }
  flipBack() {
    this.flipped = false;
  }
}

var cardContent = [
  {
    value: 1,
    content: "<div>var</div>",
  },
  {
    value: 1,
    content: "<div>a := 123</div>",
  },
  {
    value: 2,
    content: "<div>slice</div>",
  },
  {
    value: 2,
    content: "<div>var a []int</div>",
  },
  {
    value: 3,
    content: "<div>for loop</div>",
  },
  {
    value: 3,
    content: "<div>for _, v := range arr {}</div>",
  },
  {
    value: 4,
    content: "<div>null</div>",
  },
  {
    value: 4,
    content: "<div>nil</div>",
  },
  {
    value: 5,
    content: "<div>function</div>",
  },
  {
    value: 5,
    content: "<div>func Test()</div>",
  },
  {
    value: 6,
    content: "<div>error</div>",
  },
  {
    value: 6,
    content: "<div>errors.New('err msg')</div>",
  },
  {
    value: 7,
    content: "<div>struct</div>",
  },
  {
    value: 7,
    content: "<div>type a struct{}</div>",
  },
  {
    value: 8,
    content: "<div>interface</div>",
  },
  {
    value: 8,
    content: "<div>type a interface{}</div>",
  }
];

var app = new Vue({
  el: '#app',
  data: {
    selectedCards: [],
    cardData: [],
    cardValue: [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8],
    timer: 120,
    isRunning: false,
    intervalId: null
  },
  methods: {
    flipCard(cardID) {
      this.startTimer();
      if (this.cardData[cardID].flipped || this.cardData[cardID].bingo) {
        return;
      }

      this.cardData[cardID].flip();
      this.selectedCards.push(this.cardData[cardID]);

      if (this.selectedCards.length == 2) {
        this.checkSelectedCards();
      }

      // If all cards are bingoed
      if (this.cardData.every(card => card.bingo)) {
        this.stopTimer();
        // Avoid alerting before the last card is flipped
        setTimeout(() => {
          alert("You win! Congratulations!");
        }, 300);
      }
    },
    generateCardData() {
      var cards = shuffleArr(cardContent);
      for (i = 0; i <= 15; i++) {
        var card = new Card(
          i, cards[i].value, cards[i].content
        );
        this.cardData.push(card);
      }
    },
    checkSelectedCards() {
      if (this.selectedCards[0].value === this.selectedCards[1].value) {
        this.cardData[this.selectedCards[0].id].bingoed();
        this.cardData[this.selectedCards[1].id].bingoed();
      }

      setTimeout(() => {
        this.resetCards();
      }, 500);

    },
    resetCards() {
      this.selectedCards = [];
      this.cardData.forEach(card => {
        if (!card.bingo) {
          card.flipBack();
        }
      });
    },
    startTimer() {
      if (!this.isRunning && this.timer > 0) {
        this.intervalId = setInterval(() => {
          this.timer--;
          if (this.timer === 0) {
            this.stopTimer();
            alert("You lose! Please try again.");
            location.reload();
          }
        }, 1000);
        this.isRunning = true;
      }
    },
    stopTimer() {
      if (this.isRunning) {
        clearInterval(this.intervalId);
        this.isRunning = false;
      }
    },
    formatTime(seconds) {
      const minutes = Math.floor(seconds / 60);
      const remainingSeconds = seconds % 60;
      const formattedMinutes = String(minutes).padStart(2, '0');
      const formattedSeconds = String(remainingSeconds).padStart(2, '0');
      return `${formattedMinutes}:${formattedSeconds}`;
    }
  },
  mounted() {
    this.generateCardData();
  }
});

function shuffleArr(array) {
  let currentIndex = array.length, randomIndex;
  while (currentIndex != 0) {
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;
    [array[currentIndex], array[randomIndex]] = [
      array[randomIndex], array[currentIndex]];
  }
  return array;
}