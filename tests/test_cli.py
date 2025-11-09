from app.cli import add

def test_add_basics():
    assert add(1,2) == 3
    assert add(-1,1) == 0
