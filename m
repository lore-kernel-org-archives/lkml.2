Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1IOGp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 02:45:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50696 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1IOGp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 02:45:57 -0400
Subject: [PATCH] xtensa: fix prototype for ccount_read()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chris Zankel <chris@zankel.net>, Torben Hohn <torbenh@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 14:45:05 +0800
Message-ID: <1316069105.2283.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 02101fa01a443c224fd92bb49ff5ca9d64218c2b Mon Sep 17 00:00:00 2001
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 15 Sep 2011 14:39:26 +0800
Subject: [PATCH] xtensa: fix prototype for ccount_read()

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/xtensa/kernel/time.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index f3e5eb4..db18807 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -31,7 +31,7 @@ unsigned long ccount_per_jiffy;		/* per 1/HZ */
 unsigned long nsec_per_ccount;		/* nsec per ccount increment */
 #endif
 
-static cycle_t ccount_read(void)
+static cycle_t ccount_read(struct clocksource *cs)
 {
 	return (cycle_t)get_ccount();
 }
-- 
1.7.4.1



