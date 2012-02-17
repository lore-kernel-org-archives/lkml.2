Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2BQOm7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 09:42:59 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37402
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2BQOm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 09:42:58 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, standby24x7@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [trivial] Documentation: Fix typo in proc_usb_info.txt
Date: Fri, 17 Feb 2012 23:42:34 +0900
Message-Id: <1329489754-2358-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo "filsystem" to "filesystem" in
Documentation/usb/proc_usb_info.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/usb/proc_usb_info.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/usb/proc_usb_info.txt b/Documentation/usb/proc_usb_info.txt
index afe596d..c9c3f0f 100644
--- a/Documentation/usb/proc_usb_info.txt
+++ b/Documentation/usb/proc_usb_info.txt
@@ -7,7 +7,7 @@ The usbfs filesystem for USB devices is traditionally mounted at
 /proc/bus/usb.  It provides the /proc/bus/usb/devices file, as well as
 the /proc/bus/usb/BBB/DDD files.
 
-In many modern systems the usbfs filsystem isn't used at all.  Instead
+In many modern systems the usbfs filesystem isn't used at all.  Instead
 USB device nodes are created under /dev/usb/ or someplace similar.  The
 "devices" file is available in debugfs, typically as
 /sys/kernel/debug/usb/devices.
-- 
1.7.6.5

