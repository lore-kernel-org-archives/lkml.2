Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab2KBURB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:17:01 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:28429 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab2KBURA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:17:00 -0400
Date: Fri, 2 Nov 2012 20:16:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz
 CPUs
In-Reply-To: <20121102183544.GZ3027@linux.vnet.ibm.com>
Message-ID: <0000013ac2c4f47a-d21f2685-6660-4d02-872d-581d203285a0-000000@email.amazonses.com>
References: <20121029202711.062749374@goodmis.org> <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com> <1351867045.4004.141.camel@gandalf.local.home> <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
 <20121102183544.GZ3027@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Paul E. McKenney wrote:

> So I believe that these need to be controlled separately for the immediate
> future.

Yes they do but the configurations are similar and it would be best if
these were cpumasks in standard locations instead of being specified at
boot time or in a cpuset.

Put the cpu masks into

/sys/devices/system/cpu/{nohz_cpus,rcu_cpus}

or so?
