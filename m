Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab2CFM42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:56:28 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:52624 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750979Ab2CFM40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:56:26 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: include machine header to core.h
Date: Tue, 6 Mar 2012 13:55:57 +0100
Message-ID: <1331038557-1398-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

struct pinctrl_setting contains an enum pinctrl_map_type
field, so we need to include machine.h. Also fix kerneldoc
to indicate that the pinctrl_setting is about both muxing
and other config.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 5b3ff13..42fb0ea 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -12,6 +12,7 @@
 #include <linux/mutex.h>
 #include <linux/radix-tree.h>
 #include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/machine.h>
 
 struct pinctrl_gpio_range;
 
-- 
1.7.8

