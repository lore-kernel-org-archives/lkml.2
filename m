Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761117Ab2EIUkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:40:07 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42856 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab2EIUkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:40:06 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mfd: tps65217: Staticise non-exported
 tps65217_update_bis()
Thread-Topic: [PATCH] mfd: tps65217: Staticise non-exported
 tps65217_update_bis()
Thread-Index: AQHNLiDd4JPbg1qUpEeQPb6f1rA20JbB6oeQ
Date: Wed, 9 May 2012 20:39:58 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9B95BF@DBDE01.ent.ti.com>
References: <1336594685-20954-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1336594685-20954-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for the patch

Acked-by: AnilKumar Ch <anilkumar@ti.com>

On Thu, May 10, 2012 at 01:48:05, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/tps65217.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
> index f7d854e..1c0fd2b 100644
> --- a/drivers/mfd/tps65217.c
> +++ b/drivers/mfd/tps65217.c
> @@ -96,7 +96,7 @@ EXPORT_SYMBOL_GPL(tps65217_reg_write);
>   * @val: Value to write.
>   * @level: Password protected level
>   */
> -int tps65217_update_bits(struct tps65217 *tps, unsigned int reg,
> +static int tps65217_update_bits(struct tps65217 *tps, unsigned int reg,
>  		unsigned int mask, unsigned int val, unsigned int level)
>  {
>  	int ret;
> -- 
> 1.7.10
> 
> 

