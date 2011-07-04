Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab1GDQLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 12:11:09 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38402 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755976Ab1GDQLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 12:11:07 -0400
X-Sasl-enc: cMKijyWln+868KB1MousSQXYSoixegUTePttXgv4DIlt 1309795865
Date: Mon, 4 Jul 2011 09:09:41 -0700
From: Greg KH <greg@kroah.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        linux-security-module@vger.kernel.org,
        ksummit-2011-discuss@lists.linux-foundation.org,
        Will Drewry <wad@chromium.org>, linux-doc@vger.kernel.org,
        fweisbec@gmail.com, Chris Evans <scarybeasts@gmail.com>,
        djm@mindrot.org, James Morris <jmorris@namei.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, segoon@openwall.com
Subject: Re: [Ksummit-2011-discuss] [PATCH v9 05/13] seccomp_filter: Document
 what seccomp_filter is and how it works.
Message-ID: <20110704160941.GA18303@kroah.com>
References: <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
 <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
 <20110701115600.GK20990@elte.hu>
 <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
 <20110701130705.GG12605@elte.hu>
 <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
 <20110701161027.GA29035@elte.hu>
 <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
 <1309543448.26417.156.camel@gandalf.stny.rr.com>
 <20110701202538.GN32221@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110701202538.GN32221@outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 01:25:38PM -0700, Kees Cook wrote:
> On Fri, Jul 01, 2011 at 02:04:08PM -0400, Steven Rostedt wrote:
> > On Fri, 2011-07-01 at 11:43 -0500, Will Drewry wrote:
> > > On Fri, Jul 1, 2011 at 11:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > I'd like to be able to move along security for the platform today and
> > > not in two years, but if my only chance of any form of this being
> > > ACK'd is to write it such that it shares code with perf and has a
> > > shiny new ABI, then I'll queue up the work for when I can start trying
> > > to tackle it.
> > 
> > As this seems to be dragging on, and does not look to be solved by
> > October, I would like to propose this topic for the Kernel Summit in
> > Prague. I believe all parties involved may be there, and if not, I will
> > push hard to get them there.
> > 
> > Email is not always the best median for discussions. Face to face can
> > usually solve things much quicker.
> 
> How about we put it in as-is and mark it experimental, and then folks
> can discuss improvements to it in Oct after all the API users have had
> a chance to play with it? Four months seems like a needless delay to me.
> I respect the objections, but it doesn't seem to balance against the
> demonstrated need for this feature when faced with a viable working patch
> series.

We can't add something and then remove it if userspace programs are
depending on it, sorry.
