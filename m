Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab1BBKhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 05:37:14 -0500
Received: from www.tglx.de ([62.245.132.106]:57400 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab1BBKhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 05:37:12 -0500
Date: Wed, 2 Feb 2011 11:37:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 28/28] posix clocks: Introduce dynamic clocks
In-Reply-To: <20110202075058.GA2747@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1102021134520.31804@localhost6.localdomain6>
References: <20110201134320.688829863@linutronix.de> <20110201134420.164172635@linutronix.de> <1296596987.3336.83.camel@work-vm> <20110202075058.GA2747@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Richard Cochran wrote:

> On Tue, Feb 01, 2011 at 01:49:47PM -0800, john stultz wrote:
> > I sort of worry about the naming collision with the term posix-clock, as
> > this is just one type of posix clock (I suspect most folks think of a
> > posix clock as the clockid passed to the existing posix api).
> > 
> > Could we maybe use posix-dynclock or posix-fdclock or something? I know
> > its already been changed from clkdev, so sorry for being finicky here
> > and not catching this earlier.
> 
> A rose by any other name...
> 
> I agree that naming (even internal APIs) is important and have no
> objection to changing the name. I did spend a bit of time considering
> various alternatives, and now I'm out of ideas.
> 
> So, please do change the name if you have a better one.

We have a clear distinction between posix-timers and those new
posix-clocks. Adding some artificial "fd", "dyn" or whatever will not
make it much better.

Thanks,

	tglx
