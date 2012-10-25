Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990Ab2JYTYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:24:33 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:49099 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934197Ab2JYTYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:24:32 -0400
X-Sasl-enc: y2WnSjj3tUg4/fOpM42JND493cbswrKgrjSogBG4Qny5 1351193071
Date: Thu, 25 Oct 2012 12:24:30 -0700
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging/comedi: Use pr_ or dev_ printks in
 drivers/gsc_hdpi.c
Message-ID: <20121025192430.GA26555@kroah.com>
References: <20121025024357.GA24008@kroah.com>
 <1351163546-13261-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351163546-13261-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 08:12:26PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warning.
> - WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...
> 
> some of them have been replaced by dev_dbg,
> and added pr_fmt.
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/gsc_hpdi.c |   31 +++++++++++++++--------------
>  1 file changed, 16 insertions(+), 15 deletions(-)

This patch does not apply against my tree, can you please redo it
against the latest linux-next release and resend it?

thanks,

greg k-h
