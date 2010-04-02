Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0DBPZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 11:25:20 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37377 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab0DBPZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 11:25:15 -0400
Date: Fri, 2 Apr 2010 08:25:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in
 rcu_check_callbacks()
Message-ID: <20100402152507.GA2549@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB014DF.9030905@cn.fujitsu.com>
 <20100329044236.GB2343@linux.vnet.ibm.com>
 <4BB1C7C5.5070700@cn.fujitsu.com>
 <20100330160339.GB2513@linux.vnet.ibm.com>
 <20100331153656.GA4623@linux.vnet.ibm.com>
 <4BB3EF25.1040804@cn.fujitsu.com>
 <20100401011747.GJ2461@linux.vnet.ibm.com>
 <4BB44A15.60306@cn.fujitsu.com>
 <20100402005317.GI2472@linux.vnet.ibm.com>
 <4BB5E2A3.3080105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB5E2A3.3080105@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 08:27:15PM +0800, Lai Jiangshan wrote:
> Paul E. McKenney wrote:
> > On Thu, Apr 01, 2010 at 03:24:05PM +0800, Lai Jiangshan wrote:
> >> Paul E. McKenney wrote:
> >>> Possibly by moving the clearing of RCU_READ_UNLOCK_NEED_QS to
> >>> rcu_preempt_check_callbacks() 
> >> current rcu_preempt_check_callbacks() already has code to
> >> clear RCU_READ_UNLOCK_NEED_QS.
> > 
> > English is failing me. 
> > How about the following patch instead?  Untested,
> > probably does not even compile.
> 
> Very nice, thank you.
> 
> Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thank you!  It passed overnight testing, so I have queued this for 2.6.35
with your Acked-by.

							Thanx, Paul
