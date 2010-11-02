Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0KBPZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:25:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56435 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0KBPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:25:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TLxGM3DpfZIJX/18O+XO/9QqjTK1Swn4uTATkfusbDZJx0v92DXhpLLqaMMyk15rWB
         VX7Rnq7prIIPx6KGG7u1oWlIUgC+2FZfuQ+9+wGUVs40BJXUyJL106ixcN88P60wgGqe
         BbyZHHspxk7VdTWdkQS0G8/1sWZ/qLJ8MzSkw=
Date: Tue, 2 Nov 2010 08:24:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gimli <gimli@dark-green.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 3/6] MacBookAir3,1(3,2) btusb support
Message-ID: <20101102152454.GC11778@core.coreip.homeip.net>
References: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e7738c0461aa509dd55fe470df3855e@mognix.dark-green.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure of you guys monitor LKML...

On Tue, Nov 02, 2010 at 08:19:43AM +0100, gimli wrote:
> This patch add support for the MacBookAir3,1 and MacBookAir3,2 to the btusb
> driver.
> 
> Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>

> --- a/drivers/bluetooth/btusb.c	2010-10-30 21:08:45.170492002 +0200
> +++ b/drivers/bluetooth/btusb.c	2010-10-30 21:18:11.820492000 +0200
> @@ -62,6 +62,9 @@
>  	/* Apple iMac11,1 */
>  	{ USB_DEVICE(0x05ac, 0x8215) },
>  
> +	/* Apple MacBookAir3,1, MacBookAir3,2 */
> +	{ USB_DEVICE(0x05ac, 0x821b) },
> +
>  	/* AVM BlueFRITZ! USB v2.0 */
>  	{ USB_DEVICE(0x057c, 0x3800) },
>  


-- 
Dmitry
