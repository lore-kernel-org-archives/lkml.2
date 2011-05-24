Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab1EXTJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 15:09:16 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4096 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab1EXTJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 15:09:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 24 May 2011 12:09:14 -0700
Subject: Re: [PATCH 2/2] power: bq20z75: enable detection after registering
From: Rhyland Klein <rklein@nvidia.com>
To: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>
Cc: "bleung@chromium.org" <bleung@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1306263960-1236-2-git-send-email-rklein@nvidia.com>
References: <1306263960-1236-1-git-send-email-rklein@nvidia.com>
	 <1306263960-1236-2-git-send-email-rklein@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 12:07:33 -0700
Message-ID: <1306264053.31129.5.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 12:06 -0700, Rhyland Klein wrote:
> Need to enable detection, which is also blocking the unit conversion logic
> after registering the power_supply.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
> v2:	This should have been adding the line, not removing it. Fixed that.
> 
>  drivers/power/bq20z75.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> index e1adc0e..9c5e5be 100644
> --- a/drivers/power/bq20z75.c
> +++ b/drivers/power/bq20z75.c
> @@ -702,6 +702,8 @@ skip_gpio:
>  
>  	INIT_DELAYED_WORK(&bq20z75_device->work, bq20z75_delayed_work);
>  
> +	bq20z75_device->enable_detection = true;
> +
>  	return 0;
>  
>  exit_psupply:

ignore this patch, sent updated patch with proper version tag in
subject.

-rhyland


