Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab0LWItk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:49:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0LWIti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:49:38 -0500
Date: Thu, 23 Dec 2010 09:49:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Valdis.Kletnieks@vt.edu, mat <castet.matthieu@free.fr>,
        Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20101223084908.GA21946@elte.hu>
References: <4CE2F914.9070106@free.fr>
 <24422.1290656467@localhost>
 <20101126182355.62615dff@mat-laptop>
 <20101208221951.GO5750@outflux.net>
 <20101211001857.4c5e0794@mat-laptop>
 <20101222124019.GG10809@elte.hu>
 <34428.1293053719@localhost>
 <20101222215725.GB5585@elte.hu>
 <1293055346.22802.0.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293055346.22802.0.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2010-12-22 at 22:57 +0100, Ingo Molnar wrote:
> 
> > It would be nice to see that fix submitted so that it gets into the tree that 
> > introduced the bug.
> > 
> > Steve, Andrew?
> 
> Hi Ingo,
> 
> Which tree/branch should I base this on?

Please use tip:x86/security, it contains the RO/NX patches:

 691513f70d39: x86: Resume trampoline must be executable
 84e1c6bb38eb: x86: Add RO/NX protection for loadable kernel modules
 5bd5a452662b: x86: Add NX protection for kernel data
 64edc8ed5ffa: x86: Fix improper large page preservation

> [...] I could do write up formal patch and push it out.

Thanks!

	Ingo
