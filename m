Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab1AaHor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:44:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59778 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1AaHoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:44:46 -0500
Subject: [PATCH 0/3] dt: documentation reorganization
To: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: jwboyer@linux.vnet.ibm.com, sam@ravnborg.org, benh@kernel.crashing.org
Date: Mon, 31 Jan 2011 00:44:41 -0700
Message-ID: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series reorganizes and cleans up the device tree documentation
to make the directory useful for non-powerpc users.

Patch 3 of this series adds some documentation about the ARM device
tree boot interface, but I'm posting this one for RFC only at the
moment.  I'll not merge this until dt support for ARM is also merged.

g.

---

Grant Likely (3):
      dt: Move device tree documentation out of powerpc directory
      dt: Remove obsolete description of powerpc boot interface
      dt: add documentation of ARM dt boot interface


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
 Documentation/devicetree/booting-without-of.txt    |   86 +++++++++-----------
 60 files changed, 40 insertions(+), 46 deletions(-)
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
 rename Documentation/{powerpc/booting-without-of.txt => devicetree/booting-without-of.txt} (96%)

-- 
Signature
