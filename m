Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0FVWZv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:25:51 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47475 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab0FVWZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:25:49 -0400
Date: Tue, 22 Jun 2010 15:25:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Miles Lane <miles.lane@gmail.com>
Subject: Re: [Bug #15863] 2.6.34-rc5-git7 (plus all patches) -- another
 suspicious rcu_dereference_check() usage.
Message-ID: <20100622222547.GQ2290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
 <rHrHQMIU4rI.A.E9B.QcpHMB@chimera>
 <20100622211135.GO2290@linux.vnet.ibm.com>
 <201006222349.13096.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006222349.13096.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 11:49:12PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, June 22, 2010, Paul E. McKenney wrote:
> > On Mon, Jun 21, 2010 at 12:34:25AM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.33 and 2.6.34.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> > > be listed and let the tracking team know (either way).
> > 
> > We have been knocking these off as they appear.  There is one or two
> > that the relevant maintainers have been ignoring, but that always seems
> > to be the case.  ;-)
> > 
> > Your choice as to whether you want to track the group...
> 
> I think I'll simply leave that one bug open until all known instances have been
> dealt with.
> 
> Please let me know when that happens. :-)

So if I am sufficiently forgetful, I can just ask you to close the
bug immediately?

Sorry, but you really couldn't expect me to pass up that kind of
loophole!  ;-)

							Thanx, Paul
