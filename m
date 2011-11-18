Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055Ab1KRJfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 04:35:18 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:47046 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab1KRJfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 04:35:13 -0500
Date: Fri, 18 Nov 2011 10:35:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Zac Storer <zac.3.14159@gmail.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers: hwmon: adm1031: fixed spacing coding style
 issues
Message-ID: <20111118103501.3c14d106@endymion.delvare>
In-Reply-To: <1321605413-13614-1-git-send-email-zac.3.14159@gmail.com>
References: <1321605413-13614-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011 01:36:53 -0700, Zac Storer wrote:
> Fixed spacing coding style issues.
> 
> Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
> ---
>  drivers/hwmon/adm1031.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
> index 0683e6b..694392b 100644
> --- a/drivers/hwmon/adm1031.c
> +++ b/drivers/hwmon/adm1031.c
> @@ -1058,7 +1058,7 @@ static struct adm1031_data *adm1031_update_device(struct device *dev)
>  			data->alarm &= 0xc0ff;
>  		}
>  
> -		for (chan=0; chan<(data->chip_type == adm1030 ? 1 : 2); chan++) {
> +		for (chan = 0; chan < (data->chip_type == adm1030 ? 1 : 2); chan++) {
>  			data->fan_div[chan] =
>  			    adm1031_read_value(client, ADM1031_REG_FAN_DIV(chan));
>  			data->fan_min[chan] =

Err, you apparently did not understand my request. Please send _one_
patch fixing all the adm1031 coding style issues at once.

-- 
Jean Delvare
