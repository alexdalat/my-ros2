import rclpy
from std_msgs.msg import String

def main(args=None):
    rclpy.init(args=args)

    node = rclpy.create_node('talker')

    publisher = node.create_publisher(String, 'chatter', 10)

    msg = String()
    i = 1
    def timer_callback():
        nonlocal i
        msg.data = 'Hello World: %d' % i
        i += 1
        publisher.publish(msg)
        node.get_logger().info('Publishing: "%s"' % msg.data)

    timer = node.create_timer(0.5, timer_callback)

    rclpy.spin(node)

    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
