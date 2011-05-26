Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1EZIfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 04:35:15 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41009 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1EZIfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 04:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BiG2BMJBnu8WG8NT6SzkTCbKq7B0usIdhAioRGYCaGBCsOI5bPnKPI8HH8Z/TuXXdH
         lHkzAVPBhQmZSvGDL46h+v0BvQnyXnjLFBzylWKF5gDZ5SKPvBTfhSRbih2oWfqOtpPh
         SkAa5wj5y0o/SoB/uesEVeu+QXV8FfxkoAxxA=
MIME-Version: 1.0
In-Reply-To: <20110526082451.GB26775@elte.hu>
References: <BANLkTiki8aQJbFkKOFC+s6xAEiuVyMM5MQ@mail.gmail.com>
	<BANLkTim9UyYAGhg06vCFLxkYPX18cPymEQ@mail.gmail.com>
	<1306254027.18455.47.camel@twins>
	<20110524195435.GC27634@elte.hu>
	<alpine.LFD.2.02.1105242239230.3078@ionos>
	<20110525150153.GE29179@elte.hu>
	<alpine.LFD.2.02.1105251836030.3078@ionos>
	<20110525180100.GY19633@outflux.net>
	<BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
	<alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
	<20110526082451.GB26775@elte.hu>
Date: Thu, 26 May 2011 11:35:11 +0300
X-Google-Sender-Auth: RiCPUFNX0_gnJJHDpe6gMqJyblM
Message-ID: <BANLkTi=22rgFJ-7edOf41e013uDnYuVAAg@mail.gmail.com>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call filtering
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, gnatapov@redhat.com,
        Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, May 26, 2011 at 11:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Unlike Qemu tools/kvm/ has a design that is very fit for MAC
> concepts: it uses separate helper threads for separate resources
> (this could in many cases even be changed to be separate processes
> which only share access to the guest RAM image) - while Qemu is in
> most parts a state machine, so in tools/kvm/ we can realistically
> have a good object manager and keep an exploit in a networking
> interface driver from being able to access disk driver state.

I haven't really followed this particular discussion nor do I know if
Qemu is good or bad fit but sure, for tools/kvm Chrome-style
sandboxing makes tons of sense and would be a pretty good fit for how
our device model works now.

                        Pekka
