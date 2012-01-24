Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab2AXWQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:16:20 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40266 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185Ab2AXWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:16:18 -0500
X-Sasl-enc: 5JzZxi3zuj7jMT5+xn71GZukW7uDarPhTJizYqNuauK2 1327443377
Date: Tue, 24 Jan 2012 14:05:22 -0800
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: Re: [PATCH v3] serial/efm32: add new driver
Message-ID: <20120124220522.GA10590@kroah.com>
References: <1324561092-1945-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1326127447-20284-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1326127447-20284-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 05:44:07PM +0100, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> changes since v2:
> - use {read,write}l_relaxed
> - rename driver to efm32-uart as USARTs and UARTs can be handled both
>   with it
> - disable TX in .stop_tx (which needs some changes related to
>   USARTn_IF_TXC)
> 
> Best regards
> Uwe
> 
>  .../devicetree/bindings/tty/serial/efm32-uart.txt  |   14 +
>  arch/arm/boot/dts/efm32gg-dk3750.dts               |    2 +-
>  arch/arm/mach-efm32/devices/pdev-efm32-usart.c     |    6 +-

This file isn't in 3.3-rc1, so I can't apply this patch :(

What tree is it supposed to be against?

thanks,

greg k-h
