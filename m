Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab2CaPba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 11:31:30 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:58601 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760114Ab2CaPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 11:31:16 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH V2 2/2] Documentation: Add sysfs ABI change for cfq's target latency.
Date: Sat, 31 Mar 2012 23:31:07 +0800
Message-Id: <1333207867-2957-2-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1333207867-2957-1-git-send-email-tm@tao.ma>
References: <1332836213-5266-1-git-send-email-tm@tao.ma>
 <1333207867-2957-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 69.198.183.141 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 Documentation/ABI/testing/sysfs-cfq-target-latency |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-cfq-target-latency

diff --git a/Documentation/ABI/testing/sysfs-cfq-target-latency b/Documentation/ABI/testing/sysfs-cfq-target-latency
new file mode 100644
index 0000000..df0f782
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-cfq-target-latency
@@ -0,0 +1,8 @@
+What:		/sys/block/<device>/iosched/target_latency
+Date:		March 2012
+contact:	Tao Ma <boyu.mt@taobao.com>
+Description:
+		The /sys/block/<device>/iosched/target_latency only exists
+		when the user sets cfq to /sys/block/<device>/scheduler.
+		It contains an estimated latency time for the cfq. cfq will
+		use it to calculate the time slice used for every task.
-- 
1.7.0.4

