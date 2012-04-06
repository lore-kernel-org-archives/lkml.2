Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2DFHDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 03:03:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58859 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2DFHDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 03:03:13 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>
Subject: RE: [PATCH 6/6] regulator: tps65217: Constify regulator_desc
Thread-Topic: [PATCH 6/6] regulator: tps65217: Constify regulator_desc
Thread-Index: AQHNE4yufYGoOaX/qk2JVb6/Cm89qZaNXmtw
Date: Fri, 6 Apr 2012 07:03:07 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC1317E141F@DBDE01.ent.ti.com>
References: <1333671867.2777.2.camel@phoenix>
 <1333672311.2777.9.camel@phoenix>
In-Reply-To: <1333672311.2777.9.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.31]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3673OJH032382

Hi Axel Lin,

It's completely missed from my side, thanks for the patch

ACK: AnilKumar Ch <anilkumar@ti.com>

On Fri, Apr 06, 2012 at 06:01:51, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps65217-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
> index e39521b..80fad2d 100644
> --- a/drivers/regulator/tps65217-regulator.c
> +++ b/drivers/regulator/tps65217-regulator.c
> @@ -312,7 +312,7 @@ static struct regulator_ops tps65217_pmic_ldo1_ops = {
>  	.list_voltage		= tps65217_pmic_list_voltage,
>  };
>  
> -static struct regulator_desc regulators[] = {
> +static const struct regulator_desc regulators[] = {
>  	TPS65217_REGULATOR("DCDC1", TPS65217_DCDC_1, tps65217_pmic_ops, 64),
>  	TPS65217_REGULATOR("DCDC2", TPS65217_DCDC_2, tps65217_pmic_ops, 64),
>  	TPS65217_REGULATOR("DCDC3", TPS65217_DCDC_3, tps65217_pmic_ops, 64),
> -- 
> 1.7.5.4
> 
> 
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
