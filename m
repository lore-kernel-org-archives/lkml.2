Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1DFWuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:50:24 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52498 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab1DFWuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:50:23 -0400
Date: Thu, 7 Apr 2011 04:20:13 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 23/26] 23: perf: show possible probes
 in a given executable file or library.
Message-ID: <20110406225013.GB5806@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143707.15455.66114.sendpatchset@localhost6.localdomain6>
 <4D999A2F.4020204@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4D999A2F.4020204@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> [2011-04-04 19:15:11]:

> (2011/04/01 23:37), Srikar Dronamraju wrote:
> > Enhances -F/--funcs option of "perf probe" to list possible probe points in
> > an executable file or library. A new option -e/--exe specifies the path of
> > the executable or library.
> 
> I think you'd better use -x for abbr. of --exe, since -e is used for --event
> for other subcommands.

Okay, 

> 
> And also, it seems this kind of patch should be placed after perf-probe
> uprobe support patch, because without uprobe support, user binary analysis
> is meaningless. (In the result, this introduces -u/--uprobe option without
> uprobe support)
> 

Okay, I can do that, Should we do the listing before or after the uprobe
can place a breakpoint is arguable.

> 
> > Show last 10 functions in /bin/zsh.
> > 
> > # perf probe -F -u -e /bin/zsh | tail
> 
> I also can't understand why -u is required even if we have -x for user
> binaries and -m for kernel modules.
> 

yes, for the listing we can certainly do without -u option.

-- 
Thanks and Regards
Srikar
