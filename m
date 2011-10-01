Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1JAUFx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:05:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab1JAUFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 04/26] net/pxa168_eth: add missing include of interrupt.h
Date: Sat,  1 Oct 2011 22:03:36 +0200
Message-Id: <1317499438-14058-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:DZW93etWY6Mfo7fcyc7sCWMepeXytMf9jmgJWzDVSBZ
 0RK+Ef0iwXEesNRGCNZ4t0xJo6+cBMnkqk4elZBu7NhnLYZ3mu
 mWGQ+/wdZuMjwyVemkkOE5Uy5ZLjAYDELW/qiRZKaRSlxv/3y2
 U3HJL5OUiKsmrM3cfnJGCEqqZpT7SPRwZo3m4V+ITpKGfy/4Df
 52hOcVLNQFm7t71exWdUiGWnSjWDV2my3/GoROtODgIruD4ofU
 CGUn/i/Wxd2y8+A9TI/UigehD+b1d4Rq7RgRZHEfr7Pb5id1k5
 Z+tI5YdVezDdLRm2GhyVsYRZWrZw0uv/W2hdvgLrp08yLmShyu
 t05ZMyI+Eo8o793yk3Hk2iEhv/+8taCLzE3y/++0FmoLoa4sY/
 8OXSmXAsGXobA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interrupt.h is no longer implicitly included here, so manually
add it instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/pxa168_eth.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/pxa168_eth.c b/drivers/net/pxa168_eth.c
index 1a3033d..d5a6cfc 100644
--- a/drivers/net/pxa168_eth.c
+++ b/drivers/net/pxa168_eth.c
@@ -41,6 +41,7 @@
 #include <linux/phy.h>
 #include <linux/io.h>
 #include <linux/types.h>
+#include <linux/interrupt.h>
 #include <asm/pgtable.h>
 #include <asm/system.h>
 #include <asm/cacheflush.h>
-- 
1.7.5.4

