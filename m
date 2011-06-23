Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848Ab1FWWDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:03:35 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23757 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab1FWWDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:03:34 -0400
Date: Thu, 23 Jun 2011 23:54:40 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>
Subject: [PATCH 01/37] Remove unneeded version.h includes from sound/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106232353040.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the sound/ directory there are two files (flagged by 'make
versioncheck'); sound/pci/asihpi/asihpi.c and
sound/soc/codecs/wm8991.c that include linux/version.h although they
don't need it. This patch removes the unneeded includes.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 sound/pci/asihpi/asihpi.c |    1 -
 sound/soc/codecs/wm8991.c |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index 2ca6f4f..e3569bd 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -27,7 +27,6 @@
 #include "hpioctl.h"
 
 #include <linux/pci.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
 #include <linux/slab.h>
diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 3c2ee1b..6af23d0 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/delay.h>
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

