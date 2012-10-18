Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab2JRXzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:55:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43363 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2JRXzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:55:07 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-60-508096d9c6ed
Message-id: <508096BA.6070706@samsung.com>
Date: Fri, 19 Oct 2012 08:54:34 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827
 Thunderbird/15.0
MIME-version: 1.0
To: Sangho Yi <antiroot@gmail.com>
Cc: paul.gortmaker@windriver.com, stefan.xk.nilsson@stericsson.com,
        linus.walleij@linaro.org, ulf.hansson@stericsson.com, rjw@sisk.pl,
        girish.shivananjappa@linaro.org, cjb@laptop.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 3/6] mmc: core: sdio_bus.c: Fixed lines > 80 chars
References: <n@samsung.com>
 <1350577919-2750-1-git-send-email-antiroot@gmail.com>
 <1350577919-2750-3-git-send-email-antiroot@gmail.com>
In-reply-to: <1350577919-2750-3-git-send-email-antiroot@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t9jAd2b0xoCDNYe1rC4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGW0fJvNUnCBq+LorEaWBsbdHF2MnBwSAiYS0zsnsELY
	YhIX7q1n62Lk4hASWMQocWrfObCEkMBLRolJmxO7GDk4eAW0JHp+eoGEWQRUJZ4ebmYBsdkE
	dCS2fzvOBGKLCoRILJn7lR3E5hUQlPgx+R5YjYiAkkT7mY9g85kFvjJKnG68DTZfWMBNYnHf
	bkaIxd2MEq0bf7KCLOMUcJJ4vDEcpIYZaMH+1mlsELa8xOY1b5knMArMQrJjFpKyWUjKFjAy
	r2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDsVnUjsYVzZYHGIU4GBU4uG91FMfIMSaWFZc
	mXuIUYKDWUmEd+UmoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeZo+UACGB9MSS1OzU1ILUIpgs
	EwenVANjTEIL94n9wkVHi3dmTkiXOi+WK3e+ctqkLaHWj9ZM+nztd0bcQbUF+2Mq75vr/nSb
	9sjg15rFlsy7PPRvep7T9pmcG5eU923Ha4/Oxpdht2rNZ28XzAvf4/24qiD9Y+z9zGhV/7/C
	8w1MVsnVW890qMvz/ff30oaWCQ7v5n6RiOX3q7l68Y2OEktxRqKhFnNRcSIA/dpOjkECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

your patch[1/3] is also "Fixed lines > 80chars".
Why do you separate with patch[1/6] and patch[3/6]?

Best Regards,
Jaehoon Chung

On 10/19/2012 01:31 AM, Sangho Yi wrote:
> I fixed lines over 80 characters per line.
> 
> Signed-off-by: Sangho Yi <antiroot@gmail.com>
> ---
>  drivers/mmc/core/sdio_bus.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
> index 13146d2..efa30eb 100644
> --- a/drivers/mmc/core/sdio_bus.c
> +++ b/drivers/mmc/core/sdio_bus.c
> @@ -27,7 +27,7 @@
>  /* show configuration fields */
>  #define sdio_config_attr(field, format_string)				\
>  static ssize_t								\
> -field##_show(struct device *dev, struct device_attribute *attr, char *buf)				\
> +field##_show(struct device *dev, struct device_attribute *attr, char *buf)\
>  {									\
>  	struct sdio_func *func;						\
>  									\
> @@ -39,7 +39,8 @@ sdio_config_attr(class, "0x%02x\n");
>  sdio_config_attr(vendor, "0x%04x\n");
>  sdio_config_attr(device, "0x%04x\n");
>  
> -static ssize_t modalias_show(struct device *dev, struct device_attribute *attr, char *buf)
> +static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
> +		char *buf)
>  {
>  	struct sdio_func *func = dev_to_sdio_func (dev);
>  
> 

