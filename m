Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2LBT1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 14:27:40 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:64271 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab2LBT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 14:27:39 -0500
Date: Sun, 2 Dec 2012 20:27:33 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] scheduler fix for autogroups
Message-ID: <20121202192733.GA19824@gmail.com>
References: <20121201111609.GA18679@gmail.com>
 <CA+55aFx_yJbonbEC5AYteyNv+qWbG-H=yj_=YaiJHwKyu4FH3Q@mail.gmail.com>
 <20121201214438.GA6544@gmail.com>
 <1354436468.7048.35.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354436468.7048.35.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sat, 2012-12-01 at 22:44 +0100, Ingo Molnar wrote:
> 
> > Should we use some other file for that - or no file at all and 
> > just emit a bootup printk for kernel hackers with a short 
> > attention span?
> 
> Or, whack the file and don't bother with a printk either.  If 
> it's in your config, and your command line doesn't contain 
> noautogroup, it's on, so the info is already present (until 
> buffer gets full).  That makes for even fewer lines dedicated 
> to dinky sideline feature.
> 
> Or (as previously mentioned) just depreciate (or rip out) the 
> whole thing since systemd is propagating everywhere anyway, 
> and offers the same functionality.
> 
> For 3.7, a revert of 800d4d30c8f2 would prevent the explosion 
> when folks play with the now non-functional on/off switch 
> (task groups are required to _always_ exist, that commit 
> busted the autogroup assumption), so is perhaps a viable 
> quickfix until autogroups fate is decided?

Linus, which one would be your preference? I'm fine with the 
first and third options - #2 that rips it all out looks like
a sad removal of an otherwise useful feature.

( The fourth option would be to fix the dynamic knobs - there's 
  no patch for that yet. )

Thanks,

	Ingo
