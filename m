Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab2ALQeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:34:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56386 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2ALQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:34:49 -0500
X-Authority-Analysis: v=2.0 cv=Pb19d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=hQRVNFTGe2sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=uqqAYBjFkXbumLrn0cYA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326386087.7642.92.camel@gandalf.stny.rr.com>
Subject: Re: [lttng-dev] Perf ABI (was: Re: [PATCH 09/11] sched: export
 task_prio to GPL modules)
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: devel@driverdev.osuosl.org, "Ted Ts'o" <tytso@mit.edu>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 12 Jan 2012 11:34:47 -0500
In-Reply-To: <20120112162756.GA2540@Krystal>
References: <20111219153053.GA21548@Krystal>
	 <20111220110813.GA19105@elte.hu> <20111223164629.GA30474@Krystal>
	 <20111223172155.GA14117@thunk.org> <20111223181641.GA12681@Krystal>
	 <20111225174613.GA12732@thunk.org> <20120112140905.GA30377@Krystal>
	 <1326380042.7642.73.camel@gandalf.stny.rr.com>
	 <20120112153957.GA20514@Krystal>
	 <1326383629.7642.85.camel@gandalf.stny.rr.com>
	 <20120112162756.GA2540@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 11:27 -0500, Mathieu Desnoyers wrote:

> > What udev did is more like what you want to do than what I did with
> > trace-cmd.
> 
> OK. Then how can trace-cmd support the LTTng features ?

New syscalls, or new files, and simply check if they exist.

New features should not break old ones.

-- Steve


