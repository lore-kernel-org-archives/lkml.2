Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2AWT3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:29:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5206 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab2AWT3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:29:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Mon, 23 Jan 2012 11:29:10 -0800
Subject: Re: [PATCH] power_supply: Convert power_supply i2c drivers to
 module_i2c_driver
From: Rhyland Klein <rklein@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, Woogyom Kim <milo.kim@ti.com>,
        Daniel Jeong <daniel.jeong@ti.com>, Minkyu Kang <mk7.kang@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Peter Edwards <sweetlilmre@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
In-Reply-To: <1327128174.24831.1.camel@phoenix>
References: <1327128174.24831.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Jan 2012 11:28:21 -0800
Message-ID: <1327346901.29206.1.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 22:42 -0800, Axel Lin wrote:
> diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
> index 9ff8af0..4f05498 100644
> --- a/drivers/power/sbs-battery.c
> +++ b/drivers/power/sbs-battery.c
> @@ -853,17 +853,7 @@ static struct i2c_driver sbs_battery_driver = {
>  	},
>  };
>  
> -static int __init sbs_battery_init(void)
> -{
> -	return i2c_add_driver(&sbs_battery_driver);
> -}
> -module_init(sbs_battery_init);
> -
> -static void __exit sbs_battery_exit(void)
> -{
> -	i2c_del_driver(&sbs_battery_driver);
> -}
> -module_exit(sbs_battery_exit);
> +module_i2c_driver(sbs_battery_driver);

For sbs-battery
Acked-by Rhyland Klein <rklein@nvidia.com>

-Rhyland

