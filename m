Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0JBQiU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 12:38:20 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41672 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab0JBQiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 12:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YKMEWvINIc6ITvcjEA6dZG9P4s33ZHcU2UZcsaOvkQ8u+vtbou8pwWqKcGtat6uF0P
         hP+ai0nRxA1wp13AEA3YatVGfLbLvKER8Rgelb3vtAhnkvQWjCNE9c9lNB5HSsrGK1fq
         k4y+GAHafENrjys3LePJK07sofiPFlcAioejA=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH v3 06/20] Stagng: easycap: Makefile: cleaned up Makefile cflag lines
Date: Sat,  2 Oct 2010 12:37:55 -0400
Message-Id: <1286037489-28439-6-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed to use the proper ccflags-y option

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/easycap/Makefile |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/easycap/Makefile b/drivers/staging/easycap/Makefile
index d93bd6b..680f370 100644
--- a/drivers/staging/easycap/Makefile
+++ b/drivers/staging/easycap/Makefile
@@ -5,9 +5,9 @@ easycap-objs	:= easycap_main.o easycap_low.o easycap_sound.o
 easycap-objs	+= easycap_ioctl.o easycap_settings.o
 easycap-objs	+= easycap_testcard.o
 
-EXTRA_CFLAGS += -Wall
+ccflags-y := -Wall
 # Impose all or none of the following:
-EXTRA_CFLAGS += -DEASYCAP_IS_VIDEODEV_CLIENT
-EXTRA_CFLAGS += -DEASYCAP_NEEDS_V4L2_DEVICE_H
-EXTRA_CFLAGS += -DEASYCAP_NEEDS_V4L2_FOPS
+ccflags-y += -DEASYCAP_IS_VIDEODEV_CLIENT
+ccflags-y += -DEASYCAP_NEEDS_V4L2_DEVICE_H
+ccflags-y += -DEASYCAP_NEEDS_V4L2_FOPS
 
-- 
1.7.3.1.50.g1e633

