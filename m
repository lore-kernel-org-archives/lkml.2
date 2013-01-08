Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3AHIUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:20:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:60074 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab3AHITz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:19:55 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: <linux@arm.linux.org.uk>, <nsekhar@ti.com>, <khilman@ti.com>, <hs@denx.de>
Subject: [PATCH V2 2/3] ARM: davinci: da8xx defconfig: enable pinctrl config option
Date: Tue, 8 Jan 2013 13:50:19 +0530
Message-ID: <1357633220-29827-3-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
References: <1357633220-29827-1-git-send-email-anilkumar.v@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable pinctrl related config option in da8xx_omapl_defconfig

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
:100644 100644 f292239... 0892db4... M	arch/arm/configs/da8xx_omapl_defconfig
 arch/arm/configs/da8xx_omapl_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/da8xx_omapl_defconfig b/arch/arm/configs/da8xx_omapl_defconfig
index f292239..0892db4 100644
--- a/arch/arm/configs/da8xx_omapl_defconfig
+++ b/arch/arm/configs/da8xx_omapl_defconfig
@@ -81,6 +81,7 @@ CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_I2C=y
 CONFIG_I2C_CHARDEV=y
 CONFIG_I2C_DAVINCI=y
+CONFIG_PINCTRL_SINGLE=y
 # CONFIG_HWMON is not set
 CONFIG_WATCHDOG=y
 CONFIG_REGULATOR=y
-- 
1.7.4.1

