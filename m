Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab1GWAPv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 20:15:51 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59197 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1GWAPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 20:15:41 -0400
Date: Fri, 22 Jul 2011 17:15:34 -0700 (PDT)
Message-Id: <20110722.171534.202703728483982275.davem@davemloft.net>
To: daniel.morsing@gmail.com
Cc: broonie@opensource.wolfsonmicro.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm9000: Make the driver follow the IRQF_SHARED contract
From: David Miller <davem@davemloft.net>
In-Reply-To: <1311357162-16200-1-git-send-email-daniel.morsing@gmail.com>
References: <1311357162-16200-1-git-send-email-daniel.morsing@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 22 Jul 2011 17:15:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Morsing <daniel.morsing@gmail.com>
Date: Fri, 22 Jul 2011 19:52:42 +0200

> The dm9000 driver requests a shared interrupt but doesn't return
> IRQ_NONE when the device didn't generate the interrupt. This could lead
> to the other devices sharing the irq never getting an interrupt. This
> patch makes the routine return IRQ_NONE for the path where no work was
> done.
> 
> Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
> Cc: stable@kernel.org

Applied.
