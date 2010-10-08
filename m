Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab0JHACx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:02:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34703 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0JHACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:02:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=jP1uhxlMVKbKA5PWlsUSkdwB/lDRNMew9vUNii+IeTwO0T6bMR+pAp//M+xM3OIiAx
         p4if9S2e029ogapHuHi+V8eItAqR099zBKJ/YpJnsLHUG5TBWbOmVIJsnP8QEhHDl0/C
         /iBGZZDhX99Y0plzF0aWu2vDq1rDAa3n5KCL0=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 33/33] Staging: zram: Makefile: replace the use of <module>-objs with <module>-y
Date: Thu,  7 Oct 2010 20:01:53 -0400
Message-Id: <1286496113-11897-33-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
References: <1286496113-11897-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed <module>-objs to <module>-y in Makefile.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/zram/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/zram/Makefile b/drivers/staging/zram/Makefile
index c01160a..b1709c5 100644
--- a/drivers/staging/zram/Makefile
+++ b/drivers/staging/zram/Makefile
@@ -1,3 +1,3 @@
-zram-objs	:=	zram_drv.o zram_sysfs.o xvmalloc.o
+zram-y	:=	zram_drv.o zram_sysfs.o xvmalloc.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
-- 
1.7.3.1.50.g1e633

