Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1DPHa2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 03:30:28 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:23307 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1DPHa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 03:30:27 -0400
Date: Sat, 16 Apr 2011 09:30:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpiolib: export gpiochip_find
Message-ID: <20110416093015.3befd780@endymion.delvare>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export function gpiochip_find so that modules can use it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
I need this to add support for SMBus multiplexing on my Asus Z8NA-D6
board.

 drivers/gpio/gpiolib.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.39-rc3.orig/drivers/gpio/gpiolib.c	2011-03-30 10:57:19.000000000 +0200
+++ linux-2.6.39-rc3/drivers/gpio/gpiolib.c	2011-04-16 09:00:25.000000000 +0200
@@ -1165,6 +1165,7 @@ struct gpio_chip *gpiochip_find(void *da
 
 	return chip;
 }
+EXPORT_SYMBOL_GPL(gpiochip_find);
 
 /* These "optional" allocation calls help prevent drivers from stomping
  * on each other, and help provide better diagnostics in debugfs.


-- 
Jean Delvare
