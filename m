Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab0HEP0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:26:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39301 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274Ab0HEP0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:26:19 -0400
Date: Thu, 5 Aug 2010 20:53:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv10 2.6.35-rc6-tip 12/14]  perf: Add third parameter to
 symbol_filter_t.
Message-ID: <20100805152335.GD9561@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
 <20100727111119.24690.74064.sendpatchset@localhost6.localdomain6>
 <20100805151930.GB12570@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100805151930.GB12570@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Em Tue, Jul 27, 2010 at 04:41:19PM +0530, Srikar Dronamraju escreveu:
> > GElf_Sym for a symbol is needed to filter out based on binding,
> > type, value. This will be needed to list only global binding
> > functions when listing functions from  perf probe.
> 
> Humm, I think it is better to store the symbol binding in struct symbol,
> so that we can have the full symtab and then, on a particular routine,
> decide wheter we should use it or not.
> 
> I'll cook up a patch now.

Okay, Please keep me in loop on that patch so that I can update this
patch accordingly.

--
Thanks and Regards
Srikar
