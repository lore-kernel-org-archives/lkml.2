Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab0GUFER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:04:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39306 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933508Ab0GUE6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FzIh6L07jABuQ3DtSVDQjbyL0CGGxY+VjGQ0BWMZikqL7ltjtzY6j0CWQ6tmbHPtEG
         oDsLYC5k7tTwlpwavVEJ0HSzAqpCg2AJyB8+2rk0ZCb9/Wn3qbqjhlMmP4hroIO/sftZ
         uBDm+/xqopSZJWl/PyH/Ai3832G3LAW90FJHU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 121/121]Documentation/video4linux/ibmcam.txt update web address.
Date: Tue, 20 Jul 2010 21:58:38 -0700
Message-Id: <1279688336-29735-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below updates a broken web addresses.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/video4linux/ibmcam.txt |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/video4linux/ibmcam.txt b/Documentation/video4linux/ibmcam.txt
index 397a94e..a510552 100644
--- a/Documentation/video4linux/ibmcam.txt
+++ b/Documentation/video4linux/ibmcam.txt
@@ -27,9 +27,8 @@ SUPPORTED CAMERAS:
 
 Xirlink "C-It" camera, also known as "IBM PC Camera".
 The device uses proprietary ASIC (and compression method);
-it is manufactured by Xirlink. See http://www.xirlink.com/
-(renamed to http://www.veo.com), http://www.ibmpccamera.com,
-or http://www.c-itnow.com/ for details and pictures.
+it is manufactured by Xirlink. See http://xirlinkwebcam.sourceforge.net, 
+http://www.ibmpccamera.com, or http://www.c-itnow.com/ for details and pictures.
 
 This very chipset ("X Chip", as marked at the factory)
 is used in several other cameras, and they are supported
-- 
1.7.1.rc1.21.gf3bd6

