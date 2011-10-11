Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378Ab1JKVLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:11:08 -0400
Received: from s15407518.onlinehome-server.info ([82.165.136.167]:39840 "EHLO
	s15407518.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399Ab1JKVLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:11:07 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: [PATCH] regulator: gpio-regulator add dependency on GENERIC_GPIO
Date: Tue, 11 Oct 2011 23:11:01 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-2-686; KDE/4.4.5; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110112311.02195.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without GENERIC_GPIO "struct gpio" is undefined leading to errors.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 5e0c7b6..9713b1b 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -66,6 +66,7 @@ config REGULATOR_USERSPACE_CONSUMER
 
 config REGULATOR_GPIO
 	tristate "GPIO regulator support"
+	depends on GENERIC_GPIO
 	help
 	  This driver provides support for regulators that can be
 	  controlled via gpios.
-- 
1.7.2.3
