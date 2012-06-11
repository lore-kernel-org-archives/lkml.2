Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab2FKA7e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 20:59:34 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:40542 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab2FKA6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 20:58:30 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rubini@gnudd.com,
        Davide Ciminaghi <ciminaghi@gnudd.com>
Subject: [PATCH 08/14] sta2x11-mfd : add apb-soc-regs defines and mask function
Date: Mon, 11 Jun 2012 02:57:53 +0200
Message-Id: <1339376279-16753-9-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1339376279-16753-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Ciminaghi <ciminaghi@gnudd.com>


Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
---
 include/linux/mfd/sta2x11-mfd.h |  130 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)

diff --git a/include/linux/mfd/sta2x11-mfd.h b/include/linux/mfd/sta2x11-mfd.h
index 09a94d3..4d85879 100644
--- a/include/linux/mfd/sta2x11-mfd.h
+++ b/include/linux/mfd/sta2x11-mfd.h
@@ -343,4 +343,134 @@ u32 sta2x11_sctl_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
 #define SCTL_SCPEREN1_I2C3		(1 << 16)
 #define SCTL_SCPEREN1_USB_PHY		(1 << 17)
 
+/*
+ * APB-SOC registers
+ */
+static inline
+u32 sta2x11_apb_soc_regs_mask(struct pci_dev *pdev, u32 reg, u32 mask, u32 val)
+{
+	return __sta2x11_mfd_mask(pdev, reg, mask, val, sta2x11_apb_soc_regs);
+}
+
+#define PCIE_EP1_FUNC3_0_INTR_REG	0x000
+#define PCIE_EP1_FUNC7_4_INTR_REG	0x004
+#define PCIE_EP2_FUNC3_0_INTR_REG	0x008
+#define PCIE_EP2_FUNC7_4_INTR_REG	0x00c
+#define PCIE_EP3_FUNC3_0_INTR_REG	0x010
+#define PCIE_EP3_FUNC7_4_INTR_REG	0x014
+#define PCIE_EP4_FUNC3_0_INTR_REG	0x018
+#define PCIE_EP4_FUNC7_4_INTR_REG	0x01c
+#define PCIE_INTR_ENABLE0_REG		0x020
+#define PCIE_INTR_ENABLE1_REG		0x024
+#define PCIE_EP1_FUNC_TC_REG		0x028
+#define PCIE_EP2_FUNC_TC_REG		0x02c
+#define PCIE_EP3_FUNC_TC_REG		0x030
+#define PCIE_EP4_FUNC_TC_REG		0x034
+#define PCIE_EP1_FUNC_F_REG		0x038
+#define PCIE_EP2_FUNC_F_REG		0x03c
+#define PCIE_EP3_FUNC_F_REG		0x040
+#define PCIE_EP4_FUNC_F_REG		0x044
+#define PCIE_PAB_AMBA_SW_RST_REG	0x048
+#define PCIE_PM_STATUS_0_PORT_0_4	0x04c
+#define PCIE_PM_STATUS_7_0_EP1		0x050
+#define PCIE_PM_STATUS_7_0_EP2		0x054
+#define PCIE_PM_STATUS_7_0_EP3		0x058
+#define PCIE_PM_STATUS_7_0_EP4		0x05c
+#define PCIE_DEV_ID_0_EP1_REG		0x060
+#define PCIE_CC_REV_ID_0_EP1_REG	0x064
+#define PCIE_DEV_ID_1_EP1_REG		0x068
+#define PCIE_CC_REV_ID_1_EP1_REG	0x06c
+#define PCIE_DEV_ID_2_EP1_REG		0x070
+#define PCIE_CC_REV_ID_2_EP1_REG	0x074
+#define PCIE_DEV_ID_3_EP1_REG		0x078
+#define PCIE_CC_REV_ID_3_EP1_REG	0x07c
+#define PCIE_DEV_ID_4_EP1_REG		0x080
+#define PCIE_CC_REV_ID_4_EP1_REG	0x084
+#define PCIE_DEV_ID_5_EP1_REG		0x088
+#define PCIE_CC_REV_ID_5_EP1_REG	0x08c
+#define PCIE_DEV_ID_6_EP1_REG		0x090
+#define PCIE_CC_REV_ID_6_EP1_REG	0x094
+#define PCIE_DEV_ID_7_EP1_REG		0x098
+#define PCIE_CC_REV_ID_7_EP1_REG	0x09c
+#define PCIE_DEV_ID_0_EP2_REG		0x0a0
+#define PCIE_CC_REV_ID_0_EP2_REG	0x0a4
+#define PCIE_DEV_ID_1_EP2_REG		0x0a8
+#define PCIE_CC_REV_ID_1_EP2_REG	0x0ac
+#define PCIE_DEV_ID_2_EP2_REG		0x0b0
+#define PCIE_CC_REV_ID_2_EP2_REG	0x0b4
+#define PCIE_DEV_ID_3_EP2_REG		0x0b8
+#define PCIE_CC_REV_ID_3_EP2_REG	0x0bc
+#define PCIE_DEV_ID_4_EP2_REG		0x0c0
+#define PCIE_CC_REV_ID_4_EP2_REG	0x0c4
+#define PCIE_DEV_ID_5_EP2_REG		0x0c8
+#define PCIE_CC_REV_ID_5_EP2_REG	0x0cc
+#define PCIE_DEV_ID_6_EP2_REG		0x0d0
+#define PCIE_CC_REV_ID_6_EP2_REG	0x0d4
+#define PCIE_DEV_ID_7_EP2_REG		0x0d8
+#define PCIE_CC_REV_ID_7_EP2_REG	0x0dC
+#define PCIE_DEV_ID_0_EP3_REG		0x0e0
+#define PCIE_CC_REV_ID_0_EP3_REG	0x0e4
+#define PCIE_DEV_ID_1_EP3_REG		0x0e8
+#define PCIE_CC_REV_ID_1_EP3_REG	0x0ec
+#define PCIE_DEV_ID_2_EP3_REG		0x0f0
+#define PCIE_CC_REV_ID_2_EP3_REG	0x0f4
+#define PCIE_DEV_ID_3_EP3_REG		0x0f8
+#define PCIE_CC_REV_ID_3_EP3_REG	0x0fc
+#define PCIE_DEV_ID_4_EP3_REG		0x100
+#define PCIE_CC_REV_ID_4_EP3_REG	0x104
+#define PCIE_DEV_ID_5_EP3_REG		0x108
+#define PCIE_CC_REV_ID_5_EP3_REG	0x10c
+#define PCIE_DEV_ID_6_EP3_REG		0x110
+#define PCIE_CC_REV_ID_6_EP3_REG	0x114
+#define PCIE_DEV_ID_7_EP3_REG		0x118
+#define PCIE_CC_REV_ID_7_EP3_REG	0x11c
+#define PCIE_DEV_ID_0_EP4_REG		0x120
+#define PCIE_CC_REV_ID_0_EP4_REG	0x124
+#define PCIE_DEV_ID_1_EP4_REG		0x128
+#define PCIE_CC_REV_ID_1_EP4_REG	0x12c
+#define PCIE_DEV_ID_2_EP4_REG		0x130
+#define PCIE_CC_REV_ID_2_EP4_REG	0x134
+#define PCIE_DEV_ID_3_EP4_REG		0x138
+#define PCIE_CC_REV_ID_3_EP4_REG	0x13c
+#define PCIE_DEV_ID_4_EP4_REG		0x140
+#define PCIE_CC_REV_ID_4_EP4_REG	0x144
+#define PCIE_DEV_ID_5_EP4_REG		0x148
+#define PCIE_CC_REV_ID_5_EP4_REG	0x14c
+#define PCIE_DEV_ID_6_EP4_REG		0x150
+#define PCIE_CC_REV_ID_6_EP4_REG	0x154
+#define PCIE_DEV_ID_7_EP4_REG		0x158
+#define PCIE_CC_REV_ID_7_EP4_REG	0x15c
+#define PCIE_SUBSYS_VEN_ID_REG		0x160
+#define PCIE_COMMON_CLOCK_CONFIG_0_4_0	0x164
+#define PCIE_MIPHYP_SSC_EN_REG		0x168
+#define PCIE_MIPHYP_ADDR_REG		0x16c
+#define PCIE_L1_ASPM_READY_REG		0x170
+#define PCIE_EXT_CFG_RDY_REG		0x174
+#define PCIE_SoC_INT_ROUTER_STATUS0_REG 0x178
+#define PCIE_SoC_INT_ROUTER_STATUS1_REG 0x17c
+#define PCIE_SoC_INT_ROUTER_STATUS2_REG 0x180
+#define PCIE_SoC_INT_ROUTER_STATUS3_REG 0x184
+#define DMA_IP_CTRL_REG			0x324
+#define DISP_BRIDGE_PU_PD_CTRL_REG	0x328
+#define VIP_PU_PD_CTRL_REG		0x32c
+#define USB_MLB_PU_PD_CTRL_REG		0x330
+#define SDIO_PU_PD_MISCFUNC_CTRL_REG1	0x334
+#define SDIO_PU_PD_MISCFUNC_CTRL_REG2	0x338
+#define UART_PU_PD_CTRL_REG		0x33c
+#define ARM_Lock			0x340
+#define SYS_IO_CHAR_REG1		0x344
+#define SYS_IO_CHAR_REG2		0x348
+#define SATA_CORE_ID_REG		0x34c
+#define SATA_CTRL_REG			0x350
+#define I2C_HSFIX_MISC_REG		0x354
+#define SPARE2_RESERVED			0x358
+#define SPARE3_RESERVED			0x35c
+#define MASTER_LOCK_REG			0x368
+#define SYSTEM_CONFIG_STATUS_REG	0x36c
+#define MSP_CLK_CTRL_REG		0x39c
+#define COMPENSATION_REG1		0x3c4
+#define COMPENSATION_REG2		0x3c8
+#define COMPENSATION_REG3		0x3cc
+#define TEST_CTL_REG			0x3d0
+
 #endif /* __STA2X11_MFD_H */
-- 
1.7.9.1

