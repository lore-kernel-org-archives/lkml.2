Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab1ECU6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:58:04 -0400
Received: from mail.openrapids.net ([64.15.138.104]:37449 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755086Ab1ECU6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:58:02 -0400
Date: Tue, 3 May 2011 16:57:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC patch 29/32] trace event asoc remove semicolons
Message-ID: <20110503205759.GD32331@Krystal>
References: <20110502211123.163877033@efficios.com> <20110502213216.050459585@efficios.com> <20110503132138.GL1762@opensource.wolfsonmicro.com> <20110503140647.GA29665@Krystal> <20110503141436.GB2893@sirena.org.uk> <20110503142407.GC2893@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110503142407.GC2893@sirena.org.uk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:56:53 up 161 days,  1:59,  5 users,  load average: 0.08, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown (broonie@opensource.wolfsonmicro.com) wrote:
> On Tue, May 03, 2011 at 03:14:37PM +0100, Mark Brown wrote:
> > On Tue, May 03, 2011 at 10:06:47AM -0400, Mathieu Desnoyers wrote:
> 
> > > Yes, this change is related, because these declarations will cause harm.
> > > The structure declaration cannot be put within an array declaration,
> > > because then they won't be simply "ignored": they will try to declare
> > > structures within an array, which is not valid. This is why I did this
> > > change in the same patch.
> 
> > This might make a bit more sense if we'd seen the earlier or possibly
> > later patches...  According to the patch description all you're doing
> > here is removing the semicolons.
> 
> OK, now I see patch 1 I understand why you're doing this.  It should
> still be at least called out in the patch description if not actually
> split out into a separate patch (which would be ideal) - one of the
> things that really stands out in reviews is unrelated changes.

Due to the large number of patches (32 overall), I prefer not to overdo
it in terms of splitting changes to each individual subsystem in even
more patches. If it's OK with you, I'll just clarify the changelog.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
