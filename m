Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621Ab1GTKML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 06:12:11 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:25864 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229Ab1GTKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 06:12:07 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 3/6] pch_gpio: support ML7223 IOH n-Bus
Date: Wed, 20 Jul 2011 19:10:59 +0900
Message-Id: <1311156662-3044-3-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1311156662-3044-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/pch_gpio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index 252bddb..d548069 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -296,6 +296,7 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8014) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_ROHM, 0x8043) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
-- 
1.7.4.4

