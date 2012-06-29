Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab2F2M4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:56:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:49189 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2F2M4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:56:40 -0400
MIME-Version: 1.0
In-Reply-To: <1340973434.3070.168.camel@sauron.fi.intel.com>
References: <1340834129-15545-1-git-send-email-stigge@antcom.de>
	<1340973434.3070.168.camel@sauron.fi.intel.com>
Date: Fri, 29 Jun 2012 09:56:39 -0300
Message-ID: <CAAAP30HZ1Z5U44wLwSEfcaJSLmVp8AbXPTCagS31hnoCy_tf-g@mail.gmail.com>
Subject: Re: [PATCH v10] MTD: LPC32xx MLC NAND driver
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: dedekind1@gmail.com
Cc: Roland Stigge <stigge@antcom.de>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dwmw2@infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 9:37 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Wed, 2012-06-27 at 23:55 +0200, Roland Stigge wrote:
>> This patch adds a driver for the MLC NAND controller of the LPC32xx SoC.
>>
>> Signed-off-by: Roland Stigge <stigge@antcom.de>
>> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>> ---
>
> Aiaiai complains like this about your patch, please, take a look:
>
> --------------------------------------------------------------------------------
>
> Successfully built configuration "arm-lpc32xx_defconfig,arm,arm-unknown-linux-gnueabi-", results:
>
> --- before_patching.log
> +++ after_patching.log
> @@ @@
> +drivers/mtd/nand/lpc32xx_mlc.c: In function 'lpc32xx_nand_probe':
> +drivers/mtd/nand/lpc32xx_mlc.c:679:10: warning: variable 'sr' set but not used [-Wunused-but-set-variable]
> +drivers/mtd/nand/lpc32xx_mlc.c:561:24: error: bad constant expression [sparse]

This build fine here, with gcc 4.5.3

Which gcc version is he using?

> --------------------------------------------------------------------------------
>
> checkpatch.pl has some complaints:
>
> --------------------------------------------------------------------------------
>
> checkpatch.pl results for patch "[PATCH] MTD: LPC32xx MLC NAND driver"
>
> ERROR:INITIALISED_STATIC: do not initialise statics to 0 or NULL
> #339: FILE: drivers/mtd/nand/lpc32xx_mlc.c:224:
> +static int use_dma = 0;
>
> total: 1 errors, 0 warnings, 1004 lines checked
>
> --------------------------------------------------------------------------------
>
> --
> Best Regards,
> Artem Bityutskiy
