Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1JCIdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 04:33:15 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:6374 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab1JCIdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 04:33:08 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: linux-arm-kernel@lists.infradead.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/3] tty/serial: atmel_serial: __devinit_p for probe function
Date: Mon,  3 Oct 2011 11:46:16 +0200
Message-Id: <cd489c1d28c26624d6b68399d222aec371045e53.1317634987.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <b371e80a96a36d962fb8806c2bd7aa20bb688b88.1317634987.git.nicolas.ferre@atmel.com>
References: <b371e80a96a36d962fb8806c2bd7aa20bb688b88.1317634987.git.nicolas.ferre@atmel.com>
In-Reply-To: <b371e80a96a36d962fb8806c2bd7aa20bb688b88.1317634987.git.nicolas.ferre@atmel.com>
References: <b371e80a96a36d962fb8806c2bd7aa20bb688b88.1317634987.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index a652f8f..453cdb5 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1789,7 +1789,7 @@ static int __devexit atmel_serial_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver atmel_serial_driver = {
-	.probe		= atmel_serial_probe,
+	.probe		= __devexit_p(atmel_serial_probe),
 	.remove		= __devexit_p(atmel_serial_remove),
 	.suspend	= atmel_serial_suspend,
 	.resume		= atmel_serial_resume,
-- 
1.7.3

