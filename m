Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab2CHG5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:57:34 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58200 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2CHG5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:57:30 -0500
Date: Wed, 07 Mar 2012 22:53:17 -0800 (PST)
Message-Id: <20120307.225317.837723066642024990.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: benh@kernel.crashing.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] net: powerpc: remove the legacy iSeries ethernet
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120308153353.ee2ff35c8ebe7ee66fa374e9@canb.auug.org.au>
References: <20120308152853.b5010336abbb8f90e8a2500c@canb.auug.org.au>
	<20120308153353.ee2ff35c8ebe7ee66fa374e9@canb.auug.org.au>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 07 Mar 2012 22:53:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 8 Mar 2012 15:33:53 +1100

> This driver is specific to the PowerPC legcay iSeries platform which is
> being removed.
> 
> Cc: David Miller <davem@davemloft.net>
> Cc: <netdev@vger.kernel.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: David S. Miller <davem@davemloft.net>
