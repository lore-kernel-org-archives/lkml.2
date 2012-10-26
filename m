Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2JZAQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:16:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:53905 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab2JZAIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:08:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [ 55/85] pinctrl: tegra: set low power mode bank width to 2
Date: Thu, 25 Oct 2012 17:06:13 -0700
Message-Id: <20121026000036.645939738@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000031.107227138@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pritesh Raithatha <praithatha@nvidia.com>

commit 154f3ebf53edcfbe28728452b4ab37a118581125 upstream.

Signed-off-by: Pritesh Raithatha <praithatha@nvidia.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-tegra.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-tegra.c
+++ b/drivers/pinctrl/pinctrl-tegra.c
@@ -466,7 +466,7 @@ static int tegra_pinconf_reg(struct tegr
 		*bank = g->drv_bank;
 		*reg = g->drv_reg;
 		*bit = g->lpmd_bit;
-		*width = 1;
+		*width = 2;
 		break;
 	case TEGRA_PINCONF_PARAM_DRIVE_DOWN_STRENGTH:
 		*bank = g->drv_bank;


