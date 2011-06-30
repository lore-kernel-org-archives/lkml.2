Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab1F3Vsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:48:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41962 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab1F3Vsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:48:41 -0400
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: [PATCH 1/2] Making sure LEDS_NET5501 depends on CONFIG_MFD_CS5535
Date: Thu, 30 Jun 2011 21:48:02 +0000
Message-Id: <1309470483-18546-2-git-send-email-gurligebis@gentoo.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309470483-18546-1-git-send-email-gurligebis@gentoo.org>
References: <1309470483-18546-1-git-send-email-gurligebis@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>

Fixes dependency problem for LEDS_NET5501.

Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
---
 drivers/leds/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 713d43b..4ea885a 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -92,7 +92,7 @@ config LEDS_NET48XX
 config LEDS_NET5501
 	tristate "LED Support for Soekris net5501 series Error LED"
 	depends on LEDS_TRIGGERS
-	depends on X86 && LEDS_GPIO_PLATFORM && GPIO_CS5535
+	depends on X86 && LEDS_GPIO_PLATFORM && GPIO_CS5535 && CONFIG_MFD_CS5535
 	select LEDS_TRIGGER_DEFAULT_ON
 	default n
 	help
-- 
1.7.6

