import unittest
from app import functions


class FunctionsTestIntegration(unittest.TestCase):

    def test_bad_type(self):
        with self.assertRaises(TypeError):
            functions.add_1('test')


if __name__ == '__main__':
    unittest.main()
