Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab1EBTVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 15:21:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:53562 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1EBTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 15:21:10 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimer: make lookup table const
Date: Mon,  2 May 2011 15:24:27 -0400
Message-Id: <1304364267-14489-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 kernel/hrtimer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 87fdb3f..dbbbf7d 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -81,7 +81,7 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 	}
 };
 
-static int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
+static const int hrtimer_clock_to_base_table[MAX_CLOCKS] = {
 	[CLOCK_REALTIME]	= HRTIMER_BASE_REALTIME,
 	[CLOCK_MONOTONIC]	= HRTIMER_BASE_MONOTONIC,
 	[CLOCK_BOOTTIME]	= HRTIMER_BASE_BOOTTIME,
-- 
1.7.5.rc3

