import unittest
from app import functions


class FunctionsTestIntegration(unittest.TestCase):

    def test_bad_type(self):
        with self.assertRaises(TypeError):
            functions.add_1('test')

    def test_bad_test(self):
        self.assertIsInstance(functions.add_1(5.5), int)


if __name__ == '__main__':
    unittest.main()
