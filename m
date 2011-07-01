Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab1GASJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 14:09:59 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48175 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab1GASJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 14:09:57 -0400
MIME-Version: 1.0
In-Reply-To: <1309543448.26417.156.camel@gandalf.stny.rr.com>
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
Date: Fri, 1 Jul 2011 13:09:56 -0500
Message-ID: <BANLkTin6rpBvbA1OuVHWy9ViZ-WPnwuXNw@mail.gmail.com>
Subject: Re: [PATCH v9 05/13] seccomp_filter: Document what seccomp_filter is
 and how it works.
From: Will Drewry <wad@chromium.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, James Morris <jmorris@namei.org>,
        Chris Evans <scarybeasts@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, djm@mindrot.org,
        segoon@openwall.com, kees.cook@canonical.com, fweisbec@gmail.com,
        tglx@linutronix.de, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        linux-security-module@vger.kernel.org,
        ksummit-2011-discuss@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 1, 2011 at 1:04 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-07-01 at 11:43 -0500, Will Drewry wrote:
>> On Fri, Jul 1, 2011 at 11:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>> I'd like to be able to move along security for the platform today and
>> not in two years, but if my only chance of any form of this being
>> ACK'd is to write it such that it shares code with perf and has a
>> shiny new ABI, then I'll queue up the work for when I can start trying
>> to tackle it.
>
> As this seems to be dragging on, and does not look to be solved by
> October, I would like to propose this topic for the Kernel Summit in
> Prague. I believe all parties involved may be there, and if not, I will
> push hard to get them there.
>
> Email is not always the best median for discussions. Face to face can
> usually solve things much quicker.

I have a panel reserved on system/kernel hardening with Kees at the
Linux Security Summit as part of the LPC (thanks to the LSS
committee).  Will the relevant people be able to attend that in
September?

(Since the KS is invite-only, I'm obviously not on the list for it,
but I realize I'm just a bit player in this. Maybe some direction can
be resolved I can play catch up with.)

What's another couple months? :)

Thanks!
will
