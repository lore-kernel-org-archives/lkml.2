Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1AZRUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:20:51 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49133 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AZRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:20:49 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Cc: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] dt: Move device tree documentation out of powerpc directory
Date: Wed, 26 Jan 2011 10:20:34 -0700
Message-Id: <1296062434-18027-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device tree is used by more than just PowerPC.  Make the documentation
directory available to all.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Assuming nobody has an issue with this, I'll push it out to Linus for
2.6.38 since it is only a documentation change.

g.

 .../bindings}/4xx/cpm.txt                          |    0
 .../bindings}/4xx/emac.txt                         |    0
 .../bindings}/4xx/ndfc.txt                         |    0
 .../bindings}/4xx/ppc440spe-adma.txt               |    0
 .../bindings}/4xx/reboot.txt                       |    0
 .../bindings}/can/sja1000.txt                      |    0
 .../dts-bindings => devicetree/bindings}/ecm.txt   |    0
 .../bindings}/eeprom.txt                           |    0
 .../bindings}/fsl/83xx-512x-pci.txt                |    0
 .../bindings}/fsl/8xxx_gpio.txt                    |    0
 .../bindings}/fsl/board.txt                        |    0
 .../bindings}/fsl/can.txt                          |    0
 .../bindings}/fsl/cpm_qe/cpm.txt                   |    0
 .../bindings}/fsl/cpm_qe/cpm/brg.txt               |    0
 .../bindings}/fsl/cpm_qe/cpm/i2c.txt               |    0
 .../bindings}/fsl/cpm_qe/cpm/pic.txt               |    0
 .../bindings}/fsl/cpm_qe/cpm/usb.txt               |    0
 .../bindings}/fsl/cpm_qe/gpio.txt                  |    0
 .../bindings}/fsl/cpm_qe/network.txt               |    0
 .../bindings}/fsl/cpm_qe/qe.txt                    |    0
 .../bindings}/fsl/cpm_qe/qe/firmware.txt           |    0
 .../bindings}/fsl/cpm_qe/qe/par_io.txt             |    0
 .../bindings}/fsl/cpm_qe/qe/pincfg.txt             |    0
 .../bindings}/fsl/cpm_qe/qe/ucc.txt                |    0
 .../bindings}/fsl/cpm_qe/qe/usb.txt                |    0
 .../bindings}/fsl/cpm_qe/serial.txt                |    0
 .../bindings}/fsl/diu.txt                          |    0
 .../bindings}/fsl/dma.txt                          |    0
 .../bindings}/fsl/esdhc.txt                        |    0
 .../bindings}/fsl/gtm.txt                          |    0
 .../bindings}/fsl/guts.txt                         |    0
 .../bindings}/fsl/i2c.txt                          |    0
 .../bindings}/fsl/lbc.txt                          |    0
 .../bindings}/fsl/mcm.txt                          |    0
 .../bindings}/fsl/mcu-mpc8349emitx.txt             |    0
 .../bindings}/fsl/mpc5121-psc.txt                  |    0
 .../bindings}/fsl/mpc5200.txt                      |    0
 .../bindings}/fsl/mpic.txt                         |    0
 .../bindings}/fsl/msi-pic.txt                      |    0
 .../bindings}/fsl/pmc.txt                          |    0
 .../bindings}/fsl/sata.txt                         |    0
 .../bindings}/fsl/sec.txt                          |    0
 .../bindings}/fsl/spi.txt                          |    0
 .../bindings}/fsl/ssi.txt                          |    0
 .../bindings}/fsl/tsec.txt                         |    0
 .../bindings}/fsl/upm-nand.txt                     |    0
 .../bindings}/fsl/usb.txt                          |    0
 .../bindings}/gpio/gpio.txt                        |    0
 .../bindings}/gpio/led.txt                         |    0
 .../bindings}/gpio/mdio.txt                        |    0
 .../bindings}/marvell.txt                          |    0
 .../bindings}/mmc-spi-slot.txt                     |    0
 .../bindings}/mtd-physmap.txt                      |    0
 .../bindings}/nintendo/gamecube.txt                |    0
 .../bindings}/nintendo/wii.txt                     |    0
 .../dts-bindings => devicetree/bindings}/phy.txt   |    0
 .../bindings}/spi-bus.txt                          |    0
 .../bindings}/usb-ehci.txt                         |    0
 .../bindings}/xilinx.txt                           |    0
 .../{powerpc => devicetree}/booting-without-of.txt |    0
 60 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/4xx/cpm.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/4xx/emac.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/4xx/ndfc.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/4xx/ppc440spe-adma.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/4xx/reboot.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/can/sja1000.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/ecm.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/eeprom.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/83xx-512x-pci.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/8xxx_gpio.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/board.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/can.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/cpm.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/cpm/brg.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/cpm/i2c.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/cpm/pic.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/cpm/usb.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/gpio.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/network.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/qe.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/qe/firmware.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/qe/par_io.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/qe/pincfg.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/qe/ucc.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/qe/usb.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/cpm_qe/serial.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/diu.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/dma.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/esdhc.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/gtm.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/guts.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/i2c.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/lbc.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/mcm.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/mcu-mpc8349emitx.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/mpc5121-psc.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/mpc5200.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/mpic.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/msi-pic.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/pmc.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/sata.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/sec.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/spi.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/ssi.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/tsec.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/upm-nand.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/fsl/usb.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/gpio/gpio.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/gpio/led.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/gpio/mdio.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/marvell.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/mmc-spi-slot.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/mtd-physmap.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/nintendo/gamecube.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/nintendo/wii.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/phy.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/spi-bus.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/usb-ehci.txt (100%)
 rename Documentation/{powerpc/dts-bindings => devicetree/bindings}/xilinx.txt (100%)
 rename Documentation/{powerpc => devicetree}/booting-without-of.txt (100%)

diff --git a/Documentation/powerpc/dts-bindings/4xx/cpm.txt b/Documentation/devicetree/bindings/4xx/cpm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/cpm.txt
rename to Documentation/devicetree/bindings/4xx/cpm.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/emac.txt b/Documentation/devicetree/bindings/4xx/emac.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/emac.txt
rename to Documentation/devicetree/bindings/4xx/emac.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/ndfc.txt b/Documentation/devicetree/bindings/4xx/ndfc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/ndfc.txt
rename to Documentation/devicetree/bindings/4xx/ndfc.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt b/Documentation/devicetree/bindings/4xx/ppc440spe-adma.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/ppc440spe-adma.txt
rename to Documentation/devicetree/bindings/4xx/ppc440spe-adma.txt
diff --git a/Documentation/powerpc/dts-bindings/4xx/reboot.txt b/Documentation/devicetree/bindings/4xx/reboot.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/4xx/reboot.txt
rename to Documentation/devicetree/bindings/4xx/reboot.txt
diff --git a/Documentation/powerpc/dts-bindings/can/sja1000.txt b/Documentation/devicetree/bindings/can/sja1000.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/can/sja1000.txt
rename to Documentation/devicetree/bindings/can/sja1000.txt
diff --git a/Documentation/powerpc/dts-bindings/ecm.txt b/Documentation/devicetree/bindings/ecm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/ecm.txt
rename to Documentation/devicetree/bindings/ecm.txt
diff --git a/Documentation/powerpc/dts-bindings/eeprom.txt b/Documentation/devicetree/bindings/eeprom.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/eeprom.txt
rename to Documentation/devicetree/bindings/eeprom.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt b/Documentation/devicetree/bindings/fsl/83xx-512x-pci.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/83xx-512x-pci.txt
rename to Documentation/devicetree/bindings/fsl/83xx-512x-pci.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt b/Documentation/devicetree/bindings/fsl/8xxx_gpio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/8xxx_gpio.txt
rename to Documentation/devicetree/bindings/fsl/8xxx_gpio.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/board.txt b/Documentation/devicetree/bindings/fsl/board.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/board.txt
rename to Documentation/devicetree/bindings/fsl/board.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/can.txt b/Documentation/devicetree/bindings/fsl/can.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/can.txt
rename to Documentation/devicetree/bindings/fsl/can.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/cpm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/cpm.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/cpm/brg.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/brg.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/cpm/brg.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/cpm/i2c.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/i2c.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/cpm/i2c.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/cpm/pic.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/pic.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/cpm/pic.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/cpm/usb.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/cpm/usb.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/cpm/usb.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/gpio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/gpio.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/gpio.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/network.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/network.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/network.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/qe.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/qe.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/qe/firmware.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/firmware.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/qe/firmware.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/qe/par_io.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/par_io.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/qe/par_io.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/qe/pincfg.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/pincfg.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/qe/pincfg.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/qe/ucc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/ucc.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/qe/ucc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/qe/usb.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/qe/usb.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/qe/usb.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt b/Documentation/devicetree/bindings/fsl/cpm_qe/serial.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/cpm_qe/serial.txt
rename to Documentation/devicetree/bindings/fsl/cpm_qe/serial.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/diu.txt b/Documentation/devicetree/bindings/fsl/diu.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/diu.txt
rename to Documentation/devicetree/bindings/fsl/diu.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/dma.txt b/Documentation/devicetree/bindings/fsl/dma.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/dma.txt
rename to Documentation/devicetree/bindings/fsl/dma.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/esdhc.txt b/Documentation/devicetree/bindings/fsl/esdhc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/esdhc.txt
rename to Documentation/devicetree/bindings/fsl/esdhc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/gtm.txt b/Documentation/devicetree/bindings/fsl/gtm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/gtm.txt
rename to Documentation/devicetree/bindings/fsl/gtm.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/guts.txt b/Documentation/devicetree/bindings/fsl/guts.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/guts.txt
rename to Documentation/devicetree/bindings/fsl/guts.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/i2c.txt b/Documentation/devicetree/bindings/fsl/i2c.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/i2c.txt
rename to Documentation/devicetree/bindings/fsl/i2c.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/lbc.txt b/Documentation/devicetree/bindings/fsl/lbc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/lbc.txt
rename to Documentation/devicetree/bindings/fsl/lbc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mcm.txt b/Documentation/devicetree/bindings/fsl/mcm.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mcm.txt
rename to Documentation/devicetree/bindings/fsl/mcm.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt b/Documentation/devicetree/bindings/fsl/mcu-mpc8349emitx.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mcu-mpc8349emitx.txt
rename to Documentation/devicetree/bindings/fsl/mcu-mpc8349emitx.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt b/Documentation/devicetree/bindings/fsl/mpc5121-psc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
rename to Documentation/devicetree/bindings/fsl/mpc5121-psc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpc5200.txt b/Documentation/devicetree/bindings/fsl/mpc5200.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mpc5200.txt
rename to Documentation/devicetree/bindings/fsl/mpc5200.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/mpic.txt b/Documentation/devicetree/bindings/fsl/mpic.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/mpic.txt
rename to Documentation/devicetree/bindings/fsl/mpic.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/msi-pic.txt b/Documentation/devicetree/bindings/fsl/msi-pic.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/msi-pic.txt
rename to Documentation/devicetree/bindings/fsl/msi-pic.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/pmc.txt b/Documentation/devicetree/bindings/fsl/pmc.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/pmc.txt
rename to Documentation/devicetree/bindings/fsl/pmc.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/sata.txt b/Documentation/devicetree/bindings/fsl/sata.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/sata.txt
rename to Documentation/devicetree/bindings/fsl/sata.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/sec.txt b/Documentation/devicetree/bindings/fsl/sec.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/sec.txt
rename to Documentation/devicetree/bindings/fsl/sec.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/spi.txt b/Documentation/devicetree/bindings/fsl/spi.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/spi.txt
rename to Documentation/devicetree/bindings/fsl/spi.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/ssi.txt b/Documentation/devicetree/bindings/fsl/ssi.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/ssi.txt
rename to Documentation/devicetree/bindings/fsl/ssi.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/tsec.txt b/Documentation/devicetree/bindings/fsl/tsec.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/tsec.txt
rename to Documentation/devicetree/bindings/fsl/tsec.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/upm-nand.txt b/Documentation/devicetree/bindings/fsl/upm-nand.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/upm-nand.txt
rename to Documentation/devicetree/bindings/fsl/upm-nand.txt
diff --git a/Documentation/powerpc/dts-bindings/fsl/usb.txt b/Documentation/devicetree/bindings/fsl/usb.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/fsl/usb.txt
rename to Documentation/devicetree/bindings/fsl/usb.txt
diff --git a/Documentation/powerpc/dts-bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/gpio/gpio.txt
rename to Documentation/devicetree/bindings/gpio/gpio.txt
diff --git a/Documentation/powerpc/dts-bindings/gpio/led.txt b/Documentation/devicetree/bindings/gpio/led.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/gpio/led.txt
rename to Documentation/devicetree/bindings/gpio/led.txt
diff --git a/Documentation/powerpc/dts-bindings/gpio/mdio.txt b/Documentation/devicetree/bindings/gpio/mdio.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/gpio/mdio.txt
rename to Documentation/devicetree/bindings/gpio/mdio.txt
diff --git a/Documentation/powerpc/dts-bindings/marvell.txt b/Documentation/devicetree/bindings/marvell.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/marvell.txt
rename to Documentation/devicetree/bindings/marvell.txt
diff --git a/Documentation/powerpc/dts-bindings/mmc-spi-slot.txt b/Documentation/devicetree/bindings/mmc-spi-slot.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/mmc-spi-slot.txt
rename to Documentation/devicetree/bindings/mmc-spi-slot.txt
diff --git a/Documentation/powerpc/dts-bindings/mtd-physmap.txt b/Documentation/devicetree/bindings/mtd-physmap.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/mtd-physmap.txt
rename to Documentation/devicetree/bindings/mtd-physmap.txt
diff --git a/Documentation/powerpc/dts-bindings/nintendo/gamecube.txt b/Documentation/devicetree/bindings/nintendo/gamecube.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/nintendo/gamecube.txt
rename to Documentation/devicetree/bindings/nintendo/gamecube.txt
diff --git a/Documentation/powerpc/dts-bindings/nintendo/wii.txt b/Documentation/devicetree/bindings/nintendo/wii.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/nintendo/wii.txt
rename to Documentation/devicetree/bindings/nintendo/wii.txt
diff --git a/Documentation/powerpc/dts-bindings/phy.txt b/Documentation/devicetree/bindings/phy.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/phy.txt
rename to Documentation/devicetree/bindings/phy.txt
diff --git a/Documentation/powerpc/dts-bindings/spi-bus.txt b/Documentation/devicetree/bindings/spi-bus.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/spi-bus.txt
rename to Documentation/devicetree/bindings/spi-bus.txt
diff --git a/Documentation/powerpc/dts-bindings/usb-ehci.txt b/Documentation/devicetree/bindings/usb-ehci.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/usb-ehci.txt
rename to Documentation/devicetree/bindings/usb-ehci.txt
diff --git a/Documentation/powerpc/dts-bindings/xilinx.txt b/Documentation/devicetree/bindings/xilinx.txt
similarity index 100%
rename from Documentation/powerpc/dts-bindings/xilinx.txt
rename to Documentation/devicetree/bindings/xilinx.txt
diff --git a/Documentation/powerpc/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
similarity index 100%
rename from Documentation/powerpc/booting-without-of.txt
rename to Documentation/devicetree/booting-without-of.txt
-- 
1.7.1

