Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1CTMAf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 08:00:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:49685 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1CTMAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 08:00:33 -0400
Date: Sun, 20 Mar 2011 13:00:26 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Nicolas Palix <Nicolas.Palix@inria.fr>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@shadowen.org>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] checkpatch: Test for kmalloc/memset(0) pairs
In-Reply-To: <AANLkTi=LHeMPCHARy0GE7u2_q0=sz2jLfpb6a-RU8gLM@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103201258450.28495@ask.diku.dk>
References: <1300416744.16880.904.camel@gandalf.stny.rr.com>
 <20110317211548.646b04d2@tpl.lwn.net> <1300419170.16880.956.camel@gandalf.stny.rr.com>
 <AANLkTikZK278BR5o1fP_w2u5PUPbgub9QT4XxzSmEhL5@mail.gmail.com>
 <AANLkTi=2d8S_Pi8kuZMXAmNvHa_2KrOs6K+_FF6P7-pU@mail.gmail.com>
 <Pine.LNX.4.64.1103200852080.28495@ask.diku.dk>
 <AANLkTi=MMKvA-9pFiM1K_JSXjS71JLRCem8THnhu-0=N@mail.gmail.com>
 <Pine.LNX.4.64.1103201007430.28495@ask.diku.dk> <20110320105412.GA11266@elte.hu>
 <AANLkTimdbs2AZ9OE6j+=ziJA1LR2wkZR5qsT8AEq--5x@mail.gmail.com>
 <AANLkTi=LHeMPCHARy0GE7u2_q0=sz2jLfpb6a-RU8gLM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-528062432-1300622426=:28495"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-528062432-1300622426=:28495
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Sun, 20 Mar 2011, Nicolas Palix wrote:

> Hi,
> 
> On Sun, Mar 20, 2011 at 12:06 PM, Pekka Enberg <penberg@kernel.org> wrote:
> > Hi,
> >
> > On Sun, Mar 20, 2011 at 12:54 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>> Indeed that one seems to be quite out of date.  You can get the most
> >>> recent version here: https://launchpad.net/~npalix/+archive/coccinelle
> >>
> >> With tools/coccinelle/ you would never run into such problems of distributing
> >> the latest stable version to your fellow kernel developers: it would always be
> >> available in tools/coccinelle/.
> >>
> >> Integration, synergy, availability, distribution and half a dozen other
> >> buzzwords come to mind as to why it's a good idea to have kernel-focused
> >> tools hosted in the kernel repo :-)
> 
> Our usage is mainly kernel-focused but not the tool. It is C-program focused
> and we have used it on other programs like Wine, OpenSSL, VLC. Others
> use it on other projects like Davecot or close-source projets.
> So, IMHO Coccinelle should no be part of Linux.
> 
> Integrating kernel-focused SmPL scripts is on the other hand a great idea
> to check the kernel and to ease kernel developer life.
> It is what have been done so far. It is certainly possible to improve that,
> at least by adding more and more scripts.
> 
> >>
> >> IMO it's an option to consider.
> >
> > That's my thinking too. Yes, 80 KLOC of OCaml in the kernel tree
> > sounds crazy but I think the practical advantages might be enough to
> > justify it. Btw, would git-submodule be something to consider here?
> >
> 
> At every RC, we push the Coccinelle code on github. Using git-submodule
> seems the way to go thus. Moreover, it will ease the maintenance of
> scripts as we may assume users have one of the latest versions.

The latter is indeed the more serious problem.  But even if the Coccinelle 
code is available, the person will still have to have ocaml installed to 
be able to compile it.

julia
---511516320-528062432-1300622426=:28495--
