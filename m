Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1CRTjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:39:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60155
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932334Ab1CRTfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:35:04 -0400
Date: Fri, 18 Mar 2011 12:35:41 -0700 (PDT)
Message-Id: <20110318.123541.189691785.davem@davemloft.net>
To: laijs@cn.fujitsu.com
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, axboe@kernel.dk,
        robert.w.love@intel.com, James.Bottomley@suse.de,
        nhorman@tuxdriver.com, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        eric.dumazet@gmail.com, shemminger@vyatta.com, tj@kernel.org,
        jarkao2@gmail.com, linux-kernel@vger.kernel.org, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 04/36] net,rcu: convert call_rcu(__leaf_info_free_rcu)
 to kfree_rcu()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D82D4AA.2080601@cn.fujitsu.com>
References: <4D82D071.5020703@cn.fujitsu.com>
	<4D82D3FF.2080303@cn.fujitsu.com>
	<4D82D4AA.2080601@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 11:42:34 +0800

> 
> 
> The rcu callback __leaf_info_free_rcu() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(__leaf_info_free_rcu).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
