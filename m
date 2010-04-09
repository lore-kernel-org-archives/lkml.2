Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0DIQ7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:59:17 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60356 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617Ab0DIQ7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:59:15 -0400
Date: Fri, 9 Apr 2010 09:59:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent 4/4] rcu: fix syntax error in
 rcu_dereference_check() example in comment
Message-ID: <20100409165911.GC2421@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1270792042-9358-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20100409054701.GA8833@linux.vnet.ibm.com>
 <23696.1270804637@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23696.1270804637@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 10:17:17AM +0100, David Howells wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Need a logical "or" rather than a comma.
> > 
> > Suggested-by: Yong Zhang <yong.zhang@windriver.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I'm surprised you didn't just roll this in to patch 2.

I will do so when I resubmit.  I am finally growing more comfortable
with "git rebase -i", but still some ways to go.  It has been a long
journey from the old punched-card cabinets of my youth.  ;-)

							Thanx, Paul

> Acked-by: David Howells <dhowells@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
