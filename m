Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab1CRUGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 16:06:25 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:22180 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab1CRUGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 16:06:19 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 20/36] net,rcu: convert call_rcu(netlbl_unlhsh_free_addr4) to kfree_rcu()
Date: Fri, 18 Mar 2011 16:05:48 -0400
User-Agent: KMail/1.13.6 (Linux/2.6.35-gentoo-r15; KDE/4.6.1; x86_64; ; )
Cc: laijs@cn.fujitsu.com, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4D82D9AC.30205@cn.fujitsu.com> <20110318.123651.245394297.davem@davemloft.net>
In-Reply-To: <20110318.123651.245394297.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181605.48331.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 18, 2011 3:36:51 PM David Miller wrote:
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> Date: Fri, 18 Mar 2011 12:03:56 +0800
> 
> > The rcu callback netlbl_unlhsh_free_addr4() just calls a kfree(),
> > so we use kfree_rcu() instead of the call_rcu(netlbl_unlhsh_free_addr4).
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Me too ...

Acked-by: Paul Moore <paul.moore@hp.com>

--
paul moore
linux @ hp
