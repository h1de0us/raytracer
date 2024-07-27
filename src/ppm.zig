const std = @import("std");

// (const|var) identifier[: type] = value
const HEIGHT: i64 = 64;
const WIDTH: i64 = 48;
const RADIUS: i64 = 5;
const MAX_PPM_VALUE: u8 = 255;

const Color = struct {
    r: u8,
    g: u8,
    b: u8,
    pub fn format(
        self: Color,
        comptime fmt: []const u8, // idk
        options: std.fmt.FormatOptions, // idk
        writer: anytype, // idk
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("{} {} {}", .{
            self.r, self.g, self.b,
        });
    }
};

const BLACK: Color = .{ .r = 0, .g = 0, .b = 0 };
const WHITE: Color = .{ .r = 255, .g = 255, .b = 255 };

pub fn ppm() !void {
    const stdout = std.io.getStdOut().writer(); // TODO: think about multithreading, mutexes and so on

    try stdout.print("P3\n", .{});
    try stdout.print("{} {}\n", .{ WIDTH, HEIGHT });
    try stdout.print("{}\n", .{MAX_PPM_VALUE});

    for (0..HEIGHT) |h| {
        for (0..WIDTH) |w| {
            var h_normalized: i64 = @intCast(h);
            var w_normalized: i64 = @intCast(w);
            h_normalized = h_normalized - HEIGHT / 2;
            w_normalized = w_normalized - WIDTH / 2;
            // std.debug.print("{} {}\n", .{ h_normalized, w_normalized });
            if (std.math.pow(i64, h_normalized, 2) + std.math.pow(i64, w_normalized, 2) <= std.math.pow(i64, RADIUS, 2)) {
                try stdout.print("{s}\n", .{BLACK});
            } else {
                try stdout.print("{s}\n", .{WHITE});
            }
            // std.debug.print("{} {} {}\n", .{ std.math.pow(i64, h_normalized, 2), std.math.pow(i64, w_normalized, 2), std.math.pow(i64, RADIUS, 2) });
        }
    }
}

pub fn main() !void {
    try ppm();
}
