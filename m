Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab1FMXQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 19:16:00 -0400
Received: from mail.perches.com ([173.55.12.10]:2886 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab1FMXP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 19:15:59 -0400
Subject: Re: [PATCH trival/tree-wide] Change Ryan Mallon's email address
 across the kernel
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, Andre Renaud <andre@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <avictor.za@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Anton Vorontsov <cbou@mail.ru>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, trivial@kernel.org,
        jj@chaosbits.net, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4DF697B4.6080000@gmail.com>
References: <1307661170-9325-1-git-send-email-rmallon@gmail.com>
	 <20110610025532.GE26006@linux-sh.org>
	 <20110610095641.664fad35@lxorguk.ukuu.org.uk>  <4DF697B4.6080000@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 16:15:56 -0700
Message-ID: <1308006956.26699.52.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-14 at 09:05 +1000, Ryan Mallon wrote:
> On 10/06/11 18:56, Alan Cox wrote:
> > On Fri, 10 Jun 2011 11:55:49 +0900
> > Paul Mundt<lethal@linux-sh.org>  wrote:
> >> On Fri, Jun 10, 2011 at 09:12:50AM +1000, Ryan Mallon wrote:
> >>> I no longer work at Bluewater Systems. Update my email address accordingly.
> >> Is this sort of churn really necessary?
> > Yes - stale email addresses cause all sorts of problems, particularly if
> > in the future the address is re-used in the company. It also causes
> > confusion over who owns and maintains stuff because it's never obvious
> > whether the resolution of an unknown address is
> > A.	'user has moved on, follow the user'
> > B.	'user has moved on, company probably has someone else assigned
> > 	 to it'
> Okay, so there seem to be a number of different opinions on this. I 
> would really like some solution for this so it can go into 3.0. The 
> options I see are:
> a) My original patch
> b) My original patch, but delete email address in .[ch] files rather 
> than change it
> c) Entry in .mailmap (will this work for 3.0?)

It will if Andrew Morton/Linus picks up my patch.

> d) Add MAINTAINERS entries for each of the files which have my email 
> address in them
> e) Some combination of the above

> Is there a preferred option?

My preferred combination is b and c.
If you're European, maybe a and c is best.

