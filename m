Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab2BOPAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 10:00:21 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:58029
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750896Ab2BOPAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 10:00:18 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] Documentation: Fix typo in power-management.txt
Date: Wed, 15 Feb 2012 23:59:47 +0900
Message-Id: <1329317987-2298-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "diconnect()" to "disconnect()" in
Documentation/usb/power-management.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/usb/power-management.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/usb/power-management.txt b/Documentation/usb/power-management.txt
index 12511c9..817df29 100644
--- a/Documentation/usb/power-management.txt
+++ b/Documentation/usb/power-management.txt
@@ -345,7 +345,7 @@ autosuspend the device.
 Drivers need not be concerned about balancing changes to the usage
 counter; the USB core will undo any remaining "get"s when a driver
 is unbound from its interface.  As a corollary, drivers must not call
-any of the usb_autopm_* functions after their diconnect() routine has
+any of the usb_autopm_* functions after their disconnect() routine has
 returned.
 
 Drivers using the async routines are responsible for their own
-- 
1.7.4.4

