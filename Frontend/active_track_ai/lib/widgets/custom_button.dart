import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;  // ✅ Make nullable
  final IconData icon;
  final bool isOutlined;
  final bool isLoading;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,  // ✅ Nullable
    required this.icon,
    this.isOutlined = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,  // ✅ Proper null handling
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2, 
                  color: Colors.white,
                ),
              )
            : Icon(icon, size: 20),
        label: Text(
          isLoading ? 'Logging...' : text,
          style: const TextStyle(
            fontSize: 16, 
            fontWeight: FontWeight.w600
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : const Color(0xFF6366F1),
          foregroundColor: isOutlined ? const Color(0xFF6366F1) : Colors.white,
          elevation: isOutlined ? 0 : 8,
          shadowColor: isOutlined ? Colors.transparent : Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isOutlined
                ? const BorderSide(color: Color(0xFF6366F1), width: 2)
                : BorderSide.none,
          ),
          // ✅ Disabled style when loading
          disabledBackgroundColor: const Color(0xFF6366F1).withOpacity(0.6),
          disabledForegroundColor: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
}
