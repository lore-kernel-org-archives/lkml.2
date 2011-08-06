Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab1HFRWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:22:01 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39934 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1HFRWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:22:00 -0400
From: stufever@gmail.com
To: linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, jarod@redhat.com,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
Subject: [PATCH] media: declare redrat3_init_rc_dev with the same parameter types
Date: Sun,  7 Aug 2011 01:19:15 +0800
Message-Id: <1312651155-21891-1-git-send-email-wangshaoyan.pt@taobao.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Shaoyan <wangshaoyan.pt@taobao.com>

  drivers/media/rc/redrat3.c: In function 'redrat3_init_rc_dev':
  drivers/media/rc/redrat3.c:1107: warning: assignment from incompatible pointer type

Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 drivers/media/rc/redrat3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index a166044..332ffa4 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -912,7 +912,7 @@ static int redrat3_set_tx_carrier(struct rc_dev *dev, u32 carrier)
 	return carrier;
 }
 
-static int redrat3_transmit_ir(struct rc_dev *rcdev, int *txbuf, u32 n)
+static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf, unsigned n)
 {
 	struct redrat3_dev *rr3 = rcdev->priv;
 	struct device *dev = rr3->dev;
-- 
1.7.0.4

