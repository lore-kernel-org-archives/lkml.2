Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab2K2LSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 06:18:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41002 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645Ab2K2LS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 06:18:28 -0500
Date: Thu, 29 Nov 2012 11:18:27 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5102: Correct default for LDO1_CONTROL_2
Message-ID: <20121129111827.GB22736@opensource.wolfsonmicro.com>
References: <1354128448-12664-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354128448-12664-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 06:47:28PM +0000, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5102-tables.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/wm5102-tables.c b/drivers/mfd/wm5102-tables.c
> index 50bbe15..065ffd3 100644
> --- a/drivers/mfd/wm5102-tables.c
> +++ b/drivers/mfd/wm5102-tables.c
> @@ -307,6 +307,7 @@ static const struct reg_default wm5102_reg_default[] = {
>  	{ 0x000001AA, 0x0004 },   /* R426   - FLL2 GPIO Clock */ 
>  	{ 0x00000200, 0x0006 },   /* R512   - Mic Charge Pump 1 */ 
>  	{ 0x00000210, 0x00D4 },   /* R528   - LDO1 Control 1 */ 
> +	{ 0x00000212, 0x0001 },   /* R530   - LDO1 Control 2 */ 

The default for this register is changed in the register patch to
zero should we not leave this setting at zero to match?
