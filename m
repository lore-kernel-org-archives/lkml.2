Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab1B0HzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 02:55:10 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:46132 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1B0HzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 02:55:08 -0500
Date: Sun, 27 Feb 2011 08:54:55 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 10/17]drivers:hwmon:sht15.c Remove one to many n's in a
 word.
Message-ID: <20110227085455.701a5665@endymion.delvare>
In-Reply-To: <1298781250-2718-11-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
	<1298781250-2718-11-git-send-email-justinmattock@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Feb 2011 20:34:03 -0800, Justin P. Mattock wrote:
> The Patch below removes one to many "n's" in a word..

4 spelling mistakes in the summary of a spelling fix patch. Ah, the
irony ;)


> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> CC: Jean Delvare <khali@linux-fr.org>
> CC: Guenter Roeck <guenter.roeck@ericsson.com>
> CC: lm-sensors@lm-sensors.org
> ---
>  drivers/hwmon/sht15.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
> index a610e78..3ba7dd8 100644
> --- a/drivers/hwmon/sht15.c
> +++ b/drivers/hwmon/sht15.c
> @@ -610,7 +610,7 @@ static int __devexit sht15_remove(struct platform_device *pdev)
>  	struct sht15_data *data = platform_get_drvdata(pdev);
>  
>  	/* Make sure any reads from the device are done and
> -	 * prevent new ones beginnning */
> +	 * prevent new ones from beginning */
>  	mutex_lock(&data->read_lock);
>  	hwmon_device_unregister(data->hwmon_dev);
>  	sysfs_remove_group(&pdev->dev.kobj, &sht15_attr_group);

Applied, thanks.

-- 
Jean Delvare
