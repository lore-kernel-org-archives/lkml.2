Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1AaUYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:24:00 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:48741 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab1AaUX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:23:59 -0500
Subject: [PATCH v3 1/3] dt: Move device tree documentation out of powerpc
	directory
To: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, sam@ravnborg.org
Date: Mon, 31 Jan 2011 13:23:47 -0700
Message-ID: <20110131202201.12821.69418.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree is used by more than just PowerPC.  Make the documentation
directory available to all.

v2: reorganized files while moving to create arch and driver specific
    directories.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
---

Oops; resending 1/3 because last post sent raw patch which is too big
for the lists.  This repost uses the git file rename diff format.

Sorry for the noise.

g.

 Documentation/devicetree/bindings/ata/fsl-sata.txt |    0 
 Documentation/devicetree/bindings/eeprom.txt       |    0 
 .../devicetree/bindings/gpio/8xxx_gpio.txt         |    0 
 Documentation/devicetree/bindings/gpio/gpio.txt    |    0 
 Documentation/devicetree/bindings/gpio/led.txt     |    0 
 Documentation/devicetree/bindings/i2c/fsl-i2c.txt  |    0 
 Documentation/devicetree/bindings/marvell.txt      |    0 
 .../devicetree/bindings/mmc/fsl-esdhc.txt          |    0 
 .../devicetree/bindings/mmc/mmc-spi-slot.txt       |    0 
 .../devicetree/bindings/mtd/fsl-upm-nand.txt       |    0 
 .../devicetree/bindings/mtd/mtd-physmap.txt        |    0 
 .../devicetree/bindings/net/can/mpc5xxx-mscan.txt  |    0 
 .../devicetree/bindings/net/can/sja1000.txt        |    0 
 .../devicetree/bindings/net/fsl-tsec-phy.txt       |    0 
 .../devicetree/bindings/net/mdio-gpio.txt          |    0 
 Documentation/devicetree/bindings/net/phy.txt      |    0 
 .../devicetree/bindings/pci/83xx-512x-pci.txt      |    0 
 .../devicetree/bindings/powerpc/4xx/cpm.txt        |    0 
 .../devicetree/bindings/powerpc/4xx/emac.txt       |    0 
 .../devicetree/bindings/powerpc/4xx/ndfc.txt       |    0 
 .../bindings/powerpc/4xx/ppc440spe-adma.txt        |    0 
 .../devicetree/bindings/powerpc/4xx/reboot.txt     |    0 
 .../devicetree/bindings/powerpc/fsl/board.txt      |    0 
 .../devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt |    0 
 .../bindings/powerpc/fsl/cpm_qe/cpm/brg.txt        |    0 
 .../bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt        |    0 
 .../bindings/powerpc/fsl/cpm_qe/cpm/pic.txt        |    0 
 .../bindings/powerpc/fsl/cpm_qe/cpm/usb.txt        |    0 
 .../bindings/powerpc/fsl/cpm_qe/gpio.txt           |    0 
 .../bindings/powerpc/fsl/cpm_qe/network.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt  |    0 
 .../bindings/powerpc/fsl/cpm_qe/qe/firmware.txt    |    0 
 .../bindings/powerpc/fsl/cpm_qe/qe/par_io.txt      |    0 
 .../bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt      |    0 
 .../bindings/powerpc/fsl/cpm_qe/qe/ucc.txt         |    0 
 .../bindings/powerpc/fsl/cpm_qe/qe/usb.txt         |    0 
 .../bindings/powerpc/fsl/cpm_qe/serial.txt         |    0 
 .../devicetree/bindings/powerpc/fsl/diu.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/dma.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/ecm.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/gtm.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/guts.txt       |    0 
 .../devicetree/bindings/powerpc/fsl/lbc.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/mcm.txt        |    0 
 .../bindings/powerpc/fsl/mcu-mpc8349emitx.txt      |    0 
 .../bindings/powerpc/fsl/mpc5121-psc.txt           |    0 
 .../devicetree/bindings/powerpc/fsl/mpc5200.txt    |    0 
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |    0 
 .../devicetree/bindings/powerpc/fsl/msi-pic.txt    |    0 
 .../devicetree/bindings/powerpc/fsl/pmc.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/sec.txt        |    0 
 .../devicetree/bindings/powerpc/fsl/ssi.txt        |    0 
 .../bindings/powerpc/nintendo/gamecube.txt         |    0 
 .../devicetree/bindings/powerpc/nintendo/wii.txt   |    0 
 Documentation/devicetree/bindings/spi/fsl-spi.txt  |    0 
 Documentation/devicetree/bindings/spi/spi-bus.txt  |    0 
 Documentation/devicetree/bindings/usb/fsl-usb.txt  |    0 
 Documentation/devicetree/bindings/usb/usb-ehci.txt |    0 
 Documentation/devicetree/bindings/xilinx.txt       |    0 
 Documentation/devicetree/booting-without-of.txt    |    0 
 60 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{powerpc/dts-bindings/fsl/sata.txt => devicetree/bindings/ata/fsl-sata.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/eeprom.txt => devicetree/bindings/eeprom.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/8xxx_gpio.txt => devicetree/bindings/gpio/8xxx_gpio.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/gpio/gpio.txt => devicetree/bindings/gpio/gpio.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/gpio/led.txt => devicetree/bindings/gpio/led.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/i2c.txt => devicetree/bindings/i2c/fsl-i2c.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/marvell.txt => devicetree/bindings/marvell.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/esdhc.txt => devicetree/bindings/mmc/fsl-esdhc.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/mmc-spi-slot.txt => devicetree/bindings/mmc/mmc-spi-slot.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/upm-nand.txt => devicetree/bindings/mtd/fsl-upm-nand.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/mtd-physmap.txt => devicetree/bindings/mtd/mtd-physmap.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/can.txt => devicetree/bindings/net/can/mpc5xxx-mscan.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/can/sja1000.txt => devicetree/bindings/net/can/sja1000.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/tsec.txt => devicetree/bindings/net/fsl-tsec-phy.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/gpio/mdio.txt => devicetree/bindings/net/mdio-gpio.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/phy.txt => devicetree/bindings/net/phy.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/83xx-512x-pci.txt => devicetree/bindings/pci/83xx-512x-pci.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/4xx/cpm.txt => devicetree/bindings/powerpc/4xx/cpm.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/4xx/emac.txt => devicetree/bindings/powerpc/4xx/emac.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/4xx/ndfc.txt => devicetree/bindings/powerpc/4xx/ndfc.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/4xx/ppc440spe-adma.txt => devicetree/bindings/powerpc/4xx/ppc440spe-adma.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/4xx/reboot.txt => devicetree/bindings/powerpc/4xx/reboot.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/board.txt => devicetree/bindings/powerpc/fsl/board.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/cpm.txt => devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt => devicetree/bindings/powerpc/fsl/cpm_qe/cpm/brg.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt => devicetree/bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt => devicetree/bindings/powerpc/fsl/cpm_qe/cpm/pic.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt => devicetree/bindings/powerpc/fsl/cpm_qe/cpm/usb.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/gpio.txt => devicetree/bindings/powerpc/fsl/cpm_qe/gpio.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/network.txt => devicetree/bindings/powerpc/fsl/cpm_qe/network.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/qe.txt => devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt => devicetree/bindings/powerpc/fsl/cpm_qe/qe/firmware.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt => devicetree/bindings/powerpc/fsl/cpm_qe/qe/par_io.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt => devicetree/bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt => devicetree/bindings/powerpc/fsl/cpm_qe/qe/ucc.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt => devicetree/bindings/powerpc/fsl/cpm_qe/qe/usb.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/cpm_qe/serial.txt => devicetree/bindings/powerpc/fsl/cpm_qe/serial.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/diu.txt => devicetree/bindings/powerpc/fsl/diu.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/dma.txt => devicetree/bindings/powerpc/fsl/dma.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/ecm.txt => devicetree/bindings/powerpc/fsl/ecm.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/gtm.txt => devicetree/bindings/powerpc/fsl/gtm.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/guts.txt => devicetree/bindings/powerpc/fsl/guts.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/lbc.txt => devicetree/bindings/powerpc/fsl/lbc.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/mcm.txt => devicetree/bindings/powerpc/fsl/mcm.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt => devicetree/bindings/powerpc/fsl/mcu-mpc8349emitx.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/mpc5121-psc.txt => devicetree/bindings/powerpc/fsl/mpc5121-psc.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/mpc5200.txt => devicetree/bindings/powerpc/fsl/mpc5200.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/mpic.txt => devicetree/bindings/powerpc/fsl/mpic.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/msi-pic.txt => devicetree/bindings/powerpc/fsl/msi-pic.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/pmc.txt => devicetree/bindings/powerpc/fsl/pmc.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/sec.txt => devicetree/bindings/powerpc/fsl/sec.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/ssi.txt => devicetree/bindings/powerpc/fsl/ssi.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/nintendo/gamecube.txt => devicetree/bindings/powerpc/nintendo/gamecube.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/nintendo/wii.txt => devicetree/bindings/powerpc/nintendo/wii.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/spi.txt => devicetree/bindings/spi/fsl-spi.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/spi-bus.txt => devicetree/bindings/spi/spi-bus.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/fsl/usb.txt => devicetree/bindings/usb/fsl-usb.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/usb-ehci.txt => devicetree/bindings/usb/usb-ehci.txt} (100%)
 rename Documentation/{powerpc/dts-bindings/xilinx.txt => devicetree/bindings/xilinx.txt} (100%)
 rename Documentation/{powerpc/booting-without-of.txt => devicetree/booting-without-of.txt} (100%)

diff --git a/Documentation/powerpc/dts-bindings/fsl/sata.txt b/Documentation/devicetree/bindings/ata/fsl-sata.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/sata.txt
rename to Documentation/devicetree/bindings/ata/fsl-sata.txt
diff --git a/Documentation/powerpc/dts-bindings/eeprom.txt b/Documentation/devicetree/bindings/eeprom.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/eeprom.txt
rename to Documentation/devicetree/bindings/eeprom.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt b/Documentation/devicetree/bindings/gpio/8xxx_gpio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt
rename to Documentation/devicetree/bindings/gpio/8xxx_gpio.txt
diff --git a/Documentation/powerpc/dts-bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/gpio/gpio.txt
rename to Documentation/devicetree/bindings/gpio/gpio.txt
diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/devicetree/bindings/gpio/led.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/gpio/led.txt
rename to Documentation/devicetree/bindings/gpio/led.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/i2c.txt b/Documentation/devicetree/bindings/i2c/fsl-i2c.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/i2c.txt
rename to Documentation/devicetree/bindings/i2c/fsl-i2c.txt
diff --git a/Documentation/powerpc/dts-bindings/marvell.txt b/Documentation/devicetree/bindings/marvell.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/marvell.txt
rename to Documentation/devicetree/bindings/marvell.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt b/Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/esdhc.txt
rename to Documentation/devicetree/bindings/mmc/fsl-esdhc.txt
diff --git a/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt b/Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
rename to Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/upm-nand.txt b/Documentation/devicetree/bindings/mtd/fsl-upm-nand.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/upm-nand.txt
rename to Documentation/devicetree/bindings/mtd/fsl-upm-nand.txt
diff --git a/Documentation/powerpc/dts-bindings/mtd-physmap.txt b/Documentation/devicetree/bindings/mtd/mtd-physmap.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/mtd-physmap.txt
rename to Documentation/devicetree/bindings/mtd/mtd-physmap.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/can.txt b/Documentation/devicetree/bindings/net/can/mpc5xxx-mscan.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/can.txt
rename to Documentation/devicetree/bindings/net/can/mpc5xxx-mscan.txt
diff --git a/Documentation/powerpc/dts-bindings/can/sja1000.txt b/Documentation/devicetree/bindings/net/can/sja1000.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/can/sja1000.txt
rename to Documentation/devicetree/bindings/net/can/sja1000.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/tsec.txt b/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/tsec.txt
rename to Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
diff --git a/Documentation/powerpc/dts-bindings/gpio/mdio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/gpio/mdio.txt
rename to Documentation/devicetree/bindings/net/mdio-gpio.txt
diff --git a/Documentation/powerpc/dts-bindings/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/phy.txt
rename to Documentation/devicetree/bindings/net/phy.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt b/Documentation/devicetree/bindings/pci/83xx-512x-pci.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt
rename to Documentation/devicetree/bindings/pci/83xx-512x-pci.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/cpm.txt b/Documentation/devicetree/bindings/powerpc/4xx/cpm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/cpm.txt
rename to Documentation/devicetree/bindings/powerpc/4xx/cpm.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/emac.txt b/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/emac.txt
rename to Documentation/devicetree/bindings/powerpc/4xx/emac.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/ndfc.txt b/Documentation/devicetree/bindings/powerpc/4xx/ndfc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/ndfc.txt
rename to Documentation/devicetree/bindings/powerpc/4xx/ndfc.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt b/Documentation/devicetree/bindings/powerpc/4xx/ppc440spe-adma.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
rename to Documentation/devicetree/bindings/powerpc/4xx/ppc440spe-adma.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/reboot.txt b/Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/reboot.txt
rename to Documentation/devicetree/bindings/powerpc/4xx/reboot.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/board.txt b/Documentation/devicetree/bindings/powerpc/fsl/board.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/board.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/board.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/brg.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/brg.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/i2c.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/pic.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/pic.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/usb.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/cpm/usb.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/gpio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/gpio.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/network.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/firmware.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/firmware.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/par_io.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/par_io.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/pincfg.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/ucc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/ucc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/usb.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/qe/usb.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt b/Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/serial.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/cpm_qe/serial.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/diu.txt b/Documentation/devicetree/bindings/powerpc/fsl/diu.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/diu.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/diu.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/dma.txt b/Documentation/devicetree/bindings/powerpc/fsl/dma.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/dma.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/dma.txt
diff --git a/Documentation/powerpc/dts-bindings/ecm.txt b/Documentation/devicetree/bindings/powerpc/fsl/ecm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/ecm.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/ecm.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/gtm.txt b/Documentation/devicetree/bindings/powerpc/fsl/gtm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/gtm.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/gtm.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/guts.txt b/Documentation/devicetree/bindings/powerpc/fsl/guts.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/guts.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/guts.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/lbc.txt b/Documentation/devicetree/bindings/powerpc/fsl/lbc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/lbc.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/lbc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mcm.txt b/Documentation/devicetree/bindings/powerpc/fsl/mcm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mcm.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/mcm.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt b/Documentation/devicetree/bindings/powerpc/fsl/mcu-mpc8349emitx.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/mcu-mpc8349emitx.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpc5121-psc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/mpc5121-psc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpc5200.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpc5200.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mpc5200.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/mpc5200.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpic.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mpic.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt b/Documentation/devicetree/bindings/powerpc/fsl/msi-pic.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/msi-pic.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/pmc.txt b/Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/pmc.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/pmc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/sec.txt b/Documentation/devicetree/bindings/powerpc/fsl/sec.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/sec.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/sec.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/ssi.txt b/Documentation/devicetree/bindings/powerpc/fsl/ssi.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/ssi.txt
rename to Documentation/devicetree/bindings/powerpc/fsl/ssi.txt
diff --git a/Documentation/powerpc/dts-bindings/nintendo/gamecube.txt b/Documentation/devicetree/bindings/powerpc/nintendo/gamecube.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/nintendo/gamecube.txt
rename to Documentation/devicetree/bindings/powerpc/nintendo/gamecube.txt
diff --git a/Documentation/powerpc/dts-bindings/nintendo/wii.txt b/Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/nintendo/wii.txt
rename to Documentation/devicetree/bindings/powerpc/nintendo/wii.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/spi.txt b/Documentation/devicetree/bindings/spi/fsl-spi.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/spi.txt
rename to Documentation/devicetree/bindings/spi/fsl-spi.txt
diff --git a/Documentation/powerpc/dts-bindings/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/spi-bus.txt
rename to Documentation/devicetree/bindings/spi/spi-bus.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/usb.txt b/Documentation/devicetree/bindings/usb/fsl-usb.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/usb.txt
rename to Documentation/devicetree/bindings/usb/fsl-usb.txt
diff --git a/Documentation/powerpc/dts-bindings/usb-ehci.txt b/Documentation/devicetree/bindings/usb/usb-ehci.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/usb-ehci.txt
rename to Documentation/devicetree/bindings/usb/usb-ehci.txt
diff --git a/Documentation/powerpc/dts-bindings/xilinx.txt b/Documentation/devicetree/bindings/xilinx.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/xilinx.txt
rename to Documentation/devicetree/bindings/xilinx.txt
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
similarity index 100%
rename from Documentation/powerpc/booting-without-of.txt
rename to Documentation/devicetree/booting-without-of.txt

