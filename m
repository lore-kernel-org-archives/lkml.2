Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab1CRHAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:00:03 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46257 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193Ab1CRG74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 02:59:56 -0400
Message-ID: <4D8302E9.30303@kernel.dk>
Date: Fri, 18 Mar 2011 07:59:53 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>, Tejun Heo <tj@kernel.org>,
        Jarek Poplawski <jarkao2@gmail.com>, linux-kernel@vger.kernel.org,
        devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 05/36] block,rcu: convert call_rcu(disk_free_ptbl_rcu_cb)
  to kfree_rcu()
References: <4D82D071.5020703@cn.fujitsu.com> <4D82D3FF.2080303@cn.fujitsu.com> <4D82D4C2.8020503@cn.fujitsu.com>
In-Reply-To: <4D82D4C2.8020503@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-18 04:42, Lai Jiangshan wrote:
> 
> 
> The rcu callback disk_free_ptbl_rcu_cb() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(disk_free_ptbl_rcu_cb).

Thanks, I'll add this.

-- 
Jens Axboe

