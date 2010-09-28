Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab0I1Sqd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:46:33 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:44958 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757803Ab0I1Sqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:46:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: jgarzik@pobox.com
Subject: [PATCH] de2104x: remove experimental status
Date: Tue, 28 Sep 2010 20:46:17 +0200
User-Agent: KMail/1.9.10
Cc: netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009282046.21279.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be ready after 8 years...remove the experimental dependency.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.36-rc3-/drivers/net/tulip/Kconfig	2010-08-29 17:36:04.000000000 +0200
+++ linux-2.6.36-rc3/drivers/net/tulip/Kconfig	2010-09-28 19:49:46.000000000 +0200
@@ -11,8 +11,8 @@ menuconfig NET_TULIP
 if NET_TULIP
 
 config DE2104X
-	tristate "Early DECchip Tulip (dc2104x) PCI support (EXPERIMENTAL)"
-	depends on PCI && EXPERIMENTAL
+	tristate "Early DECchip Tulip (dc2104x) PCI support"
+	depends on PCI
 	select CRC32
 	---help---
 	  This driver is developed for the SMC EtherPower series Ethernet


-- 
Ondrej Zary
