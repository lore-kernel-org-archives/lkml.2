Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020Ab0JVSZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:25:47 -0400
Received: from kroah.org ([198.145.64.141]:37835 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758981Ab0JVSZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:25:41 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/31] driver-core: base: change to new flag variable
Date: Fri, 22 Oct 2010 11:25:07 -0700
Message-Id: <1287771916-15016-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175107.GB13489@kroah.com>
References: <20101022175107.GB13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index c12c7f2..5f51c3b 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -19,7 +19,5 @@ obj-$(CONFIG_MODULES)	+= module.o
 endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 
-ifeq ($(CONFIG_DEBUG_DRIVER),y)
-EXTRA_CFLAGS += -DDEBUG
-endif
+ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
-- 
1.7.2

