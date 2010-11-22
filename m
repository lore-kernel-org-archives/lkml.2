Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab0KVWHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 17:07:18 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29586 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab0KVWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 17:07:16 -0500
Date: Mon, 22 Nov 2010 22:54:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: alsa-devel@alsa-project.org
cc: Jon Smirl <jonsmirl@gmail.com>, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, linuxppc-dev@lists.ozlabs.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] MPC5200: Eliminate duplicate include of of_device.h
Message-ID: <alpine.LNX.2.00.1011222246250.6285@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Eliminate duplicate  #include <linux/of_device.h>  from 
sound/soc/fsl/mpc5200_dma.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mpc5200_dma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/fsl/mpc5200_dma.c b/sound/soc/fsl/mpc5200_dma.c
index dce6b55..f92dca0 100644
--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -9,7 +9,6 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/slab.h>
-#include <linux/of_device.h>
 #include <linux/of_platform.h>
 
 #include <sound/soc.h>



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

