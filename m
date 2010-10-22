Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab0JVVaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 17:30:35 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36602 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab0JVVae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 17:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jBahvA7+hRZGSdh/8nNJ7C/daB+B56OK0/pPylH305ubL+bhI5up4LiCUQ6b0C3NBc
         FRlm7+9TVKsitUZNd+ByKAA4dS7mXfMhr1XYe2bikU+aFZ5FKTJtZuFm4kCH8uu740wf
         6sjk7L4dc7rh7n6hA2smDkXu1zVLrto8izMFo=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH] Staging: msm: Makefile: replace the use of <module>-objs with <module>-y
Date: Fri, 22 Oct 2010 17:30:28 -0400
Message-Id: <1287783028-3864-1-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/msm/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/msm/Makefile b/drivers/staging/msm/Makefile
index bb3606f..07a89ec 100644
--- a/drivers/staging/msm/Makefile
+++ b/drivers/staging/msm/Makefile
@@ -41,11 +41,11 @@ obj-$(CONFIG_FB_MSM_EBI2) += ebi2_lcd.o
 obj-$(CONFIG_FB_MSM_LCDC) += lcdc.o
 
 # MDDI
-msm_mddi-objs := mddi.o mddihost.o mddihosti.o
+msm_mddi-y := mddi.o mddihost.o mddihosti.o
 obj-$(CONFIG_FB_MSM_MDDI) += msm_mddi.o
 
 # External MDDI
-msm_mddi_ext-objs := mddihost_e.o mddi_ext.o
+msm_mddi_ext-y := mddihost_e.o mddi_ext.o
 obj-$(CONFIG_FB_MSM_EXTMDDI) += msm_mddi_ext.o
 
 # TVEnc
-- 
1.7.3.1.104.gc752e

