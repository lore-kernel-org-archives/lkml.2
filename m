Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab1AMUoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:44:23 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:60279 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757281Ab1AMUoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:44:12 -0500
Date: Thu, 13 Jan 2011 12:44:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 2/2] rcu: avoid pointless blocked-task
 warnings
Message-ID: <20110113204405.GL2500@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110113190414.GA10457@linux.vnet.ibm.com>
 <1294945477-10612-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <alpine.LFD.2.00.1101132029130.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101132029130.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 08:29:49PM +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Paul E. McKenney wrote:
> > Reported-by: Russell King <rmk@arm.linux.org.uk>
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> So finally someone managed to clone you ?

Thankfully, they only managed to multiplex me.  ;-)

							Thanx, Paul
