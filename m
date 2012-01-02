Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2ABPo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 10:44:57 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50719 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab2ABPoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 10:44:55 -0500
Message-ID: <4F01D0F4.2070301@gmail.com>
Date: Mon, 02 Jan 2012 07:44:52 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Rudolf Marek <r.marek@assembler.cz>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Olof Johansson <olof@lixom.net>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Wolfram Sang <w.sang@pengutronix.de>, Feng Tang <feng.tang@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Convert to DEFINE_PCI_DEVICE_TABLE
References: <1324956897.9775.2.camel@phoenix>
In-Reply-To: <1324956897.9775.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2011 07:34 PM, Axel Lin wrote:
> Convert static struct pci_device_id *[] to static DEFINE_PCI_DEVICE_TABLE
> tables.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> Cc: Rudolf Marek<r.marek@assembler.cz>
> Cc: Jean Delvare<khali@linux-fr.org>
> Cc: Ben Dooks<ben-linux@fluff.org>
> Cc: Olof Johansson<olof@lixom.net>
> Cc: "Mark M. Hoffman"<mhoffman@lightlink.com>
> Cc: Dirk Brandewie<dirk.brandewie@gmail.com>
> Cc: Tomoya MORINAGA<tomoya-linux@dsn.lapis-semi.com>
> Cc: Wolfram Sang<w.sang@pengutronix.de>
> Cc: Feng Tang<feng.tang@intel.com>
> Cc: Sebastian Andrzej Siewior<bigeasy@linutronix.de>
> Cc: linux-i2c@vger.kernel.org
> ---
> This patch is against linux-next tree.
> Axel
>
>   drivers/i2c/busses/i2c-ali1563.c           |    2 +-
>   drivers/i2c/busses/i2c-ali15x3.c           |    2 +-
>   drivers/i2c/busses/i2c-amd756.c            |    2 +-
>   drivers/i2c/busses/i2c-amd8111.c           |    2 +-
>   drivers/i2c/busses/i2c-designware-pcidrv.c |    2 +-
>   drivers/i2c/busses/i2c-eg20t.c             |    2 +-
>   drivers/i2c/busses/i2c-hydra.c             |    2 +-
>   drivers/i2c/busses/i2c-i801.c              |    2 +-
>   drivers/i2c/busses/i2c-intel-mid.c         |    2 +-
>   drivers/i2c/busses/i2c-nforce2.c           |    2 +-
>   drivers/i2c/busses/i2c-pasemi.c            |    2 +-
>   drivers/i2c/busses/i2c-piix4.c             |    2 +-
>   drivers/i2c/busses/i2c-pxa-pci.c           |    2 +-
>   drivers/i2c/busses/i2c-sis5595.c           |    2 +-
>   drivers/i2c/busses/i2c-sis630.c            |    2 +-
>   drivers/i2c/busses/i2c-sis96x.c            |    2 +-
>   drivers/i2c/busses/i2c-via.c               |    2 +-
>   drivers/i2c/busses/i2c-viapro.c            |    2 +-
>   drivers/i2c/busses/scx200_acb.c            |    2 +-
>   19 files changed, 19 insertions(+), 19 deletions(-)
>

> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
> index 9e89e73..37f4211 100644
> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> @@ -349,7 +349,7 @@ static void __devexit i2c_dw_pci_remove(struct pci_dev *pdev)
>   /* work with hotplug and coldplug */
>   MODULE_ALIAS("i2c_designware-pci");
>
> -DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
> +static DEFINE_PCI_DEVICE_TABLE(i2_designware_pci_ids) = {
>   	/* Moorestown */
>   	{ PCI_VDEVICE(INTEL, 0x0802), moorestown_0 },
>   	{ PCI_VDEVICE(INTEL, 0x0803), moorestown_1 },
Acked-by: Dirk Brandewie <dirk.brandewie@gmail.com>
