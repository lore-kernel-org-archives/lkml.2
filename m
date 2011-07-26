Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427Ab1GZSuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:50:18 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51890 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab1GZSuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:50:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] MMC / TMIO: Fix build issue related to struct scatterlist
Date: Tue, 26 Jul 2011 20:50:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-mmc@vger.kernel.org
References: <201107262049.15333.rjw@sisk.pl>
In-Reply-To: <201107262049.15333.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107262050.23379.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix build issue caused by undefined struct scatterlist in
drivers/mmc/host/tmio_mmc.c.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/mmc/host/tmio_mmc.h      |    1 +
 drivers/usb/renesas_usbhs/fifo.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6/drivers/mmc/host/tmio_mmc.h
===================================================================
--- linux-2.6.orig/drivers/mmc/host/tmio_mmc.h
+++ linux-2.6/drivers/mmc/host/tmio_mmc.h
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/spinlock.h>
+#include <linux/scatterlist.h>
 
 /* Definitions for values the CTRL_SDIO_STATUS register can take. */
 #define TMIO_SDIO_STAT_IOIRQ	0x0001

