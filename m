Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2IKNDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:03:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2IKNDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:03:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 16/16] ARM: spear: move platform_data definitions
Date: Tue, 11 Sep 2012 15:02:39 +0200
Message-Id: <1347368559-31329-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1347368559-31329-1-git-send-email-arnd@arndb.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368559-31329-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:IQAwJC+3XjADsbEXZ9kevpfhWhWY7SY1A4O/9waVs0r
 MFRc/HZE8/oPVFfgoiGeJHU/HA5DoHcrf3ZqIjb+laWlIipAkS
 C1/ItJZ5Jw42y4Qh9kQXrrrHDLNwmRGr8uTKN6lxIGxbZmtABq
 kmeuxsNxQ9AGOZ2zINGb4QaZ2ruMdXP4T9atSmU2xPoML8uWXT
 TOr6m6TegT2k72887sVr2XLFiLHnr36A/xvBjAUpRzh8E8Qw3g
 BYklcMaF1BYyTBqt+V0ZHEfOxdnNk8yyTGtRWB81xQYhu7zhrB
 tGWZA+Zg44cpyY+o/+7Zv2rmoFWGQ9CRKZIBXLKTx1ljkxOX3G
 Fs1tgUh/X6Uq/YMyQqYPaDd7ZaHmVTmHaw8l0kxOvdt8rYj9hn
 knJ52dEyoV5yB4jc6iCEtAnP3YWPXRHpNg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This moves such data out of the spear include directories

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.hashim@st.com>
Cc: spear-devel@list.st.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/spear-keyboard.c                              |    2 +-
 .../plat/keyboard.h => include/linux/platform_data/keyboard-spear.h  |    0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/arm/plat-spear/include/plat/keyboard.h => include/linux/platform_data/keyboard-spear.h (100%)

diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 72ef01b..c7ca97f 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -24,7 +24,7 @@
 #include <linux/pm_wakeup.h>
 #include <linux/slab.h>
 #include <linux/types.h>
-#include <plat/keyboard.h>
+#include <linux/platform_data/keyboard-spear.h>
 
 /* Keyboard Registers */
 #define MODE_CTL_REG	0x00
diff --git a/arch/arm/plat-spear/include/plat/keyboard.h b/include/linux/platform_data/keyboard-spear.h
similarity index 100%
rename from arch/arm/plat-spear/include/plat/keyboard.h
rename to include/linux/platform_data/keyboard-spear.h
-- 
1.7.10

