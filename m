Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0LRDHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 22:07:00 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50946 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0LRDG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 22:06:57 -0500
Date: Sat, 18 Dec 2010 08:34:03 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 18/20] 18: uprobes: commonly used
 filters.
Message-ID: <20101218030403.GA19705@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095714.23751.52601.sendpatchset@localhost6.localdomain6>
 <20101216100049.23751.2658.sendpatchset@localhost6.localdomain6>
 <51253.1292614379@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <51253.1292614379@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> [2010-12-17 14:32:59]:

> On Thu, 16 Dec 2010 15:30:49 +0530, Srikar Dronamraju said:
> 
> > Provides most commonly used filters. Prevents users from having to define
> > their own filters. However this would be useful once we can
> > dynamically associate a filter with a uprobe-event tracer.
> 
> Unclear/awkward language here...
> 
> Did you mean "Prevents users from defining their own filters" or "Allows
> users to not have to define their own filters"?

The later one. From my perspective, users would prefer to filter
based on tid, pid, sid. So by defining these common/generic filters
within uprobes, we help users from not having to redine these
filters. However it no way prevents users from defining their
filters. Also users can still go ahead and add a filter for the same
purpose for which we already have defined a filter.

If you think user would like to filter based on some other
parameter that most users would be interested, then do let me know,
I will try to add a filter for the same.

--
Thanks and Regards
Srikar
