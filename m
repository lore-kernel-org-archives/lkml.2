Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab2FKQze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:55:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:32874 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2FKQzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:55:33 -0400
Date: Mon, 11 Jun 2012 09:54:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <mgalbraith@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: endless stalls
Message-ID: <20120611165413.GC2521@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1339409176.7350.26.camel@marge.simpson.net>
 <20120611133953.GI2425@linux.vnet.ibm.com>
 <1339424543.7350.101.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339424543.7350.101.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061116-7282-0000-0000-000009D02F77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 04:22:23PM +0200, Mike Galbraith wrote:
> On Mon, 2012-06-11 at 06:39 -0700, Paul E. McKenney wrote: 
> > On Mon, Jun 11, 2012 at 12:06:16PM +0200, Mike Galbraith wrote:
> > > Greetings,
> > > 
> > > I received a report of a 48 core UV box hitting a gripe, taking longer
> > > than timeout to emit same, so box griped endlessly, forcing reboot.
> > 
> > So it took minutes to print an RCU CPU stall warning?  On only 48 CPUs?
> > 
> > If so, yow!!!
> 
> The report was a tad fuzzy on details, but serial console can take a
> while at low baud rate, and the box was apparently perma-stalled.

Which clearly demands the question "why not increase the serial-console
baud rate"...  ;-)

							Thanx, Paul

> > My guess is that rcu_cpu_stall_suppress must be manipulated atomically
> > for this to work reliably, for example, using xchg().
> 
> Ah, thanks.
> 
> -Mike
> 

