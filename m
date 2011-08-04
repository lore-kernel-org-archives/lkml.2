Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1HDIb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:31:26 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35241 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab1HDIbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:31:22 -0400
Date: Thu, 04 Aug 2011 01:30:06 -0700 (PDT)
Message-Id: <20110804.013006.562311010847994961.davem@davemloft.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, yegorslists@googlemail.com,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [patch] ide: Fix irq flags madness
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110723154916.323967213@linutronix.de>
References: <20110723154916.323967213@linutronix.de>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 04 Aug 2011 01:30:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 23 Jul 2011 15:51:37 -0000

> commit ec1a123 (IDE: pass IRQ flags to the IDE core) introduced the
> bogosity of passing unfiltered resource->flags to the irq_flags which
> are used for request_irq. It results in random bits set (especially
> IORESOURCE_IRQ which maps to IRQF_PER_CPU).
> 
> Filter the bits proper.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Applied, but please post IDE patches to linux-ide in the future.

Thanks.
