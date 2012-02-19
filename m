Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2BSN5u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 08:57:50 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:41741
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab2BSN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 08:57:48 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] [trivial] Documentation: Fix typo in README.cpio2
Date: Sun, 19 Feb 2012 22:56:24 +0900
Message-Id: <1329659784-1781-4-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329659784-1781-1-git-send-email-standby24x7@gmail.com>
References: <1329659784-1781-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "separted" to "separated" in
Documentation/video4linux/README.cpio2

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/video4linux/README.cpia2 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/video4linux/README.cpia2 b/Documentation/video4linux/README.cpia2
index ce8213d..38e742f 100644
--- a/Documentation/video4linux/README.cpia2
+++ b/Documentation/video4linux/README.cpia2
@@ -12,7 +12,7 @@ gqcam application to view this stream.
 	The driver is implemented as two kernel modules. The cpia2 module
 contains the camera functions and the V4L interface.  The cpia2_usb module
 contains usb specific functions.  The main reason for this was the size of the
-module was getting out of hand, so I separted them.  It is not likely that
+module was getting out of hand, so I separated them.  It is not likely that
 there will be a parallel port version.
 
 FEATURES:
-- 
1.7.9.1.197.g5f90b

