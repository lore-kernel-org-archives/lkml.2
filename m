Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0IXTVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:21:08 -0400
Received: from qmta14.emeryville.ca.mail.comcast.net ([76.96.27.212]:53125
	"EHLO qmta14.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757654Ab0IXTVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:21:05 -0400
From: matt mooney <mfm@muteddisk.com>
To: kernel-janitors@vger.kernel.org
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sergey Lapin <slapin@ossfans.org>,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 07/24] ieee802154: change to new flag variable
Date: Fri, 24 Sep 2010 12:17:17 -0700
Message-Id: <40a2d76d013ad025d08a411992af10f6bbef0a13.1285355033.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <9968d4260be8850200cc9c7dfe08addf611468b4.1285355033.git.mfm@muteddisk.com>
 <036514b5dd23c5af14303519d79d60d79adccbee.1285355033.git.mfm@muteddisk.com>
 <ffbd189ef2d414ea7c87ffe2b40fce87877dc014.1285355033.git.mfm@muteddisk.com>
 <b3e2061e1e6703f7b84c0484030e07de6000546a.1285355033.git.mfm@muteddisk.com>
 <70fe6b462b3ee22922698a12d62d650cf029033a.1285355033.git.mfm@muteddisk.com>
In-Reply-To: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace EXTRA_CFLAGS with ccflags-y.

Signed-off-by: matt mooney <mfm@muteddisk.com>
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
1.7.2.1

