Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422733Ab2KNL6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:58:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54971 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673Ab2KNL6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:58:41 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 3/3] pwm: lpc32xx - Set the chip base for dynamic allocation
Date: Wed, 14 Nov 2012 12:58:15 +0100
Message-Id: <1352894295-14339-4-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:rahly3ygLFd05kInDlC1vXvl5fjsgCcs5fVv/zmECH+
 UhQDqb0W2TBkICyewELwDXkqI5pTvq+wbNs2CZ0dQhcL4akl8Q
 uWxv/vTdbxkML9KPACm1foYd6BJnCuvvYNuYrelXeyJWS3GeeG
 rudbrscGtoSi7+n4Cbu9Kw4rr0KSMwIwq0UmYOnLrZod7TmkXo
 I+oRN5V35sQ5e0o6kQoisGOQbx/jhTBfnyG7vkP6uusPnt6a7f
 4+NGiA888V171r33YjD7X/sS3226AoMJOVz6C+EFbbvk3lfmrP
 464brAjAEGT9nZegy10jHyEJLxhGkKQnFaSrFHnH/7HCfymNr0
 t39CsWwCG00g8FdaceLUZ2DATcpwHicp5iOQQA4F4a7lFsjkvQ
 p0R5V7h50+T7pI8FEGKHYwck5ETNiFzMYKaKqxrcO8+9KVDDLp
 guBmj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/pwm/pwm-lpc32xx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index f45ce2c..3e63689 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -121,6 +121,7 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
 	lpc32xx->chip.dev = &pdev->dev;
 	lpc32xx->chip.ops = &lpc32xx_pwm_ops;
 	lpc32xx->chip.npwm = 2;
+	lpc32xx->chip.base = -1;
 
 	ret = pwmchip_add(&lpc32xx->chip);
 	if (ret < 0) {
-- 
1.7.0.4

