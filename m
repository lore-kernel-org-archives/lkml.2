Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab1HZQvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:51:19 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58622 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab1HZQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:51:13 -0400
Date: Fri, 26 Aug 2011 12:51:07 -0400 (EDT)
Message-Id: <20110826.125107.163718127055087168.davem@davemloft.net>
To: abhilash.kv@ti.com
Cc: netdev@vger.kernel.org, wg@grandegger.com, linux-kernel@vger.kernel.org,
        =linux-omap@vger.kernel.org
Subject: Re: [PATCH] can: ti_hecc: Fix unintialized variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1314104748-16424-1-git-send-email-abhilash.kv@ti.com>
References: <1314104748-16424-1-git-send-email-abhilash.kv@ti.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 26 Aug 2011 09:51:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhilash K V <abhilash.kv@ti.com>
Date: Tue, 23 Aug 2011 18:35:48 +0530

> In ti_hecc_xmit(), local variable "data" is not initialized before
> being used.
> This initialization got inadvertently removed in the following patch:
> 
> 	can: Unify droping of invalid tx skbs and netdev stats
> 
> Acked-by: Anant Gole <anantgole@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

Applied.
