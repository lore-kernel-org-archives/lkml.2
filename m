Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab1DHNHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 09:07:25 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:60008 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752234Ab1DHNHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 09:07:24 -0400
Date: Fri, 8 Apr 2011 15:07:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: rpurdie@rpsys.net, lenz@cs.wisc.edu,
        kernel list <linux-kernel@vger.kernel.org>, arminlitzel@web.de,
        Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
        utx@penguin.cz, zaurus-devel@www.linuxtogo.org,
        Marek Vasut <marek.vasut@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Zaurus-devel] 2.6.39-rc2 on zaurus: does not build, does not
 boot
Message-ID: <20110408130715.GA1632@ucw.cz>
References: <20110408062646.GA1472@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110408062646.GA1472@ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Boot stops just after mounting root filesystem; cursor stops
> flashing. (Any idea what goes on there?)

With CF bluetooth unplugged, it gets  up to userland.

Once it hung in eaarly boot, once early in runlevel 2.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
