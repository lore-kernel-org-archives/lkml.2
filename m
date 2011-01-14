Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab1ANOOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:14:46 -0500
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:41527
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546Ab1ANONg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:13:36 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 16/27] ide: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:39 -0800
Message-Id: <9f38b4a1cb0035e9605856b3b116cec6e11476e9.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 drivers/ide/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/Makefile b/drivers/ide/Makefile
index 81df925..7f879b2 100644
--- a/drivers/ide/Makefile
+++ b/drivers/ide/Makefile
@@ -2,7 +2,7 @@
 # link order is important here
 #
 
-EXTRA_CFLAGS				+= -Idrivers/ide
+ccflags-y				:= -Idrivers/ide
 
 ide-core-y += ide.o ide-ioctls.o ide-io.o ide-iops.o ide-lib.o ide-probe.o \
 	      ide-taskfile.o ide-pm.o ide-park.o ide-sysfs.o ide-devsets.o \
-- 
1.7.3.4

