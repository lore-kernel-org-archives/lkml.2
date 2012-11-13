Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab2KMOqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:46:24 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:4134 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab2KMOqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:46:22 -0500
Date: Tue, 13 Nov 2012 09:46:20 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121113144620.GA27426@elliptictech.com>
References: <20121113004906.GA10557@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113004906.GA10557@linux.vnet.ibm.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-12 16:49 -0800, Paul E. McKenney wrote:
> Hello!
> 
> I know of people using TINY_RCU, TREE_RCU, and TREE_PREEMPT_RCU, but I
> have not heard of anyone using TINY_PREEMPT_RCU for whom TREE_PREEMPT_RCU
> was not a viable option (in contrast, the people running Linux on
> tiny-memmory systems typically use TINY_RCU).  Of course, if no one
> really needs it, the proper thing to do is to remove it.
> 
> So, if you need TINY_PREEMPT_RCU, please let me know.  Otherwise, I will
> remove it, probably in the 3.9 timeframe.

Yes, I use TINY_PREEMPT_RCU on my UP machines.  It is, in fact, the only
option.

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
