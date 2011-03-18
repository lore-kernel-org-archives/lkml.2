Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1CRTgh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:36:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60320
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932701Ab1CRTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:36:27 -0400
Date: Fri, 18 Mar 2011 12:37:04 -0700 (PDT)
Message-Id: <20110318.123704.70191230.davem@davemloft.net>
To: laijs@cn.fujitsu.com
Cc: paulmck@linux.vnet.ibm.com, mingo@elte.hu, jpirko@redhat.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/36] net,rcu: convert call_rcu(net_generic_release)
 to kfree_rcu()
From: David Miller <davem@davemloft.net>
In-Reply-To: <4D82DA48.2070305@cn.fujitsu.com>
References: <4D82DA48.2070305@cn.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:06:32 +0800

> 
> 
> The rcu callback net_generic_release() just calls a kfree(),
> so we use kfree_rcu() instead of the call_rcu(net_generic_release).
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Acked-by: David S. Miller <davem@davemloft.net>
