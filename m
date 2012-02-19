Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2BSN5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 08:57:42 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:41736
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2BSN5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 08:57:31 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [trivial] Documentation: Fix typo in wusb-cbaf
Date: Sun, 19 Feb 2012 22:56:23 +0900
Message-Id: <1329659784-1781-3-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329659784-1781-1-git-send-email-standby24x7@gmail.com>
References: <1329659784-1781-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct typo "HOST-CHDI" to "HOST-CHID" in
Documentation/usb/wusb-cbaf

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/usb/wusb-cbaf |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/usb/wusb-cbaf b/Documentation/usb/wusb-cbaf
index 426ddaa..8b3d43e 100644
--- a/Documentation/usb/wusb-cbaf
+++ b/Documentation/usb/wusb-cbaf
@@ -36,7 +36,7 @@ COMMAND/ARGS are
 
  get-cdid DEVICE
 
-   Get the device ID associated to the HOST-CHDI we sent with
+   Get the device ID associated to the HOST-CHID we sent with
    'set-chid'. We might not know about it.
 
  set-cc DEVICE
-- 
1.7.9.1.197.g5f90b

