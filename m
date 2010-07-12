Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab0GKAbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 20:31:13 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43296 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789Ab0GKAbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 20:31:07 -0400
Date: Mon, 12 Jul 2010 03:35:21 +0000
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] email address change
Message-ID: <20100712033521.7978766c@debxo>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


My Collabora address is no longer enabled - update the MODULE_AUTHOR
fields of drivers to my current email address.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/clocksource/cs5535-clockevt.c |    2 +-
 drivers/gpio/cs5535-gpio.c            |    2 +-
 drivers/misc/cs5535-mfgpt.c           |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/cs5535-clockevt.c b/drivers/clocksource/cs5535-clockevt.c
index d7be69f..b7dab32 100644
--- a/drivers/clocksource/cs5535-clockevt.c
+++ b/drivers/clocksource/cs5535-clockevt.c
@@ -194,6 +194,6 @@ err_timer:
 
 module_init(cs5535_mfgpt_init);
 
-MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("CS5535/CS5536 MFGPT clock event driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index f73a155..e23c068 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -352,6 +352,6 @@ static void __exit cs5535_gpio_exit(void)
 module_init(cs5535_gpio_init);
 module_exit(cs5535_gpio_exit);
 
-MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index 9bec24d..2d44b33 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -366,6 +366,6 @@ static int __init cs5535_mfgpt_init(void)
 
 module_init(cs5535_mfgpt_init);
 
-MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_AUTHOR("Andres Salomon <dilinger@queued.net>");
 MODULE_DESCRIPTION("CS5535/CS5536 MFGPT timer driver");
 MODULE_LICENSE("GPL");
-- 
1.5.6.5

