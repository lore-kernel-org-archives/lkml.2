Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab0CVJaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 05:30:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab0CVJaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 05:30:05 -0400
Message-ID: <4BA738CE.8000901@redhat.com>
Date: Mon, 22 Mar 2010 10:30:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc13 Thunderbird/3.0.1
MIME-Version: 1.0
To: Giel van Schijndel <me@mortis.eu>
CC: Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Hwmon: f71882fg: fixed braces coding style issues
References: <1269185834-10266-1-git-send-email-me@mortis.eu>
In-Reply-To: <1269185834-10266-1-git-send-email-me@mortis.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ack.

Acked-by: Hans de Goede <hdegoede@redhat.com>

On 03/21/2010 04:37 PM, Giel van Schijndel wrote:
> Fixed several coding style issues.
>
> Signed-off-by: Giel van Schijndel<me@mortis.eu>
> ---
>   drivers/hwmon/f71882fg.c |   11 +++++------
>   1 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
> index a95fa42..21bc661 100644
> --- a/drivers/hwmon/f71882fg.c
> +++ b/drivers/hwmon/f71882fg.c
> @@ -866,11 +866,11 @@ static int superio_inw(int base, int reg)
>   static inline void superio_enter(int base)
>   {
>   	/* according to the datasheet the key must be send twice! */
> -	outb( SIO_UNLOCK_KEY, base);
> -	outb( SIO_UNLOCK_KEY, base);
> +	outb(SIO_UNLOCK_KEY, base);
> +	outb(SIO_UNLOCK_KEY, base);
>   }
>
> -static inline void superio_select( int base, int ld)
> +static inline void superio_select(int base, int ld)
>   {
>   	outb(SIO_REG_LDSEL, base);
>   	outb(ld, base + 1);
> @@ -945,7 +945,7 @@ static struct f71882fg_data *f71882fg_update_device(struct device *dev)
>   	mutex_lock(&data->update_lock);
>
>   	/* Update once every 60 seconds */
> -	if ( time_after(jiffies, data->last_limits + 60 * HZ ) ||
> +	if (time_after(jiffies, data->last_limits + 60 * HZ) ||
>   			!data->valid) {
>   		if (data->type == f71882fg || data->type == f71889fg) {
>   			data->in1_max =
> @@ -2151,8 +2151,7 @@ static int __init f71882fg_find(int sioaddr, unsigned short *address,
>   	}
>
>   	*address = superio_inw(sioaddr, SIO_REG_ADDR);
> -	if (*address == 0)
> -	{
> +	if (*address == 0) {
>   		printk(KERN_WARNING DRVNAME ": Base address not set\n");
>   		goto exit;
>   	}
