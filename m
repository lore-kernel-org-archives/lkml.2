Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1JXMfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 08:35:40 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51935 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab1JXMfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 08:35:39 -0400
Date: Mon, 24 Oct 2011 05:34:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 54/55] rcu: Make srcu_read_lock_held()
 call common lockdep-enabled function
Message-ID: <20111024123457.GF2273@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110906180015.GA2560@linux.vnet.ibm.com>
 <1315332049-2604-54-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111017020309.GI19421@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017020309.GI19421@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11102412-5112-0000-0000-00000139C00F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 07:03:10PM -0700, Josh Triplett wrote:
> On Tue, Sep 06, 2011 at 11:00:48AM -0700, Paul E. McKenney wrote:
> > A common debug_lockdep_rcu_enabled() function is used to check whether
> > RCU lockdep splats should be reported, but srcu_read_lock() does not
> > use it.  This commit therefore brings srcu_read_lock_held() up to date.
> 
> Should this patch go before 53, or merge into 53, to prevent the issues
> you describe from occuring in a tree which has 53 applied but not 54?

It is OK as is because the SRCU code does something reasonably sane
as is.  This is more about code cleanliness than about functionality.

							Thanx, Paul

