Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab0D3TZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:25:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37406 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759367Ab0D3TYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 15:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T4elB/2vqYe2b5i/R+ix053N8VH8iTN4HOgB6lkRkj9krD628wD2O3mgvKnwNLG8EH
         y3cXpGAOfS7ePCBG8KfFWjEHOsQDqcz6Zf/UcAtNqR/EW5WEDdg+5kweGFg46Dbvrqic
         JwgJ49pjXvrx3g0SfBkxAqEJRuovUg81iY7VI=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: chihau@gmail.com, pavel@ucw.cz, jochen.maes@sejo.be,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: dream: pmem: code style fixes
Date: Thu, 29 Apr 2010 17:37:34 -0400
Message-Id: <1272577054-4656-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This patch include <linux/io.h> instead of <asm/io.h> and
<linux/uaccess.h> instead of <asm/uaccess.h>.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/pmem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index 3e4dd21..d5f3e72 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -23,8 +23,8 @@
 #include <linux/android_pmem.h>
 #include <linux/mempolicy.h>
 #include <linux/sched.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
+#include <linux/io.h>
+#include <linux/uaccess.h>
 #include <asm/cacheflush.h>
 
 #define PMEM_MAX_DEVICES 10
-- 
1.5.6.3

