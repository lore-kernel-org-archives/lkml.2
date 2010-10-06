Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332Ab0JFGMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 02:12:35 -0400
Received: from compulab.co.il ([67.18.134.219]:43693 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab0JFGMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 02:12:34 -0400
Message-ID: <4CAC1347.3000301@compulab.co.il>
Date: Wed, 06 Oct 2010 08:12:23 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20100106)
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: achew@nvidia.com, axel.lin@gmail.com, gking@nvidia.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mfd: Add TPS658621C device ID
References: <1286317946-11170-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1286317946-11170-1-git-send-email-achew@nvidia.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Can you please queue this?

achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> The interface for this device should be identical to that of the
> TPS658521A.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>

Acked-by: Mike Rapoport <mike@compulab.co.il>

> ---
>  drivers/mfd/tps6586x.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
> index 117eb7c..b4931ab 100644
> --- a/drivers/mfd/tps6586x.c
> +++ b/drivers/mfd/tps6586x.c
> @@ -47,6 +47,7 @@
>  /* device id */
>  #define TPS6586X_VERSIONCRC	0xcd
>  #define TPS658621A_VERSIONCRC	0x15
> +#define TPS658621C_VERSIONCRC	0x2c
>  
>  struct tps6586x_irq_data {
>  	u8	mask_reg;
> @@ -497,7 +498,8 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
>  		return -EIO;
>  	}
>  
> -	if (ret != TPS658621A_VERSIONCRC) {
> +	if ((ret != TPS658621A_VERSIONCRC) &&
> +	    (ret != TPS658621C_VERSIONCRC)) {
>  		dev_err(&client->dev, "Unsupported chip ID: %x\n", ret);
>  		return -ENODEV;
>  	}


-- 
Sincerely yours,
Mike.
