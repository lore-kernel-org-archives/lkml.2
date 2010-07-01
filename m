Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0GAFIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 01:08:09 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42285 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0GAFIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 01:08:05 -0400
Date: Thu, 1 Jul 2010 10:32:16 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mel Gorman <mel@csn.ul.ie>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Roland McGrath <roland@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv7 2.6.35-rc3-tip 0/11]  Uprobes Patches:
Message-ID: <20100701050216.GI23231@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100629183454.32537.63582.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100629183454.32537.63582.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, 

I have addressed all comments to the uprobes patchset.  We have few
todos (most of them are features over the current code) which I plan
to work in the immediate future.

So would it be possible for this patchset to be picked into the tip
tree. Getting these patches merged into the tip tree would help in
getting more comments/feedback and testing.

--
Thanks and Regards
Srikar

> Uprobes Patches
> 
> Changelog from V6:
>   - Addressed comments from Masami on function names in common
>     trace event code. 
>   - Addressed comments from Arnaldo on perf adjust symbol patch.
> 
> Changelog from V5:
>   - Merged user_bkpt and user_bkpt_xol into uprobes.
>   - Addressed comments till now.
> 
> Changelog from V4:
>   - Rebased to tip tree. (2.6.35-rc3-tip)
> 
> Changelog from v3:
>   - Reverted to background page replacement as suggested by Peter Zijlstra.
>   - Dso in 'perf probe' can be either be a short name or a absolute path.
>   - Addressed comments from Masami, Frederic, Steven on traceevents and perf
> 
> Changelog from v2:
>   - Addressed comments from Oleg, including removal of interrupt context
>     handlers, reverting background page replacement in favour of
>     access_process_vm().
> 
>   - Provides perf interface for uprobes.
> 
> Changelog from v1:
>  - Added trace_event interface for uprobes.
>  - Addressed comments from Andrew Morton and Randy Dunlap.
> 
> For previous posting: please refer: http://lkml.org/lkml/2010/6/14/41
> http://lkml.org/lkml/2010/3/20/107 and http://lkml.org/lkml/2010/5/18/307
> 
> 

[ Snipped ... ]

> Here is the list of TODO Items.
> 
> - Allowing probes across fork.
> - Allowing probes per-executable/per dso.
> - Allow multiple probes to share a probepoint.
> - Return probes.
> - Support for other architectures.
> - Uprobes booster.
> - Merge uprobes and kprobes trace_event.
> - replace macro W with bits in inat table.
> 
> Please do provide your valuable comments.
> 
