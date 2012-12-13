Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2LMBrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 20:47:53 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:56171 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724Ab2LMBrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 20:47:52 -0500
X-Sasl-enc: aPQ3/UP6BpGBuvciaVNq9etUv0owshxrBem2iHHmUHLN 1355363271
Date: Wed, 12 Dec 2012 17:50:25 -0800
From: Greg KH <greg@kroah.com>
To: Benoit Touchette <draekko.dev@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        trivial@kernel.org, marcobiscaro2112@gmail.com
Subject: Re: [PATCH] USB: adds support for Novatek wireless mouse to usbhid
Message-ID: <20121213015025.GA10991@kroah.com>
References: <CAKPZWXc55MWN3ajpvf0vLXP9KebFo17bGAmD8X=mavxyWJui1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKPZWXc55MWN3ajpvf0vLXP9KebFo17bGAmD8X=mavxyWJui1w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 08:43:32PM -0500, Benoit Touchette wrote:
> This patch adds support for the Novatek wireless mouse (device id
> 0603:1602) to usbhid and fixes bug
> https://bugzilla.kernel.org/show_bug.cgi?id=47031
> 
> Reported-by: Benoit Touchette <draekko.dev@gmail.com>
> Signed-off-by: Benoit Touchette <draekko.dev@gmail.com>
> 
> ---
> 
> --- linux-3.6.10/drivers/hid/hid-ids.h.orig    2012-12-10
> 14:13:27.000000000 -0500
> +++ linux-3.6.10/drivers/hid/hid-ids.h    2012-12-12 20:06:41.000000000 -0500

Please use the scripts/get_maintainer.pl tool to send this patch to the
correct people and mailing list.

Also, your patch is line-wrapped, and can't be applied, you need to look
into fixing your email client to not do this if you wish to get patches
accepted.

greg k-h
