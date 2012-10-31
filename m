Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422877Ab2JaNYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:24:19 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:62251 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935574Ab2JaNYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:24:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BblT8Nv9pGzfgJ9DdK+54I/IAatF+meI=
Date: Wed, 31 Oct 2012 09:24:05 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>, Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org,
        lkml <linux-kernel@vger.kernel.org>, arm@kernel.org
Subject: Re: [PULL REQ] IXP4xx changes for Linux 3.7
Message-ID: <20121031132405.GD22042@titan.lakedaemon.net>
References: <m3bog6m5iz.fsf@intrepid.localdomain>
 <m3a9vkahci.fsf@intrepid.localdomain>
 <20121029082940.GC2527@netboy.at.omicron.at>
 <201210302227.55857.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210302227.55857.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 10:27:55PM +0000, Arnd Bergmann wrote:
> On Monday 29 October 2012, Richard Cochran wrote:
> > On Thu, Oct 18, 2012 at 12:01:17AM +0200, Krzysztof Halasa wrote:
> > > 
> > > Don't get me wrong. If I had time for this it could be different.
> > > Unfortunately IXP4xx is a legacy arch, and for me it's simply a hobby at
> > > this point. Given the raised barriers to participate, probably aimed at
> > > paid maintainers, I have to quit doing this.
> > > 
> > > BTW since Imre has probably even much less time, it would be a good time
> > > to find someone to maintain IXP4xx code. I will be publishing (from time
> > > to time) my tree (I'm using the hw myself), so even simple
> > > cherry-picking would probably make some sense.
> > 
> > So if no one else wants to do this, then I am willing to look after
> > the IXP code. I think that I do have the time for it.
> 
> Thanks for the offer! 

Yes, thank you!

> Jason Cooper was also volunteering to help out with this, and even we can't
> convince Krzysztof to continue doing it, there is also Imre who is officially
> listed as maintainer for IXP4xx and who has not commented on this. As Krzysztof
> mentions, he probably doesn't have much time for it, but I'd like to give
> him the chance to comment as well.

Agreed.

> I'm sure we can find some solution between the four of you. Right now, I think
> we should focus on getting the bug fixes from Krzysztof's tree into mainline
> and the stable kernels where applicable, and then establish a better working
> mode for the future kernels.

We also need to keep an eye on the big picture.  If we are going to
keep/maintain ixp4xx in the kernel, there are some things which need to
be done.  The drivers need moved to drivers/, platform headers need
moved to platform_data/, and we may as well add devicetree bindings
while we're moving things around.

Making ixp4xx compatible with multiplatform zImage would probably help
out the embedded distros as well.

thx,

Jason.
