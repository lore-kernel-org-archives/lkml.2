Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2KBPDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 11:03:06 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:60816 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755308Ab2KBPDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 11:03:03 -0400
Date: Fri, 2 Nov 2012 15:03:01 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz
 CPUs
In-Reply-To: <1351867045.4004.141.camel@gandalf.local.home>
Message-ID: <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
References: <20121029202711.062749374@goodmis.org> <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com> <1351867045.4004.141.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Steven Rostedt wrote:

> > also it would be best to sync this conceptually with the processors
> > enabled for rcu processing.
>
> Processors can be disabled for rcu processing? Or are you talking about
> Paul's new work of offloading rcu callbacks?

Yes. Paul's new work to remove rcu processing from processors. That needs
to be synced configuration wise somehow. It does not make sense to process
rcu callbacks on processors where the timer tick does not work anymore.

