Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0FNRpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 13:45:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851Ab0FNRpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 13:45:12 -0400
Date: Mon, 14 Jun 2010 13:44:41 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH v5 2/14] mm: Move replace_page to mm/memory.c
Message-ID: <20100614174441.GC23754@infradead.org>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082818.29068.35191.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614082818.29068.35191.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 01:58:18PM +0530, Srikar Dronamraju wrote:
> move_replace_page.patch
> 
> From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Move replace_page() and write_protect_page() to mm/memory.c
> 
> User bkpt will use background page replacement approach to insert/delete
> breakpoints. Background page replacement approach will be based on
> replace_page and write_protect_page.
> Now replace_page() loses its static attribute.

Neither of these actually gets used in this series.  So you can drop
the patch for now.

