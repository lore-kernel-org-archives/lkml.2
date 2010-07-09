Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab0GIFtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 01:49:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51479 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab0GIFti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 01:49:38 -0400
Date: Fri, 9 Jul 2010 11:11:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Naren A Devaiah <naren.devaiah@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv8 2.6.35-rc4-tip 11/12]  perf: perf interface for
 uprobes
Message-ID: <20100709054133.GC26884@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
 <20100708171215.29165.7352.sendpatchset@localhost6.localdomain6>
 <20100708201926.GB30946@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100708201926.GB30946@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph, 

> > Here is a terminal snapshot of placing, using and removing a probe on a
> > process with pid 3591 (corresponding to zsh)
> 
> Btw, I think this interface is not the most the best one for typical
> uses cases.  To make perf probe support more useful we'll need at least
> a way to create a probe in all intances of a given binary/DSO, and
> a way to run a binary with pre-defined breakpoints.
> 

Yes Peter had already asked for this and we have it in plan.
These are listed in the todos I listed corresponding to file based
probes.

- Allowing probes per-executable/per dso.
- Allowing probes across fork.

I have some thoughts on how to achieve these.

However I am not sure which items I should work first
- file based probes or on
- automatically trigger perf uprobes on high overhead functions 
 that Ingo suggested.

I am not too clear on later so I might as well start thinking on file
based probes.

--
Thanks and Regards
Srikar
