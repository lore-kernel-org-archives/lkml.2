Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2DXNVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:21:40 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:45743 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab2DXNVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:21:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: fix dangling comment
Date: Tue, 24 Apr 2012 15:21:16 +0200
Message-ID: <1335273676-22212-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This comment was referring to an older PINMUX define, it should
be PINCTRL now.

Reported-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/pinctrl/machine.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pinctrl/machine.h b/include/linux/pinctrl/machine.h
index e4d1de7..9c4a198 100644
--- a/include/linux/pinctrl/machine.h
+++ b/include/linux/pinctrl/machine.h
@@ -163,5 +163,5 @@ static inline int pinctrl_register_mappings(struct pinctrl_map const *map,
 	return 0;
 }
 
-#endif /* !CONFIG_PINMUX */
+#endif /* !CONFIG_PINCTRL */
 #endif
-- 
1.7.9.2

