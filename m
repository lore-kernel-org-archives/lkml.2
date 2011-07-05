Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab1GEMlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:41:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab1GEMk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:40:59 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=BMon_h8pASkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=vPzrylZ24F0Xrq26TXoA:9 a=wg5AXannT6bYYn7Pgf8A:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter
 is and how it works.
From: Steven Rostedt <rostedt@goodmis.org>
To: James Morris <jmorris@namei.org>
Cc: Will Drewry <wad@chromium.org>, Ingo Molnar <mingo@elte.hu>,
        Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, fweisbec@gmail.com,
        tglx@linutronix.de, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org,
        ksummit-2011-discuss@lists.linux-foundation.org
In-Reply-To: <alpine.LRH.2.00.1107041207570.7474@tundra.namei.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>
	 <1308875813-20122-5-git-send-email-wad@chromium.org>
	 <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>
	 <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>
	 <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
	 <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>
	 <20110701115600.GK20990@elte.hu>
	 <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>
	 <20110701130705.GG12605@elte.hu>
	 <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
	 <20110701161027.GA29035@elte.hu>
	 <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
	 <1309543448.26417.156.camel@gandalf.stny.rr.com>
	 <BANLkTin6rpBvbA1OuVHWy9ViZ-WPnwuXNw@mail.gmail.com>
	 <1309546099.26417.159.camel@gandalf.stny.rr.com>
	 <alpine.LRH.2.00.1107041207570.7474@tundra.namei.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 05 Jul 2011 08:40:54 -0400
Message-ID: <1309869654.26417.165.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 12:19 +1000, James Morris wrote:
> On Fri, 1 Jul 2011, Steven Rostedt wrote:
> 
> > On Fri, 2011-07-01 at 13:09 -0500, Will Drewry wrote:
> > 
> > > I have a panel reserved on system/kernel hardening with Kees at the
> > > Linux Security Summit as part of the LPC (thanks to the LSS
> > > committee).  Will the relevant people be able to attend that in
> > > September?
> > 
> > No, unfortunately most of the key players will not be there.
> 
> Hold on, do we know this for sure?  And that they will all definitely be 
> at KS?  I'd really prefer to see this resolved via email, it's more 
> scalable, transparent and timely.
> 
> In any case, Plumbers and LSS should have some of the key people.
> 
> Ingo & Linus: will you be there?

I don't know about Linus, but as I was trying to find out who would be
interested in a tracing track a plumber's, Peter Zijlstra, Thomas
Gleixner, and Ingo, all told me that they would not be able to make it.

-- Steve


