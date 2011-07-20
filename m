Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab1GTPAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 11:00:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39351 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab1GTPAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 11:00:22 -0400
MIME-Version: 1.0
In-Reply-To: <e9d4e9e2edf4c51412c141140d51e9baf9ff13a3.1311162926.git.andriy.shevchenko@linux.intel.com>
References: <fddeabc04a1b81a5c1f51a4164d93366dccf5f8e.1311162926.git.andriy.shevchenko@linux.intel.com>
	<e9d4e9e2edf4c51412c141140d51e9baf9ff13a3.1311162926.git.andriy.shevchenko@linux.intel.com>
Date: Wed, 20 Jul 2011 20:30:21 +0530
Message-ID: <CAD2nsn2tOJTcOo=OcUp-agYCkBNT5Rt2j0D1+E1m1C56+QdQ-A@mail.gmail.com>
Subject: Re: [PATCH 2/3] wireless: ath9k: use %pM to print MAC
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 7:04 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
> Cc: ath9k-devel@lists.ath9k.org
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_debug.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
> index aa48b3a..d3ff33c 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_debug.c
> @@ -623,11 +623,8 @@ static ssize_t read_file_base_eeprom(struct file *file, char __user *user_buf,
>                                pBase9287->openLoopPwrCntl);
>        }
>
> -       len += snprintf(buf + len, size - len,
> -                       "%20s : %02X:%02X:%02X:%02X:%02X:%02X\n",
> -                       "MacAddress",
> -                       pBase->macAddr[0], pBase->macAddr[1], pBase->macAddr[2],
> -                       pBase->macAddr[3], pBase->macAddr[4], pBase->macAddr[5]);
> +       len += snprintf(buf + len, size - len, "%20s : %pM\n", "MacAddress",
> +                       pBase->macAddr);
>        if (len > size)
>                len = size;

thanks for the patch!

>
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
