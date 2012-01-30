Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2A3WJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:09:08 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:48691 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab2A3WJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:09:04 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: ath5k-devel@venema.h4ckr.net
Cc: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Bob Copeland <me@bobcopeland.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] ath5k: make ath5k_modparam_no_hw_rfkill_switch real
Date: Mon, 30 Jan 2012 23:00:15 +0100
Message-Id: <1327960820-11867-12-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327961344;a4c7c510;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make ath5k_modparam_no_hw_rfkill_switch real bool to fix:
'warning: return from incompatible pointer type' compiler warning.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d366dad..ad2f115 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -80,7 +80,7 @@ static bool modparam_fastchanswitch;
 module_param_named(fastchanswitch, modparam_fastchanswitch, bool, S_IRUGO);
 MODULE_PARM_DESC(fastchanswitch, "Enable fast channel switching for AR2413/AR5413 radios.");
 
-static int ath5k_modparam_no_hw_rfkill_switch;
+static bool ath5k_modparam_no_hw_rfkill_switch;
 module_param_named(no_hw_rfkill_switch, ath5k_modparam_no_hw_rfkill_switch,
 								bool, S_IRUGO);
 MODULE_PARM_DESC(no_hw_rfkill_switch, "Ignore the GPIO RFKill switch state");
-- 
1.7.7.3

