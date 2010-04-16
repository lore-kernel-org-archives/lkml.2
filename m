Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387Ab0DPNM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 09:12:57 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50818 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758329Ab0DPNMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 09:12:55 -0400
Date: Fri, 16 Apr 2010 15:12:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: spitz 2.6.34-rc4: fix On/off key name to fix warning during boot
Message-ID: <20100416131245.GA1306@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On/Off contains slash in the name, which causes warning during boot.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

--- ./arch/arm/mach-pxa/spitz.c	2010-03-21 22:09:12.000000000 +0100
+++ ./arch/arm/mach-pxa/spitz.c	2010-04-16 03:45:07.000000000 +0200
@@ -363,7 +363,7 @@
 		.type	= EV_PWR,
 		.code	= KEY_SUSPEND,
 		.gpio	= SPITZ_GPIO_ON_KEY,
-		.desc	= "On/Off",
+		.desc	= "On Off",
 		.wakeup	= 1,
 	},
 	/* Two buttons detecting the lid state */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
