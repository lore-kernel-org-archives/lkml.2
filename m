Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1BWFqC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 00:46:02 -0500
Received: from mail.perches.com ([173.55.12.10]:3855 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab1BWFma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 00:42:30 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] MAINTAINERS: Add missing : after HR Timers F tag
Date: Tue, 22 Feb 2011 21:41:57 -0800
Message-Id: <495c1ab9755c86d1dfb037db5ed444fcd2e7ac21.1298439175.git.joe@perches.com>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <cover.1298439175.git.joe@perches.com>
References: <cover.1298439175.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 920d8d3..fc5d548 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2973,7 +2973,7 @@ F:	kernel/hrtimer.c
 F:	kernel/time/clockevents.c
 F:	kernel/time/tick*.*
 F:	kernel/time/timer_*.c
-F	include/linux/clockevents.h
+F:	include/linux/clockevents.h
 F:	include/linux/hrtimer.h
 
 HIGH-SPEED SCC DRIVER FOR AX.25
-- 
1.7.4.rc3

