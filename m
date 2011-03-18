Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab1CRTgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:36:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60314
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab1CRTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:36:13 -0400
Date: Fri, 18 Mar 2011 12:36:51 -0700 (PDT)
Message-Id: <20110318.123651.245394297.davem@davemloft.net>
To: laijs@cn.fujitsu.com
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, paul.moore@hp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/36] net,rcu: convert
 call_rcu(netlbl_unlhsh_free_addr4) to kfree_rcu()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D82D9AC.30205@cn.fujitsu.com>
References: <4D82D9AC.30205@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:03:56 +0800

> 
> 
> The rcu callback netlbl_unlhsh_free_addr4() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(netlbl_unlhsh_free_addr4).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
