Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1CPWIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 18:08:48 -0400
Received: from blu0-omc1-s3.blu0.hotmail.com ([65.55.116.14]:1504 "EHLO
	blu0-omc1-s3.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab1CPWIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 18:08:41 -0400
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP385AFC2668A8F4A790629996CE0@phx.gbl>
Date: Wed, 16 Mar 2011 18:08:35 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jason Baron <jbaron@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>, peterz@infradead.org, hpa@zytor.com,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        ralf@linux-mips.org, jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] jump label: update for .39 v2
References: <cover.1300299760.git.jbaron@redhat.com> <1300307811.16880.53.camel@gandalf.stny.rr.com> <20110316213143.GB8792@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110316213143.GB8792@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:07:43 up 343 days,  7:57,  5 users,  load average: 0.12, 0.17,
	0.18
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 16 Mar 2011 22:08:40.0396 (UTC) FILETIME=[B4D550C0:01CBE426]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jason Baron (jbaron@redhat.com) wrote:
> On Wed, Mar 16, 2011 at 04:36:51PM -0400, Steven Rostedt wrote:
> > On Wed, 2011-03-16 at 15:58 -0400, Jason Baron wrote:
> > > Hi,
> > > 
> > > Update against tip/perf/urgent. I've incorporated feedback from the last round.
> > > Hopefully these can still be considered for .39.
> > > 
> > 
> > Doesn't apply to tip/perf/urgent. Could you try again.
> > 
> > Thanks,
> > 
> > -- Steve
> 
> Hi,
> 
> yes, applying would be nice :)
> 
> Looks like I forgot a 'git fetch' there. After doing that, only patch
> 1/4 is affected b/c 'perf_task_events' was renamed to
> 'perf_sched_events'. I've re-posed 1/4.

I'm getting more confident about the alignment story, as we're
generating these structures directly from assembly. You can add my
Acked-by to this patch series.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

Mathieu

> 
> thanks,
> 
> -Jason

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
