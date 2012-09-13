Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2IMUTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:19:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2IMUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:19:15 -0400
Date: Thu, 13 Sep 2012 16:19:13 -0400 (EDT)
Message-Id: <20120913.161913.650029892141015680.davem@davemloft.net>
To: srivatsa.bhat@linux.vnet.ibm.com
Cc: nhorman@tuxdriver.com, David.Laight@aculab.com, john.r.fastabend@intel.com,
        gaofeng@cn.fujitsu.com, eric.dumazet@gmail.com,
        mark.d.rustad@intel.com, lizefan@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [v3 PATCH 2/2] netprio_cgroup: Use memcpy instead of the
 for-loop to copy priomap
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120913063233.6278.7615.stgit@srivatsabhat.in.ibm.com>
References: <20120913063225.6278.87780.stgit@srivatsabhat.in.ibm.com>
	<20120913063233.6278.7615.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2012 12:02:34 +0530

> Replace the current (inefficient) for-loop with memcpy, to copy priomap.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to net-next
