(require [hy.contrib.walk [let]])

(import [eaf [State Vec3 Timer]]
        [xo1 [Application]]
        [xo1.color [Palette]]
        [xo1.render [Renderable]]
        [xo1.surface [Surface]])


(defclass Hyetris [Application]
  "Hyetris game application class."

  (defn __init__ [self x y]
    (.__init__ (super) x y :title "Hyetris")))


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
                     (when (<= self.pos.y 0)
                       (setv self._moving False)))))

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
  (let [app (Hyetris 40 40)]
    (.register app GameState)
    (try
      (.start app)
      (except [KeyboardInterrupt]
        (.stop app)))))
