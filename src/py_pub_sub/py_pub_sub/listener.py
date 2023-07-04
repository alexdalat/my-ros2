import rclpy
from std_msgs.msg import String

def main(args=None):
    rclpy.init(args=args)

    node = rclpy.create_node('listener')

    def callback(msg):
        node.get_logger().info('I heard: "%s"' % msg.data)

    subscription = node.create_subscription(String, 'chatter', callback, 10)

    rclpy.spin(node)

    node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
