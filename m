Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170Ab1ECV3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:29:16 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47811 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754124Ab1ECV3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:29:15 -0400
Date: Tue, 3 May 2011 17:29:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 29/32] trace event asoc remove semicolons
Message-ID: <20110503212914.GH32331@Krystal>
References: <20110502211123.163877033@efficios.com> <20110502213216.050459585@efficios.com> <20110503132138.GL1762@opensource.wolfsonmicro.com> <20110503140647.GA29665@Krystal> <20110503141436.GB2893@sirena.org.uk> <20110503142407.GC2893@sirena.org.uk> <1304433287.25414.2396.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304433287.25414.2396.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:28:58 up 161 days,  2:32,  5 users,  load average: 0.05, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-05-03 at 15:24 +0100, Mark Brown wrote:
> > On Tue, May 03, 2011 at 03:14:37PM +0100, Mark Brown wrote:
> 
> > OK, now I see patch 1 I understand why you're doing this.  It should
> > still be at least called out in the patch description if not actually
> > split out into a separate patch (which would be ideal) - one of the
> > things that really stands out in reviews is unrelated changes.
> 
> I actually think there should have been two different patch sets. One
> for the semi colon clean up, and the other to do the work for arrays.
> The semi colon clean up is non-controversial as it is just a clean up
> that does not affect the current code at all.
> 
> But the added array preparation is not needed until we do the array
> work, which deserves its own patch set.

OK, I'll split those patches.

Thanks,

Mathieu

> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
