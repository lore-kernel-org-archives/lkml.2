Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2BBF5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 00:57:03 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55850 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2BBF5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 00:57:00 -0500
X-Originating-IP: 217.70.178.148
X-Originating-IP: 50.43.15.19
Date: Wed, 1 Feb 2012 21:56:39 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 32/41] rcu: Update stall-warning
 documentation
Message-ID: <20120202055639.GS29058@leaf>
References: <20120201194131.GA10028@linux.vnet.ibm.com>
 <1328125319-5205-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1328125319-5205-32-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328125319-5205-32-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 11:41:50AM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> Add documentation of CONFIG_RCU_CPU_STALL_VERBOSE, CONFIG_RCU_CPU_STALL_INFO,
> and RCU_STALL_DELAY_DELTA.  Describe multiple stall-warning messages from
> a single stall, and the timing of the subsequent messages.  Add headings.

Don't some of these documentation changes go with earlier patches in
this series?

Also, this commit message doesn't say anything about the removal of
RCU_SECONDS_TILL_STALL_RECHECK:

> --- a/Documentation/RCU/stallwarn.txt
> +++ b/Documentation/RCU/stallwarn.txt
> @@ -14,12 +14,36 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
>  	issues an RCU CPU stall warning.  This time period is normally
>  	ten seconds.
>  
> -RCU_SECONDS_TILL_STALL_RECHECK
[...]
> -	This macro defines the period of time that RCU will wait after
> -	issuing a stall warning until it issues another stall warning
> -	for the same stall.  This time period is normally set to three
> -	times the check interval plus thirty seconds.

- Josh Triplett
