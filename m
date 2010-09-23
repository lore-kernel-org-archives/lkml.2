Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab0IWGvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:51:52 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:59753 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591Ab0IWGvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:51:47 -0400
From: matt mooney <mfm@muteddisk.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "David S. Miller" <davem@davemloft.net>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 09/20] microblaze: change to new flag variable
Date: Wed, 22 Sep 2010 23:50:57 -0700
Message-Id: <1285224657-29763-1-git-send-email-mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 arch/microblaze/kernel/cpu/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/kernel/cpu/Makefile b/arch/microblaze/kernel/cpu/Makefile
index 59cc7bc..fceed4e 100644
--- a/arch/microblaze/kernel/cpu/Makefile
+++ b/arch/microblaze/kernel/cpu/Makefile
@@ -6,7 +6,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_cache.o = -pg
 endif
 
-EXTRA_CFLAGS += -DCPU_MAJOR=$(CPU_MAJOR) -DCPU_MINOR=$(CPU_MINOR) \
+ccflags-y := -DCPU_MAJOR=$(CPU_MAJOR) -DCPU_MINOR=$(CPU_MINOR) \
 		-DCPU_REV=$(CPU_REV)
 
 obj-y += cache.o cpuinfo.o cpuinfo-pvr-full.o cpuinfo-static.o mb.o pvr.o
-- 
1.7.2.1

