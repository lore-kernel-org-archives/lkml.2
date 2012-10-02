Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab2JBCHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 22:07:21 -0400
Received: from noserose.net ([66.220.18.76]:53287 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752968Ab2JBCHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 22:07:20 -0400
Date: Mon, 1 Oct 2012 19:07:15 -0700
Message-Id: <230b8409008d3d45868ab4ab4a04d519996fb9a1.1349104674.git.ecashin@coraid.com>
In-Reply-To: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
References: <3c9c2338b9c963e1d5f19cc9ed51b01cf829eeee.1349104674.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 5/7] aoe: remove unused code
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 4ae2468..c2bf797 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -10,9 +10,6 @@
 #define AOE_PARTITIONS (16)
 #endif
 
-#define SYSMINOR(aoemajor, aoeminor) ((aoemajor) * NPERSHELF + (aoeminor))
-#define AOEMAJOR(sysminor) ((sysminor) / NPERSHELF)
-#define AOEMINOR(sysminor) ((sysminor) % NPERSHELF)
 #define WHITESPACE " \t\v\f\n"
 
 enum {
@@ -82,7 +79,6 @@ enum {
 
 enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
-	NPERSHELF = 16,		/* number of slots per shelf address */
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
-- 
1.7.1

