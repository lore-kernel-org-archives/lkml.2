Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab0C2BDr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:03:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57784 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755512Ab0C2BDq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:03:46 -0400
Message-ID: <4BAFFC78.5040909@cn.fujitsu.com>
Date: Mon, 29 Mar 2010 09:03:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: move some code from macro to function
References: <4BAEC91E.8000001@cn.fujitsu.com> <20100328041554.GQ2343@linux.vnet.ibm.com>
In-Reply-To: <20100328041554.GQ2343@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Sun, Mar 28, 2010 at 11:12:30AM +0800, Lai Jiangshan wrote:
>> cleanup: move some code from macro to function
> 
> Nice!
> 
> I have queued this for RCU 2.6.35, with the following commit message:
> 
> 	Shrink the RCU_INIT_FLAVOR() macro by moving all but the
> 	initialization of the ->rda[] array to rcu_init_one().
> 	The call to rcu_init_one() can then be moved to the end
> 	of the RCU_INIT_FLAVOR() macro, which is required because
> 	rcu_boot_init_percpu_data(), which is now called from
> 	rcu_init_one(), depends on the initialization of the ->rda[]
> 	array.
> 
> Seem reasonable?
> 
> 							Thanx, Paul
> 

OK
Thanks, Lai
