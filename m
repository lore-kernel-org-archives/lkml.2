Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab1AJU4M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:56:12 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14794 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1AJU4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:56:09 -0500
Date: Mon, 10 Jan 2011 21:56:08 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mmc@vger.kernel.org
cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Axel Lin <axel.lin@gmail.com>, Chris Ball <cjb@laptop.org>,
        David Vrabel <david.vrabel@csr.com>
Subject: [PATCH] USB SD Host Controller: Including usb.h once is enough
Message-ID: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Including usb.h once is enough in drivers/mmc/host/ushc.c
This removes the duplicate.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 ushc.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mmc/host/ushc.c b/drivers/mmc/host/ushc.c
index f8f65df..f08f944 100644
--- a/drivers/mmc/host/ushc.c
+++ b/drivers/mmc/host/ushc.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/kernel.h>
-#include <linux/usb.h>
 #include <linux/slab.h>
 #include <linux/dma-mapping.h>
 #include <linux/mmc/host.h>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

