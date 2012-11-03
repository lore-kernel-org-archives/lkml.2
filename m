Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2KCCIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 22:08:54 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55904 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2KCCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 22:08:53 -0400
Date: Fri, 2 Nov 2012 19:08:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 00/32] [RFC] nohz/cpuset: Start discussions on nohz CPUs
Message-ID: <20121103020845.GF3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121029202711.062749374@goodmis.org>
 <0000013ac180f152-79f05c71-4d38-43b0-9b62-8a71c00dfda7-000000@email.amazonses.com>
 <1351867045.4004.141.camel@gandalf.local.home>
 <0000013ac1a58555-bea33420-d101-4e86-abc5-11dd6863b7a8-000000@email.amazonses.com>
 <20121102183544.GZ3027@linux.vnet.ibm.com>
 <0000013ac2c4f47a-d21f2685-6660-4d02-872d-581d203285a0-000000@email.amazonses.com>
 <20121102204157.GE3027@linux.vnet.ibm.com>
 <1351889510.4004.149.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351889510.4004.149.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110302-7606-0000-0000-0000051382A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 04:51:50PM -0400, Steven Rostedt wrote:
> On Fri, 2012-11-02 at 13:41 -0700, Paul E. McKenney wrote:
> 
> > The no-CBs mask would be read-only for some time -- changed only at
> > boot.  Longer term, I hope to allow run-time modification, but...
> 
> but what? You're not looking to retire already are you? ;-)

Not for a few decades.  ;-)

But let's add the no-CBs mask to sysfs when I add the ability to run-time
modify that mast.

							Thanx, Paul

