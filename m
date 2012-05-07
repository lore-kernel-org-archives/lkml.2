Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2EGNGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:06:51 -0400
Received: from stats.peacock.arvixe.com ([174.122.104.67]:39486 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056Ab2EGNGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:06:49 -0400
From: Przemo Firszt <przemo@firszt.eu>
To: pinglinux@gmail.com, jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH] HID: wacom: Add ABI description for I4 WL LED selector.
Date: Mon,  7 May 2012 14:06:36 +0100
Message-Id: <1336395996-6923-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.7.10
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Short ABI description for LED selector for Wacom Intuos4 WL.

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 Documentation/ABI/testing/sysfs-driver-wacom |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
index 0130d66..5d8e1e1 100644
--- a/Documentation/ABI/testing/sysfs-driver-wacom
+++ b/Documentation/ABI/testing/sysfs-driver-wacom
@@ -9,6 +9,14 @@ Description:
 		or 0 otherwise. Writing to this file one of these values
 		switches reporting speed.
 
+What:		/sys/class/hidraw/hidraw*/device/wacom_led/status_led0_select
+Date:		May 2012
+Kernel Version:	3.5
+Contact:	linux-bluetooth@vger.kernel.org
+Description:
+		The file controls state of LED selector on Intuos4 WL.
+		Useful range is 0 to 3 (4 different LEDs)
+
 What:		/sys/bus/usb/devices/<busnum>-<devnum>:<cfg>.<intf>/wacom_led/led
 Date:		August 2011
 Contact:	linux-input@vger.kernel.org
-- 
1.7.10

