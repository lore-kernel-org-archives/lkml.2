Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2KBUmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:42:07 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48486 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2KBUmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:42:04 -0400
Date: Fri, 2 Nov 2012 13:41:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
Message-ID: <20121102204157.GE3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121029202711.062749374@goodmis.org>
 <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
 <1351867045.4004.141.camel@gandalf.local.home>
 <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
 <20121102183544.GZ3027@linux.vnet.ibm.com>
 <0000013ac2c4f47a-d21f2685-6660-4d02-872d-581d203285a0-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013ac2c4f47a-d21f2685-6660-4d02-872d-581d203285a0-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110220-7606-0000-0000-00000512396D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 08:16:58PM +0000, Christoph Lameter wrote:
> On Fri, 2 Nov 2012, Paul E. McKenney wrote:
> 
> > So I believe that these need to be controlled separately for the immediate
> > future.
> 
> Yes they do but the configurations are similar and it would be best if
> these were cpumasks in standard locations instead of being specified at
> boot time or in a cpuset.
> 
> Put the cpu masks into
> 
> /sys/devices/system/cpu/{nohz_cpus,rcu_cpus}
> 
> or so?

The no-CBs mask would be read-only for some time -- changed only at
boot.  Longer term, I hope to allow run-time modification, but...

							Thanx, Paul

