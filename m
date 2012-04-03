Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab2DCEys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 00:54:48 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:41004
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515Ab2DCEyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 00:54:47 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Ying <Ying.Liu@freescale.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: <g.liakhovetski@gmx.de>, <hechtb@gmail.com>, <sfr@canb.auug.org.au>,
        <clalancette@gmail.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 1/1] V4L: OV5642:remove redundant code to set cropping w/h
Date: Tue, 3 Apr 2012 11:58:01 +0800
Message-ID: <1333425481-14472-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains code change only to remove redundant
code to set priv->crop_rect.width/height in probe function.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
Acked-by: Chris Lalancette <clalancette@gmail.com>
---
 drivers/media/video/ov5642.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index bb37ec8..efdd6be 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -1025,8 +1025,6 @@ static int ov5642_probe(struct i2c_client *client,
 	priv->crop_rect.height	= OV5642_DEFAULT_HEIGHT;
 	priv->crop_rect.left	= (OV5642_MAX_WIDTH - OV5642_DEFAULT_WIDTH) / 2;
 	priv->crop_rect.top	= (OV5642_MAX_HEIGHT - OV5642_DEFAULT_HEIGHT) / 2;
-	priv->crop_rect.width	= OV5642_DEFAULT_WIDTH;
-	priv->crop_rect.height	= OV5642_DEFAULT_HEIGHT;
 	priv->total_width = OV5642_DEFAULT_WIDTH + BLANKING_EXTRA_WIDTH;
 	priv->total_height = BLANKING_MIN_HEIGHT;
 
-- 
1.7.1


