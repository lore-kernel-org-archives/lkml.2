Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab1GNQJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:09:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab1GNQJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:09:36 -0400
Date: Thu, 14 Jul 2011 12:09:30 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Message-Id: <1b9211eace14f70f8b725d1516189ff1fa3d8046.1310657068.git.jbaron@redhat.com>
In-Reply-To: <cover.1310657068.git.jbaron@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
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

