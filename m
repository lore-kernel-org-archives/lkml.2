Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0KUQQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 11:16:07 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:56967 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753416Ab0KUQQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 11:16:05 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/mEvEJCfLmZhrqri9YNBaErCIriAzaQmQsJIcEw8
	V7y7cZsUs7lGiC
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101121133744.GA10765@elte.hu>
References: <20101121133744.GA10765@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 09:15:44 -0700
Message-ID: <1290356144.4816.11.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 14:37 +0100, Ingo Molnar wrote:
> Hello Mike,
> 
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Tue, 2010-11-16 at 18:28 +0100, Ingo Molnar wrote:
> > 
> > > Mike,
> > > 
> > > Mind sending a new patch with a separate v2 announcement in a new thread, once you 
> > > have something i could apply to the scheduler tree (for a v2.6.38 merge)?
> > 
> > Changes since last:
> > - switch to per session vs tty
> > - make autogroups visible in /proc/sched_debug
> > - make autogroups visible in /proc/<pid>/autogroup
> > - add nice level bandwidth tweakability to /proc/<pid>/autogroup
> 
> I tested it a bit, and autosched-v4 crashes on bootup with with attached config.

Oh crud.  I ran 37, but not tip, it's toxic with my own config.  So much
for darn thing being ready :(

	-Mike

