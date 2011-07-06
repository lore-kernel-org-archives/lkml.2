Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1GFAhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 20:37:43 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:35446 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1GFAhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 20:37:41 -0400
Date: Tue, 5 Jul 2011 20:37:29 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: James Morris <jmorris@namei.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        linux-security-module@vger.kernel.org,
        ksummit-2011-discuss@lists.linux-foundation.org,
        Will Drewry <wad@chromium.org>, linux-doc@vger.kernel.org,
        fweisbec@gmail.com, Chris Evans <scarybeasts@gmail.com>,
        djm@mindrot.org, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        kees.cook@canonical.com, tglx@linutronix.de,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, segoon@openwall.com
Subject: Re: [Ksummit-2011-discuss] [PATCH v9 05/13] seccomp_filter:
 Document what seccomp_filter is and how it works.
Message-ID: <20110706003729.GF21216@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	James Morris <jmorris@namei.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-security-module@vger.kernel.org,
	ksummit-2011-discuss@lists.linux-foundation.org,
	Will Drewry <wad@chromium.org>, linux-doc@vger.kernel.org,
	fweisbec@gmail.com, Chris Evans <scarybeasts@gmail.com>,
	djm@mindrot.org, linux-kernel@vger.kernel.org,
	Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
	kees.cook@canonical.com, tglx@linutronix.de,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>, segoon@openwall.com
References: <20110701130705.GG12605@elte.hu>
 <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>
 <20110701161027.GA29035@elte.hu>
 <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
 <1309543448.26417.156.camel@gandalf.stny.rr.com>
 <BANLkTin6rpBvbA1OuVHWy9ViZ-WPnwuXNw@mail.gmail.com>
 <1309546099.26417.159.camel@gandalf.stny.rr.com>
 <alpine.LRH.2.00.1107041207570.7474@tundra.namei.org>
 <1309869654.26417.165.camel@gandalf.stny.rr.com>
 <alpine.LRH.2.00.1107060945410.23585@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1107060945410.23585@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 09:46:36AM +1000, James Morris wrote:
> On Tue, 5 Jul 2011, Steven Rostedt wrote:
> 
> > I don't know about Linus, but as I was trying to find out who would be
> > interested in a tracing track a plumber's, Peter Zijlstra, Thomas
> > Gleixner, and Ingo, all told me that they would not be able to make it.
> 
> Damn.  Bring on (or back) the single developer event...

I tried telling you that people were complaining about needing to fly
to different cities for Plumbers and Kernel Summit, and you didn't
believe me.....  :-)

					- Ted
