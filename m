Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab1J1VpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:45:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55737 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1J1VpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:45:20 -0400
From: jhbird.choi@gmail.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Jonghwan Choi <jhbird.choi@gmail.com>
Subject: [PATCH] ARM: SAMSUNG: Fix compile error due to kfree
Date: Sat, 29 Oct 2011 06:45:12 +0900
Message-Id: <1319838312-8205-1-git-send-email-jhbird.choi@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@gmail.com>

Fix  implicit declaration of function 'kfree'

Signed-off-by: Jonghwan Choi <jhbird.choi@gmail.com>
---
 arch/arm/plat-samsung/dev-backlight.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/dev-backlight.c b/arch/arm/plat-samsung/dev-backlight.c
index 3cedd4c..2adbeae 100644
--- a/arch/arm/plat-samsung/dev-backlight.c
+++ b/arch/arm/plat-samsung/dev-backlight.c
@@ -14,6 +14,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/pwm_backlight.h>
+#include <linux/slab.h>
 
 #include <plat/devs.h>
 #include <plat/gpio-cfg.h>
-- 
1.7.0.4

