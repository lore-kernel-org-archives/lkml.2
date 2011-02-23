Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1BWFof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:44:35 -0500
Received: from mail.perches.com ([173.55.12.10]:3855 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1BWFmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:32 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 10/18] MAINTAINERS: Remove unused clockevents.h
Date: Tue, 22 Feb 2011 21:42:03 -0800
Message-Id: <a3262af7d515b591a5d1c480b85598dccba09441.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 88606e80da0e8d862a42ee19e5bb60b01b940ea7
("MAINTAINERS: Update timer related entries")
added a file that doesn't exist.  Remove it.

cc: John Stultz <johnstul@us.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3508c0f..5e90ba7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2970,7 +2970,6 @@ F:	kernel/hrtimer.c
 F:	kernel/time/clockevents.c
 F:	kernel/time/tick*.*
 F:	kernel/time/timer_*.c
-F:	include/linux/clockevents.h
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
-- 
1.7.4.rc3

