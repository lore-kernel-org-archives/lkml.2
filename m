Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934399Ab1EST2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:28:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36365 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933896Ab1EST2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:28:35 -0400
Date: Thu, 19 May 2011 20:28:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <21cnbao@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Arnd Bergmann <arnd@arndb.de>, lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] ARM Subarchitecture group maintainership
Message-ID: <20110519192817.GB7445@n2100.arm.linux.org.uk>
References: <201105181047.17309.arnd@arndb.de> <BANLkTim_0eRvDkQwAYjTNQsOVQiHV+DdBQ@mail.gmail.com> <alpine.LFD.2.00.1105182234130.14430@xanadu.home> <BANLkTinXQvrG3LeSEO9Lnam3Bvq3dDKOsw@mail.gmail.com> <BANLkTi=OdvDT6MEk-RxiTNnX-rbwTOqrrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=OdvDT6MEk-RxiTNnX-rbwTOqrrw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:31:42PM +0200, Linus Walleij wrote:
> On Thu, May 19, 2011 at 5:01 AM, Barry Song <21cnbao@gmail.com> wrote:
> 
> > i asked this because we wanted to send the source codes of
> > CSR(http://www.csr.com) to upstream as i have told you in LDS. it
> > looks like we need to follow the below new changes to make our source
> > codes acceptable?
> > 1. arm device tree
> > 2. new pinmux framework from Linus Walleij
> 
> I'm working on that to post a new v3 of this patch set ASAP, if the
> ARM subarch tree maintainers are interested I can send them a
> pull request after that.

As my tree currently contains a large proportion of the consolidation work
so far, it probably makes sense for this stuff to continue coming through
my tree so that we can sort out any merge conflicts there, rather than
starting on a new tree... It probably makes sense for the subarch tree to
get going after this merge window has closed.
