Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab2ENQb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:31:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50705 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2ENQb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:31:58 -0400
Date: Mon, 14 May 2012 09:31:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Reinhard Tartler <tartler@cs.fau.de>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@lists.cs.fau.de
Subject: Re: [PATCH] usb: musb: cppi: add missing include to fix compilation
Message-ID: <20120514163154.GA17555@kroah.com>
References: <1337011520-15286-1-git-send-email-tartler@cs.fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337011520-15286-1-git-send-email-tartler@cs.fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 06:05:20PM +0200, Reinhard Tartler wrote:
> This fixes compilation as module.
> 
> Signed-off-by: Reinhard Tartler <tartler@cs.fau.de>
> ---
>  drivers/usb/musb/cppi_dma.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> This patch was found by tools developed in the VAMOS project:
> http://www4.cs.fau.de/Research/VAMOS/

Does that mean that no one actually can hit this in "real life"?  Or is
there a valid .config that this solves a problem for?  If so, is it also
needed for the 3.4/3.3-stable tree and older ones?

thanks,

greg k-h
