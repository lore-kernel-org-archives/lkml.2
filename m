Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0FYMPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:15:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55977 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751813Ab0FYMPn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:15:43 -0400
References: <1277387389-5103-1-git-send-email-marek.vasut@gmail.com> (sfid-20100624_145209_103254_E72A93DB)
Message-Id: <915329C2-278A-4388-AA84-7EF4DF7F293E@opensource.wolfsonmicro.com>
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>
In-Reply-To: <1277387389-5103-1-git-send-email-marek.vasut@gmail.com> (sfid-20100624_145209_103254_E72A93DB)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (iPad Mail 7B367)
Subject: Re: [PATCH] tps65023: Allow registering similar TPS65021
Date: Thu, 24 Jun 2010 17:36:55 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
       Marek Vasut <marek.vasut@gmail.com>
X-Mailer: iPad Mail (7B367)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 24 Jun 2010, at 14:49, Marek Vasut <marek.vasut@gmail.com> wrote:

> TPS65021 is an older model and is slightly weaker (can supply less current),
> otherwise is the same.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

> ---
> drivers/regulator/tps65023-regulator.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
> index f50afc9..cd6d4fc 100644
> --- a/drivers/regulator/tps65023-regulator.c
> +++ b/drivers/regulator/tps65023-regulator.c
> @@ -585,6 +585,8 @@ static const struct tps_info tps65023_regs[] = {
> static const struct i2c_device_id tps_65023_id[] = {
>  	{.name = "tps65023",
>  	.driver_data = (unsigned long) tps65023_regs,},
> +	{.name = "tps65021",
> +	.driver_data = (unsigned long) tps65023_regs,},
>  	{ },
> };
> 
> -- 
> 1.7.1
> 
