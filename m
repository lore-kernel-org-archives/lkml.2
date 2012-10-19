Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2JSAEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 20:04:47 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50895 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab2JSAEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 20:04:46 -0400
From: Fabio Estevam <festevam@gmail.com>
To: rob.herring@calxeda.com
Cc: shawn.guo@linaro.org, kernel@pengutronix.de,
        broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v2 1/2] ARM: multi_v7_defconfig: Add ARCH_MXC
Date: Thu, 18 Oct 2012 21:04:05 -0300
Message-Id: <1350605046-21358-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Let ARCH_MXC be covered by multi_v7_defconfig.

Allow booting mx6 via NFS.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v1:
- Provide a more complete config that allows booting mx6 via NFS

 arch/arm/configs/multi_v7_defconfig |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 159f75f..df1e563 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -5,6 +5,8 @@ CONFIG_ARCH_MVEBU=y
 CONFIG_MACH_ARMADA_370=y
 CONFIG_MACH_ARMADA_XP=y
 CONFIG_ARCH_HIGHBANK=y
+CONFIG_ARCH_MXC=y
+CONFIG_SOC_IMX6Q=y
 CONFIG_ARCH_SOCFPGA=y
 # CONFIG_ARCH_VEXPRESS_CORTEX_A5_A9_ERRATA is not set
 CONFIG_ARM_ERRATA_754322=y
@@ -17,18 +19,29 @@ CONFIG_ARM_APPENDED_DTB=y
 CONFIG_VFP=y
 CONFIG_NEON=y
 CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
 CONFIG_ATA=y
 CONFIG_SATA_HIGHBANK=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_CALXEDA_XGMAC=y
 CONFIG_SMSC911X=y
 CONFIG_STMMAC_ETH=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3_ACL=y
+CONFIG_NFS_V4=y
+CONFIG_ROOT_NFS=y
 CONFIG_SERIO_AMBAKMI=y
 CONFIG_SERIAL_8250=y
 CONFIG_SERIAL_8250_CONSOLE=y
 CONFIG_SERIAL_8250_DW=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+CONFIG_SERIAL_IMX=y
+CONFIG_SERIAL_IMX_CONSOLE=y
 CONFIG_SERIAL_OF_PLATFORM=y
 CONFIG_IPMI_HANDLER=y
 CONFIG_IPMI_SI=y
-- 
1.7.9.5

