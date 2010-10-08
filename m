Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0JHAFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:05:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59236 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab0JHAC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=c4k8wa/cJwEyae092KRZ0onakDheg6o6Y6h9BAQ41bRWTVaBM+f2m0r0jXWHB3jvk6
         csAXveIVXnjSj4HW0HmNIN6pg4QSxOQa+11GDhW74Q/9M6o3QoktqIuq1YnmbwOpsG+p
         y5NCToZhPWf5m87U+/SQecrxXat1R9nkSRl/0=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 20/33] Staging: rtl8187se: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:40 -0400
Message-Id: <1286496113-11897-20-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/rtl8187se/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8187se/Makefile b/drivers/staging/rtl8187se/Makefile
index adc3849..11a9226 100644
--- a/drivers/staging/rtl8187se/Makefile
+++ b/drivers/staging/rtl8187se/Makefile
@@ -16,7 +16,7 @@ ccflags-y += -DENABLE_LPS
 
 #ccflags-y := -mhard-float -DCONFIG_FORCE_HARD_FLOAT=y
 
-r8187se-objs :=			\
+r8187se-y :=			\
 		r8180_core.o		\
 		r8180_wx.o		\
 		r8180_rtl8225z2.o	\
-- 
1.7.3.1.50.g1e633

