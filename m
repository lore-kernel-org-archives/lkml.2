Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab0DTPFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:05:34 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48733 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0DTPFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:05:32 -0400
Date: Tue, 20 Apr 2010 08:05:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC tip/core/rcu 07/16] rcu: shrink rcutiny by making
 synchronize_rcu_bh() be inline
Message-ID: <20100420150522.GD2628@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1271355219-20714-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100415181255.GA19588@linux.vnet.ibm.com>
 <31621.1271758266@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31621.1271758266@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 11:11:06AM +0100, David Howells wrote:
> 
> Does it make sense for synchronize_sched() to be inline too?  Since that's
> just a wrapper around cond_resched(), which is normally just a wrapper around
> _cond_resched().

I tried that, and quickly descended into #include hell.  :-(

							Thanx, Paul

> Otherwise:
> 
> Acked-by: David Howells <dhowells@redhat.com>
