Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab2CSPIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:08:14 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54230 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877Ab2CSPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:08:12 -0400
Date: Mon, 19 Mar 2012 10:08:01 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Santiago Garcia Mantinan <manty@debian.org>
Cc: linux-kernel@vger.kernel.org, Matthias Urlichs <smurf@smurf.noris.de>,
        linux-usb@vger.kernel.org, Dirk De Schepper <ddeschepper@nvtl.com>
Subject: Re: [PATCH] USB: option: re-add
 NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED to option_id array
Message-ID: <20120319150801.GC11180@burratino>
References: <20120319102154.GA16536@www.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319102154.GA16536@www.manty.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc-ing some relevant people)
Hi,

Santiago Garcia Mantinan wrote:

> c7aa8f44b4d1dc73591894a2dd6909213612d299
[...]
>    removed NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED from the scruct while
> moving things around, it was a bit difficult to see as the defines and the
> struct are not on the same order.  We've carried this for a year and a half
> and for what I've seen there have been some reports about this like:
> https://bugs.launchpad.net/ubuntu/+source/usb-modeswitch/+bug/750362
> but unfortunately it didn't get much attention.
>
> I've looked at the strings and the only one missing was
> NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED, so here is the patch for it.

Thanks!  Can we have your sign-off?  See Documentation/SubmittingPatches,
item 12 "Sign your work", for what this means.

> --- option.c.old	2012-03-19 10:16:31.046565765 +0100
> +++ option.c	2012-03-19 10:55:34.348846327 +0100
> @@ -538,6 +538,7 @@
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_EMBEDDED_FULLSPEED) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_EMBEDDED_FULLSPEED) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_EVDO_HIGHSPEED) },
> +	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED3) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED4) },
>  	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_HSPA_HIGHSPEED5) },

Hope that helps,
Jonathan
