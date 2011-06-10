Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713Ab1FJDws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 23:52:48 -0400
Received: from linux-sh.org ([111.68.239.195]:59452 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab1FJDwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 23:52:47 -0400
Date: Fri, 10 Jun 2011 12:51:46 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address across the kernel
Message-ID: <20110610035115.GF26006@linux-sh.org>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com> <20110610025532.GE26006@linux-sh.org> <4DF189F2.3040009@gmail.com> <1307675512.20439.2.camel@Joe-Laptop> <4DF18BDC.8010306@gmail.com> <1307676240.20439.9.camel@Joe-Laptop> <4DF1902A.1040305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF1902A.1040305@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 01:31:54PM +1000, Ryan Mallon wrote:
> On 10/06/11 13:24, Joe Perches wrote:
> >On Fri, 2011-06-10 at 13:13 +1000, Ryan Mallon wrote:
> >>On 10/06/11 13:11, Joe Perches wrote:
> >>>On Fri, 2011-06-10 at 13:05 +1000, Ryan Mallon wrote:
> >>>>On 10/06/11 12:55, Paul Mundt wrote:
> >>>>>On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
> >>>>>>I no longer work at Bluewater Systems. Update my email address 
> >>>>>>accordingly.
> >>>>>Is this sort of churn really necessary?
> >>>get_maintainer uses the name and address in the first seen
> >>>commit matching on the full name where possible.
> >>Okay, what is the correct fix then so that people get the right email
> >>address for me?
> >I believe updating the MAINTAINERS file and
> >authoring and committing patches that take
> >your email address out of files works well.
> 
> If I strip my email address, but leave my name and copyright in the 
> files the patch will have the same amount of churn right?
> 
Not necessarily. You can leave the copyright bits intact but simply
update (or strip out) the address from the MODULE_AUTHOR part so people
still get the proper data from modinfo and so on. There are many people
with non-working email addresses in copyright statements tree-wide, so
there's certainly a precedent for it. It's also a motivator for not
bothering with inlining the email address in the future, unless it's to
avoid ambiguity (ie, a work done on behalf of an employer, who retains
all rights).

If there are files that you have authored but get_maintainers is
groveling the commits and using your old address, you can preempt this by
simply adding a MAINTAINERS entry with the appropriate file pattern, too.
