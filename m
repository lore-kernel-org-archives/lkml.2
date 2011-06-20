Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab1FTM5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 08:57:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37764 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752422Ab1FTM5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 08:57:18 -0400
Date: Mon, 20 Jun 2011 13:57:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org, dajun.chen@diasemi.com,
        linaro-dev@lists.linaro.org
Subject: Re: [PATCHv3 5/11 ] Regulator: Fixed DA9052 _sel() functions
Message-ID: <20110620125716.GC31140@opensource.wolfsonmicro.com>
References: <1308571392.3180.37.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308571392.3180.37.camel@L-0532.kpit.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 05:33:12PM +0530, ashishj3 wrote:

> --- a/drivers/regulator/da9052-regulator.c
> +++ b/drivers/regulator/da9052-regulator.c
> @@ -24,7 +24,7 @@
>  #include <linux/mfd/da9052/reg.h>
>  #include <linux/mfd/da9052/pdata.h>
>  
> -/* Buck step size Macros */
> +/* Buck step size */
>  #define DA9052_BUCK_PERI_3uV_STEP		100000
>  #define DA9052_BUCK_PERI_REG_MAP_UPTO_3uV	24
>  #define DA9052_CONST_3uV			3000000

This appears to be an incremental patch against some previous version of
the driver.  Since this driver is not yet part of Linux you need to send
it as a new patch, as a result I've not read the rest of the patch and
must once more urge you to read and follow the instructions in
SubmittingPatches.

Given the very substantial problems that this process appears to be
causing you I strongly urge you to accept the offers of help that the
Linaro team have made recently.
