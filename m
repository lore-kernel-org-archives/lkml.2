Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0GERpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:45:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab0GERpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:45:21 -0400
Date: Mon, 5 Jul 2010 14:44:50 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip 0/4] perf-probe updates: string support, etc.
Message-ID: <20100705174450.GB23506@ghostprotocols.net>
References: <20100519195717.2885.90799.stgit@localhost6.localdomain6> <56FC4434-EA6C-4A0C-A95B-3D7BE818774B@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56FC4434-EA6C-4A0C-A95B-3D7BE818774B@canonical.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jul 05, 2010 at 10:30:47AM -0400, Chase Douglas escreveu:
> On May 19, 2010, at 3:57 PM, Masami Hiramatsu wrote:
> > Hi,
> > 
> > Here is a series of patches which improves perf probe to
> > add below features. I cleared some coding style issues.
> > 
> > - String support, which enables dynamic events to trace string
> >  variables instead of its address.
> > 
> > - Fixed-index array entry support, which allows user to trace
> >  an array entry with digit index, e.g. array[0].
> > 
> > - Global/static variable support, which allows user to trace
> >  global or static variables, as same as local one.
> > 
> > 
> > TODOs (possible features):
> >  - Support dynamic array-indexing (var[var2])
> >  - Support force type-casting ((type)var)
> >  - Show what deta-structure member is assigned to each argument.
> >  - Better support for probes on modules
> >  - More debugger like enhancements(%next, --disasm, etc.)
> > 
> > Thank you,
> > 
> > ---
> > 
> > Masami Hiramatsu (4):
> >      perf probe: Support static and global variables
> >      perf probe: Support tracing an entry of array
> >      perf probe: Support "string" type
> >      tracing/kprobes: Support "string" type
> 
> What's the status of these patches? They seem very useful to me, but I
> don't see them in Arnaldo's tree at git.kernel.org.

Thanks for reminding me about these ones, will look at them to get them
in perf/core.

- Arnaldo
