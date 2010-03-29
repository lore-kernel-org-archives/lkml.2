Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab0C2Mup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 08:50:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43570 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752011Ab0C2Muo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 08:50:44 -0400
Date: Mon, 29 Mar 2010 13:50:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 1/5] Move TPS6507x register definition to header file.
Message-ID: <20100329125042.GB8434@rakim.wolfsonmicro.main>
References: <1269634292-29686-1-git-send-email-todd.fischer@ridgerun.com>
 <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269634292-29686-2-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: Uncompensated overtime?  Just Say No.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 02:11:28PM -0600, Todd Fischer wrote:
> Other sub-drivers for the TPS6507x chip will need to use register 
> definition so move it out of the source file and into a header file.

This....

> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 04f2e08..f090829 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -190,6 +190,7 @@ config REGULATOR_TPS65023
>  config REGULATOR_TPS6507X
>  	tristate "TI TPS6507X Power regulators"
>  	depends on I2C
> +	depends on CPU_FREQ
>  	help

...doesn't match up with this change (which seems bogus anyway).  The
register move itself seems fine.
