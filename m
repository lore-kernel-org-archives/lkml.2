Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347Ab1EaIxm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:53:42 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:53440 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758284Ab1EaIxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:53:39 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linux-arm-kernel@lists.infradead.org>, <arnd@arndb.de>
Cc: <armando.visconti@st.com>, <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 3/3] SPEAr3xx: Update defconfig for ST's PWM
Date: Tue, 31 May 2011 14:21:53 +0530
Message-ID: <1db14f78b567763df5dc344905c3d84bd79532d7.1306831238.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1306831238.git.viresh.kumar@st.com>
References: <cover.1306831238.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 arch/arm/configs/spear3xx_defconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/spear3xx_defconfig b/arch/arm/configs/spear3xx_defconfig
index 07e9613..bc29eaf 100644
--- a/arch/arm/configs/spear3xx_defconfig
+++ b/arch/arm/configs/spear3xx_defconfig
@@ -30,6 +30,8 @@ CONFIG_SPEAR_PLGPIO=y
 # CONFIG_HWMON is not set
 # CONFIG_HID_SUPPORT is not set
 # CONFIG_USB_SUPPORT is not set
+CONFIG_PWMLIB=y
+CONFIG_ST_PWM=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_SECURITY=y
-- 
1.7.2.2

