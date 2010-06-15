Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0FOLaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:30:07 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58363 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0FOLaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:30:04 -0400
Date: Tue, 15 Jun 2010 16:57:56 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: [PATCH v5 3/14] User Space Breakpoint Assistance Layer
Message-ID: <20100615112756.GK13800@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082832.29068.53628.sendpatchset@localhost6.localdomain6>
 <20100614175048.GE23754@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100614175048.GE23754@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2010-06-14 13:50:48]:

> On Mon, Jun 14, 2010 at 01:58:32PM +0530, Srikar Dronamraju wrote:
> > TODO: Merge user_bkpt layer with uprobes.
> 
> Yes, I don't think there's any point in that split.  What's the
> timeframe for you to finish that merge?

I will take this up in v6.

> 
> > +	depends on MODULES
> 
> This doesn't make too much sense - the only real user of this is not
> modular at all.

Okay. 

> 
> > +	depends on HAVE_USER_BKPT
> 
> Should this be ARCH_HAVE_USER_BKPT or similar?

Okay I shall change from HAVE_USER_BKPT to ARCH_HAVE_USER_BKPT.

--
Thanks and Regards
Srikar
