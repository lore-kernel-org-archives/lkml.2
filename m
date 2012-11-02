Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab2KBPOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:14:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28422 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab2KBPOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:14:03 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wowpZ7sFJ74A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=Z-wZqcGM7j4A:10 a=XeUjys7n5LDM7mPAvd4A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1351869241.4004.142.camel@gandalf.local.home>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Date: Fri, 02 Nov 2012 11:14:01 -0400
In-Reply-To: <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
References: <20121029202711.062749374@goodmis.org>
	 <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
	 <1351867045.4004.141.camel@gandalf.local.home>
	 <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-02 at 15:03 +0000, Christoph Lameter wrote:
> On Fri, 2 Nov 2012, Steven Rostedt wrote:
> 
> > > also it would be best to sync this conceptually with the processors
> > > enabled for rcu processing.
> >
> > Processors can be disabled for rcu processing? Or are you talking about
> > Paul's new work of offloading rcu callbacks?
> 
> Yes. Paul's new work to remove rcu processing from processors. That needs
> to be synced configuration wise somehow. It does not make sense to process
> rcu callbacks on processors where the timer tick does not work anymore.

Don't worry, Paul is working with us too ;-)

-- Steve


