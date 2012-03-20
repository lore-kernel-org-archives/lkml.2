Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab2CTB4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 21:56:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:43612 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758799Ab2CTB4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 21:56:37 -0400
Date: Mon, 19 Mar 2012 21:56:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Roland Stigge <stigge@antcom.de>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <w.sang@pengutronix.de>, <kevin.wells@nxp.com>,
        <linux-arm-kernel@lists.infradead.org>, <arm@kernel.org>,
        <srinivas.bakki@nxp.com>
Subject: Re: [PATCH] USB: gadget driver for LPC32xx
In-Reply-To: <1332191930-2433-1-git-send-email-stigge@antcom.de>
Message-ID: <Pine.LNX.4.44L0.1203192155150.24735-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Roland Stigge wrote:

> This patch adds a USB gadget driver.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

...

> +static const struct usb_ep_ops lpc32xx_ep_ops = {
> +	.enable		= lpc32xx_ep_enable,
> +	.disable	= lpc32xx_ep_disable,
> +	.alloc_request	= lpc32xx_ep_alloc_request,
> +	.free_request	= lpc32xx_ep_free_request,
> +	.queue		= lpc32xx_ep_queue,
> +	.dequeue	= lpc32xx_ep_dequeue,
> +	.set_halt	= lpc32xx_ep_set_halt,
> +};

You have not implemented the set_wedge method, which is needed for the 
file-storage gadgets.

Alan Stern

