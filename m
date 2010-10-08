Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0JHADn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:03:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab0JHACq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JzwtBl5bMfEEqfbvWSIuI2fBiffibpX1ZLcTo2kZLX9yxfz1SOrn70mf7EH2WQcNa8
         0/B6Dn+t8mvnVcFoYj4O8ojokgVuRv+BfXvxrlyx0L3NmPlgu2nHvORo4BIK3G1mdPZs
         /SoOj0VLvboojPwnPKIuZJ0MXCXr+HWStr45M=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 32/33] Staging: xgifb: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:52 -0400
Message-Id: <1286496113-11897-32-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/xgifb/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/Makefile b/drivers/staging/xgifb/Makefile
index 2a31770..f2ca6b1 100644
--- a/drivers/staging/xgifb/Makefile
+++ b/drivers/staging/xgifb/Makefile
@@ -1,4 +1,4 @@
 obj-$(CONFIG_FB_XGI)  += xgifb.o
 
-xgifb-objs := XGI_main_26.o XGI_accel.o vb_init.o vb_setmode.o vb_util.o vb_ext.o
+xgifb-y := XGI_main_26.o XGI_accel.o vb_init.o vb_setmode.o vb_util.o vb_ext.o
 
-- 
1.7.3.1.50.g1e633

