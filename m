Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab1CaSM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:12:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:49626 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab1CaSM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:12:56 -0400
Date: Thu, 31 Mar 2011 20:12:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Dave Airlie <airlied@gmail.com>, david@lang.hm,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110331181254.GA21981@merkur.ravnborg.org>
References: <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com> <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com> <alpine.LFD.2.00.1103310012500.28032@xanadu.home> <20110331105440.42692165@lxorguk.ukuu.org.uk> <20110331105000.GC14323@n2100.arm.linux.org.uk> <1301575101.10659.132.camel@e102109-lin.cambridge.arm.com> <20110331130123.GB17547@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331130123.GB17547@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And since Linus' whinge about ARM defconfigs, I really *hate* merging
> anything with *any* defconfig changes in - as a result, I don't
> particularly want to deal with ARM defconfig changes anymore.

I thought we solved this with the introduction of "make savedefconfig"
that created much much smaller defconfig.
At least the defconfigs should be down in the noise level in the
diffstats.

We can always argue about the usefullness of the 100+ defconfigs,
that is still unreadable.
But at least they no longer dominate the diffs (if people remember
to use "make savedefconfig".

	Sam
