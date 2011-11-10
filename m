Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202Ab1KJQfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:35:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:51467 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935222Ab1KJQfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:35:45 -0500
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 10 Nov 2011 17:35:24 +0100
In-Reply-To: <20111031221416.GQ6160@linux.vnet.ibm.com>
References: <20111031082634.GA10348@localhost>
	 <20111031095152.GL6160@linux.vnet.ibm.com>
	 <20111031104325.GA25808@localhost> <20111031114142.GA32555@localhost>
	 <20111031123125.GA6162@localhost> <20111031123708.GA6839@localhost>
	 <20111031221416.GQ6160@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320942925.13800.28.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 15:14 -0700, Paul E. McKenney wrote:
> Peter, I have been using "idle_cpu(smp_processor_id()))" to verify that
> I really am running in the context of the idle task when RCU believes
> that the current CPU has gone idle. 

I think this is sorted since, but just to clarify idle_cpu() was meant
to test if the cpu was idle, this is something different from actually
running the idle thread.


