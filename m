Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1BCJ4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 04:56:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42865 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab1BCJ4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 04:56:05 -0500
Subject: Re: [PATCH] regulator: Fix warning with CONFIG_BUG disabled
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
In-Reply-To: <1296677842-26867-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1296677842-26867-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Feb 2011 09:56:00 +0000
Message-ID: <1296726960.3456.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 20:17 +0000, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm831x-dcdc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
> index 8b0d2c4..06df898 100644
> --- a/drivers/regulator/wm831x-dcdc.c
> +++ b/drivers/regulator/wm831x-dcdc.c
> @@ -120,6 +120,7 @@ static unsigned int wm831x_dcdc_get_mode(struct regulator_dev *rdev)
>  		return REGULATOR_MODE_IDLE;
>  	default:
>  		BUG();
> +		return -EINVAL;
>  	}
>  }
>  

Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

