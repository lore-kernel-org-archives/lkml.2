Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1LMGcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:32:10 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:53515 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1LMGcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:05 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 02/19] eukrea_cpuimx25: enable workaround ENGcm09152
Date: Tue, 13 Dec 2011 07:31:34 +0100
Message-Id: <1323757911-25217-2-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this fix usb device controler behaviour in gadget mode

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/mach-eukrea_cpuimx25.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
index ab8fbcc..33a4c74 100644
--- a/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
+++ b/arch/arm/mach-imx/mach-eukrea_cpuimx25.c
@@ -106,6 +106,7 @@ static const struct mxc_usbh_platform_data usbh2_pdata __initconst = {
 static const struct fsl_usb2_platform_data otg_device_pdata __initconst = {
 	.operating_mode = FSL_USB2_DR_DEVICE,
 	.phy_mode       = FSL_USB2_PHY_UTMI,
+	.workaround     = FLS_USB2_WORKAROUND_ENGCM09152,
 };
 
 static int otg_mode_host;
-- 
1.7.6.4

