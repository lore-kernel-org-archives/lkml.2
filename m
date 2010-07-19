Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966679Ab0GSUPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 16:15:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39919
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966644Ab0GSUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 16:15:54 -0400
Date: Mon, 19 Jul 2010 13:16:10 -0700 (PDT)
Message-Id: <20100719.131610.170125363.davem@davemloft.net>
To: sbhatewara@vmware.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        pv-drivers@vmware.com, ronghua@vmware.com, matthieu@vmware.com
Subject: Re: [PATCH 2.6.35-rc1] net-next: vmxnet3 fixes [4/5] Do not reset
 when the device is not opened
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LRH.2.00.1007190958480.9943@localhost.localdomain>
References: <alpine.LRH.2.00.1007160108240.12503@localhost.localdomain>
	<20100717.163538.137865264.davem@davemloft.net>
	<alpine.LRH.2.00.1007190958480.9943@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shreyas Bhatewara <sbhatewara@vmware.com>
Date: Mon, 19 Jul 2010 10:02:13 -0700 (PDT)

> Hold rtnl_lock to get the right link state.
> 
> While asynchronously resetting the device, hold rtnl_lock to get the
> right value from netif_running. If a reset is scheduled, and the device
> goes thru close and open, it may happen that reset and open may run in
> parallel. Holding rtnl_lock will avoid this.
> 
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>

Applied.
