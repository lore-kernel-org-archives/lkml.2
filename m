Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2DWTki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:40:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45893 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab2DWTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:40:36 -0400
Date: Mon, 23 Apr 2012 21:40:42 +0200
From: Pavel Machek <pavel@denx.de>
To: kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, wd@denx.de
Subject: Sharing header files -- arch/arm/mach-generic  ?
Message-ID: <20120423194042.GA5734@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have new architecture I'd like to merge into the mainline. It has
some code very similar to existing plaforms (for example
real differences to mach-realview/platsmp.c are two lines.)

Is that a problem?

Should mach-generic/platsmp.c be created, so code can be better
shared? Or are the code pieces small enough that this duplication can
be ignored?

headsmp.S is another candidate for sharing. AFAICT we have 4 times
identical code in the tree already:

./mach-exynos/headsmp.S:   ldmia	r4, {r5, r6}
./plat-versatile/headsmp.S:		ldmia	 r4, {r5, r6}
./mach-ux500/headsmp.S:			ldmia	 r4, {r5, r6}
./mach-msm/headsmp.S:			ldmia	 r4, {r5, r6}

Thoughts?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
