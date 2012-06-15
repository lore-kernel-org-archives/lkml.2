Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab2FOUT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 16:19:28 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34949 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2FOUT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 16:19:27 -0400
X-Originating-IP: 217.70.178.132
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 13:19:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 1/6] rcu: Update documentation to cover
 call_srcu() and srcu_barrier().
Message-ID: <20120615201911.GA31184@leaf>
References: <20120615185725.GA25163@linux.vnet.ibm.com>
 <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339786674-25265-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:57:49AM -0700, Paul E. McKenney wrote:
> --- a/Documentation/RCU/rcubarrier.txt
> +++ b/Documentation/RCU/rcubarrier.txt
> @@ -261,8 +261,10 @@ Answers to Quick Quizzes
>  
>  Quick Quiz #1: Why is there no srcu_barrier()?
>  
> -Answer: Since there is no call_srcu(), there can be no outstanding SRCU
> -	callbacks. Therefore, there is no need to wait for them.
> +Answer: There really is an srcu_barrier() now that there is a call_srcu().
> +	Before call_srcu(), there were no SRCU callbacks, and there was
> +	therefore no need to wait for them, and therefore there was
> +	no srcu_barrier().

I don't think it makes sense to leave this question in its current form
and just change the answer.  It seems like a trick question now. :)

I'd suggest just dropping the question and renumbering the remaining
questions.

- Josh Triplett
