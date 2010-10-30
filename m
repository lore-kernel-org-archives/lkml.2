Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab0J3Nmv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:42:51 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25914 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0J3Nmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:42:49 -0400
Date: Sat, 30 Oct 2010 15:32:32 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Jonathan Corbet <corbet@lwn.net>
cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] VIA Chrome integrated camera controller driver includes
 headers multiple times
Message-ID: <alpine.LNX.2.00.1010301527580.7979@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The VIA Chrome integrated camera controller driver includes both 
'linux/pci.h' and 'linux/device.h' twice. This gets rid of the duplicates.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 via-camera.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 02a21bc..6f52818 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -13,14 +13,12 @@
 #include <linux/pci.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
-#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/videobuf-dma-sg.h>
-#include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/pm_qos_params.h>


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

