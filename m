Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0JHAGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:06:25 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55788 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab0JHACW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tV2vLji8AK2vYHF7cSlVsik99MmtOtNgBb3y2xn45SORnK4fFMWxsc50QGLhb9BoQ1
         UZkPr3pRwywipojzvEcZ8odBGoZzP8w5bnYvR6LbFECnwU7uapJpsyl/k72SQvV+axE6
         lH8mFCLLYyyIrKQJXi2ZHcg0RnlvGoMrlTLz4=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 16/33] Staging: line6: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:36 -0400
Message-Id: <1286496113-11897-16-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/line6/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/Makefile b/drivers/staging/line6/Makefile
index a1c93ed..de6bd12 100644
--- a/drivers/staging/line6/Makefile
+++ b/drivers/staging/line6/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_LINE6_USB)		+= line6usb.o
 
-line6usb-objs := 		\
+line6usb-y := 		\
 		audio.o		\
 		capture.o	\
 		control.o	\
-- 
1.7.3.1.50.g1e633

