Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073Ab0FVETI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 00:19:08 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53012 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab0FVETF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 00:19:05 -0400
Date: Tue, 22 Jun 2010 09:45:29 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 11/14] trace: uprobes trace_event interface
Message-ID: <20100622041529.GA25989@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614083008.29068.56731.sendpatchset@localhost6.localdomain6>
 <1277130156.9181.11.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1277130156.9181.11.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > +config UPROBE_EVENT
> > +	depends on UPROBES
> > +	bool "Enable uprobes-based dynamic events"
> > +	select TRACING
> > +	default y
> 
> Why is this default y?

As you see UPROBE_EVENT is gated on UPROBES. I think if UPROBES is
enabled, then UPROBE_EVENT should be enabled. Esp with Christoph
suggesting for module support to be removed, I think it becomes all the
more reason for UPROBE_EVENT to be enabled by default. Otherwise there
is no point in having uprobes code and having no enabled users.
I was even looking at "select UPROBE_EVENT" on enabling UPROBES.

Do you have any specific reason why UPROBE_EVENT should not be enabled
by default? 


--
Thanks and Regards
Srikar
