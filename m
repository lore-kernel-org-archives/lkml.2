Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1DJOMe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:12:34 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:49406 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1DJOMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=duhn4jec9tcElOaP3uzgmTAnzl7cqy9ekDboFHMmT/5XLGV8Yowub/dxAEOF3QkQs+
         NlkDYhw/zncfLRoomJgFPwhhFQxS5UUoF8pAE+BlifG35A9YD4ESZlP7TV7BaWVzKntM
         k42YGbV0lZpxgIarORGoJNmnnSsKzoosj3whI=
From: wanlong.gao@gmail.com
To: broonie@opensource.wolfsonmicro.com, geert@linux-m68k.org,
        starvik@axis.com, jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 3/5] net:removed the unused variable
Date: Sun, 10 Apr 2011 22:10:27 +0800
Message-Id: <1302444629-17043-3-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
References: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

removed the unused variable "np" of eth_v10.c.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 drivers/net/cris/eth_v10.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 9d267d3..f3b7741 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -1132,7 +1132,6 @@ static irqreturn_t
 e100rxtx_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	struct net_local *np = netdev_priv(dev);
 	unsigned long irqbits;
 
 	/*
-- 
1.7.3

