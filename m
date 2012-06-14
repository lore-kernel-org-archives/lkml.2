Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab2FNUOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 16:14:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:60825 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab2FNUOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:14:01 -0400
Date: Thu, 14 Jun 2012 22:13:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Silas Boyd-Wickizer <sbw@mit.edu>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
In-Reply-To: <20120614200125.GA26852@mit.edu>
Message-ID: <alpine.LFD.2.02.1206142213070.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.132283147@linutronix.de> <20120614200125.GA26852@mit.edu>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Thu, 14 Jun 2012, Silas Boyd-Wickizer wrote:

> Hello,
> 
> I've taken a stab at converting stop_machine to use kthread_park and
> kthread_unpark.  I don't think stop_machine can use
> smpboot_park_threads (in their current implementation) because, among
> other reasons, _cpu_down calls __stop_machine after parking the
> stopper threads via smpboot_park_threads.

Yes, I know. That's why I haven't touched it yet. That needs some
further modifications down the road.

Thanks,

	tglx
