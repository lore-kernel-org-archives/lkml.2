Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab0IXTVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:21:32 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:41643 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757676Ab0IXTV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:21:27 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/24] isdn: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:20 -0700
Message-Id: <ec9520aca140f253d8bad33cf35b8e668e7e9c9c.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
 <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
 <b484ccf548e1700e09ac7f731289503bf3e7b3bf.1285355033.git.mfm@muteddisk.com>
 <2c0fbcaafb18007c5c83823cb33e35120fe15091.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/isdn/hisax/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hisax/Makefile b/drivers/isdn/hisax/Makefile
index ab638b08..646368f 100644
--- a/drivers/isdn/hisax/Makefile
+++ b/drivers/isdn/hisax/Makefile
@@ -4,7 +4,7 @@
 
 # Define maximum number of cards
 
-EXTRA_CFLAGS      += -DHISAX_MAX_CARDS=$(CONFIG_HISAX_MAX_CARDS)
+ccflags-y      := -DHISAX_MAX_CARDS=$(CONFIG_HISAX_MAX_CARDS)
 
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax.o
 obj-$(CONFIG_HISAX_SEDLBAUER_CS)	+= sedlbauer_cs.o
-- 
1.7.2.1

