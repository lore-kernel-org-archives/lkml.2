Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab2AMSN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 13:13:59 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39753 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758623Ab2AMSNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 13:13:54 -0500
X-Sasl-enc: GSLe3NdAxavyZTcUnbBmKtjyIHUPUMydMogTYmgKWUm/ 1326478433
Date: Fri, 13 Jan 2012 10:11:15 -0800
From: Greg KH <greg@kroah.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Steve Glendinning <steve.glendinning@smsc.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/usb/smsc95xx.c: change msleep() to
 usleep_range()
Message-ID: <20120113181115.GC29700@kroah.com>
References: <1326455824-8685-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326455824-8685-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 03:57:04PM +0400, Dmitry Antipov wrote:
> The resolution of msleep is related to HZ, so 10ms msleep() causes
> ~23ms sleep with OMAP's default CONFIG_HZ=128 timer configuration.
> This looks too much, and usleep_range() with some slack gives more
> control of what is happening here.
> 
> Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
> ---
>  drivers/net/usb/smsc95xx.c |    6 +++---

drivers/net/* patches need to be sent to netdev@vger.kernel.org to be
properly applied.

thanks,

greg k-h
