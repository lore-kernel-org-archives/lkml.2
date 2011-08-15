Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab1HOQrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 12:47:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab1HOQrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 12:47:17 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=TArtW4UpbmkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=t9LGoBea0B202vEguWoA:9 a=iO-kVVIjUc28WJhN3qsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] lockdep/rcu: Find where rcu/pi/rq lock problems
 occur
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1313426593.15704.16.camel@gandalf.stny.rr.com>
References: <1313426593.15704.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 15 Aug 2011 12:47:15 -0400
Message-ID: <1313426835.15704.17.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-15 at 12:43 -0400, Steven Rostedt wrote:
> +
> +#else /* CONFIG_PREEMPT_RCU */
> +static inline void lockdep_rcu_irq(int on) { }

I need to also add:

static inline void test_lock_type(...) { } 

here too. Fixed, for the next release.

-- Steve

> +#endif
> + 

