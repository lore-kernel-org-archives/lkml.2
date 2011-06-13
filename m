Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1FMV47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:56:59 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:43685 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab1FMV45 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikye+vb1WJ08rup23=APxuOENK+Tw@mail.gmail.com>
References: <BANLkTikye+vb1WJ08rup23=APxuOENK+Tw@mail.gmail.com>
Date: Mon, 13 Jun 2011 16:56:54 -0500
Message-ID: <BANLkTin+E1mbMFURSADKC3bm5BeeczHW7A@mail.gmail.com>
Subject: Re: [PATCHv5 0/4]Initial support for TPS65912 PMIC
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca, "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Thu, Jun 9, 2011 at 2:49 PM, Margarita Olaya <magi@slimlogic.co.uk> wrote:
> Hi,
>
> This is the initial version of the TPS65912 PMIC, a power management IC
> for multimedia products.
>
> The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
> voltage to main processor and other components. The chip includes a
> GPIO module.
>

All the patches have the ack, are you going to take them via MFD tree?

Thanks,
Margarita

> Changes from v4:
> - Rename tps65912-gpio.c as gpio-tps65912.c
> - Update the gpio makefile using the new name
> - Keep alphabetic order in Kconfig
> - Add base and ngpio to template_chip struct
>
> Margarita Olaya Cabrera (4):
>  mfd: tps65912: Add new mfd device
>  tps65912: irq: add interrupt controller
>  tps65912: gpio: add gpio driver
>  tps65912: add regulator driver
>
>  drivers/gpio/Kconfig                   |    6 +
>  drivers/gpio/Makefile                  |    1 +
>  drivers/gpio/gpio-tps65912.c           |  156 +++++++
>  drivers/mfd/Kconfig                    |   22 +
>  drivers/mfd/Makefile                   |    4 +
>  drivers/mfd/tps65912-core.c            |  177 +++++++
>  drivers/mfd/tps65912-i2c.c             |  139 ++++++
>  drivers/mfd/tps65912-irq.c             |  225 +++++++++
>  drivers/mfd/tps65912-spi.c             |  142 ++++++
>  drivers/regulator/Kconfig              |    6 +
>  drivers/regulator/Makefile             |    1 +
>  drivers/regulator/tps65912-regulator.c |  800 ++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps65912.h           |  327 +++++++++++++
>  13 files changed, 2006 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/gpio-tps65912.c
>  create mode 100644 drivers/mfd/tps65912-core.c
>  create mode 100644 drivers/mfd/tps65912-i2c.c
>  create mode 100644 drivers/mfd/tps65912-irq.c
>  create mode 100644 drivers/mfd/tps65912-spi.c
>  create mode 100644 drivers/regulator/tps65912-regulator.c
>  create mode 100644 include/linux/mfd/tps65912.h
>
