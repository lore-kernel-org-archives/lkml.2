Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2EXWuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:50:05 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33371 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753584Ab2EXWuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:50:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 3/3] printk: Set KERN_CONT to ""
Date: Thu, 24 May 2012 15:49:33 -0700
Message-Id: <2129d06baa995b51ce94c450f7188cc7f8d3d57b.1337899274.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1337899274.git.joe@perches.com>
References: <cover.1337899274.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging content is only printable ASCII.

Now that all KERN_<LEVEL> uses are specified by ASCII SOH,
KERN_CONT doesn't have any real purpose.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index ad76855..482121b 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -25,7 +25,7 @@ extern const char linux_proc_banner[];
  * line that had no enclosing \n). Only to be used by core/arch code
  * during early bootup (a continued line is not SMP-safe otherwise).
  */
-#define KERN_CONT	KERN_SOH "c"
+#define KERN_CONT	""
 
 extern int console_printk[];
 
-- 
1.7.8.111.gad25c.dirty

