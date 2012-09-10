Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521Ab2IJMK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:10:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:65440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2IJMKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:10:24 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mfd: twl: Move PWM driver to PWM framework
Date: Mon, 10 Sep 2012 14:10:18 +0200
Message-Id: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12
X-Provags-ID: V02:K0:qYg8Z0G/N7ou7eWS2Hc4YGnw4IN/WPEbjlJ4w+MMc3f
 cvGlg/ZcuoLF19ZGLt8cw03rvcocp7vZdIMsaZSKMr9t4SxCs/
 VSwN9WAEgpRNuDHyPU2qfPJuUEPPn1iXTZwRNInE1Ttf0cYjrP
 J6pIyPBirTHu5cAVEZbqLGCv1vp9D6XI/0t3o/Rl/TwXQ4OIWd
 Mr5c/+MQFcQz0qg1elM42jq9DCTJK1C3LpLLMp7fdQPV6syRte
 pSjK5G/2dFHnGoFVZgOU0N8NKGbPetQ6/+Sza8KHJX7KWt7Yod
 L0ulgy6+uNVFXlXGIAoVnhuoH5D+UchiseGFgjjbv4diT5C5MY
 2iAjx57RnHuZvetfrqYrbwoED+Y5nZgwxQFdDEVBXhad07CS+H
 6EY8vZLyLoBPy2UoTmk7B2QkoAWNu16dSjHpCMkwDS/x7/XCmV
 6sQJ6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This mini series replaces the twl_has_*() macros by the equivalent
standard IS_ENABLED() macro and moves the PWM driver to the PWM
framework.

I'll take the second patch through the PWM tree but would like to have
some Acked-bys from people that know and have the hardware and can
verify that I haven't broken anything.

Thierry

Thierry Reding (2):
  mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
  pwm: Move TWL6030 PWM driver to PWM framework

 drivers/mfd/Kconfig       |  10 ---
 drivers/mfd/Makefile      |   1 -
 drivers/mfd/twl-core.c    | 124 ++++++++-----------------------
 drivers/mfd/twl6030-pwm.c | 165 -----------------------------------------
 drivers/pwm/Kconfig       |   9 +++
 drivers/pwm/Makefile      |   1 +
 drivers/pwm/pwm-twl6030.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 226 insertions(+), 268 deletions(-)
 delete mode 100644 drivers/mfd/twl6030-pwm.c
 create mode 100644 drivers/pwm/pwm-twl6030.c

-- 
1.7.12

