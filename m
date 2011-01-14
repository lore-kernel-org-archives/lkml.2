Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab1ANOVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:21:48 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:50197 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757396Ab1ANOTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:19 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 09:19:03 EST
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 17/27] ieee802154: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:40 -0800
Message-Id: <103b89667745fc3022720260762ce611d40fc49a.1295006565.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <cover.1295006561.git.mfm@muteddisk.com>
References: <cover.1295006561.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/ieee802154/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ieee802154/Makefile b/drivers/ieee802154/Makefile
index e0e8e1a..6899913 100644
--- a/drivers/ieee802154/Makefile
+++ b/drivers/ieee802154/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_IEEE802154_FAKEHARD) += fakehard.o
 
-EXTRA_CFLAGS += -DDEBUG -DCONFIG_FFD
+ccflags-y := -DDEBUG -DCONFIG_FFD
-- 
1.7.3.4

