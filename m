Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0JUIwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:52:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:42533 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750875Ab0JUIwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:52:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+wY4kACnqwG0JLOta8gBVAQFhKdG4Gj5NHj3sYlQ
	B66BOVUIUPpjX3
Subject: Re: [RFC/RFT PATCH] sched: automated per tty task groups
From: Mike Galbraith <efault@gmx.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20101021084838.GA1590@arch.trippelsdorf.de>
References: <1287479765.9920.9.camel@marge.simson.net>
	 <1287487757.24189.40.camel@marge.simson.net>
	 <AANLkTik08s=S7gZOGWEEhPW-zJtNRCse2h6jH3HAjoJH@mail.gmail.com>
	 <1287511983.7417.45.camel@marge.simson.net>
	 <1287514410.7368.10.camel@marge.simson.net>
	 <20101020025652.GB26822@elte.hu>
	 <1287648715.9021.20.camel@marge.simson.net>
	 <20101021084838.GA1590@arch.trippelsdorf.de>
Content-Type: text/plain
Date: Thu, 21 Oct 2010 10:52:45 +0200
Message-Id: <1287651165.9021.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 10:48 +0200, Markus Trippelsdorf wrote:
> On Thu, Oct 21, 2010 at 10:11:55AM +0200, Mike Galbraith wrote:
> > On Wed, 2010-10-20 at 04:56 +0200, Ingo Molnar wrote:
> > 
> > > Mind doing more of the tty->desktop renames/generalizations as Linus suggested, and 
> > > resend the patch?
> > 
> > Here she comes.  Better/Worse?
> > 
> > Changes:
> > - tty->autogroup.
> > - only autogroup fair class tasks.
> > - removed dainbramaged sleeper vruntime twiddling.
> > - removed paranoid locking.
> > - removed noop detatch code.
> > 
> > > I'd also suggest to move it out of EXPERIMENTAL - we dont really do that for core 
> > > kernel features as most distros enable CONFIG_EXPERIMENTAL so it's a rather 
> > > meaningless distinction. Since the feature is default-n, people will get the old 
> > > scheduler by default but can also choose this desktop-centric scheduling mode.
> > > 
> > > I'd even argue to make it default-y, because this patch clearly cures a form of 
> > > kbuild cancer.
> > 
> > You top dogs can make the default call.. it it's accepted that is ;-)
> > 
> > Marcus:  care to try the below?  Works fine for me (but so did first
> > cut).  It depends on the attached patch, and applied to virgin shiny new
> > 2.6.36.
> 
> Works fine interactively, but I still get the same kernel BUG on reboot
> time as before. Would a photo of the trace help you?

Odd.  Yeah, please send me the photo and your .config.

	-Mike

