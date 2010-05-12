Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab0ELSEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:04:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:53456 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751175Ab0ELSEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:04:39 -0400
Date: Wed, 12 May 2010 14:04:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Pierre Tardy <tardyp@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>
Subject: Re: Perf and ftrace [was Re: PyTimechart]
Message-ID: <20100512180438.GE15953@Krystal>
References: <20100511213625.GD5422@nowhere> <AANLkTikumkBKwYTYIK63mT2i_hI4SAo-Eua0cx9OCHnD@mail.gmail.com> <20100512144811.GA5405@nowhere> <1273678596.27703.30.camel@gandalf.stny.rr.com> <20100512164650.GH5405@nowhere> <1273683624.1626.127.camel@laptop> <20100512170734.GA15953@Krystal> <1273686425.1626.142.camel@laptop> <20100512175305.GB32496@Krystal> <1273687212.1626.147.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273687212.1626.147.camel@laptop>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:03:21 up 109 days, 20:40,  9 users,  load average: 0.18, 0.17,
	0.15
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-05-12 at 13:53 -0400, Mathieu Desnoyers wrote:
> > 
> > Would you be fine with an alternative implementation and API that support both
> > mmap() and splice(), without any need to swap pages ? 
> 
> Sure, what did you have in mind?
> 
> You basically give you page to splice, never to see it again, you'd need
> to fill that hole in your buffer again.
> 

Can't we keep multiple references to each page ? (shared page) so it's still in
the buffer, also accessed by mmap(), and in addition accessed by splice.

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
