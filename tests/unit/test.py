import unittest

from app import functions


class FunctionsTest(unittest.TestCase):
    def test_add_1(self):
        self.assertEqual(functions.add_1(4), 4)


if __name__ == '__main__':
    unittest.main()
