Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306Ab2C2B0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:26:25 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:51953 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758702Ab2C2B0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:26:14 -0400
Message-ID: <4F73BA35.7010009@xenotime.net>
Date: Wed, 28 Mar 2012 18:26:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH] sound: fix oss/msnd_pinnacle module param type
References: <20120328171401.354ddb56727a26fe64b35ddf@canb.auug.org.au>
In-Reply-To: <20120328171401.354ddb56727a26fe64b35ddf@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix module parameter data type to eliminate build warning.

sound/oss/msnd_pinnacle.c:1727:1: warning: return from incompatible pointer type

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 sound/oss/msnd_pinnacle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120328.orig/sound/oss/msnd_pinnacle.c
+++ linux-next-20120328/sound/oss/msnd_pinnacle.c
@@ -1631,7 +1631,7 @@ static int ide_irq __initdata = 0;
 static int joystick_io __initdata = 0;
 
 /* If we have the digital daugherboard... */
-static int digital __initdata = 0;
+static bool digital __initdata = false;
 #endif
 
 static int fifosize __initdata =	DEFFIFOSIZE;
