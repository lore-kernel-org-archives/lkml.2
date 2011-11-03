Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1KCDQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:16:36 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39509 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1KCDQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:16:35 -0400
X-Originating-IP: 217.70.178.133
X-Originating-IP: 50.43.15.19
Date: Wed, 2 Nov 2011 20:16:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 11/28] rcu: Omit self-awaken when
 setting up expedited grace period
Message-ID: <20111103031612.GC2042@leaf>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <1320265849-5744-11-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320265849-5744-11-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 01:30:32PM -0700, Paul E. McKenney wrote:
> -static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
> +static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp,
> +			       bool wake)
>  {
> -	return;
>  }

Removing this return represents a separate cleanup, which ought to go in
a separate commit.

- Josh Triplett
