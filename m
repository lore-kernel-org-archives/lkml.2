Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2HaUfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 16:35:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53419 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab2HaUfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 16:35:38 -0400
Date: Fri, 31 Aug 2012 16:35:36 -0400 (EDT)
Message-Id: <20120831.163536.537028996029525033.davem@davemloft.net>
To: b-liu@ti.com
Cc: mugunthanvnm@ti.com, vaibhav.bedia@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: fix kernel OOPS when remove
 davinci_mdio module
From: David Miller <davem@davemloft.net>
In-Reply-To: <1346344652-28487-1-git-send-email-b-liu@ti.com>
References: <1346344652-28487-1-git-send-email-b-liu@ti.com>
X-Mailer: Mew version 6.5 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bin Liu <b-liu@ti.com>
Date: Thu, 30 Aug 2012 11:37:32 -0500

> davinci mdio device is not unregistered from mdiobus when removing
> the module, which causes BUG_ON() when free the device from mdiobus.
> 
> Calling mdiobus_unregister() before mdiobus_free() fixes the issue.
> 
> Signed-off-by: Bin Liu <b-liu@ti.com>

Applied, thanks.
