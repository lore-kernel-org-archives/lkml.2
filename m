Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1FCNpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 09:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1FCNpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 09:45:18 -0400
Date: Fri, 3 Jun 2011 09:45:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
Message-ID: <20110603134514.GA31057@redhat.com>
References: <20110519222404.GG12600@redhat.com>
 <20110521210013.GJ2271@linux.vnet.ibm.com>
 <20110523152141.GB4019@redhat.com>
 <20110523153848.GC2310@linux.vnet.ibm.com>
 <1306401337.27271.3.camel@t41.thuisdomein>
 <20110603050724.GB2304@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603050724.GB2304@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 10:07:24PM -0700, Paul E. McKenney wrote:

[..]
> > Thu May 26 10:47:20 CEST 2011
> > /sys/kernel/debug/rcu/rcugp:
> > rcu_sched: completed=682249  gpnum=682250
> 
> 15 more seconds, a few thousand more grace periods.  About 500 grace
> periods per second, which is quite reasonable on a single-CPU system.

PaulB mentioned that crash happened at May 26 10:47:07. I am wondering
how are we able to sample the data after the crash. I am assuming
that above data gives information only before crash and does not
tell us anything about what happened just before crash. What am I missing.

PaulM, in one of the mails you had mentioned that one could print
context switch id to make sure we did not block in rcu section. Would
you have quick pointer where is context switch id stored. May be
I can write a small patch for PaulB.

Thanks
Vivek
