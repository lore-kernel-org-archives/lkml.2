Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1HKOuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:50:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55147 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab1HKOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:50:08 -0400
Message-ID: <4E43EC16.8090903@ti.com>
Date: Thu, 11 Aug 2011 15:49:58 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: sgtl5000: fix module device table type for sgtl5000_dt_ids
References: <1313072356.9215.0.camel@phoenix>
In-Reply-To: <1313072356.9215.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/11 15:19, Axel Lin wrote:
> The module device table for of_device_id should use "of" type.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  sound/soc/codecs/sgtl5000.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
> index 666fae6..91130fb 100644
> --- a/sound/soc/codecs/sgtl5000.c
> +++ b/sound/soc/codecs/sgtl5000.c
> @@ -1441,7 +1441,7 @@ static const struct of_device_id sgtl5000_dt_ids[] = {
>  	{ .compatible = "fsl,sgtl5000", },
>  	{ /* sentinel */ }
>  };
> -MODULE_DEVICE_TABLE(i2c, sgtl5000_dt_ids);
> +MODULE_DEVICE_TABLE(of, sgtl5000_dt_ids);
>  
>  static struct i2c_driver sgtl5000_i2c_driver = {
>  	.driver = {

Acked-by: Liam Girdwood <lrg@ti.com>
