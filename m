Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab1IBD5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:57:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35020 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1IBD5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:57:36 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 04/19] Staging: cx25821: Move EXPORT_SYMBOL() to the right place
Date: Fri,  2 Sep 2011 11:55:32 +0800
Message-Id: <1314935747-6881-5-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move EXPORT_SYMBOL(cx25821_set_gpiopin_direction) to the right place.

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-core.c |    1 -
 drivers/staging/cx25821/cx25821-gpio.c |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 523ac5e..8e8a56d 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -1512,7 +1512,6 @@ static void __exit cx25821_fini(void)
 	pci_unregister_driver(&cx25821_pci_driver);
 }
 
-EXPORT_SYMBOL(cx25821_set_gpiopin_direction);
 
 module_init(cx25821_init);
 module_exit(cx25821_fini);
diff --git a/drivers/staging/cx25821/cx25821-gpio.c b/drivers/staging/cx25821/cx25821-gpio.c
index 2f154b3..29e43b0 100644
--- a/drivers/staging/cx25821/cx25821-gpio.c
+++ b/drivers/staging/cx25821/cx25821-gpio.c
@@ -50,6 +50,7 @@ void cx25821_set_gpiopin_direction(struct cx25821_dev *dev,
 
 	cx_write(gpio_oe_reg, value);
 }
+EXPORT_SYMBOL(cx25821_set_gpiopin_direction);
 
 static void cx25821_set_gpiopin_logicvalue(struct cx25821_dev *dev,
 					   int pin_number, int pin_logic_value)
-- 
1.7.0.4

