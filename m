Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab1EMPap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:30:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab1EMPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:30:43 -0400
Date: Fri, 13 May 2011 17:30:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wim Heirman <wim@heirman.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: perf-stat per thread results
Message-ID: <20110513153028.GC3854@elte.hu>
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wim Heirman <wim@heirman.net> wrote:

> Hi all,
> 
> I'm using perf-stat to look at hardware performance counters for a
> parallel program. Is there a way to get counter values for each thread
> individually, rather than aggregated for the whole process? [...]

Not at the moment, but it would be a useful feature.

> [...] I know I can attach to a specific thread using --tid=, but due to the 
> time required to find the tid and attach/detach this isn't accurate for 
> short-running programs. Or, alternatively, can I use perf record --stat and 
> get an exact count for each performance counter?

Yes perf record --stat should work. 'perf report -T --stdio' is supposed to 
print this, but it has regressed i think.

Arnaldo, any ideas?

Thanks,

	Ingo
