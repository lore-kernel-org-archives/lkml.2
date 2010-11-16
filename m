Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab0KPKPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 05:15:10 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:45254 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab0KPKPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 05:15:09 -0500
From: Josh Wu <josh.wu@atmel.com>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH TRIVIAL] AT91: usb: fix typo in atmel_usba_udc driver
Date: Tue, 16 Nov 2010 18:14:53 +0800
Message-Id: <1289902493-1821-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 16 Nov 2010 10:14:54.0641 (UTC) FILETIME=[1D1FB210:01CB8577]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
fix against 2.6.37-rc1

 drivers/usb/gadget/atmel_usba_udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index b5e20e8..717ff65 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2017,7 +2017,7 @@ static int __init usba_udc_probe(struct platform_device *pdev)
 			}
 		} else {
 			/* gpio_request fail so use -EINVAL for gpio_is_valid */
-			ubc->vbus_pin = -EINVAL;
+			udc->vbus_pin = -EINVAL;
 		}
 	}
 
-- 
1.6.3.3

