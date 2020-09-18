(require [hy.contrib.walk [let]])

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


(defclass Block [Renderable]
  (setv speed 1)

  (defn __init__ [self pos]
    (setv self.pos pos)
    (setv self.image (Surface '("H   "
                                "WELL")))
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


(defclass GameState [State]
  (defn postinit [self]
    (self.add (Block (Vec3 10 10))))

  (defn events [self]))


(defmain [&rest args]
  (let [app (Hyetris)]
    (.register app GameState)
    (try
      (.start app)
      (except [KeyboardInterrupt]
        (.stop app)))))
