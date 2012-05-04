Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab2EDIa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 04:30:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60529 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab2EDIaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 04:30:24 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "J, KEERTHY" <j-keerthy@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
CC: "Pihet-XID, Jean" <j-pihet@ti.com>
Subject: RE: [PATCH V3 04/10] ARM: OMAP3: hwmod: rename the smartreflex
 entries
Thread-Topic: [PATCH V3 04/10] ARM: OMAP3: hwmod: rename the smartreflex
 entries
Thread-Index: AQHNI9P3ZOfXTlLe50yyQg8gLg33epa5V1pA
Date: Fri, 4 May 2012 08:30:12 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9B1AA2@DBDE01.ent.ti.com>
References: <1335462041-4949-1-git-send-email-j-keerthy@ti.com>
 <1335462041-4949-5-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1335462041-4949-5-git-send-email-j-keerthy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.132.210]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 23:10:35, J, KEERTHY wrote:
> From: Jean Pihet <j-pihet@ti.com>
> 
> Change the name field value to better reflect the smartreflex
> integration in the system.
> 
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |    8 ++++----
>  arch/arm/mach-omap2/smartreflex.c          |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> index 144d118..15907b0 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -1324,7 +1324,7 @@ static struct omap_hwmod_irq_info omap3_smartreflex_mpu_irqs[] = {
>  };
>  
>  static struct omap_hwmod omap34xx_sr1_hwmod = {
> -	.name		= "sr1",
> +	.name		= "smartreflex_mpu_iva",
>  	.class		= &omap34xx_smartreflex_hwmod_class,
>  	.main_clk	= "sr1_fck",
>  	.prcm		= {
> @@ -1342,7 +1342,7 @@ static struct omap_hwmod omap34xx_sr1_hwmod = {
>  };
>  
>  static struct omap_hwmod omap36xx_sr1_hwmod = {
> -	.name		= "sr1",
> +	.name		= "smartreflex_mpu_iva",
>  	.class		= &omap36xx_smartreflex_hwmod_class,
>  	.main_clk	= "sr1_fck",
>  	.prcm		= {
> @@ -1369,7 +1369,7 @@ static struct omap_hwmod_irq_info omap3_smartreflex_core_irqs[] = {
>  };
>  
>  static struct omap_hwmod omap34xx_sr2_hwmod = {
> -	.name		= "sr2",
> +	.name		= "smartreflex_core",
>  	.class		= &omap34xx_smartreflex_hwmod_class,
>  	.main_clk	= "sr2_fck",
>  	.prcm		= {
> @@ -1387,7 +1387,7 @@ static struct omap_hwmod omap34xx_sr2_hwmod = {
>  };
>  
>  static struct omap_hwmod omap36xx_sr2_hwmod = {
> -	.name		= "sr2",
> +	.name		= "smartreflex_core",
>  	.class		= &omap36xx_smartreflex_hwmod_class,
>  	.main_clk	= "sr2_fck",
>  	.prcm		= {
> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> index 2edd1e2..d859277 100644
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -183,7 +183,7 @@ static void sr_set_regfields(struct omap_sr *sr)
>  		sr->err_weight = OMAP3430_SR_ERRWEIGHT;
>  		sr->err_maxlimit = OMAP3430_SR_ERRMAXLIMIT;
>  		sr->accum_data = OMAP3430_SR_ACCUMDATA;
> -		if (!(strcmp(sr->name, "sr1"))) {
> +		if (!(strcmp(sr->name, "smartreflex_mpu_iva"))) {

What if voltage rail is different for mpu and iva? I have seen some devices
supports SmartReflex have different voltage rails for mpu and iva.

Regards
AnilKumar
