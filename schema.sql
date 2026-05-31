-- ══════════════════════════════════════════════
-- PyroLog — Schema для Supabase
-- Запусти этот файл в SQL Editor → Run
-- ══════════════════════════════════════════════

-- 1. Таблица состояния приложения
CREATE TABLE IF NOT EXISTS public.app_state (
  id         INTEGER PRIMARY KEY DEFAULT 1,
  data       JSONB NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Row Level Security — защита данных
ALTER TABLE public.app_state ENABLE ROW LEVEL SECURITY;

-- Читать могут все авторизованные пользователи
CREATE POLICY "read_authenticated"
  ON public.app_state FOR SELECT
  TO authenticated
  USING (true);

-- Обновлять могут все авторизованные пользователи
CREATE POLICY "update_authenticated"
  ON public.app_state FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

-- 3. Realtime — синхронизация между устройствами в реальном времени
ALTER TABLE public.app_state REPLICA IDENTITY FULL;
ALTER PUBLICATION supabase_realtime ADD TABLE public.app_state;

-- 4. Начальные данные
INSERT INTO public.app_state (id, data)
VALUES (1, '{"employees": [{"name": "Дима", "role": "Старший пиротехник", "perm": "manager", "c": "#ff7d4d", "bg": "rgba(255,87,34,.18)", "phone": "+79000000001", "email": "dima@pyrolog.local"}, {"name": "Даня", "role": "Пиротехник", "perm": "worker", "c": "#4da3ff", "bg": "rgba(77,163,255,.18)", "phone": "+79000000002", "email": "danya@pyrolog.local"}, {"name": "Игорь", "role": "Водитель / техник", "perm": "worker", "c": "#e8a13c", "bg": "rgba(232,161,60,.18)", "phone": "+79000000003", "email": "igor@pyrolog.local"}, {"name": "Антон", "role": "Пиротехник", "perm": "worker", "c": "#5fc77f", "bg": "rgba(95,199,127,.18)", "phone": "+79000000004", "email": "anton@pyrolog.local"}], "stock": [{"name": "Шашка заслон", "unit": "шт", "qty": 63, "min": 20, "type": "pyro", "price": 800, "cost": 400, "returnable": false}, {"name": "Шар Искра", "unit": "шт", "qty": 18, "min": 30, "type": "pyro", "price": 350, "cost": 150, "returnable": false}, {"name": "Имитация взрыва (граната)", "unit": "шт", "qty": 12, "min": 5, "type": "pyro", "price": 1500, "cost": 700, "returnable": false}, {"name": "Патроны", "unit": "шт", "qty": 210, "min": 100, "type": "ammo", "price": 60, "cost": 25, "returnable": false}, {"name": "Пистолет ПМ", "unit": "шт", "qty": 6, "min": 0, "type": "ammo", "price": 0, "cost": 0, "returnable": true}, {"name": "Юниверсал", "unit": "шт", "qty": 2, "min": 1, "type": "equip", "price": 5000, "cost": 0, "returnable": true}, {"name": "ДМХ", "unit": "шт", "qty": 1, "min": 1, "type": "equip", "price": 3000, "cost": 0, "returnable": true}, {"name": "Дист. управление", "unit": "шт", "qty": 4, "min": 2, "type": "equip", "price": 2000, "cost": 0, "returnable": true}, {"name": "Дым-машина 2.6", "unit": "шт", "qty": 2, "min": 1, "type": "equip", "price": 4000, "cost": 0, "returnable": true}, {"name": "Маркер", "unit": "шт", "qty": 5, "min": 2, "type": "equip", "price": 500, "cost": 0, "returnable": true}, {"name": "Масло", "unit": "л", "qty": 8, "min": 3, "type": "cons", "price": 600, "cost": 300, "returnable": false}], "rates": {"km": 30, "fuel": 12, "wage": 3000}, "workRates": [{"name": "Работа пиротехника (смена)", "amount": 6000}, {"name": "Постановщик трюков (смена)", "amount": 12000}], "trips": [{"id": 1, "project": "Мажор", "date": "2025-12-22", "crew": ["Дима", "Даня", "Игорь"], "driver": "Игорь", "km": 142, "author": "Дима", "work": [{"name": "Работа пиротехника (смена)", "amount": 6000, "qty": 3}], "notes": "Масло: приписан 1 л. Пистолеты: достали 2 шт стреляющих.", "type": "Съёмка", "items": [{"name": "Юниверсал", "qty": 1, "unit": "шт", "returnable": true, "returned": false}, {"name": "ДМХ", "qty": 1, "unit": "шт", "returnable": true, "returned": false}, {"name": "Дист. управление", "qty": 1, "unit": "шт", "returnable": true, "returned": false}, {"name": "Дым-машина 2.6", "qty": 1, "unit": "шт", "returnable": true, "returned": false}, {"name": "Маркер", "qty": 1, "unit": "шт", "returnable": true, "returned": false}, {"name": "Пистолет ПМ", "qty": 6, "unit": "шт", "returnable": true, "returned": false}, {"name": "Шашка заслон", "qty": 9, "unit": "шт", "returnable": false}, {"name": "Шар Искра", "qty": 30, "unit": "шт", "returnable": false}, {"name": "Имитация взрыва (граната)", "qty": 1, "unit": "шт", "returnable": false}, {"name": "Патроны", "qty": 50, "unit": "шт", "returnable": false}, {"name": "Масло", "qty": 3, "unit": "л", "returnable": false}]}]}'::jsonb)
ON CONFLICT (id) DO NOTHING;

-- ══════════════════════════════════════════════
-- Готово! Теперь создай пользователей:
-- Authentication → Users → Add user
--
-- Примеры:
--   dima@pyrolog.local   (пароль на твой выбор)
--   danya@pyrolog.local
--   igor@pyrolog.local
--   anton@pyrolog.local
--   admin@pyrolog.local  (администратор)
--
-- После создания пользователь может войти
-- в приложение и изменить данные о сотрудниках.
-- ══════════════════════════════════════════════
