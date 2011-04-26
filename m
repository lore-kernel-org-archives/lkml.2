Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1DZLbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:31:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49260 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349Ab1DZLbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:31:17 -0400
Date: Tue, 26 Apr 2011 04:31:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
Message-ID: <20110426113113.GH4308@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110422150222.GA2300@linux.vnet.ibm.com>
 <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
 <20110423210539.GI2628@linux.vnet.ibm.com>
 <BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
 <BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
 <BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
 <20110424062728.GM2628@linux.vnet.ibm.com>
 <BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
 <20110424164331.GN2628@linux.vnet.ibm.com>
 <1303812417.20212.239.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303812417.20212.239.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 12:06:57PM +0200, Peter Zijlstra wrote:
> On Sun, 2011-04-24 at 09:43 -0700, Paul E. McKenney wrote:
> > 
> > Peter, any thoughts on what I might have done wrong to get the scheduler
> > into a state where it was ignoring a runnable realtime task? 
> 
> Not really, the only thing I can think of is something like poking at
> task->state while its sleeping. One you set it to TASK_RUNNING wakeups
> will be ignored since its already running ;-)

Well, that does give my something to check for -- thank you!

							Thanx, Paul
