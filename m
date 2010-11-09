Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0KIJcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:32:32 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59398 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0KIJc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:32:27 -0500
Date: Tue, 9 Nov 2010 18:32:04 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: linux-fbdev@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        James Simmons <jsimmons@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] fbdev git tree.
Message-ID: <20101109093204.GB21086@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I find myself spending more time reviewing and merging fbdev patches
lately, and in an effort to offload some of the pressure on -mm, I've
opted to start a git tree to start collecting and merging fbdev changes.

I plan to get a patchwork queue established for the list as well so that
things don't fall through the cracks (the link will be posted once it's
been established). People will be able to see the status of their patches
this way, rather than wondering whether things are being picked up,
overlooked, or forced through an alternate merge strategy (We have had
reasonable success with this with the SH tree, so here's hoping that the
same approach will work well here, too).

I've already made a note about this to akpm off-list, so fbdev patches
that pop up outside of the regular channels that I may be unaware of
should still have a reasonable chance of being intercepted and rerouted
(although the mmotm is rather devoid of drivers/video churn at the
moment).

I'll be combing through the list archives to see if there is anything
glaringly outstanding (the HDMI/EDID work comes to mind) and working on
getting the oustanding issues there resolved. If anyone has any
outstanding patches that have fallen through the cracks, now would be a
good time to provide pointers!

Given the point that we're at with .38 bits now and a cursory look at
-next shows that there's already quite a bit of drivers/video churn
coming in from git trees. It will likely take a few cycles to get people
used to the idea of there being an active fbdev tree to merge through,
but with any luck it will be a fairly natural transition. I'll be
contacting and working with git tree owners separately so there aren't
any surprises.

The tree can be found at:

	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git

Stephen, if you could add this with the master branch to -next, it would
be appreciated. For the moment I expect most of the patches to follow a
fairly linear line of development, but there may be cause for topic
branches as new (or contested) patch sets arise.
