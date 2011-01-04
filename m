Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456Ab1ADVTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 16:19:42 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:32776 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1ADVTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 16:19:41 -0500
Date: Tue, 4 Jan 2011 13:19:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: remove SPARSE_RCU_POINTER
Message-ID: <20110104211938.GT2026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D22DD95.7050308@cn.fujitsu.com>
 <201101041136.02514.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101041136.02514.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 11:36:02AM +0100, Arnd Bergmann wrote:
> On Tuesday 04 January 2011 09:43:01 Lai Jiangshan wrote:
> > As I known, __rcu annotations do not effect the result compiled kernel.
> > 
> > They work only when we use spare("make C=1" or "make C=2"),
> > So we don't need another new switch for it since we have one
> > for debugging(use spare or not).
> > 
> > signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> The intention of this option was to avoid introducing an excessive
> number of false positives when using sparse.
> 
> We should only make that unconditional if we are reasonably convinced
> that all the majority of warnings caused by it should actually
> lead to changes in the code.

I agree with Arnd here -- the changes required are extensive in many
cases, and a number of subsystems are making decent progress.

							Thanx, Paul
