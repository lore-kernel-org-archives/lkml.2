Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424Ab2GZCPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 22:15:39 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40610 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2GZCPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 22:15:38 -0400
MIME-Version: 1.0
In-Reply-To: <1343245264-23291-1-git-send-email-tim.gardner@canonical.com>
References: <1343245264-23291-1-git-send-email-tim.gardner@canonical.com>
Date: Thu, 26 Jul 2012 10:15:37 +0800
Message-ID: <CAMiH66GLN02JBVg4MUZ3NXqLFY4zJqZubBhwxmJdhzMwHE0XQA@mail.gmail.com>
Subject: Re: [PATCH] tlg2300: Declare MODULE_FIRMWARE usage
From: Huang Shijie <shijie8@gmail.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thanks.

Acked-by: Huang Shijie <shijie8@gmail.com>

On Thu, Jul 26, 2012 at 3:41 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Cc: Huang Shijie <shijie8@gmail.com>
> Cc: Kang Yong <kangyong@telegent.com>
> Cc: Zhang Xiaobing <xbzhang@telegent.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/media/video/tlg2300/pd-main.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
> index c096b3f..7b1f6eb 100644
> --- a/drivers/media/video/tlg2300/pd-main.c
> +++ b/drivers/media/video/tlg2300/pd-main.c
> @@ -53,7 +53,8 @@ int debug_mode;
>  module_param(debug_mode, int, 0644);
>  MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");
>
> -static const char *firmware_name = "tlg2300_firmware.bin";
> +#define TLG2300_FIRMWARE "tlg2300_firmware.bin"
> +static const char *firmware_name = TLG2300_FIRMWARE;
>  static struct usb_driver poseidon_driver;
>  static LIST_HEAD(pd_device_list);
>
> @@ -532,3 +533,4 @@ MODULE_AUTHOR("Telegent Systems");
>  MODULE_DESCRIPTION("For tlg2300-based USB device ");
>  MODULE_LICENSE("GPL");
>  MODULE_VERSION("0.0.2");
> +MODULE_FIRMWARE(TLG2300_FIRMWARE);
> --
> 1.7.9.5
>
