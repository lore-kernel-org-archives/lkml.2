Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab2LTTI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:08:59 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:43856 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750908Ab2LTTIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:08:54 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+NuXcYTProR3zaKzgKwgdX
Date: Thu, 20 Dec 2012 11:08:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        maxime.ripard@free-electrons.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
Message-ID: <20121220190847.GF21056@atomide.com>
References: <20121220163814.GA29557@quad.lixom.net>
 <20121220175639.GA14363@n2100.arm.linux.org.uk>
 <CAOesGMgxXmXUW2RP_5AxJ6Z5sRBhFJ2CQz4S12MwXAb3=ibYOA@mail.gmail.com>
 <20121220184525.GC21056@atomide.com>
 <CA+55aFyiRPk0Qta35PBqMFqn+GkKaugqKJM3WHCT0JEJ1YohWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyiRPk0Qta35PBqMFqn+GkKaugqKJM3WHCT0JEJ1YohWw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [121220 11:03]:
> On Thu, Dec 20, 2012 at 10:45 AM, Tony Lindgren <tony@atomide.com> wrote:
> >
> > I'm seeing the "BUG: spinlock bad magic on CPU#0" issue
> > reported and fixed here:
> >
> > http://marc.info/?l=linux-arm-kernel&m=135594868503683&w=2
> >
> > But that's probably been already posted as a proper patch
> > somewhere?
> 
> Hmm. The patch there looks better than any alternative I can think of.
> It uses the same spinlock name for the whole array, but I think it's
> only used for lockdep printouts, so that should be fine.
> 
> Send me the patch with signed-off and tested-by, and perhaps have a
> few more people test it. The powerpc and sparc people both use it in
> their 32-bit versions and have responsible maintainers, so it might be
> worth it double-checking with BenH and DaveM about it, just in case.
> Added to the Cc.

Looks like it's been posted to LKML as:

[PATCH] lib: atomic64: Initialize locks statically to fix early users

Replied to it with my tested-by if you want to pick it up.

Regards,

Tony
