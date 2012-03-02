require 'test/test_helper'

class DiffTest < ActiveSupport::TestCase
  def test_instance_is_loadable
    assert users(:john)
  end

  def test_instances_with_identical_attributes_should_return_a_nill_for_diff
    assert_equal nil, users(:john).diff(users(:john))
  end
  
  def test_only_different_attributes_should_be_returned
    diff_expectation = {'name' => ['John Doe', 'Jane Doe'],
                        'rank' => [1, 2],
                        'factor' => [2.718281828459045, 3.141592653589793],
                        'activated_on' => [ Date.new(2010,11,17), Date.new(2005,01,01) ],
                        'admin' => [false, true] }
    diff_result = users(:john).diff(users(:jane))
    
    assert_equal diff_expectation.inspect, diff_result.inspect
  end
  
  def test_singular_associations
    diff_expectation = {'group' => { 'name' => ['FirstGroup', 'SecondGroup'] } }
    diff_result = users(:jane).diff(users(:jane_in_a_different_group))
    
    assert_equal diff_expectation.inspect, diff_result.inspect
  end
  
  def test_plural_associations
    diff_expectation = {'tags'   => { 'foo' => {'name' => 'foo' },
                                      'bar' => {'_delete' => true } },
                        'm_tags' => { 'foo' => {'name' => 'foo' },
                                      'bar' => {'_delete' => true } } }
    diff_result = users(:john).diff(users(:john_with_different_tags))
    
    assert_equal diff_expectation.inspect, diff_result.inspect
  end
  
end
