Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab0KVNv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:51:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33753 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755226Ab0KVNvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:51:25 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regulator: Remove regulator core version announcement
Date: Mon, 22 Nov 2010 13:51:19 +0000
Message-Id: <1290433879-6184-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290433879-6184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1290433879-6184-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The version hasn't been updated since the regulator API was merged in
2.6.27 so just remove it - now we're in mainline the kernel version is
much more useful.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index fe47860..64a56a7 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -32,8 +32,6 @@
 
 #include "dummy.h"
 
-#define REGULATOR_VERSION "0.5"
-
 static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
@@ -2580,8 +2578,6 @@ static int __init regulator_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "regulator: core version %s\n", REGULATOR_VERSION);
-
 	ret = class_register(&regulator_class);
 
 	regulator_dummy_init();
-- 
1.7.1

