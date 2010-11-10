Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0KJP2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 10:28:19 -0500
Received: from mail.openrapids.net ([64.15.138.104]:54033 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756642Ab0KJP2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 10:28:18 -0500
Date: Wed, 10 Nov 2010 10:28:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110152812.GA14009@Krystal>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com> <20101110101450.GA18481@elte.hu> <1289400056.12418.139.camel@gandalf.stny.rr.com> <1289400234.2191.129.camel@laptop> <1289401781.12418.145.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289401781.12418.145.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:18:04 up 48 days, 19:20,  4 users,  load average: 0.36, 0.20,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> I added Mathieu too. I know to you LTTng does not exist, but he can at
> least give ideas about something we may not have thought about and may
> want to do in the future.

If we come up with an ABI that fulfills my user needs, I'll switch to it and
deprecate LTTng. I've actually worked almost full time on common kernel tracer
infrastructures this year, leaving LTTng development almost to a standing halt.

How do you guys want to proceed ? Do you want to throw your requirements over
the wall or do you want me to propose a trace format we can discuss on ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
