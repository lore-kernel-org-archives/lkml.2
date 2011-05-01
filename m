Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760877Ab1EAQFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 12:05:47 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35242 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1EAQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 12:05:46 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.15.19
Date: Sun, 1 May 2011 09:05:29 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 26/86] rcu: remove useless ->boosted_this_gp
 field
Message-ID: <20110501160529.GI14829@feather>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
 <1304256126-26015-26-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304256126-26015-26-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 06:21:06AM -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> The ->boosted_this_gp field is a holdover from an earlier design that
> was to carry out multiple boost operations in parallel.  It is not required
> by the current design, which boosts one task at a time.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Can you squash this patch into the commit that introduces
boosted_this_gp in the first place?

- Josh Triplett
