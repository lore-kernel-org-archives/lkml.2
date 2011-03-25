Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1CYIHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 04:07:31 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:55673 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753876Ab1CYIH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 04:07:26 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] APM: delete APM in Linux-2.6.40
Date: Fri, 25 Mar 2011 09:07:16 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <alpine.LFD.2.02.1103232321070.3848@x980> <201103241315.34722.linux@rainbow-software.org> <alpine.LFD.2.02.1103241905250.16085@x980>
In-Reply-To: <alpine.LFD.2.02.1103241905250.16085@x980>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103250907.16337.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011, Len Brown wrote:
> > Please don't turn Linux into second Windows.
>
> No worry there.
>
> I mention Microsoft not to advocate that Linux be Windows,
> but to point out that this (hardware/firmware) ship sank 5 years
> ago and Linux is still on the boat.  MS was able to delete
> APM support in 2006 from their source tree, yet we still carry it.

And we also support ISA cards (network/sound/whatever). That's why many people 
(including me) like and use Linux. Take any old machine that has enough power 
to do the job you want and install Linux - e.g. get a Pentium box, install 
Debian and you have a mail server (and if you need to power it down, you need 
APM too). It's not possible with any other OS (well, maybe *BSD but Linux has 
more drivers).

If we remove support for older HW, Linux will never get a decent desktop 
market share. The common use case is "new Windows will not run (or run slow) 
on that (old) box, let's try Linux".

> > If you don't want APM in the
> > kernel, just don't compile it. There are many people using older systems
> > with APM - and most of them wouldn't oppose to this removal as they don't
> > even know about it.
>
> They can still run old Linux on an old APM-only laptop --
> just like they can still run Windows 3.1 or Windows XP if they want to.
>
> What we'd be taking away is their ability to run the latest
> Linux kernel on that laptop.

And that's bad. With Linux philosophy, you need new kernel to get new HW 
support. So if you have an APM-only laptop and would want to use a new USB 
device, you're out of luck. What to do then? Delete Linux and install Windows 
XP?

> The issue at hand is people (like me) who have to maintain
> the latest Linux source code.  In sort, I don't want to
> write, debug, and test a cpuidle driver for an apm-only laptop
> when I could be spending effort on code that people will
> actually run.

So don't do it then. If APM works now, keep it as is. Just like hgafb (HGA 
hardware is from 1984).

-- 
Ondrej Zary
