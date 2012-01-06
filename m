Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2AFMtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 07:49:20 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:64050 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2AFMtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 07:49:18 -0500
Date: Fri, 6 Jan 2012 13:32:41 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org
Subject: [PATCH 1/6] pci_ids: add device ids for STA2X11 device (aka
 ConneXT)
Message-ID: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The chip is an I/O hub used by some Atom boards.  Most of those
symbols are used in arch/x86/platform/sta2x11/sta2x11.c (to be
introduced) and in the specific drivers as well.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
---
 include/linux/pci_ids.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2aaee0c..31d77af 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -776,6 +776,29 @@
 #define PCI_DEVICE_ID_ELSA_QS3000	0x3000
 
 #define PCI_VENDOR_ID_STMICRO		0x104A
+#define PCI_DEVICE_ID_STMICRO_USB_HOST	0xCC00
+#define PCI_DEVICE_ID_STMICRO_USB_OHCI	0xCC01
+#define PCI_DEVICE_ID_STMICRO_USB_OTG	0xCC02
+#define PCI_DEVICE_ID_STMICRO_UART_HWFC 0xCC03
+#define PCI_DEVICE_ID_STMICRO_UART_NO_HWFC	0xCC04
+#define PCI_DEVICE_ID_STMICRO_SOC_DMA	0xCC05
+#define PCI_DEVICE_ID_STMICRO_SATA	0xCC06
+#define PCI_DEVICE_ID_STMICRO_I2C	0xCC07
+#define PCI_DEVICE_ID_STMICRO_SPI_HS	0xCC08
+#define PCI_DEVICE_ID_STMICRO_MAC	0xCC09
+#define PCI_DEVICE_ID_STMICRO_SDIO_EMMC 0xCC0A
+#define PCI_DEVICE_ID_STMICRO_SDIO	0xCC0B
+#define PCI_DEVICE_ID_STMICRO_GPIO	0xCC0C
+#define PCI_DEVICE_ID_STMICRO_VIP	0xCC0D
+#define PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_DMA	0xCC0E
+#define PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_SRCS 0xCC0F
+#define PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_MSPS 0xCC10
+#define PCI_DEVICE_ID_STMICRO_CAN	0xCC11
+#define PCI_DEVICE_ID_STMICRO_MLB	0xCC12
+#define PCI_DEVICE_ID_STMICRO_DBP	0xCC13
+#define PCI_DEVICE_ID_STMICRO_SATA_PHY	0xCC14
+#define PCI_DEVICE_ID_STMICRO_ESRAM	0xCC15
+#define PCI_DEVICE_ID_STMICRO_VIC	0xCC16
 
 #define PCI_VENDOR_ID_BUSLOGIC		      0x104B
 #define PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC 0x0140
-- 
1.7.7.2
