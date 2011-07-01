Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1GAU0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:26:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58142 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab1GAU0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:26:22 -0400
Date: Fri, 1 Jul 2011 13:25:38 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Will Drewry <wad@chromium.org>, Ingo Molnar <mingo@elte.hu>,
        James Morris <jmorris@namei.org>, Chris Evans <scarybeasts@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, fweisbec@gmail.com, tglx@linutronix.de,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org,
        ksummit-2011-discuss@lists.linux-foundation.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
Message-ID: <20110701202538.GN32221@outflux.net>
References: <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
 <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
 <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
 <20110701115600.GK20990@elte.hu>
 <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
 <20110701130705.GG12605@elte.hu>
 <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
 <20110701161027.GA29035@elte.hu>
 <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
 <1309543448.26417.156.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309543448.26417.156.camel@gandalf.stny.rr.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 02:04:08PM -0400, Steven Rostedt wrote:
> On Fri, 2011-07-01 at 11:43 -0500, Will Drewry wrote:
> > On Fri, Jul 1, 2011 at 11:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > I'd like to be able to move along security for the platform today and
> > not in two years, but if my only chance of any form of this being
> > ACK'd is to write it such that it shares code with perf and has a
> > shiny new ABI, then I'll queue up the work for when I can start trying
> > to tackle it.
> 
> As this seems to be dragging on, and does not look to be solved by
> October, I would like to propose this topic for the Kernel Summit in
> Prague. I believe all parties involved may be there, and if not, I will
> push hard to get them there.
> 
> Email is not always the best median for discussions. Face to face can
> usually solve things much quicker.

How about we put it in as-is and mark it experimental, and then folks
can discuss improvements to it in Oct after all the API users have had
a chance to play with it? Four months seems like a needless delay to me.
I respect the objections, but it doesn't seem to balance against the
demonstrated need for this feature when faced with a viable working patch
series.

-Kees

-- 
Kees Cook
Ubuntu Security Team
