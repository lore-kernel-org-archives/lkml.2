Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2DPVbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:31:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53393 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2DPVbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:31:49 -0400
MIME-Version: 1.0
In-Reply-To: <1334606180.28106.7.camel@gandalf.stny.rr.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	<1333696481-3433-12-git-send-email-juri.lelli@gmail.com>
	<1334178222.23924.304.camel@gandalf.stny.rr.com>
	<CAA7rmPGcnXhPUWLWCUS7spy3Grv=aE1Mng=DfD=XM7-GNDyX_w@mail.gmail.com>
	<1334606180.28106.7.camel@gandalf.stny.rr.com>
Date: Mon, 16 Apr 2012 23:31:48 +0200
Message-ID: <CAA7rmPH7itHQttzjeCqWPYVGk4mA_RYwG_fPuCoYStLFrwxLjA@mail.gmail.com>
Subject: Re: [PATCH 11/16] sched: add latency tracing for -deadline tasks.
From: Daniel Vacek <neelx.g@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, raistlin@linux.it
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 21:56, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2012-04-16 at 17:51 +0200, Daniel Vacek wrote:
>
>> sorry for the question, I'm obviously missing something here but what
>> is the logic behind this rewrite? In both cases my gcc generates the
>> same code for me.
>
> Yeah, I noticed that later. I thought it was doing something slightly
> different, but after a good nights rest, and re-reading what I wrote in
> the morning, it was obviously the same functionality.
>
> But that said. The final result is much easier to read. And as you
> stated, it doesn't make a difference in the final outcome, it ended up
> being a good fix (more readable code means less bugs).
>
> -- Steve

That's exactly why I reacted in the first place. I would say the
original code was cleaner and more readable IMHO.

And I twisted my brain hardly in getting what's the difference I can't
see for this ugly change ;-) So at the end I compiled both versions
and then asked what I'm doing wrong :-)

Glad to hear I was not wrong. So it is up to you (or Juri) which
version is the 'right' one.

-- nX
