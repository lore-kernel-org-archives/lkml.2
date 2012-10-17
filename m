Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab2JQLja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:39:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11761 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JQLj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:39:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 17 Oct 2012 04:39:29 -0700
From: Pritesh Raithatha <praithatha@nvidia.com>
To: <linus.walleij@linaro.org>, <linux-kernel@vger.kernel.org>,
        <swarren@nvidia.com>
CC: <praithatha@nvidia.com>
Subject: [PATCH 2/2] pinctrl: tegra: set low power mode bank width to 2
Date: Wed, 17 Oct 2012 17:09:36 +0530
Message-ID: <1350473976-25700-1-git-send-email-praithatha@nvidia.com>
X-Mailer: git-send-email 1.7.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
---
 drivers/pinctrl/pinctrl-tegra.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index ae52e4e..5a5f261 100644
--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -466,7 +466,7 @@ static int tegra_pinconf_reg(struct tegra_pmx *pmx,
 		*bank = g->drv_bank;
 		*reg = g->drv_reg;
 		*bit = g->lpmd_bit;
-		*width = 1;
+		*width = 2;
 		break;
 	case TEGRA_PINCONF_PARAM_DRIVE_DOWN_STRENGTH:
 		*bank = g->drv_bank;
-- 
1.7.1

