Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab0DUIF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:05:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143Ab0DUIF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:05:56 -0400
Date: Wed, 21 Apr 2010 10:05:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "David S . Miller" <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [GIT PULL] tracing update
Message-ID: <20100421080544.GA13107@elte.hu>
References: <1271706114-8489-1-git-send-regression-fweisbec@gmail.com>
 <20100421074917.GB17237@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421074917.GB17237@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Frederic Weisbecker (1):
> >       tracing: Dump either the oops's cpu source or all cpus buffers

FYI, it has build failures on x86:

 kernel/trace/trace.c:4412: error: conflicting types for '__ftrace_dump'
 kernel/trace/trace_selftest.c:258: note: previous declaration of '__ftrace_dump' was here

	Ingo
