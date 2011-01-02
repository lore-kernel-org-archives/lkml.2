Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab1ABDJh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 22:09:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:44717 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1ABDJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 22:09:36 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH] rtc: delete legacy MAINTAINERS entry
Date: Sat,  1 Jan 2011 22:08:43 -0500
Message-Id: <1293937723-15986-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
X-OriginalArrivalTime: 02 Jan 2011 03:09:25.0483 (UTC) FILETIME=[75F993B0:01CBAA2A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

People stumble across the entry for the legacy PC specific
RTC driver entry in MAINTAINERS when they really want the
multi-arch, multi-driver RTC subsystem.  So just delete the
old entry that is causing the confusion.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
---
 MAINTAINERS |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa835f7..eb7a06b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4994,11 +4994,6 @@ F:	kernel/rcu*
 F:	kernel/srcu*
 X:	kernel/rcutorture.c
 
-REAL TIME CLOCK DRIVER (LEGACY)
-M:	Paul Gortmaker <p_gortmaker@yahoo.com>
-S:	Maintained
-F:	drivers/char/rtc.c
-
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
 L:	rtc-linux@googlegroups.com
-- 
1.7.3.3

