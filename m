Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2KSXts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:49:48 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34491 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab2KSXtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:49:47 -0500
Date: Mon, 19 Nov 2012 18:49:45 -0500 (EST)
Message-Id: <20121119.184945.1954927437456820612.davem@davemloft.net>
To: zheng.x.li@oracle.com
Cc: netdev@vger.kernel.org, fubar@us.ibm.com, andy@greyhouse.net,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: rlb mode of bond should not alter ARP
 originating via bridge
From: David Miller <davem@davemloft.net>
In-Reply-To: <1352972861-17577-1-git-send-email-zheng.x.li@oracle.com>
References: <1352972861-17577-1-git-send-email-zheng.x.li@oracle.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Li <zheng.x.li@oracle.com>
Date: Thu, 15 Nov 2012 17:47:41 +0800

> ARP traffic passing through a bridge and out via the bond (when the bond is a 
> port of the bridge) should not have its source MAC address adjusted by the 
> receive load balance code in rlb_arp_xmit.
> 
> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>

Can I please get a review from some bonding experts on this one?

Thanks!
