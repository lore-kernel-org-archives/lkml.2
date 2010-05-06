Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0EFKKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:10:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46463
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab0EFKKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:10:33 -0400
Date: Thu, 06 May 2010 03:10:40 -0700 (PDT)
Message-Id: <20100506.031040.186321896.davem@davemloft.net>
To: mingo@elte.hu
Cc: david.choi@micrel.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree boot crash (in the new micrel phy driver)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100506095940.GA12711@elte.hu>
References: <20100505.012750.246538504.davem@davemloft.net>
	<20100506095940.GA12711@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 6 May 2010 11:59:40 +0200

> I bisected it back to the following commit:
> 
> d05070091849015f8c5b7d55cd75b86ebb61b3ec is the first bad commit
> commit d05070091849015f8c5b7d55cd75b86ebb61b3ec
> Author: David J. Choi <david.choi@micrel.com>
> Date:   Thu Apr 29 06:12:41 2010 +0000
> 
>     drivers/net/phy: micrel phy driver
>     
>     This is the first version of phy driver from Micrel Inc.
>     
>     Signed-off-by: David J. Choi <david.choi@micrel.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> the config had:
> 
>   CONFIG_MICREL_PHY=y
> 
> Disabling the driver fixes the crash.

David please fix this crash, thanks.
