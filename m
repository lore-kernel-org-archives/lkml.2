Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934973Ab2JXO3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 10:29:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46278 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934873Ab2JXO3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 10:29:47 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] tty: Fix typo in tty drivers
Date: Wed, 24 Oct 2012 23:29:41 +0900
Message-Id: <1351088981-24976-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in debug messages within tty drivers.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/tty/hvc/hvc_opal.c      | 2 +-
 drivers/tty/hvc/hvc_vio.c       | 2 +-
 drivers/tty/serial/8250/Kconfig | 2 +-
 drivers/tty/serial/bfin_uart.c  | 2 +-
 drivers/tty/serial/icom.c       | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
index 0d2ea0c..a4f488f 100644
--- a/drivers/tty/hvc/hvc_opal.c
+++ b/drivers/tty/hvc/hvc_opal.c
@@ -178,7 +178,7 @@ static int __devinit hvc_opal_probe(struct platform_device *dev)
 		proto = HV_PROTOCOL_HVSI;
 		ops = &hvc_opal_hvsi_ops;
 	} else {
-		pr_err("hvc_opal: Unkown protocol for %s\n",
+		pr_err("hvc_opal: Unknown protocol for %s\n",
 		       dev->dev.of_node->full_name);
 		return -ENXIO;
 	}
diff --git a/drivers/tty/hvc/hvc_vio.c b/drivers/tty/hvc/hvc_vio.c
index ee30779..56e9725 100644
--- a/drivers/tty/hvc/hvc_vio.c
+++ b/drivers/tty/hvc/hvc_vio.c
@@ -250,7 +250,7 @@ static int __devinit hvc_vio_probe(struct vio_dev *vdev,
 		proto = HV_PROTOCOL_HVSI;
 		ops = &hvterm_hvsi_ops;
 	} else {
-		pr_err("hvc_vio: Unkown protocol for %s\n", vdev->dev.of_node->full_name);
+		pr_err("hvc_vio: Unknown protocol for %s\n", vdev->dev.of_node->full_name);
 		return -ENXIO;
 	}
 
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index a27dd05..9395800 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -271,7 +271,7 @@ config SERIAL_8250_DW
 	  present in the Synopsys DesignWare APB UART.
 
 config SERIAL_8250_EM
-	tristate "Support for Emma Mobile intergrated serial port"
+	tristate "Support for Emma Mobile integrated serial port"
 	depends on SERIAL_8250 && ARM && HAVE_CLK
 	help
 	  Selecting this option will add support for the integrated serial
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index 9242d56..9b11c3f 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -815,7 +815,7 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
 		lcr = WLS(5);
 		break;
 	default:
-		printk(KERN_ERR "%s: word lengh not supported\n",
+		printk(KERN_ERR "%s: word length not supported\n",
 			__func__);
 	}
 
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index defc4e3..6131516 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -505,7 +505,7 @@ static void load_code(struct icom_port *icom_port)
 		/* Stop processor */
 		stop_processor(icom_port);
 
-		dev_err(&icom_port->adapter->pci_dev->dev,"Port not opertional\n");
+		dev_err(&icom_port->adapter->pci_dev->dev,"Port not operational\n");
 	}
 
 	if (new_page != NULL)
-- 
1.8.0.rc3.16.g8ead1bf

