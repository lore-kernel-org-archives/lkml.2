Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0FPHLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 03:11:17 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54873 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab0FPHLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 03:11:15 -0400
Date: Wed, 16 Jun 2010 12:36:08 +0530
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
Subject: Re: [PATCH v5 5/14] Slot allocation for execution out of line (XOL)
Message-ID: <20100616070608.GN13800@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082852.29068.57866.sendpatchset@localhost6.localdomain6>
 <20100614175227.GF23754@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100614175227.GF23754@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2010-06-14 13:52:27]:

> What's the point of adding another header for a few prototypes when
> all users include user_bkpt.h anyway?
> 

Okay, 

Should we be moving the user_bkpt_xol also into uprobes when we move the
user_bkpt layer into uprobes?

--
Thanks and Regards
Srikar
