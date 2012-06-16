Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2FPU5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:57:49 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57419 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab2FPU5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:57:47 -0400
Date: Sat, 16 Jun 2012 13:57:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, sshtylyov@mvista.com, david.daney@cavium.com,
        nikunj@linux.vnet.ibm.com, axboe@kernel.dk, mingo@kernel.org,
        tglx@linutronix.de, akpm@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 09/10] POWERPC: smp: remove call to
 ipi_call_lock()/ipi_call_unlock()
Message-ID: <20120616205738.GM2420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1338275765-3217-1-git-send-email-yong.zhang0@gmail.com>
 <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
 <20120616163219.GI2420@linux.vnet.ibm.com>
 <1339867858.15222.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339867858.15222.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061620-7408-0000-0000-000005EA1136
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:30:58PM +0200, Peter Zijlstra wrote:
> On Sat, 2012-06-16 at 09:32 -0700, Paul E. McKenney wrote:
> > However, there is an effort to get rid of stop_machine() from the
> > CPU-down path...  So something else will be needed. 
> 
> Elsewhere in this thread I mentioned we could do a synchronize_sched().
> I think that covers most of what stop-machine is doing these days.

Ah, apologies for the noise!

							Thanx, Paul

