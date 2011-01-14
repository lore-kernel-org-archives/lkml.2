Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab1ANOUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:20:08 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:50172 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757841Ab1ANOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:34 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 23/27] pps: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:46 -0800
Message-Id: <37dffa3e35a72f49703d2b9ef685d5f770fde771.1295006565.git.mfm@muteddisk.com>
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
 drivers/pps/clients/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
index 42517da..4feb7e9 100644
--- a/drivers/pps/clients/Makefile
+++ b/drivers/pps/clients/Makefile
@@ -6,6 +6,4 @@ obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= pps-ktimer.o
 obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
 obj-$(CONFIG_PPS_CLIENT_PARPORT) += pps_parport.o
 
-ifeq ($(CONFIG_PPS_DEBUG),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_PPS_DEBUG) := -DDEBUG
-- 
1.7.3.4

