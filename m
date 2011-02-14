Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab1BNDrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 22:47:00 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35498 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab1BNDq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 22:46:57 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikpR4191DrgyodXV-Qx=r8mjXziknzJ8tJpgBt9@mail.gmail.com>
References: <AANLkTikM0bZbRfSPeXjf4NVn_AAHm1w7FWRKYvoucdHj@mail.gmail.com> <AANLkTikpR4191DrgyodXV-Qx=r8mjXziknzJ8tJpgBt9@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sun, 13 Feb 2011 20:46:34 -0700
X-Google-Sender-Auth: wumXbrRZgCXues66F6Szar2s2E4
Message-ID: <AANLkTimbsKh3P2QQpJOYZQKNkKJkANm1qGr1g0y-aRpi@mail.gmail.com>
Subject: [git pull] Documentation changes and an SPI bug fix
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        spi-devel-general@lists.sourceforge.net,
        linuxppc-dev <linuxppc-dev@ozlabs.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend: Android insisted on sending HTML, so it was rejected by LKML]

Hi Linus,

A set of mostly documentation changes, but I also had an spi bug fix
that I needed to send to you, so I've sent it all in one pull req.

g.

The following changes since commit d2478521afc20227658a10a8c5c2bf1a2aa615b3:

char/ipmi: fix OOPS caused by pnp_unregister_driver on unregistered
driver (2011-02-10 18:00:21 -0800)

are available in the git repository at:
git://git.secretlab.ca/git/linux-2.6 spi/merge

Grant Likely (5):
dt: Move device tree documentation out of powerpc directory
dt: Remove obsolete description of powerpc boot interface
dt: add documentation of ARM dt boot interface
MAINTAINERS: Add entry for GPIO subsystem
Merge branch 'devicetree/merge' into spi/merge

Guennadi Liakhovetski (1):
spi/spi_sh_msiof: fix wrong address calculation, which leads to an Oops

Paul Bolle (1):
devicetree-discuss is moderated for non-subscribers

Documentation/arm/Booting | 33 +++-
.../bindings/ata/fsl-sata.txt} | 0
.../bindings}/eeprom.txt | 0
.../fsl => devicetree/bindings/gpio}/8xxx_gpio.txt | 0
.../bindings}/gpio/gpio.txt | 0
.../bindings}/gpio/led.txt | 0
.../bindings/i2c/fsl-i2c.txt} | 0
.../bindings}/marvell.txt | 0
.../bindings/mmc/fsl-esdhc.txt} | 0
.../bindings/mmc}/mmc-spi-slot.txt | 0
.../bindings/mtd/fsl-upm-nand.txt} | 0
.../bindings/mtd}/mtd-physmap.txt | 0
.../bindings/net/can/mpc5xxx-mscan.txt} | 0
.../bindings/net}/can/sja1000.txt | 0
.../bindings/net/fsl-tsec-phy.txt} | 0
.../bindings/net/mdio-gpio.txt} | 0
.../bindings/net}/phy.txt | 0
.../bindings/pci}/83xx-512x-pci.txt | 0
.../bindings/powerpc}/4xx/cpm.txt | 0
.../bindings/powerpc}/4xx/emac.txt | 0
.../bindings/powerpc}/4xx/ndfc.txt | 0
.../bindings/powerpc}/4xx/ppc440spe-adma.txt | 0
.../bindings/powerpc}/4xx/reboot.txt | 0
.../bindings/powerpc}/fsl/board.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/cpm.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/cpm/brg.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/cpm/i2c.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/cpm/pic.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/cpm/usb.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/gpio.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/network.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/qe.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/qe/firmware.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/qe/par_io.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/qe/pincfg.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/qe/ucc.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/qe/usb.txt | 0
.../bindings/powerpc}/fsl/cpm_qe/serial.txt | 0
.../bindings/powerpc}/fsl/diu.txt | 0
.../bindings/powerpc}/fsl/dma.txt | 0
.../bindings/powerpc/fsl}/ecm.txt | 0
.../bindings/powerpc}/fsl/gtm.txt | 0
.../bindings/powerpc}/fsl/guts.txt | 0
.../bindings/powerpc}/fsl/lbc.txt | 0
.../bindings/powerpc}/fsl/mcm.txt | 0
.../bindings/powerpc}/fsl/mcu-mpc8349emitx.txt | 0
.../bindings/powerpc}/fsl/mpc5121-psc.txt | 0
.../bindings/powerpc}/fsl/mpc5200.txt | 0
.../bindings/powerpc}/fsl/mpic.txt | 0
.../bindings/powerpc}/fsl/msi-pic.txt | 0
.../bindings/powerpc}/fsl/pmc.txt | 0
.../bindings/powerpc}/fsl/sec.txt | 0
.../bindings/powerpc}/fsl/ssi.txt | 0
.../bindings/powerpc}/nintendo/gamecube.txt | 0
.../bindings/powerpc}/nintendo/wii.txt | 0
.../bindings/spi/fsl-spi.txt} | 0
.../bindings/spi}/spi-bus.txt | 0
.../bindings/usb/fsl-usb.txt} | 0
.../bindings/usb}/usb-ehci.txt | 0
.../bindings}/xilinx.txt | 0
.../{powerpc => devicetree}/booting-without-of.txt | 193 +++++++++-----------
MAINTAINERS | 11 +-
drivers/spi/spi_sh_msiof.c | 6 +-
63 files changed, 131 insertions(+), 112 deletions(-)
rename Documentation/{powerpc/dts-bindings/fsl/sata.txt =>
devicetree/bindings/ata/fsl-sata.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings}/eeprom.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl =>
devicetree/bindings/gpio}/8xxx_gpio.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings}/gpio/gpio.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings}/gpio/led.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl/i2c.txt =>
devicetree/bindings/i2c/fsl-i2c.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings}/marvell.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl/esdhc.txt =>
devicetree/bindings/mmc/fsl-esdhc.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/mmc}/mmc-spi-slot.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl/upm-nand.txt =>
devicetree/bindings/mtd/fsl-upm-nand.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/mtd}/mtd-physmap.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl/can.txt =>
devicetree/bindings/net/can/mpc5xxx-mscan.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/net}/can/sja1000.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl/tsec.txt =>
devicetree/bindings/net/fsl-tsec-phy.txt} (100%)
rename Documentation/{powerpc/dts-bindings/gpio/mdio.txt =>
devicetree/bindings/net/mdio-gpio.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/net}/phy.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl =>
devicetree/bindings/pci}/83xx-512x-pci.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/4xx/cpm.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/4xx/emac.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/4xx/ndfc.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/4xx/ppc440spe-adma.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/4xx/reboot.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/board.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/cpm.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/cpm/brg.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/cpm/i2c.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/cpm/pic.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/cpm/usb.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/gpio.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/network.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/qe.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/qe/firmware.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/qe/par_io.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/qe/pincfg.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/qe/ucc.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/qe/usb.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/cpm_qe/serial.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/diu.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/dma.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc/fsl}/ecm.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/gtm.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/guts.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/lbc.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/mcm.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/mcu-mpc8349emitx.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/mpc5121-psc.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/mpc5200.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/mpic.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/msi-pic.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/pmc.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/sec.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/fsl/ssi.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/nintendo/gamecube.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/powerpc}/nintendo/wii.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl/spi.txt =>
devicetree/bindings/spi/fsl-spi.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/spi}/spi-bus.txt (100%)
rename Documentation/{powerpc/dts-bindings/fsl/usb.txt =>
devicetree/bindings/usb/fsl-usb.txt} (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings/usb}/usb-ehci.txt (100%)
rename Documentation/{powerpc/dts-bindings =>
devicetree/bindings}/xilinx.txt (100%)
rename Documentation/{powerpc => devicetree}/booting-without-of.txt (90%)

--
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
