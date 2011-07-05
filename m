Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab1GEXr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 19:47:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:52179 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab1GEXr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 19:47:26 -0400
Date: Wed, 6 Jul 2011 09:46:36 +1000 (EST)
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
In-Reply-To: <1309869654.26417.165.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LRH.2.00.1107060945410.23585@tundra.namei.org>
References: <1308875813-20122-1-git-send-email-wad@chromium.org>  <1308875813-20122-5-git-send-email-wad@chromium.org>  <BANLkTimtYUyXbZjWhjK61B_1WBXE4MoAeA@mail.gmail.com>  <alpine.LRH.2.00.1106270919290.30367@tundra.namei.org>  <BANLkTi=sB2R-gWM30a0KKSGXz5p7OHRfeA@mail.gmail.com>
  <alpine.LRH.2.00.1106301128590.13496@tundra.namei.org>  <20110701115600.GK20990@elte.hu>  <BANLkTim8CGx89nOg0HX=S1=arunBU3sEGQ@mail.gmail.com>  <20110701130705.GG12605@elte.hu>  <BANLkTimN0nEa2Bog2-vzCv=1XOG5OsJjLA@mail.gmail.com>  <20110701161027.GA29035@elte.hu>
  <BANLkTikCaACO8o9HkAnkuaTuoKqqQWQrtw@mail.gmail.com>  <1309543448.26417.156.camel@gandalf.stny.rr.com>  <BANLkTin6rpBvbA1OuVHWy9ViZ-WPnwuXNw@mail.gmail.com>  <1309546099.26417.159.camel@gandalf.stny.rr.com>  <alpine.LRH.2.00.1107041207570.7474@tundra.namei.org>
 <1309869654.26417.165.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011, Steven Rostedt wrote:

> I don't know about Linus, but as I was trying to find out who would be
> interested in a tracing track a plumber's, Peter Zijlstra, Thomas
> Gleixner, and Ingo, all told me that they would not be able to make it.

Damn.  Bring on (or back) the single developer event...


- James
-- 
James Morris
<jmorris@namei.org>
