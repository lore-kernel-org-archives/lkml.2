Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab2KMV2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:28:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:58350 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2KMV2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:28:23 -0500
Date: Tue, 13 Nov 2012 13:20:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tim Sander <tim01@vlsi.informatik.tu-darmstadt.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: Does anyone use CONFIG_TINY_PREEMPT_RCU?
Message-ID: <20121113212034.GD2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121113004906.GA10557@linux.vnet.ibm.com>
 <201211132122.30259.tim01@vlsi.informatik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211132122.30259.tim01@vlsi.informatik.tu-darmstadt.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111321-3620-0000-0000-00000058C26E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 09:22:29PM +0100, Tim Sander wrote:
> Hi Paul
> > I know of people using TINY_RCU, TREE_RCU, and TREE_PREEMPT_RCU, but I
> > have not heard of anyone using TINY_PREEMPT_RCU for whom TREE_PREEMPT_RCU
> > was not a viable option (in contrast, the people running Linux on
> > tiny-memmory systems typically use TINY_RCU).  Of course, if no one
> > really needs it, the proper thing to do is to remove it.
> > 
> > So, if you need TINY_PREEMPT_RCU, please let me know.  Otherwise, I will
> > remove it, probably in the 3.9 timeframe.
> I am using TINY_PREEMPT_RCU on the i.mx35 platform. I am currently on 3.4-rt 
> since the 3.6 compile failed due to for my config? Some strange device tree 
> stuff which i haven't had the time to figure out why.

OK, how much memory does your device have?

							Thanx, Paul

