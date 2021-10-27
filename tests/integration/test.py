import unittest
from app import functions


class FunctionsTestIntegration(unittest.TestCase):

    def test_bad_type(self):
        with self.assertRaises(TypeError):
            functions.add_1('test')

    def test_is_int(self):
        self.assertIsInstance(functions.add_1(5), int)

    def test_is_float(self):
        self.assertIsInstance(functions.add_1(5.5), float)


if __name__ == '__main__':
    unittest.main()
