Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab0JOUPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:15:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51946 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab0JOUPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:15:07 -0400
Date: Fri, 15 Oct 2010 21:14:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Woodruff <r-woodruff2@ti.com>
Subject: Re: [PATCH .36-rc8] arm: mm: allow, but warn, when issuing
	ioremap() on RAM
Message-ID: <20101015201453.GB12981@n2100.arm.linux.org.uk>
References: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com> <1287153021.27165.6.camel@e102109-lin.cambridge.arm.com> <20101015194255.GA12981@n2100.arm.linux.org.uk> <AANLkTinmAy13niqRKrray1Gk4hkr19tA2gWwYbfnFoh7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinmAy13niqRKrray1Gk4hkr19tA2gWwYbfnFoh7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 11:00:40PM +0300, Felipe Contreras wrote:
> On Fri, Oct 15, 2010 at 10:42 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > As soon as the first ARM merge hits during the merge window, I'll be
> > restoring the 'always fail' behaviour.
> 
> Ok, are you going to merge also your patch to use memblock for the
> initialization? Many drivers could certainly use that to fix the
> issue.

There's a lot of work going on with memblock in x86-land which impacts
ARM and means major conflicts for that patch - I think first we'll have
to deal with the fallout from that (iow, finding out what's been broken
by this activity and fix that), and then I'll have to re-do my patch from
the beginning.

Technically, following the rules, that means it has to miss this merge
window - so it looks like it's going to take another six months to solve
this issue (three months to get the memblock patch in, and another three
months for driver fixes to find their way through.)

I find these timescales (12 months) rather unacceptable to fix a problem
such as this.  Makes me wonder why I even bother trying.
