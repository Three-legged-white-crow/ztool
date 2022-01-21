const std = @import("std");

pub fn main() anyerror!void {

    const filePath = "/home/test/file";
    const f = try std.os.open(filePath, 0x0, 0);
    var rba: [64]u8 = undefined;
    const lenArry = rba.len;
    const rb: []u8 = rba[0..lenArry];

    var rs :usize = 0;
    var h = std.crypto.hash.Md5.init(std.crypto.hash.Md5.Options{});

    while (true) {
        rs = try std.os.read(f, rb);
        if (rs == 0) {
            std.log.info("read EOF, break", .{});
            break;
        }
        std.log.info("read content len: {}", .{rs});
        h.update(rb[0..rs]);
    }

    var res: [16]u8 = undefined;
    h.final(&res);
    const res1 = res[0..16];

    const hexFormatter = std.fmt.fmtSliceHexLower(res1);
    const stderrWriter = std.io.getStdErr().writer();
    try hexFormatter.format("digest hex: ", std.fmt.FormatOptions{}, stderrWriter);


}