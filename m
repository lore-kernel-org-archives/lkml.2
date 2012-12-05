Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2LEKY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:24:26 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63881 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab2LEKYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:24:25 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, thomas.abraham@linaro.org,
        sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 1/1] pinctrl: samsung: Fix a typo in pinctrl-samsung.h
Date: Wed,  5 Dec 2012 15:47:35 +0530
Message-Id: <1354702655-26388-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct samsung_pin_bank does not have a member called reg_offset.
It should be pctl_offset instead.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/pinctrl/pinctrl-samsung.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-samsung.h b/drivers/pinctrl/pinctrl-samsung.h
index 5addfd1..e2d4e67 100644
--- a/drivers/pinctrl/pinctrl-samsung.h
+++ b/drivers/pinctrl/pinctrl-samsung.h
@@ -104,7 +104,7 @@ struct samsung_pinctrl_drv_data;
 
 /**
  * struct samsung_pin_bank: represent a controller pin-bank.
- * @reg_offset: starting offset of the pin-bank registers.
+ * @pctl_offset: starting offset of the pin-bank registers.
  * @pin_base: starting pin number of the bank.
  * @nr_pins: number of pins included in this bank.
  * @func_width: width of the function selector bit field.
-- 
1.7.4.1

