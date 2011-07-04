Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1GDCWK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:22:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:36527 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab1GDCWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:22:08 -0400
Date: Mon, 4 Jul 2011 12:19:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Will Drewry <wad@chromium.org>, Ingo Molnar <mingo@elte.hu>,
        Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, fweisbec@gmail.com,
        tglx@linutronix.de, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org,
        ksummit-2011-discuss@lists.linux-foundation.org
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter
 is and how it works.
In-Reply-To: <1309546099.26417.159.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LRH.2.00.1107041207570.7474@tundra.namei.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>  <1308875813-20122-5-git-send-email-wad@chromium.org>  <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>  <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>  <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
  <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>  <20110701115600.GK20990@elte.hu>  <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>  <20110701130705.GG12605@elte.hu>  <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>  <20110701161027.GA29035@elte.hu>
  <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>  <1309543448.26417.156.camel@gandalf.stny.rr.com>  <BANLkTin6rpBvbA1OuVHWy9ViZ-WPnwuXNw@mail.gmail.com> <1309546099.26417.159.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011, Steven Rostedt wrote:

> On Fri, 2011-07-01 at 13:09 -0500, Will Drewry wrote:
> 
> > I have a panel reserved on system/kernel hardening with Kees at the
> > Linux Security Summit as part of the LPC (thanks to the LSS
> > committee).  Will the relevant people be able to attend that in
> > September?
> 
> No, unfortunately most of the key players will not be there.

Hold on, do we know this for sure?  And that they will all definitely be 
at KS?  I'd really prefer to see this resolved via email, it's more 
scalable, transparent and timely.

In any case, Plumbers and LSS should have some of the key people.

Ingo & Linus: will you be there?



- James
-- 
James Morris
<jmorris@namei.org>
