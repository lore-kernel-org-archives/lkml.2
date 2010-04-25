Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab0DYKwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 06:52:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53871 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab0DYKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 06:52:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=G+3pmSuZXlNtnXWheu0EjVyKgGWXkMiMgs6301byVqRjcSFzwQpfAYrXAU6FSzuSEc
         Zl34YkBaLjec4UwQgc0adVDBI/zlPwrAKZs0pdplhQVKlEyeRl5+3TSAjCpaLNk38iA0
         y4ZV2mgILczYUKG5EY3QMtnWi65nYxfDNznjo=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
       John Pilles <jpilles@bb-elec.com>, Johan Hovold <jhovold@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH] USB: mos7840: Cleanup useless header
Date: Sun, 25 Apr 2010 12:52:02 +0200
Message-Id: <1272192722-1182-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BKL isn't anymore present into this file thus it is no necessary still include smp_lock.h.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/usb/serial/mos7840.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 2fda1c0..f8424d1 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -26,7 +26,6 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
-- 
1.6.3.3

