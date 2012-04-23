Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab2DWPns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:43:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:55841 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2DWPnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:43:47 -0400
Date: Mon, 23 Apr 2012 08:43:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH RESEND] driver core: always handle dpm_order
Message-ID: <20120423154342.GB23990@kroah.com>
References: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335165396-23604-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:16:36AM +0200, Linus Walleij wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> If !dev->class, device_move() does not respect the dpm_order.
> Fix it to do so.
> 
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> [Fixed a small dangling label compile warning]
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/base/core.c |   36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)

Is this a problem in 3.4?  Older kernels?  Or can it wait for 3.5?

thanks,

greg k-h
