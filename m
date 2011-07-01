Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab1GASEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:04:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55310 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1GASEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:04:13 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=BMon_h8pASkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_Ubq8_g_6hdqfwj8LL0A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
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
In-Reply-To: <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>
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
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 14:04:08 -0400
Message-ID: <1309543448.26417.156.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 11:43 -0500, Will Drewry wrote:
> On Fri, Jul 1, 2011 at 11:10 AM, Ingo Molnar <mingo@elte.hu> wrote:

> I'd like to be able to move along security for the platform today and
> not in two years, but if my only chance of any form of this being
> ACK'd is to write it such that it shares code with perf and has a
> shiny new ABI, then I'll queue up the work for when I can start trying
> to tackle it.

As this seems to be dragging on, and does not look to be solved by
October, I would like to propose this topic for the Kernel Summit in
Prague. I believe all parties involved may be there, and if not, I will
push hard to get them there.

Email is not always the best median for discussions. Face to face can
usually solve things much quicker.

-- Steve


