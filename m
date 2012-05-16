Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2EPPRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498Ab2EPPRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:17:10 -0400
Date: Wed, 16 May 2012 17:16:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Dmitry Antipov <dmitry.antipov@linaro.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Perf record format portability
Message-ID: <20120516151655.GE1820@m.brq.redhat.com>
References: <4FB275EB.5050904@linaro.org>
 <20120515155146.GB7864@infradead.org>
 <4FB38677.8070601@linaro.org>
 <20120516145927.GC7864@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516145927.GC7864@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 11:59:27AM -0300, Arnaldo Carvalho de Melo wrote:
> Adding Jiri and Steven to the CC list.
> 
> Em Wed, May 16, 2012 at 02:50:31PM +0400, Dmitry Antipov escreveu:
> > On 05/15/2012 07:51 PM, Arnaldo Carvalho de Melo wrote:
> > >Em Tue, May 15, 2012 at 07:27:39PM +0400, Dmitry Antipov escreveu:
> > >>are there any thoughts on how much of the perf.data is portable and how much it should be?
> > >>I'm interesting in recording scheduler activity on one machine and then replaying on
> > >>another. As I can see, replaying x86 perf.data on ARM doesn't work. At least, should it
> > >>work with a small subset of recorded events (for example, sched:sched_switch,
> > >>sched:sched_process_exit, sched:sched_process_fork, sched:sched_wakeup
> > >>and sched:sched_migrate_task) on the same architecture?
> > >
> > >Endianness issues? ARM EB? There are some patches by Jiri Olsa that may
> > >help you if that is the case.

latest version sent today, there's description of tests I did:
http://marc.info/?l=linux-kernel&m=133715172512742&w=2

Each time I run new sort of test, another endianity issue is hit.
so, tracepoints.. I'll check ;)

jirka
