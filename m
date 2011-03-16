Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1CPVcX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319Ab1CPVcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:32:16 -0400
Date: Wed, 16 Mar 2011 17:31:44 -0400
From: Jason Baron <jbaron@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        ralf@linux-mips.org, jang@linux.vnet.ibm.com, schwidefsky@de.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] jump label: update for .39 v2
Message-ID: <20110316213143.GB8792@redhat.com>
References: <cover.1300299760.git.jbaron@redhat.com>
 <1300307811.16880.53.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300307811.16880.53.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 04:36:51PM -0400, Steven Rostedt wrote:
> On Wed, 2011-03-16 at 15:58 -0400, Jason Baron wrote:
> > Hi,
> > 
> > Update against tip/perf/urgent. I've incorporated feedback from the last round.
> > Hopefully these can still be considered for .39.
> > 
> 
> Doesn't apply to tip/perf/urgent. Could you try again.
> 
> Thanks,
> 
> -- Steve

Hi,

yes, applying would be nice :)

Looks like I forgot a 'git fetch' there. After doing that, only patch
1/4 is affected b/c 'perf_task_events' was renamed to
'perf_sched_events'. I've re-posed 1/4.

thanks,

-Jason
