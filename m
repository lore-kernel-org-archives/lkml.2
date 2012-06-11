Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2FKSJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:09:41 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:63164 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2FKSJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:09:39 -0400
Date: Mon, 11 Jun 2012 20:09:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/5] nohz: Separate idle sleeping time accounting from
 nohz logic
Message-ID: <20120611180928.GC26617@somewhere.redhat.com>
References: <1339433602-26836-1-git-send-email-fweisbec@gmail.com>
 <1339433602-26836-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339433602-26836-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 06:53:18PM +0200, Frederic Weisbecker wrote:
> +}
> +
> +/**
> + * tick_nohz_idle_exit - restart the idle tick from the idle task
> + *
> + * Restart the idle tick when the CPU is woken up from idle
> + * This also exit the RCU extended quiescent state. The CPU
> + * can use RCU again after this function is called.
> + */
> +void tick_nohz_idle_exit(void)
> +
> +{

Thomas pointed me to the above undesired newline. I fixed that
in the branch nohz-for-tip-2

Thanks.
