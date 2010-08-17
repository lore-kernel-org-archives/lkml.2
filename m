Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0HQMNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 08:13:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35696 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751340Ab0HQMNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 08:13:44 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] gpiolib: Hook up WM8994 gpio_to_irq()
Date: Tue, 17 Aug 2010 13:13:37 +0100
Message-Id: <1282047217-9875-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282047217-9875-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1282047217-9875-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure where this went.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/wm8994-gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/wm8994-gpio.c b/drivers/gpio/wm8994-gpio.c
index 2ac9a16..618398e 100644
--- a/drivers/gpio/wm8994-gpio.c
+++ b/drivers/gpio/wm8994-gpio.c
@@ -140,6 +140,7 @@ static struct gpio_chip template_chip = {
 	.get			= wm8994_gpio_get,
 	.direction_output	= wm8994_gpio_direction_out,
 	.set			= wm8994_gpio_set,
+	.to_irq			= wm8994_gpio_to_irq,
 	.dbg_show		= wm8994_gpio_dbg_show,
 	.can_sleep		= 1,
 };
-- 
1.7.1

