Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1AXWpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:45:22 -0500
Received: from www.tglx.de ([62.245.132.106]:36794 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab1AXWpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:45:20 -0500
Date: Mon, 24 Jan 2011 23:44:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: john stultz <johnstul@us.ibm.com>, Torben Hohn <torbenh@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
        yong.zhang0@gmail.com
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
In-Reply-To: <1295907672.2274.44.camel@twins>
Message-ID: <alpine.LFD.2.00.1101242344090.31804@localhost6.localdomain6>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>  <1295651224-29823-2-git-send-email-torbenh@gmx.de>  <1295901169.4845.29.camel@work-vm>  <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6> <1295907672.2274.44.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011, Peter Zijlstra wrote:

> On Mon, 2011-01-24 at 23:10 +0100, Thomas Gleixner wrote:
> > The call to calc_global_load() is there for hysterical raisins and we
> > really should get rid of it sooner than later. I'm quite sure that it
> > could be run from a timer callback as well. Peter ?
> 
> calc_global_load() wants to be called on just one cpu, do we have a
> better place for that?

Well, we can call it from a timer from a single CPU.

Thanks,

	tglx
 
