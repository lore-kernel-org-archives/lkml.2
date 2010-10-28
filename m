Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0J1PZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:25:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53713 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503Ab0J1PZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=cBDp7duO4Ong2WmfrD4f5kaJlyb1d7qScOST6I+Brqd0hDT83u+wgYQvbXubnJwed+
         MG8xgO+UeRPaeFTG3L/2ATU/sHwxHflsYSfuqEmSlFVv5sj1hXhz86hKV7/bLdUSzphD
         5+n4rdHTNd3XQSAPCVxogJLCDvgPHJ16Fm8nA=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: Rabin Vincent <rabin@rab.in>, Jason Baron <jbaron@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] dynamic debug: remove unused declarations
Date: Thu, 28 Oct 2010 20:55:07 +0530
Message-Id: <1288279507-6266-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definitions of these variables are gone since 52159d98b (jump label:
Convert dynamic debug to use jump labels).  Remove the declarations.

Cc: Jason Baron <jbaron@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 include/linux/dynamic_debug.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index a90b389..c7a88a4 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -3,13 +3,6 @@
 
 #include <linux/jump_label.h>
 
-/* dynamic_printk_enabled, and dynamic_printk_enabled2 are bitmasks in which
- * bit n is set to 1 if any modname hashes into the bucket n, 0 otherwise. They
- * use independent hash functions, to reduce the chance of false positives.
- */
-extern long long dynamic_debug_enabled;
-extern long long dynamic_debug_enabled2;
-
 /*
  * An instance of this structure is created in a special
  * ELF section at every dynamic debug callsite.  At runtime,
-- 
1.7.2.3

