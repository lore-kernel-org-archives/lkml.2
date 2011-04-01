Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1DAMmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 08:42:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49765 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1DAMmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 08:42:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bill Gatliff <bgat@billgatliff.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 14:41:38 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Nicolas Pitre <nico@fluxnic.net>,
        Dave Airlie <airlied@gmail.com>, david@lang.hm,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>, David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
References: <alpine.LFD.2.00.1103301531420.28032@xanadu.home> <20110331130123.GB17547@n2100.arm.linux.org.uk> <BANLkTinmoTyceJCT+K-RCm4NC76qfDyeVw@mail.gmail.com>
In-Reply-To: <BANLkTinmoTyceJCT+K-RCm4NC76qfDyeVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104011441.38902.arnd@arndb.de>
X-Provags-ID: V02:K0:2mDUc5pWG5PnF80b+v8YZM/PvdkSk8GOm/NDrPemkFh
 UvGVAwHL2xTYedzUYmnXOmcBtwW+yjv92AZNDjtce0QOG+tEVU
 tBpImPIkKiFjTKFBjUXfIYVjoYmKLQVKQ4gfjabnlpQ3Uve45A
 kjp2T8HRYdaePZt0fzN4AGJCr6Iu5m+JXNoPf59ukxZdcSgFF/
 Kf24NUf6kDEoyyx399jog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, Bill Gatliff wrote:
> On Thu, Mar 31, 2011 at 8:01 AM, Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> > Just look at the removal of AAEC2000, LH7A40x and 2000 lines from the
> > mach-types file removed 6000 lines, which in itself is about the number
> > of lines of change submitted during the last merge window for any one
> > non-ARM architecture.  At this point in time with this complaint, I've
> > absolutely no idea why I bothered to do that.  I should've left it well
> > alone and then the diffstat percentage would've been smaller.  After
> > all, it's "pointless churn".
> 
> I think you did it because it was the Right Thing To Do.  Even
> positive change can be painful at times.
> 
> The majority is exceedingly grateful for the effort you make.

Defintely. I haven't seen anyone in this thread blame Russell for the
mess. As far as I'm concerned, the code in arch/arm consists of
the well-maintained {mm,kernel,lib,common,tools,include} directories
that are actively being taken care of by Russell, and a huge amount
of crap that has accumulated in mach-* and plat-*. Some of it is
arguably better than other parts, but the problem is not that someone
in particular did a bad job writing the code. The problem is that
nobody today is pushing back hard enough on crap getting added.

There is a lot of good work going on to reduce the amount of crap in
the mach code, but my feeling is that it's not keeping up with the
rate of crap getting added by other people. In some ways, the Linaro
project has actually made this worse by helping people get their code
into shape for inclusion (which of course is generally a good thing
to do).

	Arnd
