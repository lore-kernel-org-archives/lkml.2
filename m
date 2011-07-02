Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab1GBWF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 18:05:29 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:40421 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754728Ab1GBWF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 18:05:28 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: trivial@kernel.org
Cc: ext-phil.2.carmody@nokia.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] mn10300: there is no CONFIG_CALIBRATE_DELAY
Date: Sun,  3 Jul 2011 00:47:46 +0300
Message-Id: <1309643272-364-2-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
References: <1309643272-364-1-git-send-email-ext-phil.2.carmody@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is, however, CONFIG_GENERIC_CALIBRATE_DELAY.

Part of a shotgun patchset; found by greps, seds, and diffs
rather than actual understanding.

Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
---
 arch/mn10300/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 9242e9f..d159b87 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -855,7 +855,7 @@ static void __init smp_callin(void)
 		BUG();
 	}
 
-#ifdef CONFIG_CALIBRATE_DELAY
+#ifdef CONFIG_GENERIC_CALIBRATE_DELAY
 	calibrate_delay();		/* Get our bogomips */
 #endif
 
-- 
1.7.2.5

