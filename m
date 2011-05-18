Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab1ERQHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:07:42 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:41770 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756376Ab1ERQHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:07:41 -0400
Date: Wed, 18 May 2011 17:56:15 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Message-ID: <20110518155615.GJ15292@game.jcrosoft.org>
References: <201105181047.17309.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105181047.17309.arnd@arndb.de>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 17206565327784946436
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:47 Wed 18 May     , Arnd Bergmann wrote:
> This is the draft plan for maintaining the ARM subarchitectures in a common
> tree, as a way to help coordinate the upstream merging of the
> arch/arm/{plat,mach}-* changes into Linus' tree.
> 
> This was discussed in great length at the Linaro Developer Summit in Budapest
> last week where we worked out an initial plan. We are modeling the maintainance
> after how the linux-tip tree is used for the x86 architecture, with a set
> of developers that have commit access to one tree on kernel.org and
> have mutual trust in one another. Nicolas Pitre and me are funded
> by Linaro to do the bulk of the work, while Thomas Gleixner will help
> us part-time with his long time architecture maintainance experience.
> Despite the funding by Linaro, this is not a Linaro project and all
> ARM subarchitectures are welcome to go through our tree.
> 
> Russell King's role as ARM maintainer is of course unchanged by this, but
> he has the same commit access to the new tree as the other maintainers and
> is welcome to work in the same tree. We are also open to nominations for
> further people outside of Linaro to join us as committers. Marc Zyngier from
> ARM ltd is one of the candidates that has been suggested and I would also
> like to see someone from Google. We have to find the right balance with the
> number of committers so we get all the work done without stepping on each
> other's toes.
> 
> Our tree will be strictly organized in topic brances so we can feed them
> upstream in the bitesized chunks that Linus likes. The master branch
> is an integration branch that pulls all other branches that are scheduled
> for the next merge window and itself gets integrated into linux-next.
> 
> We will probably not be fully functional during the 2.6.40 merge window,
> but we are trying our best to be useful. For 2.6.41, my hope is that
> we can merge the bulk of the ARM subarchitecture changes through this
> tree. Once Linus is happy with the way that the process works, we can
> mandate that all ARM subarchitecture changes go through our tree, until
> then it stays voluntary.
How do you plan to manage with already sub arch maintainers?

In my ming such tree could be good to organise cross arch drivers
but for real arch specific the current workflow is good

If we add a new stage it will be difficult to follow for people

I'd like to have scenario example where such workflow will give a significant
advantage compare to the current workflow. And please real example.

Best Regards,
J.
