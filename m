Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3AJSZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 13:25:15 -0500
Received: from mail-vb0-f74.google.com ([209.85.212.74]:53413 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3AJSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 13:25:12 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-mmc@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Will Newton <will.newton@imgtec.com>,
        Chris Ball <cjb@laptop.org>, Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [REPOST PATCH v3 2/4] ARM: dts: Add disable-wp for sd card slot on smdk5250
Date: Thu, 10 Jan 2013 10:24:27 -0800
Message-Id: <1357842269-15062-2-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1357842269-15062-1-git-send-email-dianders@chromium.org>
References: <1354251857-21587-1-git-send-email-dianders@chromium.org>
 <1357842269-15062-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The next change will remove the code from the dw_mmc-exynos that added
the DW_MCI_QUIRK_NO_WRITE_PROTECT.  Keep existing functionality of
having no write protect pin on smdk5250 by adding the disable-wp
property.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
---
Changes in v3:
- New for this version of the patch series.

 arch/arm/boot/dts/exynos5250-smdk5250.dts |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index 942d576..75b9d83 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -146,6 +146,7 @@
 			reg = <0>;
 			bus-width = <4>;
 			samsung,cd-pinmux-gpio = <&gpc3 2 2 3 3>;
+			disable-wp;
 			gpios = <&gpc3 0 2 0 3>, <&gpc3 1 2 0 3>,
 				<&gpc3 3 2 3 3>, <&gpc3 4 2 3 3>,
 				<&gpc3 5 2 3 3>, <&gpc3 6 2 3 3>,
-- 
1.7.7.3

