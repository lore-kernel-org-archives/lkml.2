Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762495Ab2DLKNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 06:13:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43887 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab2DLKNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 06:13:34 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, "Michal Nazarewicz" <mpn@google.com>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_mass_storage: remove deprecated fsg_add()
References: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com>
Date: Thu, 12 Apr 2012 12:13:32 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wcndcuqd3l0zgt@mpn-glaptop>
In-Reply-To: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com>
User-Agent: Opera Mail/11.62 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 12:21:15 +0100, Michal Nazarewicz <mpn@google.com> wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>
> There are no in-tree fsg_add() users and it has been deprecated
> since 2.6.35 [1dc90985d1: fsg_add() renamed to fsg_bind_config()] so
> out-of-tree users had more then enough time to convert.  Removing.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  drivers/usb/gadget/f_mass_storage.c |    7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index a371e96..47383f4 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -3110,13 +3110,6 @@ static int fsg_bind_config(struct usb_composite_dev *cdev,
>  	return rc;
>  }
>-static inline int __deprecated __maybe_unused
> -fsg_add(struct usb_composite_dev *cdev, struct usb_configuration *c,
> -	struct fsg_common *common)
> -{
> -	return fsg_bind_config(cdev, c, common);
> -}
> -
> /************************* Module parameters *************************/
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
