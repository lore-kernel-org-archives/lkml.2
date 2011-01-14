Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604Ab1ANOTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:19:17 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:50025 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396Ab1ANOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:05 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 01/27] kernel: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:24 -0800
Message-Id: <24def639d4d33e9f50e11d7ae33f6039b6f92573.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 kernel/gcov/Makefile  |    2 +-
 kernel/power/Makefile |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/gcov/Makefile b/kernel/gcov/Makefile
index 3f76100..e97ca59 100644
--- a/kernel/gcov/Makefile
+++ b/kernel/gcov/Makefile
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
+ccflags-y := -DSRCTREE='"$(srctree)"' -DOBJTREE='"$(objtree)"'
 
 obj-$(CONFIG_GCOV_KERNEL) := base.o fs.o gcc_3_4.o
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index c350e18..c5ebc6a 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -1,4 +1,5 @@
-ccflags-$(CONFIG_PM_DEBUG)	:=	-DDEBUG
+
+ccflags-$(CONFIG_PM_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
-- 
1.7.3.4

