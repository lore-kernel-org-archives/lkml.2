Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab0FVVLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:11:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57779 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0FVVLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:11:38 -0400
Date: Tue, 22 Jun 2010 14:11:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Miles Lane <miles.lane@gmail.com>
Subject: Re: [Bug #15863] 2.6.34-rc5-git7 (plus all patches) -- another
 suspicious rcu_dereference_check() usage.
Message-ID: <20100622211135.GO2290@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera>
 <rHrHQMIU4rI.A.E9B.QcpHMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rHrHQMIU4rI.A.E9B.QcpHMB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 12:34:25AM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).

We have been knocking these off as they appear.  There is one or two
that the relevant maintainers have been ignoring, but that always seems
to be the case.  ;-)

Your choice as to whether you want to track the group...

							Thanx, Paul

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15863
> Subject		: 2.6.34-rc5-git7 (plus all patches) -- another suspicious rcu_dereference_check() usage.
> Submitter	: Miles Lane <miles.lane@gmail.com>
> Date		: 2010-04-27 0:51 (55 days old)
> Message-ID	: <h2ya44ae5cd1004261751waa5cb65ei3d139cbcfa2cc5cf@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127232949104878&w=2
> Handled-By	: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Patch		: https://patchwork.kernel.org/patch/96096/
> 
> 
