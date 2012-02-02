Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2BBRZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:25:22 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:48643 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2BBRZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:25:18 -0500
Date: Thu, 2 Feb 2012 09:05:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 06/41] rcu: Move RCU_TRACE to
 lib/Kconfig.debug
Message-ID: <20120202170516.GN2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120202013952.GI29058@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202013952.GI29058@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020217-5930-0000-0000-000004AFF639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:39:52PM -0800, Josh Triplett wrote:
> On Wed, Feb 01, 2012 at 11:41:24AM -0800, Paul E. McKenney wrote:
> > The RCU_TRACE kernel parameter has always been intended for debugging,
> > not for production use.  Formalize this by moving RCU_TRACE from
> > init/Kconfig to lib/Kconfig.debug.
> 
> Shouldn't it then depend on DEBUG_KERNEL?

Good point, done!

							Thanx, Paul

