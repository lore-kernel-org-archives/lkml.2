Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0IVSav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:30:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42081 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab0IVSat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:30:49 -0400
Subject: Re: [PATCH] tracing, perf: add more power related events
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <20100922182356.GB9058@elte.hu>
References: <20100917162412.GB3341@elte.hu>
	 <201009180026.59482.trenn@suse.de>
	 <AANLkTimMAr9kEzybFGai3qGyXx36v055iPpXq_C1vW8C@mail.gmail.com>
	 <4C9A21AD.1000800@linux.intel.com>
	 <AANLkTim6B+Je=LykgJb9=0vK5Br1rkft619BRJkBcHdP@mail.gmail.com>
	 <4C9A2FB3.105@linux.intel.com> <1285173835.2275.1026.camel@laptop>
	 <4C9A37AE.2010509@linux.intel.com> <1285176629.2275.1033.camel@laptop>
	 <1285179355.26872.27.camel@gandalf.stny.rr.com>
	 <20100922182356.GB9058@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Sep 2010 20:30:33 +0200
Message-ID: <1285180233.2275.1038.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-22 at 20:23 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > We could add a TRACE_EVENT_ABI() as Ingo has been suggesting. [...]
> 
> That would be rather useful.
> 
> We could still be flexible about experimental tracepoints (they dont 
> hurt), but apps should stick to ABI bits - or at least not complain when 
> non-ABI tracepoints change for good reasons. (arbitrary, avoidable 
> changes are still bad obviously, regardless of the type of the 
> tracepoint)
> 
> We'd be more stringent with marking tracepoints an ABI.
> 
> So yes, this would be lovely to have.

Why? As long as we mandate that apps need to fully parse the format
stuff anyway, it doesn't buy us much.
