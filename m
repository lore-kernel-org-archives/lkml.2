Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1FAR76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:59:58 -0400
Received: from mail.perches.com ([173.55.12.10]:2374 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab1FAR7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:59:19 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/6] MAINTAINERS: Update HIGH RESOLUTION TIMERS patterns
Date: Wed,  1 Jun 2011 10:59:11 -0700
Message-Id: <cd1888389931e38cbc5de6f53676f727387d6574.1306950701.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306950701.git.joe@perches.com>
References: <cover.1306950701.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clockchips.h was typoed as clockevents.h

cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d43f2b..ab6340f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2993,7 +2993,7 @@ F:	kernel/hrtimer.c
 F:	kernel/time/clockevents.c
 F:	kernel/time/tick*.*
 F:	kernel/time/timer_*.c
-F:	include/linux/clockevents.h
+F:	include/linux/clockchips.h
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
-- 
1.7.5.rc3.dirty

