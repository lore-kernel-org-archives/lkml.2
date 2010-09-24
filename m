Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab0IXTSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:18:42 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:55849 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757522Ab0IXTSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:18:41 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 01/24] base: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:11 -0700
Message-Id: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
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
1.7.2.1

