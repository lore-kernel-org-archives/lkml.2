Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab1JKIt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:49:56 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:55439 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758Ab1JKItw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:49:52 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] mfd/ab8500-core: remove support for early drop chip
Date: Tue, 11 Oct 2011 10:49:39 +0200
Message-ID: <1318322979-11503-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch removes the early drop version of ab8500 which have
the really bad version nr 0x0. This chip should not be found in
the wild and only exist as ST-Ericsson scrap equipment.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Reviewed-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 14ee189..41da973 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -844,7 +844,6 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 		return ret;
 
 	switch (value) {
-	case AB8500_CUTEARLY:
 	case AB8500_CUT1P0:
 	case AB8500_CUT1P1:
 	case AB8500_CUT2P0:
-- 
1.7.3.2

