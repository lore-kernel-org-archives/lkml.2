Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab0JXJox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 05:44:53 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39195 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab0JXJow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 05:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hiZeFq6bF59uC2R04dlNQkfKlxmpdLFihU4KuiGZR4mLfEsvOn1n4GpuwnVwQlah3g
         kfgdN4Uv9wIKfvLeAU44huX9uanew6Pj+s3ntCaVylU7Tcs/KTZqsEQzX93STCSp+OgH
         rqEXAgYVpkQF+FFUGMjSMvBCegvVSLWxQJd9Q=
MIME-Version: 1.0
In-Reply-To: <1287858313-22645-1-git-send-email-neilmunro@gmail.com>
References: <1287858313-22645-1-git-send-email-neilmunro@gmail.com>
Date: Sun, 24 Oct 2010 13:44:51 +0400
Message-ID: <AANLkTimE9Q2kgWf67zmATJwJDMSCPJV8XLPkqiw7SvhG@mail.gmail.com>
Subject: Re: [PATCH] Staging: RT2860: Fixed two errors in usb_main_dev.c
From: Denis Kirjanov <kirjanov@gmail.com>
To: Neil Munro <neilmunro@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 10:25 PM, Neil Munro <neilmunro@gmail.com> wrote:
> usb_main_dev.c has now been cleaned of all errors, just needed spaces around colon symbols.
>
> Signed-off-by: Neil Munro <neilmunro@gmail.com>
> ---
>  drivers/staging/rt2860/usb_main_dev.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
> index ebf9074..30c16dd 100644
> --- a/drivers/staging/rt2860/usb_main_dev.c
> +++ b/drivers/staging/rt2860/usb_main_dev.c
> @@ -368,8 +368,8 @@ struct usb_driver rtusb_driver = {
>        .id_table = rtusb_usb_id,
>
>  #ifdef CONFIG_PM
> -suspend:rt2870_suspend,
> -resume:rt2870_resume,
> +suspend : rt2870_suspend,
> +resume : rt2870_resume,

Structure should _not_ be initialized like this.
There are tons of examples through the kernel tree.

>  #endif
>  };
>
> --
> 1.7.3.2
>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
>

-- 
Regards,
Denis
