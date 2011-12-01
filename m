Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1LAWEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:04:48 -0500
Received: from mail.openrapids.net ([64.15.138.104]:35315 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754393Ab1LAWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:04:47 -0500
Date: Thu, 1 Dec 2011 17:04:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Darren Hart <darren@dvhart.com>
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111201220445.GA10552@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com> <1322776568.4699.52.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322776568.4699.52.camel@twins>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:01:54 up 373 days,  3:04,  6 users,  load average: 0.17, 0.06,
	0.05
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2011-12-01 at 16:41 -0500, Mathieu Desnoyers wrote:
> > LTTng needs this symbol to prepend the current task dynamic priority
> > value to events (optional context information).
> 
> I absolutely detest exporting such stuff. It propagates the idea that
> task prio actually means something. Also, modules really shouldn't care.

People debugging their SCHED_FIFO/SCHED_RR applications, as well as
users of priority-inheritance futexes, may happen to find this
information extremely useful.

Just saying...

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
