Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1BWFoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:44:00 -0500
Received: from mail.perches.com ([173.55.12.10]:3858 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab1BWFmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:32 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 12/18] MAINTAINERS: Remove unused TIMEKEEPING timekeeping.h
Date: Tue, 22 Feb 2011 21:42:05 -0800
Message-Id: <1e6297e3b8b8a308c7b75ab45ac6dfe8adcf4939.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 88606e80da0e8d862a42ee19e5bb60b01b940ea7
("MAINTAINERS: Update timer related entries")
added a file pattern that didn't actually exist.

cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf8431a..6e4d58d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5377,7 +5377,6 @@ S:	Supported
 F:	include/linux/clocksource.h
 F:	include/linux/time.h
 F:	include/linux/timex.h
-F:	include/linux/timekeeping.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
-- 
1.7.4.rc3

