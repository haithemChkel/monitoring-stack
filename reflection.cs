using System;
using System.Reflection;
using Confluent.Kafka;
using OpenTelemetry.Instrumentation.ConfluentKafka;

public class ReflectionHelper
{
    public static void SetInternalProperty(object target, string propertyName, object value)
    {
        if (target == null)
        {
            throw new ArgumentNullException(nameof(target));
        }

        var property = target.GetType().GetProperty(propertyName, BindingFlags.Instance | BindingFlags.NonPublic);
        if (property == null)
        {
            throw new InvalidOperationException($"Property '{propertyName}' not found on type '{target.GetType().FullName}'.");
        }

        if (!property.CanWrite)
        {
            throw new InvalidOperationException($"Property '{propertyName}' is read-only.");
        }

        property.SetValue(target, value);
    }
}

class Program
{
    static void Main(string[] args)
    {
        // Kafka consumer configuration
        var config = new ConsumerConfig
        {
            BootstrapServers = "localhost:9092",
            GroupId = "test-group",
            AutoOffsetReset = AutoOffsetReset.Earliest,
        };

        // Create an InstrumentedConsumerBuilder
        var consumerBuilder = new InstrumentedConsumerBuilder<string, string>(config);

        // Use reflection to set the internal 'EnableMetrics' property to true
        ReflectionHelper.SetInternalProperty(consumerBuilder, "EnableMetrics", true);

        Console.WriteLine("Internal property 'EnableMetrics' has been set to true.");

        // Build the consumer and use it
        var consumer = consumerBuilder.Build();
        consumer.Subscribe("test-topic");

        while (true)
        {
            var result = consumer.Consume();
            Console.WriteLine($"Message: {result.Message.Value}");
        }
    }
}
