Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0LDOd6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 09:33:58 -0500
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:58853 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754987Ab0LDOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 09:33:56 -0500
Date: Sat, 4 Dec 2010 15:29:23 +0100
From: Nicolas Kaiser <nikai@nikai.net>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Pavel Revak <palo@bielyvlk.sk>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm/income pxa270: enable backlight when pwm_bl is a module
Message-ID: <20101204152923.04244dfa@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a suspected typo in the config symbol.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
I don't have the hardware to test, but this config symbol looks
unusual enough to me that I'm suspecting it might be a typo.

 arch/arm/mach-pxa/colibri-pxa270-income.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/colibri-pxa270-income.c b/arch/arm/mach-pxa/colibri-pxa270-income.c
index 37f0f3e..3aba0e1 100644
--- a/arch/arm/mach-pxa/colibri-pxa270-income.c
+++ b/arch/arm/mach-pxa/colibri-pxa270-income.c
@@ -231,7 +231,7 @@ static inline void income_lcd_init(void) {}
 /******************************************************************************
  * Backlight
  ******************************************************************************/
-#if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM__MODULE)
+#if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM_MODULE)
 static struct platform_pwm_backlight_data income_backlight_data = {
 	.pwm_id		= 0,
 	.max_brightness	= 0x3ff,
-- 
1.7.2.2
