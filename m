Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1LJDVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 22:21:23 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52468 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab1LJDVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 22:21:18 -0500
X-Sasl-enc: IHh2EwsJVbGvhNEFFySdCQVgkhvfYPDCcCFEV3omS40H 1323487277
Date: Fri, 9 Dec 2011 19:09:34 -0800
From: Greg KH <greg@kroah.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 1/2] serial: bfin-uart: Enable hardware automatic CTS
 only when CTS pin is available.
Message-ID: <20111210030934.GA2897@kroah.com>
References: <1323410421-10465-1-git-send-email-sonic.adi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323410421-10465-1-git-send-email-sonic.adi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 02:00:20PM +0800, Sonic Zhang wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/tty/serial/bfin_uart.c |   19 ++++++++++---------
>  1 files changed, 10 insertions(+), 9 deletions(-)

This patch does not apply on top of your other patches:

patching file drivers/tty/serial/bfin_uart.c
Hunk #1 FAILED at 726.
1 out of 1 hunk FAILED -- saving rejects to file drivers/tty/serial/bfin_uart.c.rej

Care to redo it on top of the next linux-next tree and resend both of
these in the series?

thanks,

greg k-h
