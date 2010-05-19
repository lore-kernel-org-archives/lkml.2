Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0ESGVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:21:50 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:55161 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab0ESGVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:21:46 -0400
Date: Wed, 19 May 2010 11:51:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 10/13] trace: Common code for kprobes/uprobes
 traceevents
Message-ID: <20100519062142.GD19957@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
 <20100518170024.20070.25438.sendpatchset@localhost6.localdomain6>
 <4BF2CD2F.8000104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4BF2CD2F.8000104@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Isn't it a common header for kprobes and uprobes? :)
> 
> Maybe "Probe-based dynamic events common header" ?
> 

Agree.

> > +#define MAX_TRACE_ARGS 128
> > +#define MAX_ARGSTR_LEN 63
> > +#define MAX_EVENT_NAME_LEN 64
> > +#define UPROBE_EVENT_SYSTEM "uprobes"
> 
> You should *just move* the common code in this patch.
> Additional uprobes code can be introduced in next patch.
> 

Okay.

> > +
> > +/* Flags for trace_probe */
> > +#define TP_FLAG_TRACE	1
> > +#define TP_FLAG_PROFILE	2
> > +#define UPROBE_ENABLED	4
> 
> If this is a trace_probe flag, it is better to start with TP_FLAG_.

Okay.
Does TP_FLAG_UPROBE sound fine?


Thanks Masami.

--
Thanks and Regards
Srikar
