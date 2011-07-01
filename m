Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab1GASsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:48:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1GASsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:48:22 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=BMon_h8pASkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2dMWQYJMTPoG89rWWgsA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter
 is and how it works.
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Drewry <wad@chromium.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
        Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, fweisbec@gmail.com,
        tglx@linutronix.de, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org,
        ksummit-2011-discuss@lists.linux-foundation.org
In-Reply-To: <BANLkTin6rpBvbA1OuVHWy9ViZ-WPnwuXNw@mail.gmail.com>
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
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 14:48:19 -0400
Message-ID: <1309546099.26417.159.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 13:09 -0500, Will Drewry wrote:

> I have a panel reserved on system/kernel hardening with Kees at the
> Linux Security Summit as part of the LPC (thanks to the LSS
> committee).  Will the relevant people be able to attend that in
> September?

No, unfortunately most of the key players will not be there.

> 
> (Since the KS is invite-only, I'm obviously not on the list for it,

But I'm on the KS committee ;) I'll vote for you and I think I can talk
the others into accepting you. If this is an issue that can be solved
face to face, I do not think anyone would have a problem with you
coming.

-- Steve


