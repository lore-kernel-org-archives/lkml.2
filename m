Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab2LXQKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:10:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49932 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab2LXQK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:10:29 -0500
Date: Mon, 24 Dec 2012 17:10:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
Subject: Re: [PATCH 7/7] MFD:rtsx: Fix checkpatch warning
Message-ID: <20121224161025.GF6702@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
References: <cover.1356319097.git.wei_wang@realsil.com.cn>
 <fd3b65dc90ea95d4e904885fe8eefff295450f2a.1356319097.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fd3b65dc90ea95d4e904885fe8eefff295450f2a.1356319097.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 02:03:56PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> WARNING: Avoid CamelCase: <min_N>
> +	u8 N, min_N, max_N, clk_divider;
> 
> WARNING: Avoid CamelCase: <max_N>
> +	u8 N, min_N, max_N, clk_divider;
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rtsx_pcr.c |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
> index cc28f17..f843c73 100644
> --- a/drivers/mfd/rtsx_pcr.c
> +++ b/drivers/mfd/rtsx_pcr.c
> @@ -590,7 +590,7 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
>  		u8 ssc_depth, bool initial_mode, bool double_clk, bool vpclk)
>  {
>  	int err, clk;
> -	u8 N, min_N, max_N, clk_divider;
> +	u8 n, min_n, max_n, clk_divider;
>  	u8 mcu_cnt, div, max_div;
>  	u8 depth[] = {
>  		[RTSX_SSC_DEPTH_4M] = SSC_DEPTH_4M,
> @@ -615,8 +615,8 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
>  	card_clock /= 1000000;
>  	dev_dbg(&(pcr->pci->dev), "Switch card clock to %dMHz\n", card_clock);
>  
> -	min_N = 80;
> -	max_N = 208;
> +	min_n = 80;
> +	max_n = 208;

Naked magic values? Maybe macro defines with descriptive names instead?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
