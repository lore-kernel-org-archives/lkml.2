Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1A1WKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 17:10:19 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:35065 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab1A1WKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 17:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iYF1FGsygwXSFrLGoLrT/PgIhMYZC44wSv7F5VE1VkhnVd9JLV+tMug+uAxMeKv37s
         35VbNJsJQ/crg9Xol8cnDu8C9ExWqkdhGuEdajvE5tZ7WZmEXjuZkn/N7L1QxBUHzqBx
         3s6jVoP8Oy1l/jpXzWybNrmzFq1XRxSP4S4VM=
Date: Fri, 28 Jan 2011 14:09:52 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer@nvidia.com
Cc: olof@lixom.net, achew@nvidia.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v1] input: tegra-kbc: Fix build error.
Message-ID: <20110128220952.GK6252@core.coreip.homeip.net>
References: <1296252213-15003-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296252213-15003-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 02:03:33PM -0800, riyer@nvidia.com wrote:
> From: Rakesh Iyer <riyer@nvidia.com>
> 
> Fix build error introduced by variable name change.
> 

Did I manage to pick up wrong version?

> Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> ---
>  drivers/input/keyboard/tegra-kbc.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> index 6ca903a..ac471b7 100644
> --- a/drivers/input/keyboard/tegra-kbc.c
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -355,8 +355,8 @@ static void tegra_kbc_config_pins(struct tegra_kbc *kbc)
>  	for (i = 0; i < KBC_MAX_GPIO; i++) {
>  		u32 r_shft = 5 * (i % 6);
>  		u32 c_shft = 4 * (i % 8);
> -		u32 r_mask = 0x1f << r_shift;
> -		u32 c_mask = 0x0f << c_shift;
> +		u32 r_mask = 0x1f << r_shft;
> +		u32 c_mask = 0x0f << c_shft;
>  		u32 r_offs = (i / 6) * 4 + KBC_ROW_CFG0_0;
>  		u32 c_offs = (i / 8) * 4 + KBC_COL_CFG0_0;
>  		u32 row_cfg = readl(kbc->mmio + r_offs);
> -- 
> 1.7.0.4
> 

-- 
Dmitry
