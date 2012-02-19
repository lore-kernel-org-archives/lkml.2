Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2BSN5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 08:57:40 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:41731
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab2BSN5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 08:57:10 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [trivial] Documentation: Fix typo in dwc3.txt
Date: Sun, 19 Feb 2012 22:56:22 +0900
Message-Id: <1329659784-1781-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329659784-1781-1-git-send-email-standby24x7@gmail.com>
References: <1329659784-1781-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "requries" to "requires" in
Documentation/usb/dwc3.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/usb/dwc3.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/usb/dwc3.txt b/Documentation/usb/dwc3.txt
index 7b590ed..1d02c01 100644
--- a/Documentation/usb/dwc3.txt
+++ b/Documentation/usb/dwc3.txt
@@ -28,7 +28,7 @@ Please pick something while reading :)
       none
 
     - primary handler of the EP-interrupt
-      reads the event and tries to process it. Everything that requries
+      reads the event and tries to process it. Everything that requires
       sleeping is handed over to the Thread. The event is saved in an
       per-endpoint data-structure.
       We probably have to pay attention not to process events once we
-- 
1.7.9.1.197.g5f90b

