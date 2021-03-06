(require [hy.contrib.walk [let]])

(import random)

(import [eaf [State Vec3 Timer]]
        [xo1 [Application]]
        [xo1.color [Palette]]
        [xo1.render [Renderable]]
        [xo1.surface [Surface]])


(defclass Hyetris [Application]
  "Hyetris game application class."

  (setv max-x 40
        max-y 40)

  (defn __init__ [self]
    (.__init__ (super) self.max-x self.max-y :title "Hyetris")))


(defclass Shape [Renderable]
  (setv speed 1
        image None)

  (defn __init__ [self pos]
    (setv self.pos pos)
    (setv self._moving True)
    (setv self._timer
          (Timer 1 (fn []
                     (+= self.pos.y 1)
                     (when (>= self.pos.y (- (. (.current Application) max-y) 3))
                       (setv self._moving False
                             self.pos.y (- (. (.current Application) max-y) 3))))))

    (.start self._timer))

  (defn update [self dt]
    (when self._moving
      (.update self._timer dt)
      (unless (. self._timer running)
        (.restart self._timer)))))


(defmacro defshape [name image]
  `(defclass ~name [Shape]
     (setv image (Surface ~image))))

(defshape IShape '("XXXX"))

(defshape OShape'("XX"
                  "XX"))

(defshape TShape '("XXX"
                   " X "))

(defshape JShape '(" X"
                   " X"
                   "XX"))

(defshape LShape '("X "
                   "X "
                   "XX"))

(defshape SShape '(" XX"
                   "XX "))

(defshape ZShape '("XX "
                   " XX"))


(defclass GameState [State]
  (defn postinit [self]
    (setv self.figs []))

  (defn events [self])

  (defn update [self dt]
    (unless (some (fn [fig] (. fig _moving)) self.figs)
      (setv fig ((random.choice [IShape OShape JShape]) (Vec3 25 10)))
      (.append self.figs fig)
      (.add self fig))
    (.update (super) dt)))


(defmain [&rest args]
  (let [app (Hyetris)]
    (.register app GameState)
    (try
      (.start app)
      (except [KeyboardInterrupt]
        (.stop app)))))
