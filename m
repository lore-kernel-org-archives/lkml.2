Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab2IFUbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:31:33 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:33556 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770Ab2IFUb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:31:28 -0400
Date: Thu, 6 Sep 2012 13:30:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 06/23] rcu: Break up rcu_gp_kthread() into
 subfunctions
Message-ID: <20120906203056.GT2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346938791.18408.7.camel@twins>
 <20120906173207.GK2448@linux.vnet.ibm.com>
 <20120906184921.GA5738@jtriplet-mobl1>
 <1346958541.18408.67.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346958541.18408.67.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090620-7408-0000-0000-00000843C8D6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 09:09:01PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-06 at 11:49 -0700, Josh Triplett wrote:
> > 
> > Huh, I thought GCC knew to not emit that warning unless it actually
> > found control flow reaching the end of the function; since the
> > infinite
> > loop has no break in it, you shouldn't need the return.  Annoying. 
> 
> tag the function with __noreturn

Ah, I will try that.

							Thanx, Paul

