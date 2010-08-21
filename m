Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab0HUWqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 18:46:17 -0400
Received: from tor-exit-node-readme.printf.net ([89.145.121.180]:34086 "EHLO
	void.printf.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516Ab0HUWqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 18:46:16 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Aug 2010 18:46:16 EDT
From: Chris Ball <cjb@laptop.org>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-mmc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        Hanumath Prasad <hanumath.prasad@stericsson.com>
Subject: Re: [PATCH] mmc: MMC 4.4 DDR support
References: <1278658780-26397-1-git-send-email-hanumath.prasad@stericsson.com>
	<AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>
Date: Sat, 21 Aug 2010 18:37:45 -0400
In-Reply-To: <AANLkTikBdBhJeQ-t2+0echJfAxz529QZEYPJtyHUsROd@mail.gmail.com>
	(Linus Walleij's message of "Sun, 22 Aug 2010 00:30:33 +0200")
Message-ID: <m3pqxbsibq.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   > Hm is there some problem with this patch or has the processing of
   > it simply stalled? When I read the thread I cannot see Hanumaths
   > answers on the list but it looks mainly like the patch is OK and
   > there is some chit-chat.
   > 
   > Can it be picked up? Everyone is going to need DDR MMC for their
   > eMMCs soon-ish.

I'd like to dedicate more time to mmc/.  Do you think it'd be useful
for me to catch all the patches sent to linux-mmc@ into a public Git
tree, and periodically report on what went upstream via akpm and
what's still waiting?

Of course, the tree could also be used for testing.  Maybe even
automated testing, which I'm also interested in.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
