Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132Ab3ACAtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 19:49:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16392 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3ACAtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 19:49:24 -0500
X-Authority-Analysis: v=2.0 cv=YruNtvkX c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=PmS3AnHzXUwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=1-tHwzTh79YA:10 a=7yy1jtqfD6nYzWQQvfEA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1357174163.10284.8.camel@gandalf.local.home>
Subject: Re: INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Date: Wed, 02 Jan 2013 19:49:23 -0500
In-Reply-To: <20130102212948.GA25701@linux.vnet.ibm.com>
References: <20130102190920.GD29452@charite.de>
	 <20130102205630.GA5594@home.goodmis.org>
	 <20130102212948.GA25701@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-02 at 13:29 -0800, Paul E. McKenney wrote:
> On Wed, Jan 02, 2013 at 03:56:30PM -0500, Steven Rostedt wrote:
> > On Wed, Jan 02, 2013 at 08:09:20PM +0100, Ralf Hildebrandt wrote:
> > > This happened of a virtual guest (Linux mail 3.2.0-35-virtual #55-Ubuntu SMP Wed Dec 5 18:02:05 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux)
> > 
> > 3.2 is rather old and this looks to be a stock Ubuntu kernel. May want
> > to file a Bugzilla (or whatever they call it) with them.
> > 
> > > 
> > > Jan  2 13:24:08 mail kernel: [3531872.484283] INFO: rcu_bh detected stall on CPU 3 (t=0 jiffies)
> > 
> > 0 jiffies?
> 
> One possibility is that they are missing commit a10d206e (rcu: Fix
> day-one dyntick-idle stall-warning bug), at least assuming that
> CONFIG_PREEMPT=n.  This went into 3.6, IIRC.

If that does fix the issue, we probably should send that off to Ben for
inclusion into 3.2 stable.

Thanks,

-- Steve

> 
> 							Thanx, Paul
> 



