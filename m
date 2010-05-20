Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0ETC0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 22:26:20 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:38676 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab0ETC0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 22:26:18 -0400
Date: Thu, 20 May 2010 07:56:10 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>, Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/13] Uprobes v4
Message-ID: <20100520022610.GC3319@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6>
 <20100518204944.GA6959@Krystal>
 <20100519060803.GB19957@linux.vnet.ibm.com>
 <1274278660.5605.11006.camel@twins>
 <20100519173806.GA3319@linux.vnet.ibm.com>
 <1274291660.1674.1544.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1274291660.1674.1544.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-05-19 19:54:20]:

> On Wed, 2010-05-19 at 23:08 +0530, Srikar Dronamraju wrote:
> 
> > Or do you suggest any alternative methods for global tracing?
> 
> COW the page for each existing and future mapping.

Yes, we could certainly do this. However we could end up with multiple
copies of the same page. And probably equal number of uprobe and probept
structures. 

--
Thanks and Regards
Srikar

> 
