Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0KWS2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 13:28:06 -0500
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:41304 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab0KWS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 13:28:05 -0500
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: [PATCH 1/3] mfd: Added new regulator_data pointer to ab8500 board configuration
Date: Tue, 23 Nov 2010 19:25:52 +0100
Message-ID: <1290536754-21775-2-git-send-email-bengt.g.jonsson@stericsson.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ab8500 regulator board configuration will be better separated
from the MFD board configuration. This patch adds a void pointer
for this purpose.

Signed-off-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
---
 include/linux/mfd/ab8500.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
index d63b605..70d8d9a 100644
--- a/include/linux/mfd/ab8500.h
+++ b/include/linux/mfd/ab8500.h
@@ -146,6 +146,7 @@ struct ab8500_platform_data {
 	int irq_base;
 	void (*init) (struct ab8500 *);
 	struct regulator_init_data *regulator[AB8500_NUM_REGULATORS];
+	void *regulator_data;
 };
 
 extern int __devinit ab8500_init(struct ab8500 *ab8500);
-- 
1.7.2.2

