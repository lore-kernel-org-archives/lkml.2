Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758Ab2GFRd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:33:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357Ab2GFRd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:33:27 -0400
Date: Fri, 6 Jul 2012 10:33:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: gaosen <gaosen.zhang@mediatek.com>
Cc: smurf@smurf.noris.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: USB: option: Add MEDIATEK product ids
Message-ID: <20120706173323.GA2373@kroah.com>
References: <CAAwpLmyd2SMR0EKGowDqo54mPUuPmKkziGVTsuRZcrd7i2r2jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAwpLmyd2SMR0EKGowDqo54mPUuPmKkziGVTsuRZcrd7i2r2jA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 09:50:50PM +0800, gaosen wrote:
> >From 86fcd5bb701bd927d588386c480c37784d10040a Mon Sep 17 00:00:00 2001
> From: Gaosen Zhang <gaosen.zhang@mediatek.com>
> Date: Fri, 6 Jul 2012 21:44:10 +0800
> Subject: [PATCH 1/1] USB: option: Add MEDIATEK product ids
> 
> 
> Signed-off-by: Gaosen Zhang <gaosen.zhang@mediatek.com>
> ---
>  drivers/usb/serial/option.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)

This conflicts with the patch that you sent me a few days ago which I've
already applied.  What is the difference and why did you rename some of
the #defines?

Can you please send me an incremental patch on top of the other patch
that you previous sent me, so that I can properly include this one, as
it looks like it does add support for a few more devices?

thanks,

greg k-h
