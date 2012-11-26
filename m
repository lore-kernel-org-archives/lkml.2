Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933710Ab2KZRL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:11:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47925 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933680Ab2KZRLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:11:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 191/270] pinctrl: tegra: set low power mode bank width to 2
Date: Mon, 26 Nov 2012 14:58:01 -0200
Message-Id: <1353949160-26803-192-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit 154f3ebf53edcfbe28728452b4ab37a118581125 upstream.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pinctrl/pinctrl-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-tegra.c b/drivers/pinctrl/pinctrl-tegra.c
index b693486..2c9166d 100644
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
1.7.9.5

