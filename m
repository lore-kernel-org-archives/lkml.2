Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab2IBAEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 20:04:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62582 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab2IBAEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 20:04:13 -0400
Message-ID: <1346544244.3355.1.camel@phoenix>
Subject: [PATCH] gpio: Use DEFINE_PCI_DEVICE_TABLE macro
From: Axel Lin <axel.lin@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org
Date: Sun, 02 Sep 2012 08:04:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/gpio/gpio-bt8xx.c     |    2 +-
 drivers/gpio/gpio-sodaville.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-bt8xx.c b/drivers/gpio/gpio-bt8xx.c
index 92d555d..7d9d7cb 100644
--- a/drivers/gpio/gpio-bt8xx.c
+++ b/drivers/gpio/gpio-bt8xx.c
@@ -310,7 +310,7 @@ static int bt8xxgpio_resume(struct pci_dev *pdev)
 #define bt8xxgpio_resume NULL
 #endif /* CONFIG_PM */
 
-static struct pci_device_id bt8xxgpio_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(bt8xxgpio_pci_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878) },
diff --git a/drivers/gpio/gpio-sodaville.c b/drivers/gpio/gpio-sodaville.c
index 9d9891f..e25f731 100644
--- a/drivers/gpio/gpio-sodaville.c
+++ b/drivers/gpio/gpio-sodaville.c
@@ -270,7 +270,7 @@ static void sdv_gpio_remove(struct pci_dev *pdev)
 	kfree(sd);
 }
 
-static struct pci_device_id sdv_gpio_pci_ids[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(sdv_gpio_pci_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_SDV_GPIO) },
 	{ 0, },
 };
-- 
1.7.9.5



