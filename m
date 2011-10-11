Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab1JKPcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:32:00 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:35713 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab1JKPb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:31:59 -0400
Subject: [PATCH] [TRIVIAL] ARM: pxa: Fix typo 'CONFIG_BACKLIGHT_PWM__MODULE'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 17:31:55 +0200
Message-ID: <1318347115.5754.3.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested (I don't think I've got the hardware, nor have I got the
toolchain at hand, etc.).

 arch/arm/mach-pxa/colibri-pxa270-income.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-pxa/colibri-pxa270-income.c b/arch/arm/mach-pxa/colibri-pxa270-income.c
index 80538b8..248804b 100644
--- a/arch/arm/mach-pxa/colibri-pxa270-income.c
+++ b/arch/arm/mach-pxa/colibri-pxa270-income.c
@@ -183,7 +183,7 @@ static inline void income_lcd_init(void) {}
 /******************************************************************************
  * Backlight
  ******************************************************************************/
-#if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM__MODULE)
+#if defined(CONFIG_BACKLIGHT_PWM) || defined(CONFIG_BACKLIGHT_PWM_MODULE)
 static struct platform_pwm_backlight_data income_backlight_data = {
 	.pwm_id		= 0,
 	.max_brightness	= 0x3ff,
-- 
1.7.4.4

