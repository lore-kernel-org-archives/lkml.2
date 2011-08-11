Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1HKSgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab1HKSgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:36:43 -0400
Date: Thu, 11 Aug 2011 14:36:38 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <fd40bfaaf75df83a44b9b69eb7c8d06b83c042f3.1313085588.git.jbaron@redhat.com>
In-Reply-To: <cover.1313085588.git.jbaron@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
Subject: [PATCH 05/11] dynamic_debug: remove unused control variables
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Remove no longer used dynamic debug control variables. The
definitions were removed a while ago, but we forgot to clean
up the extern references.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index bdf1531..843cb9e 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -1,13 +1,6 @@
 #ifndef _DYNAMIC_DEBUG_H
 #define _DYNAMIC_DEBUG_H
 
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
1.7.5.4

