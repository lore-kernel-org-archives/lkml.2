Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab1ANOOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:14:36 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:55368 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757565Ab1ANONi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:13:38 -0500
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 18/27] isdn: change to new flag variable
Date: Fri, 14 Jan 2011 06:12:41 -0800
Message-Id: <e19eff48eb0bbfdbdc115f632cfa74837e11c3a1.1295006565.git.mfm@muteddisk.com>
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
1.7.3.4

