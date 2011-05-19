Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab1ESSwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:52:00 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:50475 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab1ESSv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:51:59 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=5MY7Lr4KU4vtOFSQiOedKGXxZLw@mail.gmail.com>
References: <BANLkTi=5MY7Lr4KU4vtOFSQiOedKGXxZLw@mail.gmail.com>
Date: Thu, 19 May 2011 13:51:57 -0500
Message-ID: <BANLkTim56oPzQ_knGc6ezg+9_CY2kqshqQ@mail.gmail.com>
Subject: Re: [PATCHv4 0/4] Initial support for TPS65912 PMIC
From: Margarita Olaya <magi@slimlogic.co.uk>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 16, 2011 at 6:02 PM, Margarita Olaya <magi@slimlogic.co.uk> wrote:
> Hi,
>
> This is the initial version of the TPS65912 PMIC, a power management IC
> for multimedia products.
>
> The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
> voltage to main processor and other components. The chip includes a
> GPIO module.
>
> Changes from V3:
> - split core driver into tps65912-spi and tps65912-i2c
> - create new function in regulator with common code in set/get mode
>

Do you have any comments on this version of the driver? Please let me know them.

Regards,
Margarita

> Margarita Olaya Cabrera (4):
>  mfd: tps65912: Add new mfd device
>  tps65912: irq: add interrupt controller
>  tps65912: gpio: add gpio driver
>  tps65912: add regulator driver
>
>  drivers/gpio/Kconfig                   |    6 +
>  drivers/gpio/Makefile                  |    1 +
>  drivers/gpio/tps65912-gpio.c           |  159 +++++++
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
>  13 files changed, 2009 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/gpio/tps65912-gpio.c
>  create mode 100644 drivers/mfd/tps65912-core.c
>  create mode 100644 drivers/mfd/tps65912-i2c.c
>  create mode 100644 drivers/mfd/tps65912-irq.c
>  create mode 100644 drivers/mfd/tps65912-spi.c
>  create mode 100644 drivers/regulator/tps65912-regulator.c
>  create mode 100644 include/linux/mfd/tps65912.h
>
