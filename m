Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab2IJXCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:02:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40417 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562Ab2IJXCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:02:48 -0400
Date: Mon, 10 Sep 2012 16:00:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Huang Shijie <b32955@freescale.com>
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org
Subject: Re: [PATCH] serial: mxs-auart: put the device when exit or error
Message-ID: <20120910230005.GA15782@kroah.com>
References: <20120907024349.GH26709@S2101-09.ap.freescale.net>
 <1346985187-30459-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346985187-30459-1-git-send-email-b32955@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 10:33:07AM +0800, Huang Shijie wrote:
> We call the get_device() in the mxs_auart_probe().
> For the balance of the reference count, we should put the
> device in the mxs_auart_remove() or in the error path of
> probe.
> 
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/tty/serial/mxs-auart.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

I already applied the previous version, so can you make up a patch
against the tty-next tree that fixes it up properly based on this patch?

thanks,

greg k-h
