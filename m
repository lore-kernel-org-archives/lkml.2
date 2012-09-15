Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2IOSLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 14:11:05 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:29406 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754263Ab2IOSLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 14:11:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19d9c5Oma0sUAeNkT1a5lML
Date: Sat, 15 Sep 2012 11:10:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH 17/24] ARM: OMAP: use __iomem pointers for MMIO
Message-ID: <20120915181057.GH4521@atomide.com>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de>
 <1347658492-11608-18-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347658492-11608-18-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [120914 14:36]:
> ARM is moving to stricter checks on readl/write functions,
> so we need to use the correct types everywhere.
> 
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/plat-omap/include/plat/hardware.h |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/include/plat/hardware.h b/arch/arm/plat-omap/include/plat/hardware.h
> index ddbde38..2518f6c 100644
> --- a/arch/arm/plat-omap/include/plat/hardware.h
> +++ b/arch/arm/plat-omap/include/plat/hardware.h

With my patches, this is now all omap1 specific and
moved to arch/arm/mach-omap1/include/mach/hardware.h.
It's probably easiest to just update this patch on
top of the hardware.h changes I've done.

Regards,

Tony
