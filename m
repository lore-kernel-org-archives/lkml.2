Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223Ab2IMUTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:19:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49052 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875Ab2IMUTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:19:08 -0400
Date: Thu, 13 Sep 2012 16:19:06 -0400 (EDT)
Message-Id: <20120913.161906.1620891081013420444.davem@davemloft.net>
To: srivatsa.bhat@linux.vnet.ibm.com
Cc: nhorman@tuxdriver.com, David.Laight@aculab.com, john.r.fastabend@intel.com,
        gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3 PATCH 1/2] netprio_cgroup: Remove update_netdev_tables()
 since it is unnecessary
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120913063225.6278.87780.stgit@srivatsabhat.in.ibm.com>
References: <20120913063225.6278.87780.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2012 12:02:25 +0530

> The update_netdev_tables() function appears to be unnecessary, since the
> write_update_netdev_table() function will adjust the priomaps as and when
> required anyway. So drop the usage of update_netdev_tables() entirely.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to net-next
