Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0F1Q5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:57:01 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35830 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab0F1Q46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:56:58 -0400
Date: Mon, 28 Jun 2010 09:56:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: simplify the usage of percpu data
Message-ID: <20100628165654.GA2357@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4C285C60.90801@cn.fujitsu.com>
 <4C285F8F.3040707@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C285F8F.3040707@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 10:38:39AM +0200, Tejun Heo wrote:
> On 06/28/2010 10:25 AM, Lai Jiangshan wrote:
> > &percpu_data is compatible with allocated percpu data.
> > 
> > And we use it and remove the "rda[NR_CPUS]" array.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Looks good to me.
> 
> Reviewed-by: Tejun Heo <tj@kernel.org>

Thank you both!!!  I have queued this.

							Thanx, Paul
