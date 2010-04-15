Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0DOSDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:03:31 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41099 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755195Ab0DOSDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:03:30 -0400
Date: Thu, 15 Apr 2010 20:03:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
       Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz, zaurus-devel@www.linuxtogo.org
Subject: 2.6.34-rc3 vs zaurus spitz: mistery solved
Message-ID: <20100415180314.GC1443@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

For some reason, spitz will hang very early in boot with SLUB. With
SLOB, it boots fine.

SLUB worked fine in 2.6.33 and SLOB is hidden under CONFIG_EMBEDDED,
so it took a while to figure out.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
