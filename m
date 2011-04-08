Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1DHG07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:26:59 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58016 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753198Ab1DHG06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:26:58 -0400
Date: Fri, 8 Apr 2011 08:26:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: 2.6.39-rc2 on zaurus: does not build, does not boot
Message-ID: <20110408062646.GA1472@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Build fix is below. Maybe it is pending in the trees somewhere
already...

Boot stops just after mounting root filesystem; cursor stops
flashing. (Any idea what goes on there?)

								Pavel

--- ./drivers/video.ofic/pxafb.c	2011-04-06 15:19:51.000000000 +0200
+++ ./drivers/video/pxafb.c	2011-04-07 06:20:20.000000000 +0200
@@ -1648,7 +1648,7 @@
 
 	switch (val) {
 	case CPUFREQ_PRECHANGE:
-		if (!fbi->overlay[0].usage && !fbi->overlay[1].usage)
+//		if (!fbi->overlay[0].usage && !fbi->overlay[1].usage)
 			set_ctrlr_state(fbi, C_DISABLE_CLKCHANGE);
 		break;
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
