-- Câu lệnh CALL để tái hiện lỗi:
-- Giả sử một lịch khám có appointment_id = 10 đã có trạng thái là 'Completed' (đã hoàn tất), việc gọi thủ tục cũ vẫn sẽ ghi đè trạng thái của nó:

-- Giải thích nguyên nhân lỗi:
 -- Mã nguồn hiện tại thiếu điều kiện lọc (mệnh đề WHERE) để kiểm tra trạng thái ban đầu của lịch khám. Hệ thống cho phép cập nhật trạng thái sang 'Cancelled' cho bất kỳ ID nào tồn tại, kể cả khi lịch đó đã hoàn tất hoặc đã bị hủy trước đó, trái với quy tắc chỉ được hủy lịch ở trạng thái 'Pending'.
 
 -- Để sửa lỗi này, chúng ta cần xóa thủ tục cũ và viết lại một phiên bản mới có tích hợp kiểm tra điều kiện trạng thái 'Pending'.	
 -- Trong bản mới này, tôi thêm điều kiện status = 'Pending' vào mệnh đề WHERE để đảm bảo chỉ những bản ghi hợp lệ mới bị thay đổi.
 CREATE DATABASE ex1;
use ex1;
 DELIMITER //

CREATE PROCEDURE CancelAppointment(IN p_appointment_id INT)
BEGIN
    -- Cập nhật trạng thái chỉ khi lịch khám đang ở trạng thái 'Pending'
    UPDATE Appointments
    SET status = 'Cancelled'
    WHERE appointment_id = p_appointment_id 
      AND status = 'Pending';
      
    -- (Tùy chọn) Có thể thêm kiểm tra ROW_COUNT() để thông báo nếu không có hàng nào được cập nhật
END //

DELIMITER ;