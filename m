Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab0ERT0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 15:26:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54674
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766Ab0ERT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 15:26:32 -0400
Date: Tue, 18 May 2010 12:26:40 -0700 (PDT)
Message-Id: <20100518.122640.24579847.davem@davemloft.net>
To: shemminger@vyatta.com
Cc: randy.dunlap@oracle.com, sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH -next] bridge: fix build for CONFIG_SYSFS disabled
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100518102837.2622c3b1@nehalam>
References: <4BF18468.5010005@oracle.com>
	<20100517.223237.55871633.davem@davemloft.net>
	<20100518102837.2622c3b1@nehalam>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <shemminger@vyatta.com>
Date: Tue, 18 May 2010 10:28:37 -0700

> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build when CONFIG_SYSFS is not enabled:
> net/bridge/br_if.c:136: error: 'struct net_bridge_port' has no member named 'sysfs_name'
> 
> Note: dev->name == sysfs_name except when change name is in
> progress, and we are protected from that by RTNL mutex.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-off-by: Stephen Hemminger <shemminger@vyatta.com>

It's "Acked-by" :-)

Applied, thanks!
