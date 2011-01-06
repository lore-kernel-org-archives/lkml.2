Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1AFTyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:54:31 -0500
Received: from mail.openrapids.net ([64.15.138.104]:43059 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752915Ab1AFTya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:54:30 -0500
Date: Thu, 6 Jan 2011 14:54:28 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        Alan.Brunelle@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace event block fix unassigned field
Message-ID: <20110106195428.GA3114@Krystal>
References: <20110106184331.GA2449@Krystal> <4D261B23.5040100@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D261B23.5040100@kernel.dk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:52:34 up 44 days, 55 min,  5 users,  load average: 0.06, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe (axboe@kernel.dk) wrote:
> On 2011-01-06 19:43, Mathieu Desnoyers wrote:
> > The "error" field in block_bio_complete is not assigned, leaving the
> > memory area uninitialized (keeping garbage data). Pass an additional
> > tracepoint argument to this event to initialize this field.
> 
> Thanks guys, applied.

Thanks Jens. A side-note for Frederic and Steven: for this patch specifically,
going through the block layer tree seems like the right approach, because we
also modify the tracepoint caller code.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
