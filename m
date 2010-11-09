Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab0KICtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:49:07 -0500
Received: from toronto-hs-216-138-233-67.s-ip.magma.ca ([216.138.233.67]:38559
	"HELO yow.seanm.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754722Ab0KICtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:49:06 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Nov 2010 21:49:06 EST
Date: Mon, 8 Nov 2010 21:41:42 -0500
From: Sean MacLennan <smaclennan@pikatech.com>
To: "Axel Lin" <axel.lin@gmail.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Jean Delvare" <khali@linux-fr.org>, <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: (ad7414) Return proper error code for
 ad7414_probe()
Message-ID: <20101108214142.6e2556ac@lappy.seanm.ca>
In-Reply-To: <1289266834.14461.3.camel@mola>
References: <1289266834.14461.3.camel@mola>
Organization: PIKA
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.14.7; i686-pc-linux-gnu)
X-Message-Flag: Warning: This message may contain actual content.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Nov 2010 20:40:34 -0500
"Axel Lin" <axel.lin@gmail.com> wrote:

> [PATCH] hwmon: (ad7414) Return proper error code for ad7414_probe()
> 
> Return proper error if i2c_check_functionality reports
> the adapter does not support the capability we need.
> 
> Also remove unneeded initialization for err variable.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Sean MacLennan <smaclennan@pikatech.com>

> ---
>  drivers/hwmon/ad7414.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
> index 1e4c21f..86d822a 100644
> --- a/drivers/hwmon/ad7414.c
> +++ b/drivers/hwmon/ad7414.c
> @@ -178,11 +178,13 @@ static int ad7414_probe(struct i2c_client
> *client, {
>         struct ad7414_data *data;
>         int conf;
> -       int err = 0;
> +       int err;

I wouldn't mind if this was "int conf, err;", but I don't mind the way
it is.

Cheers,
   Sean
