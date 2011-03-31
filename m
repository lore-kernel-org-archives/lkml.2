Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab1CaSS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:18:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47012 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1CaSS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:18:28 -0400
Date: Thu, 31 Mar 2011 19:17:51 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Dave Airlie <airlied@gmail.com>, david@lang.hm,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Message-ID: <20110331181751.GC19452@n2100.arm.linux.org.uk>
References: <alpine.LFD.2.00.1103301814250.28032@xanadu.home> <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm> <alpine.LFD.2.00.1103302255280.28032@xanadu.home> <AANLkTikV5OMifKjWRVdtJLEcxcZ56jrjWLYJBX89pHQ0@mail.gmail.com> <alpine.LFD.2.00.1103310012500.28032@xanadu.home> <20110331105440.42692165@lxorguk.ukuu.org.uk> <20110331105000.GC14323@n2100.arm.linux.org.uk> <1301575101.10659.132.camel@e102109-lin.cambridge.arm.com> <20110331130123.GB17547@n2100.arm.linux.org.uk> <20110331181254.GA21981@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331181254.GA21981@merkur.ravnborg.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 08:12:54PM +0200, Sam Ravnborg wrote:
> > And since Linus' whinge about ARM defconfigs, I really *hate* merging
> > anything with *any* defconfig changes in - as a result, I don't
> > particularly want to deal with ARM defconfig changes anymore.
> 
> I thought we solved this with the introduction of "make savedefconfig"
> that created much much smaller defconfig.

Did we solve it to Linus' satisfaction, or did we solve it sufficiently
to avoid the immediate threat of them all being removed and we still have
work to do?  I've no idea.

Personally, I'd still like to see less of them but without significantly
impacting the usefulness of automated built tooks like Simtec's
kautobuild.
