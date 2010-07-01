Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0GAGQI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 02:16:08 -0400
Received: from mx2.bticino.it ([91.208.195.91]:51550 "EHLO bticino.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771Ab0GAGQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 02:16:05 -0400
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 02:16:04 EDT
Importance: Normal
X-Priority: 3 (Normal)
Sensitivity: 
In-Reply-To: <AANLkTilnVxNfsfJ4nCWITM_DhOb6BDGZQC8cMiM0RkiF@mail.gmail.com>
References: <1277707655-3468-1-git-send-email-lamiaposta71@gmail.com>,
	<AANLkTilnVxNfsfJ4nCWITM_DhOb6BDGZQC8cMiM0RkiF@mail.gmail.com>
Subject: Rif: Re: [PATCH] spi: davinci: Added support for chip select using gpio
MIME-Version: 1.0
From: raffaele.recalcati@bticino.it
To: Grant Likely <grant.likely@secretlab.ca>,
       Brian Niebuhr <bniebuhr3@gmail.com>
Cc: Raffaele Recalcati <lamiaposta71@gmail.com>,
       davinci-linux-open-source@linux.davincidsp.com,
       Davide Bonfanti <davide.bonfanti@bticino.it>,
       Russell King <linux@arm.linux.org.uk>,
       Sandeep Paulraj <s-paulraj@ti.com>, Cyril Chemparathy <cyril@ti.com>,
       Miguel Aguilar <miguel.aguilar@ridgerun.com>,
       Thomas Koeller <thomas.koeller@baslerweb.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Philby John <pjohn@in.mvista.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
X-MIMETrack: MIME-CD by HTTP Server on NOTES-VA/BTICINO/IT(Release 8.0.2 FP2|June 23, 2009) at
 01/07/2010 07.59.50,
	MIME-CD complete at 01/07/2010 07.59.51,
	Serialize by Router on IT-VAR-HUB-01/SRV/GRPLEG(Release 8.0.2 FP2|June 23, 2009) at
 01/07/2010 07.59.51
Message-ID: <OF309AC560.325C057E-ONC1257753.0020F1E5-C1257753.0020F21E@grpleg.it>
Date: Thu, 1 Jul 2010 07:59:51 +0200
X-Mailer: Lotus Domino Web Server Release 8.0.2 FP2 June 23, 2009           
Content-transfer-encoding: 8BIT
Content-Type: text/plain;
	charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----glikely@secretlab.ca ha scritto: -----

>Per: Raffaele Recalcati <lamiaposta71@gmail.com>, Brian Niebuhr
><bniebuhr3@gmail.com>
>Da: Grant Likely <grant.likely@secretlab.ca>
>Inviato da: glikely@secretlab.ca
>Data: 01/07/2010 01.03
>Cc: davinci-linux-open-source@linux.davincidsp.com, Raffaele
>Recalcati <raffaele.recalcati@bticino.it>, Davide Bonfanti
><davide.bonfanti@bticino.it>, Russell King <linux@arm.linux.org.uk>,
>Sandeep Paulraj <s-paulraj@ti.com>, Cyril Chemparathy <cyril@ti.com>,
>Miguel Aguilar <miguel.aguilar@ridgerun.com>, Thomas Koeller
><thomas.koeller@baslerweb.com>, David Brownell
><dbrownell@users.sourceforge.net>, Philby John <pjohn@in.mvista.com>,
>Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
>linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
>spi-devel-general@lists.sourceforge.net
>Oggetto: Re: [PATCH] spi: davinci: Added support for chip select
>using gpio
>
>On Mon, Jun 28, 2010 at 12:47 AM, Raffaele Recalcati
><lamiaposta71@gmail.com> wrote:
>> From: Raffaele Recalcati <raffaele.recalcati@bticino.it>
>>
>>    It is not everytime possible, due to hardware constraints,
>>    to use the hw chip select available on spi port.
>>    So I add this possibility using a gpio as chip select.
>>    If controller_data variable is not null it is
>>    the gpio to be used as chip select.
>>    The default case is compatible with evmdm365.
>>    This patch has been developed against the
>>
>http://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-davinci.
>git
>>    git tree and has been tested on bmx board (similar to dm365 evm
>but with
>>    gpio as spi chip select).
>>
>> Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
>> Signed-off-by: Davide Bonfanti <davide.bonfanti@bticino.it>
>
>The davinci SPI driver is getting completely replaced (as soon as I
>receive the respun patches), and I assume this patch will no longer
>apply after the fact, so I'm not going to pick this patch up.  You
>should coordinate with Brian Niebuhr to get this feature into his new
>driver.

I'm not very lucky with davinci-linux-open-source patching.
Thank you for the information.
The patch is really simple and so it will be not a real problem to up port
it.

I'd like anyway a timing roadmap, because,
if now the best kernel choose for dm365 is surely
http://arago-project.org/git/projects/linux-davinci.git
because of dvsdk (video codec) compatibility,
it is possible that next year 2.6.36 will be stable and compatible to dvsdk
(video codec).
The kernel of dm365 (that is a video processor) has to be compatible to its
video codec.
How to manage the transition?


>Cheers,
>g.
>
>> ---
>>  arch/arm/mach-davinci/dm365.c |   10 ++++++----
>>  drivers/spi/davinci_spi.c     |   27 ++++++++++++++++++---------
>>  2 files changed, 24 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/arm/mach-davinci/dm365.c
>b/arch/arm/mach-davinci/dm365.c
>> index a146849..42fd4a4 100644
>> --- a/arch/arm/mach-davinci/dm365.c
>> +++ b/arch/arm/mach-davinci/dm365.c
>> @@ -677,10 +677,12 @@ void __init dm365_init_spi0(unsigned
>chipselect_mask,
>>        davinci_cfg_reg(DM365_SPI0_SDO);
>>
>>        /* not all slaves will be wired up */
>> -       if (chipselect_mask & BIT(0))
>> -               davinci_cfg_reg(DM365_SPI0_SDENA0);
>> -       if (chipselect_mask & BIT(1))
>> -               davinci_cfg_reg(DM365_SPI0_SDENA1);
>> +       if  (!((unsigned long) info->controller_data)) {
>> +               if (chipselect_mask & BIT(0))
>> +                       davinci_cfg_reg(DM365_SPI0_SDENA0);
>> +               if (chipselect_mask & BIT(1))
>> +                       davinci_cfg_reg(DM365_SPI0_SDENA1);
>> +       }
>>
>>        spi_register_board_info(info, len);
>>
>> diff --git a/drivers/spi/davinci_spi.c b/drivers/spi/davinci_spi.c
>> index 95afb6b..621ae46 100644
>> --- a/drivers/spi/davinci_spi.c
>> +++ b/drivers/spi/davinci_spi.c
>> @@ -29,6 +29,7 @@
>>  #include <linux/spi/spi_bitbang.h>
>>  #include <linux/slab.h>
>>
>> +#include <mach/gpio.h>
>>  #include <mach/spi.h>
>>  #include <mach/edma.h>
>>
>> @@ -270,18 +271,26 @@ static void davinci_spi_chipselect(struct
>spi_device *spi, int value)
>>        pdata = davinci_spi->pdata;
>>
>>        /*
>> -        * Board specific chip select logic decides the polarity
>and cs
>> -        * line for the controller
>> -        */
>> +       * Board specific chip select logic decides the polarity and
>cs
>> +       * line for the controller
>> +       */
>>        if (value == BITBANG_CS_INACTIVE) {
>> -               set_io_bits(davinci_spi->base + SPIDEF,
>CS_DEFAULT);
>> -
>> -               data1_reg_val |= CS_DEFAULT << SPIDAT1_CSNR_SHIFT;
>> -               iowrite32(data1_reg_val, davinci_spi->base +
>SPIDAT1);
>> -
>> +               if  ((unsigned long) spi->controller_data) {
>> +                       gpio_set_value(spi->controller_data, \
>> +                               !(spi->mode & SPI_CS_HIGH));
>> +               } else {
>> +                       set_io_bits(davinci_spi->base + SPIDEF,
>CS_DEFAULT);
>> +
>> +                       data1_reg_val |= CS_DEFAULT <<
>SPIDAT1_CSNR_SHIFT;
>> +                       iowrite32(data1_reg_val, davinci_spi->base
>+ SPIDAT1);
>> +               }
>>                while ((ioread32(davinci_spi->base + SPIBUF)
>> -                                       & SPIBUF_RXEMPTY_MASK) ==
>0)
>> +                               & SPIBUF_RXEMPTY_MASK) == 0)
>>                        cpu_relax();
>> +       } else {
>> +               if  ((unsigned long) spi->controller_data)
>> +                       gpio_set_value(spi->controller_data, \
>> +                               (spi->mode & SPI_CS_HIGH));
>>        }
>>  }
>>
>> --
>> 1.7.0.4
>>
>>
>
>
>
>--
>Grant Likely, B.Sc., P.Eng.
>Secret Lab Technologies Ltd.

Ce message, ainsi que tous les fichiers joints à ce message,
peuvent contenir des informations sensibles et/ ou confidentielles
ne devant pas être divulguées. Si vous n'êtes pas le destinataire
de ce message (ou que vous recevez ce message par erreur), nous
vous remercions de le notifier immédiatement à son expéditeur, et
de détruire ce message. Toute copie, divulgation, modification,
utilisation ou diffusion, non autorisée, directe ou indirecte, de
tout ou partie de ce message, est strictement interdite.

This e-mail, and any document attached hereby, may contain
confidential and/or privileged information. If you are not the
intended recipient (or have received this e-mail in error) please
notify the sender immediately and destroy this e-mail. Any
unauthorized, direct or indirect, copying, disclosure, distribution
or other use of the material or parts thereof is strictly
forbidden.
