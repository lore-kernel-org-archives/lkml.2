Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0ESR4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 13:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab0ESR4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 13:56:20 -0400
Date: Wed, 19 May 2010 13:45:55 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/13] Uprobes v4
Message-ID: <20100519174555.GA10508@redhat.com>
References: <20100518165826.20070.11594.sendpatchset@localhost6.localdomain6> <20100518204944.GA6959@Krystal> <20100519060803.GB19957@linux.vnet.ibm.com> <1274278660.5605.11006.camel@twins> <20100519173806.GA3319@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519173806.GA3319@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, May 19, 2010 at 11:08:06PM +0530, Srikar Dronamraju wrote:

> [...]  For global tracing we can't use access_process_vm. [...]

Well, we have already demonstrated functional "global tracing" via
access_process_vm, with the trade-off that affected pages are
replicated on a per-process basis.  (KSM could end up sharing them
again, one supposes.)

- FChE
