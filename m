Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab1ANOPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:15:15 -0500
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:51795 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab1ANONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:13:25 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 07/27] microblaze: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:30 -0800
Message-Id: <cc64e68a71abc5be604000a1e41a075941b07cbc.1295006565.git.mfm@muteddisk.com>
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
1.7.3.4

