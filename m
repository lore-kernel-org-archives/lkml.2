Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab1ANOUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:20:04 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:50166 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546Ab1ANOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:34 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 25/27] rtc: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:48 -0800
Message-Id: <371c0331c71be41ddaba669cd793e1f6ecf0b622.1295006565.git.mfm@muteddisk.com>
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
 drivers/rtc/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 2afdaf3..5f6c383 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -2,9 +2,7 @@
 # Makefile for RTC class/drivers.
 #
 
-ifeq ($(CONFIG_RTC_DEBUG),y)
-	EXTRA_CFLAGS		+= -DDEBUG
-endif
+ccflags-$(CONFIG_RTC_DEBUG)	:= -DDEBUG
 
 obj-$(CONFIG_RTC_LIB)		+= rtc-lib.o
 obj-$(CONFIG_RTC_HCTOSYS)	+= hctosys.o
-- 
1.7.3.4

