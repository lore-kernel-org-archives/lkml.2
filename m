Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0IVTPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:15:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985Ab0IVTPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:15:20 -0400
Date: Wed, 22 Sep 2010 15:14:40 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: Re: [PATCH] tracing, perf: add more power related events
Message-ID: <20100922191440.GE2727@redhat.com>
References: <201009180026.59482.trenn@suse.de> <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com> <4C9A21AD.1000800@linux.intel.com> <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com> <4C9A2FB3.105@linux.intel.com> <1285173835.2275.1026.camel@laptop> <4C9A37AE.2010509@linux.intel.com> <1285176629.2275.1033.camel@laptop> <1285179355.26872.27.camel@gandalf.stny.rr.com> <1285180000.2275.1036.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285180000.2275.1036.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Sep 22, 2010 at 08:26:40PM +0200, Peter Zijlstra wrote:
> [...]
> > Not sure what you mean by "double tracepoints"
> Two different tracepoints in the same location.

Another possibility may be to provide a backward-compatibility module
that maps new tracepoints to old ones.  On demand, it could attach to
the new tracepoints, and export those callbacks as clones of the old
pseudo-ABI: same old names & parameters.  If the new ones supply a
superset of events & data, this is technically possible.

- FChE
