Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1BBKdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:33:25 -0500
Received: from www.tglx.de ([62.245.132.106]:57345 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab1BBKdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:33:24 -0500
Date: Wed, 2 Feb 2011 11:33:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 27/28] posix-timers: Add support for fd based clocks
In-Reply-To: <20110202091900.GE2747@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1102021132540.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de> <20110201134420.062860200@linutronix.de> <20110202091900.GE2747@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Richard Cochran wrote:

> On Tue, Feb 01, 2011 at 01:52:32PM -0000, Thomas Gleixner wrote:
> > --- linux-2.6-tip.orig/include/linux/posix-timers.h
> > +++ linux-2.6-tip/include/linux/posix-timers.h
> 
> > +/*
> > + * Bit fields within a clockid:
> > + *
> > + * The most significant 29 bits hold either a pid or a file descriptor.
> > + *
> > + * Bit 2 indicates whether a cpu clock refers to a thread or a process.
> > + *
> > + * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
> > + *
> > + * A clockid is invalid if bits 2, 1, and 0 all set.
> 
> I should have said, "if bits 2, 1, and 0 *are* all set."

Fixed.
