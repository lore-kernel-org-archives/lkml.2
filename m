Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1EYTMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:12:47 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57016 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab1EYTMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:12:46 -0400
Date: Wed, 25 May 2011 12:11:52 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110525191152.GC19633@outflux.net>
References: <1305807728.11267.25.camel@gandalf.stny.rr.com>
 <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
 <BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
 <1306254027.18455.47.camel@twins>
 <20110524195435.GC27634@elte.hu>
 <alpine.LFD.2.02.1105242239230.3078@ionos>
 <20110525150153.GE29179@elte.hu>
 <alpine.LFD.2.02.1105251836030.3078@ionos>
 <20110525180100.GY19633@outflux.net>
 <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, May 25, 2011 at 11:42:44AM -0700, Linus Torvalds wrote:
> And who would *use* this thing in real life? Nobody. In order to sell
> me on a new security interface, give me a real actual use case that is
> security-conscious and relevant to real users.
> [...]
> And per-system-call permissions are very dubious. What system calls
> don't you want to succeed? That ioctl? You just made it impossible to
> do a modern graphical application. Yet the kind of thing where we
> would _want_ to help users is in making it easier to sandbox something
> like the adobe flash player. But without accelerated direct rendering,
> that's not going to fly, is it?

Uhm, what? Chrome would use it. And LXC would. Those were stated very
early on as projects extremely interested in syscall filtering. And that's
just the start, I can easily imagine Apache modules enforcing a very narrow
band of syscalls, or just about anything else that could be in a position
of running potentially malicious code. This could be very far-reaching, IMO.

-Kees

-- 
Kees Cook
Ubuntu Security Team
