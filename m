Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1JKItr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:49:47 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:52094 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880Ab1JKItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:49:41 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] mfd/ab8500-core: Add support for ab8500 v3.3
Date: Tue, 11 Oct 2011 10:49:32 +0200
Message-ID: <1318322972-11470-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch adds support for ab8500 cut 3, MetalFix 3 or v3.3.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Reviewed-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index eb238ee..14ee189 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -849,6 +849,7 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	case AB8500_CUT1P1:
 	case AB8500_CUT2P0:
 	case AB8500_CUT3P0:
+	case AB8500_CUT3P3:
 		dev_info(ab8500->dev, "detected chip, revision: %#x\n", value);
 		break;
 	default:
-- 
1.7.3.2

