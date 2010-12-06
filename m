Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0LFFoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 00:44:44 -0500
Received: from mail.perches.com ([173.55.12.10]:2299 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab0LFFob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 00:44:31 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-embedded@vger.kernel.org
Subject: [PATCH 7/7] include/linux/printk.h: Use tab not spaces for indent
Date: Sun,  5 Dec 2010 21:44:21 -0800
Message-Id: <720b89950aa24fc12b19b8607f7d511f9402bafd.1291611193.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1291611190.git.joe@perches.com>
References: <cover.1291611190.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/printk.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index b4be1b1..41388e3 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -145,20 +145,20 @@ extern void dump_stack(void) __cold;
 #endif
 
 #define pr_emerg(fmt, ...) \
-        printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_alert(fmt, ...) \
-        printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_crit(fmt, ...) \
-        printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_err(fmt, ...) \
-        printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warning(fmt, ...) \
-        printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_warn pr_warning
 #define pr_notice(fmt, ...) \
-        printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_info(fmt, ...) \
-        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
 
-- 
1.7.3.2.245.g03276.dirty

