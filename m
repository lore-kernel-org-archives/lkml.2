Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab1CWSzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:55:36 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62735 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628Ab1CWSze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:55:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tnJejCQ+RvKf+Z9k3tsXA5gXXkDo61g+edLQYHHDfBEB78gEoLS4p3qwEWwBOEERJJ
         lkmlkF3Zrhw7KdK/FVJhnQ+hudjBoi8N2DizyjwxUo90e1+vBSx0UlGrat0LLDS2Nqd1
         wkxKfYI6C4Z1lr+FUqCD3jBWJf1f0aZgsOwK8=
From: Chihau Chau <chihau@gmail.com>
To: gregkj@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chihau Chau <chihau@gmail.com>
Subject: [PATCH] staging: winbond: fixing some code styles issues
Date: Wed, 23 Mar 2011 15:52:06 -0400
Message-Id: <1300909926-10019-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix some code style warnings found by the checkpatch.pl script, changing spaces for a tab

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/winbond/phy_calibration.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/phy_calibration.c b/drivers/staging/winbond/phy_calibration.c
index 09844db..79e53e4 100644
--- a/drivers/staging/winbond/phy_calibration.c
+++ b/drivers/staging/winbond/phy_calibration.c
@@ -27,10 +27,10 @@
 #define DEG2RAD(X)      0.017453 * (X)
 
 static const s32 Angles[] = {
-    FIXED(DEG2RAD(45.0)),     FIXED(DEG2RAD(26.565)),   FIXED(DEG2RAD(14.0362)),
-    FIXED(DEG2RAD(7.12502)),  FIXED(DEG2RAD(3.57633)),  FIXED(DEG2RAD(1.78991)),
-    FIXED(DEG2RAD(0.895174)), FIXED(DEG2RAD(0.447614)), FIXED(DEG2RAD(0.223811)),
-    FIXED(DEG2RAD(0.111906)), FIXED(DEG2RAD(0.055953)), FIXED(DEG2RAD(0.027977))
+	FIXED(DEG2RAD(45.0)),     FIXED(DEG2RAD(26.565)),   FIXED(DEG2RAD(14.0362)),
+	FIXED(DEG2RAD(7.12502)),  FIXED(DEG2RAD(3.57633)),  FIXED(DEG2RAD(1.78991)),
+	FIXED(DEG2RAD(0.895174)), FIXED(DEG2RAD(0.447614)), FIXED(DEG2RAD(0.223811)),
+	FIXED(DEG2RAD(0.111906)), FIXED(DEG2RAD(0.055953)), FIXED(DEG2RAD(0.027977))
 };
 
 /****************** LOCAL FUNCTION DECLARATION SECTION **********************/
-- 
1.7.3.4

