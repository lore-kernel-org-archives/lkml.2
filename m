Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab0FOLcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:32:20 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:58753 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab0FOLcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:32:19 -0400
Date: Tue, 15 Jun 2010 17:00:15 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Roland McGrath <roland@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 6/14] Uprobes Implementation
Message-ID: <20100615113015.GL13800@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100614082748.29068.21995.sendpatchset@localhost6.localdomain6>
 <20100614082903.29068.62439.sendpatchset@localhost6.localdomain6>
 <20100614072706.d29f3cbd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100614072706.d29f3cbd.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <randy.dunlap@oracle.com> [2010-06-14 07:27:06]:

> On Mon, 14 Jun 2010 13:59:03 +0530 Srikar Dronamraju wrote:
> 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 16541af..995f7f2 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -58,6 +58,16 @@ config USER_BKPT
> >  	  This service is used by components such as uprobes.
> >  	  If in doubt, say "N".
> >  
> > +config UPROBES
> > +	bool "User-space probes (EXPERIMENTAL)"
> > +	depends on MODULES && USER_BKPT_XOL
> 
> depends on having CONFIG_MODULES enabled.  Please explain.
> 

As Christoph suggested, I will remove the samples and hence the
dependency on CONFIG_MODULES.

