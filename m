Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2ACSsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:48:54 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15099 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2ACSsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:48:52 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 03 Jan 2012 10:48:31 -0800
Subject: Re: [PATCH] bq20z75: fix devicetree match table
From: Rhyland Klein <rklein@nvidia.com>
To: Olof Johansson <olof@lixom.net>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1324607824-2685-1-git-send-email-olof@lixom.net>
References: <1324607824-2685-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Jan 2012 10:46:46 -0800
Message-ID: <1325616406.13090.1.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-22 at 18:37 -0800, Olof Johansson wrote:
> It should be an of module table, not i2c.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
>  drivers/power/bq20z75.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> index ce95ff7..3efca54 100644
> --- a/drivers/power/bq20z75.c
> +++ b/drivers/power/bq20z75.c
> @@ -622,7 +622,7 @@ static const struct of_device_id bq20z75_dt_ids[] = {
>  	{ .compatible = "ti,bq20z75" },
>  	{ }
>  };
> -MODULE_DEVICE_TABLE(i2c, bq20z75_dt_ids);
> +MODULE_DEVICE_TABLE(of, bq20z75_dt_ids);
>  
>  static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
>  		struct i2c_client *client)

Acked-by: Rhyland Klein <rklein@nvidia.com>

