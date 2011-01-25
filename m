Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1AYKTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:19:46 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:60634 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394Ab1AYKTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:19:43 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 07/32] dma40: fix comment to refer to SOCs rather than boards
Date: Tue, 25 Jan 2011 11:18:10 +0100
Message-ID: <1295950715-22340-8-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
References: <1295950715-22340-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

And add DB8500v2 information.

Acked-by: Per Forlin <per.forlin@stericsson.com>
Acked-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ab3ca6af..0faae66 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2497,9 +2497,10 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 		{ .reg = D40_DREG_PERIPHID1, .val = 0x0000},
 		/*
 		 * D40_DREG_PERIPHID2 Depends on HW revision:
-		 *  MOP500/HREF ED has 0x0008,
+		 *  DB8500ed has 0x0008,
 		 *  ? has 0x0018,
-		 *  HREF V1 has 0x0028
+		 *  DB8500v1 has 0x0028
+		 *  DB8500v2 has 0x0038
 		 */
 		{ .reg = D40_DREG_PERIPHID3, .val = 0x0000},
 
-- 
1.7.3.2

