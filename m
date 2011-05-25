Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab1EYUCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:02:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042Ab1EYUCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:02:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110525191152.GC19633@outflux.net>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com> <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins> <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <20110525191152.GC19633@outflux.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 May 2011 13:01:39 -0700
Message-ID: <BANLkTimYs4rkgP+hmnG3atLhhCz+jQF=Dg@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
To: Kees Cook <kees.cook@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 12:11 PM, Kees Cook <kees.cook@canonical.com> wrote:
>
> Uhm, what? Chrome would use it. And LXC would. Those were stated very
> early on as projects extremely interested in syscall filtering.

.. and I seriously doubt it is workable.

Or at least it needs some actual working proof-of-concept thing.
Exactly because of issues like direct rendering etc, that require some
of the nastier system calls to work at all.

As to your example of apache modules - last I saw, most of those were
written in high-level scripting languages that almost invariably end
up using quite a bit of the system call interfaces. And more
importantly, almost nobody does unportable code.

So hey, I'm willing to be convinced. But I'll need more than people
_saying_ that they'd be interested. Because judging by past
performance, nobody ever uses esoteric cool new features.

                           Linus
