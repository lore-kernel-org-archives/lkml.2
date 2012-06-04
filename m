Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801Ab2FDSO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 14:14:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33313 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab2FDSOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 14:14:55 -0400
Date: Mon, 4 Jun 2012 11:13:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: fweisbec@gmail.com
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] rcu: Extended quiescent state for adaptive nohz
Message-ID: <20120604181313.GL2490@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338811708-18819-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060418-2398-0000-0000-000007323FAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 02:08:26PM +0200, fweisbec@gmail.com wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Paul, Ingo,
> 
> This is a rebase of the nohz cpusets RCU APIs on top of Paul's latest
> -rcu (rcu/core) branch.
> 
> I have only built tested it yet, I need to do a full rebase of my
> tree to test it in practice. But I wanted to show you how it looks
> like first.
> 
> I also wonder if we can set that to a tree somewhere. Ingo suggested
> to set up a tree on -tip to apply the uncontroversial part of nohz
> cpusets patches and iterate from there. I think it would accelerate
> everything if we start doing that.

It would probably be best to put these two in the -rcu set in order to
avoid conflicts with possible further RCU_FAST_NO_HZ work.  I could
push this to -tip early, if that would help.

							Thanx, Paul

> Tell me what you think.
> 
> Thanks.
> 
> Frederic Weisbecker (2):
>   rcu: New rcu_user_enter() and rcu_user_exit() APIs
>   rcu: New rcu_user_enter_irq() and rcu_user_exit_irq() APIs
> 
>  include/linux/rcupdate.h |    4 +
>  kernel/rcutree.c         |  184 +++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 163 insertions(+), 25 deletions(-)
> 
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

