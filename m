Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab2D2NRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 09:17:35 -0400
Received: from nm29-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.129]:40295 "HELO
	nm29-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750810Ab2D2NRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 09:17:34 -0400
X-Yahoo-Newman-Id: 675440.42710.bm@smtp108.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3CEkfM4VM1mzvWdraH_9T1hWwpemH24FGoAkIgeykXr87nx
 Jkr6LK8v8JZ.qUoKf7jhjtzxo_4HE6UqflIIqTb5_GP_4OBVpElxrzbCB.dw
 7_CnEkMU1xkKSBQdjcjGpADf6rSf.qkdO4UQV1Mtq3MOLaZejlgKQUB2pf5k
 dgMm2wxij1V0956VUgVbbb8HyigATsN2GGDN8BkYj69zArcnu9dYlNV2otE0
 yBYTcHDiT2N1ocQa4g25TRcagkIKFrkrJ5_T8X7KcxHk6hRist8ov1XrsvuE
 3FnuNv4djhhVofAEjrMBCvZZ.amgtKkS86Hu5JEY.GE2.HWq36NfTcZizxyV
 lOCFzL23TQKnghhP0XNPOnISSDI6LN8aSGpXBJFjvQoL2EC5OHlM4QZiYsPD
 iueWS6L.AMCVP9hcd4gBUs.3HYfcSLbg-
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Sun, 29 Apr 2012 18:50:14 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH 01/02] fixed coding style issue with comments
Message-ID: <20120429132014.GA3435@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello .

Fixed coding style issue relating to comments
in sound/usb/clock.c


>From 3bc5e14b4cf0dceb45314880233fe5a843ae048d Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Sun, 29 Apr 2012 18:05:21 +0530
Subject: [PATCH 09/10] sound:Fixed a coding style issue of comments.

Fixed a coding style issue by replacing C99
style with C89 in the file sound/usb/clock.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 sound/usb/clock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 379baad..a3319af 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -240,7 +240,7 @@ static int set_sample_rate_v1(struct snd_usb_audio *chip, int iface,
 	crate = data[0] | (data[1] << 8) | (data[2] << 16);
 	if (crate != rate) {
 		snd_printd(KERN_WARNING "current rate %d is different from the runtime rate %d\n", crate, rate);
-		// runtime->rate = crate;
+		/* runtime->rate = crate; */
 	}
 
 	return 0;
-- 
1.7.9


-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.
