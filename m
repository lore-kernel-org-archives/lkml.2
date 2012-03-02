Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab2CBPyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 10:54:19 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:52836 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879Ab2CBPyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 10:54:17 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: fix the pin descriptor kerneldoc
Date: Fri, 2 Mar 2012 16:53:41 +0100
Message-ID: <1330703621-4044-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The introduction of the owner field on the pin descriptor was not
properly documented so fix this up.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 97f8124..e1dfdb3 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -76,9 +76,7 @@ struct pinctrl {
  *	datasheet or such
  * @dynamic_name: if the name of this pin was dynamically allocated
  * @lock: a lock to protect the descriptor structure
- * @mux_requested: whether the pin is already requested by pinmux or not
- * @mux_function: a named muxing function for the pin that will be passed to
- *	subdrivers and shown in debugfs etc
+ * @owner: the device holding this pin or NULL of no device has claimed it
  */
 struct pin_desc {
 	struct pinctrl_dev *pctldev;
-- 
1.7.8

