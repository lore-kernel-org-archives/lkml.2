Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2JNWvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 18:51:52 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50376 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab2JNWvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 18:51:51 -0400
Date: Sun, 14 Oct 2012 15:51:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RCU NOHZ, tsc, and clock_gettime
Message-ID: <20121014225135.GA3288@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5077157A.7060401@redhat.com>
 <50772350.1070903@us.ibm.com>
 <20121011202103.GB2476@linux.vnet.ibm.com>
 <507860F5.7090908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507860F5.7090908@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101422-7282-0000-0000-00000DED45CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 02:27:01PM -0400, Prarit Bhargava wrote:
> 
> > The effect of removing the two functions you noted (on 3.6 and earlier)
> > is to prevent RCU from checking for dyntick-idle CPUs, likely incurring
> > a cache miss for each CPU with interrupts disabled.  If you have a lot
> > of CPUs (or even if NR_CPUS is large and you have a smaller number of
> > CPUs), this can result in user-space-visible delays.
> > 
> 
> Paul,
> 
> I built a kernel with NR_CPUS=48 and booted on a 48 cpu (logical) system.  I do
> not see a difference in the test -- the variance is AFAICT just as large as if I
> had run with NR_CPUS=4096.

OK -- have you applied John Stultz's suggestions?

							Thanx, Paul

