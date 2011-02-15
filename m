Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab1BOIu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 03:50:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1BOIuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 03:50:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lk34gvYrozsyQYGMqAzKvAlWZgzPzJX13z7i2ecNxQQubmMWgNIRpAwUqa/D1jwJvN
         xvNBbyUbXJaF5qdU/9tFBeJutBzQoe5WE3DpZTyLyc5BIKvsz1cO239fWqRc22zObnq/
         wDwghcMZj388TCSo3qgKaIWy+qCkgyq4IOfuE=
Message-ID: <4D5A3E6A.6020800@gmail.com>
Date: Tue, 15 Feb 2011 09:50:50 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: wei_wang@realsil.com.cn
CC: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb_storage: realtek_cr patch: fix sparse warning
References: <1297733911-24267-1-git-send-email-wei_wang@realsil.com.cn>
In-Reply-To: <1297733911-24267-1-git-send-email-wei_wang@realsil.com.cn>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 02:38 AM, wei_wang@realsil.com.cn wrote:
> From: wwang <wei_wang@realsil.com.cn>
> 
> Fix some sparse warning for realtek_cr patch
> 
> Signed-off-by: wwang <wei_wang@realsil.com.cn>
> ---
>  drivers/usb/storage/realtek_cr.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
> index c2bebb3..4f6b25f 100644
> --- a/drivers/usb/storage/realtek_cr.c
> +++ b/drivers/usb/storage/realtek_cr.c
> @@ -141,7 +141,7 @@ static int init_realtek_cr(struct us_data *us);
>  	.driver_info = (flags)|(USB_US_TYPE_STOR<<24)\
>  }
>  
> -struct usb_device_id realtek_cr_ids[] = {
> +static struct usb_device_id realtek_cr_ids[] = {

And it may be const too while you are at it...

regards,
-- 
js
