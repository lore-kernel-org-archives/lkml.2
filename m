Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0LON0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:26:31 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:45344 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0LON0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:26:30 -0500
Message-ID: <4D08C1C8.3090100@ru.mvista.com>
Date: Wed, 15 Dec 2010 16:25:28 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] MTD: m25p80: add debugging trace in sst_write()
References: <1292414372-17085-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1292414372-17085-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-12-2010 14:59, Nicolas Ferre wrote:

> Add a DEBUG(MTD_DEBUG_LEVEL2, ..) trace at beginning of sst_write() function as
> it is done in m25p80_write() function.

> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
[...]

> diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
> index bf5a002..e6b5707 100644
> --- a/drivers/mtd/devices/m25p80.c
> +++ b/drivers/mtd/devices/m25p80.c
> @@ -482,6 +482,10 @@ static int sst_write(struct mtd_info *mtd, loff_t to, size_t len,
>   	size_t actual;
>   	int cmd_sz, ret;
>
> +	DEBUG(MTD_DEBUG_LEVEL2, "%s: %s %s 0x%08x, len %zd\n",
> +			dev_name(&flash->spi->dev), __func__, "to",

    What's the point of printing "to" as variable? :-)

> +			(u32)to, len);
> +

WBR, Sergei
