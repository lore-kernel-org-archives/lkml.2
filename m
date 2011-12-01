Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab1LAWUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:20:48 -0500
Received: from mail.openrapids.net ([64.15.138.104]:39420 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754817Ab1LAWUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:20:47 -0500
Date: Thu, 1 Dec 2011 17:20:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Peter Zijlstra <peterz@infradead.org>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111201222046.GE10552@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-10-git-send-email-mathieu.desnoyers@efficios.com> <1322776568.4699.52.camel@twins> <20111201221404.GC3365@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201221404.GC3365@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:19:47 up 373 days,  3:22,  6 users,  load average: 0.08, 0.06,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Thu, Dec 01, 2011 at 10:56:08PM +0100, Peter Zijlstra wrote:
> > On Thu, 2011-12-01 at 16:41 -0500, Mathieu Desnoyers wrote:
> > > LTTng needs this symbol to prepend the current task dynamic priority
> > > value to events (optional context information).
> > 
> > I absolutely detest exporting such stuff. It propagates the idea that
> > task prio actually means something. Also, modules really shouldn't care.
> 
> Mathieu, if you don't have this information, does anything really care?

I can just remove this specific context module, nothing else will care
except the end users, but it's a shame to lose this option.

Thanks,

Mathieu

> 
> thanks,
> 
> greg k-h

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
