Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab2GLKxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:53:25 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:54142 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667Ab2GLKxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:53:23 -0400
Message-Id: <201207121052.q6CAq3Ix004450@sw-eng-lt-dc-vm2>
From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20120711174257.GN3938@opensource.wolfsonmicro.com>
References: <20120711142606.GK3938@opensource.wolfsonmicro.com>
	<201207111221.q6BCLW8L014872@sw-eng-lt-dc-vm2>
	<20120711132655.GG3938@opensource.wolfsonmicro.com>
	<201207111421.q6BELFoF006060@sw-eng-lt-dc-vm2>
	<201207111513.q6BFDR1x016181@sw-eng-lt-dc-vm2>
	<20120711174257.GN3938@opensource.wolfsonmicro.com>
Date: Thu, 12 Jul 2012 11:50:38 +0100
Subject: [PATCH] regulator: Fix a typo in regulator_mode_to_status() core function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Case REGULATOR_STATUS_STANDBY -> REGULATOR_MODE_STANDBY.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
---
 drivers/regulator/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 09a737c..af44b94 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2909,7 +2909,7 @@ int regulator_mode_to_status(unsigned int mode)
 		return REGULATOR_STATUS_NORMAL;
 	case REGULATOR_MODE_IDLE:
 		return REGULATOR_STATUS_IDLE;
-	case REGULATOR_STATUS_STANDBY:
+	case REGULATOR_MODE_STANDBY:
 		return REGULATOR_STATUS_STANDBY;
 	default:
 		return 0;
-- 
1.7.0.4

