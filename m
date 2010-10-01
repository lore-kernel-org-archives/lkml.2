Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab0JAL6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 07:58:39 -0400
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:53936 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932170Ab0JAL6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 07:58:32 -0400
From: Viresh KUMAR <viresh.kumar@st.com>
To: linux-arm-kernel@lists.infradead.org, rtc-linux@googlegroups.com,
        a.zummo@towertech.it, dbrownell@users.sourceforge.net,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        vipin.kumar@st.com, deepak.sikri@st.com, armando.visconti@st.com,
        vipulkumar.samar@st.com, rajeev-dlh.kumar@st.com,
        pratyush.anand@st.com, bhupesh.sharma@st.com
Subject: [PATCH V2 65/69] ST SPEAR6xx: renaming spear600_defconfig as spear6xx_defconfig
Date: Fri,  1 Oct 2010 17:26:25 +0530
Message-Id: <9c685d931c33e6b5d549519d6cec8da6c3fdbab7.1285933332.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
In-Reply-To: <cover.1285933331.git.viresh.kumar@st.com>
References: <cover.1285933331.git.viresh.kumar@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Rajeev Kumar <rajeev-dlh.kumar@st.com>
---
 .../{spear600_defconfig => spear6xx_defconfig}     |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/arm/configs/{spear600_defconfig => spear6xx_defconfig} (97%)

diff --git a/arch/arm/configs/spear600_defconfig b/arch/arm/configs/spear6xx_defconfig
similarity index 97%
rename from arch/arm/configs/spear600_defconfig
rename to arch/arm/configs/spear6xx_defconfig
index 6777c11..cef2e83 100644
--- a/arch/arm/configs/spear600_defconfig
+++ b/arch/arm/configs/spear6xx_defconfig
@@ -8,6 +8,7 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_PLAT_SPEAR=y
 CONFIG_ARCH_SPEAR6XX=y
+CONFIG_BOARD_SPEAR600_EVB=y
 CONFIG_BINFMT_MISC=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_BLK_DEV_RAM=y
@@ -22,7 +23,6 @@ CONFIG_MAX_RAW_DEVS=8192
 CONFIG_GPIO_SYSFS=y
 CONFIG_GPIO_PL061=y
 # CONFIG_HWMON is not set
-# CONFIG_VGA_CONSOLE is not set
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_EXT2_FS=y
-- 
1.7.2.2

