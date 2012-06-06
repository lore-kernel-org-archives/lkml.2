Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2FFO1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:27:46 -0400
Received: from antcom.de ([188.40.178.216]:40593 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab2FFO1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:27:45 -0400
Message-ID: <4FCF68DE.6000701@antcom.de>
Date: Wed, 06 Jun 2012 16:27:42 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v6] MTD: LPC32xx SLC NAND driver
References: <1338974414-5308-1-git-send-email-stigge@antcom.de> <1338989921.6875.50.camel@sauron.fi.intel.com>
In-Reply-To: <1338989921.6875.50.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 06/06/2012 03:38 PM, Artem Bityutskiy wrote:
>> +#else +#define lpc32xx_nand_resume NULL +#define
>> lpc32xx_nand_suspend NULL +#endif
> 
> 0, not NULL.

Can you please point me to an explanation for this? NULL sounds
natural here, since it is used as a pointer, and other nand drivers
are already doing it via NULL:

bcm_umi_nand.c
bf5xx_nand.c
pxa3xx_nand.c
r852.c
s3c2410.c
tmio_nand.c
txx9ndfmc.c

... and none is #defining as 0.

Thanks in advance,

Roland
