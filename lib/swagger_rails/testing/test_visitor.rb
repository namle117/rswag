require 'swagger_rails/testing/test_case_builder'

module SwaggerRails

  class TestVisitor

    def initialize(swagger)
      @swagger = swagger
    end

    def run_test(path_template, http_method, test, &block)
      builder = TestCaseBuilder.new(path_template, http_method, @swagger)
      builder.instance_exec(&block) if block_given?
      test_data = builder.test_data

      test.send(http_method,
        test_data[:path],
        test_data[:params],
        test_data[:headers]
      )

      test.assert_response(test_data[:expected_response][:status])
      test.assert_equal(test_data[:expected_response][:body], JSON.parse(test.response.body))
    end
  end
end

