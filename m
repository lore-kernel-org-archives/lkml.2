Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1CGUI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:08:58 -0500
Received: from kroah.org ([198.145.64.141]:40490 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab1CGUIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:08:55 -0500
Date: Mon, 7 Mar 2011 12:07:33 -0800
From: Greg KH <greg@kroah.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: pch_uart: reference clock on CM-iTC
Message-ID: <20110307200733.GA18849@kroah.com>
References: <4D74A600.7070302@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D74A600.7070302@compulab.co.il>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 11:31:44AM +0200, Denis Turischev wrote:
> Default clock source for UARTs on Topcliff is external UART_CLK.
> On CM-iTC USB_48MHz is used unstead. After VCO2PLL and DIV
> manipulations UARTs will receive 192 MHz.
> Clock manipulations on Topcliff are controlled in pch_phub.c
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> ---
>  drivers/misc/pch_phub.c       |   16 ++++++++++++++++
>  drivers/tty/serial/pch_uart.c |    9 +++++++--

This patch fails to apply to my tree, care to redo it against the
linux-next tree and resend it?

thanks,

greg k-h
