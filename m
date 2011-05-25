Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1EYREt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:04:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2023 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab1EYRCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:02:46 -0400
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] printk: Don't allow direct inclusion
Date: Wed, 25 May 2011 10:02:40 -0700
Message-Id: <c64c1617d99e4d0bb7b77ae9bfa0d80d80f4a765.1306342673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
References: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
In-Reply-To: <cover.1306342673.git.joe@perches.com>
References: <cover.1306342673.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk.h is a subfile of kernel.h, do not allow
it to be included directly.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ee048e7..3736545 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -1,3 +1,7 @@
+#ifndef _LINUX_KERNEL_H
+#error "Do not include <linux/printk.h>, use <linux/kernel.h> instead"
+#endif
+
 #ifndef __KERNEL_PRINTK__
 #define __KERNEL_PRINTK__
 
-- 
1.7.4.rc3

