Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059Ab1KCTnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 15:43:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51204 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab1KCTnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 15:43:49 -0400
Date: Thu, 3 Nov 2011 12:43:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 11/28] rcu: Omit self-awaken when
 setting up expedited grace period
Message-ID: <20111103194338.GH2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111103031612.GC2042@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103031612.GC2042@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110319-6078-0000-0000-000003F525B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 08:16:13PM -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:32PM -0700, Paul E. McKenney wrote:
> > -static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
> > +static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
> > +			       bool wake)
> >  {
> > -	return;
> >  }
> 
> Removing this return represents a separate cleanup, which ought to go in
> a separate commit.

I split this out.

							Thanx, Paul

