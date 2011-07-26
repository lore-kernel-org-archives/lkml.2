Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1GZSu3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:50:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51895 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab1GZSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:50:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/2] USB / Renesas: Fix build issue related to struct scatterlist
Date: Tue, 26 Jul 2011 20:51:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org
References: <201107262049.15333.rjw@sisk.pl>
In-Reply-To: <201107262049.15333.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107262051.02019.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix build issue caused by undefined struct scatterlist in
drivers/usb/renesas_usbhs/fifo.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/usb/renesas_usbhs/fifo.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/usb/renesas_usbhs/fifo.c
===================================================================
--- linux-2.6.orig/drivers/usb/renesas_usbhs/fifo.c
+++ linux-2.6/drivers/usb/renesas_usbhs/fifo.c
@@ -16,6 +16,7 @@
  */
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/scatterlist.h>
 #include "./common.h"
 #include "./pipe.h"
 

