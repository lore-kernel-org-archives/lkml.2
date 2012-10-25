Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759845Ab2JYO2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:28:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:4221 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692Ab2JYO2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:28:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,646,1344236400"; 
   d="scan'208";a="232438437"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Anton Vorontsov (cbouatmailru@gmail.com)" <cbouatmailru@gmail.com>
Subject: RE: [PATCH RESEND] max17042: missing assignment
Thread-Topic: [PATCH RESEND] max17042: missing assignment
Thread-Index: AQHNsrtB+yb5DR8q3UW4KkURDVKBMZfKFA6A
Date: Thu, 25 Oct 2012 14:28:03 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD24510D25@BGSMSX102.gar.corp.intel.com>
References: <20121025141638.16300.43943.stgit@localhost.localdomain>
In-Reply-To: <20121025141638.16300.43943.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9PESFTk018011


Thanks Alan.

> The second error check is unreachable because the lock function isn't assigned
> to ret
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>

> ---
> 
>  drivers/power/max17042_battery.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/max17042_battery.c
> b/drivers/power/max17042_battery.c
> index 74abc6c..73b432d 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -572,7 +572,7 @@ static int max17042_init_chip(struct max17042_chip
> *chip)
>  			__func__);
>  		return -EIO;
>  	}
> -	max17042_verify_model_lock(chip);
> +	ret = max17042_verify_model_lock(chip);
>  	if (ret) {
>  		dev_err(&chip->client->dev, "%s lock verify failed\n",
>  			__func__);

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
