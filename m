Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030444Ab2ERB3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 21:29:07 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:33131 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554Ab2ERB3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 21:29:04 -0400
Date: Fri, 18 May 2012 10:29:00 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, grant.likely@secretlab.ca,
        lethal@linux-sh.org, olof@lixom.net
Subject: Re: [PATCH][RESEND] gpio: Emma Mobile GPIO driver V2
Message-ID: <20120518012857.GA8738@verge.net.au>
References: <20120517062223.1314.98945.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517062223.1314.98945.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 03:22:23PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> This patch is V2 of the Emma Mobile GPIO driver. This
> driver is designed to be reusable between multiple SoCs
> that share the same basic building block, but so far it
> has only been used on Emma Mobile EV2.
> 
> Each driver instance handles 32 GPIOs with individually
> maskable IRQs. The driver operates on two I/O memory 
> ranges and the 32 GPIOs are hooked up to two interrupts.
> 
> In the case of Emma Mobile EV2 this GPIO building block
> is used as main external interrupt controller hooking up
> 159 GPIOS as 159 interrupts via 5 driver instances and
> 10 interrupts to the GIC and the Cortex-A9 Dual.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Tested-by: Simon Horman <horms@verge.net.au>
