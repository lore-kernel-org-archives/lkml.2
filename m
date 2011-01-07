Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab1AGUuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 15:50:15 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61089 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1AGUuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 15:50:12 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 7 Jan 2011 13:49:50 -0700
X-Google-Sender-Auth: ifr-Ankqz2fsk03OGwGBl-CA94I
Message-ID: <AANLkTi=JRPpgyYnv1+mnY_VBYM=z74dpzngOPOLTEOAz@mail.gmail.com>
Subject: [git pull] (updated) spi changes for 2.6.38
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Added one more patch from Russell to get omap DMA working.

Thanks,
g.


The following changes since commit 01539ba2a706ab7d35fc0667dff919ade7f87d63:

  Merge branch 'omap-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6
(2011-01-06 19:13:58 -0800)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 next-spi

Brian Niebuhr (42):
      spi: davinci: fix checkpatch errors
      spi: davinci: whitespace cleanup
      spi: davinci: remove unused variable 'pdata'
      spi: davinci: set chip-select mode in SPIDEF only once
      spi: davinci: enable both activation and deactivation of chip-selects
      spi: davinci: remove unnecessary data transmit on CS disable
      spi: davinci: enable GPIO lines to be used as chip selects
      spi: davinci: simplify prescalar calculation
      spi: davinci: remove 'wait_enable' platform data member
      spi: davinci: make chip-slect specific parameters really
chip-select specific
      spi: davinci: consolidate setup of SPIFMTn in one function
      spi: davinci: setup chip-select timers values only if timer enabled
      spi: davinci: add support for wait enable timeouts
      spi: davinci: remove unused members of davinci_spi_slave
      spi: davinci: eliminate the single member structure davinci_spi_slave
      spi: davinci: eliminate unnecessary update of davinci_spi->count
      spi: davinci: simplify calculation of edma acount value
      spi: davinci: check for NULL buffer pointer before using it
      spi: davinci: remove unnecessary disable of SPI
      spi: davinci: remove unnecessary 'count' variable in driver private data
      spi: davinci: remove unnecessary completion variable initialization
      spi: davinci: remove non-useful interrupt mode support
      spi: davinci: simplify poll mode transfers
      spi: davinci: add support for interrupt mode
      spi: davinci: configure the invariable bits in spipc0 only once
      spi: davinci: remove unnecessary function davinci_spi_bufs_prep()
      spi: davinci: remove unnecessary call to davinci_spi_setup_transfer()
      spi: davinci: do not store DMA channel information per chip select
      spi: davinci: always start transmit DMA
      spi: davinci: do not use temporary buffer if no transmit data provided
      spi: davinci: always start receive DMA
      spi: davinci: use edma_write_slot() to setup EDMA PaRAM slot
      spi: davinci: fix DMA event generation stoppage
      spi: davinci: fix EDMA CC errors at end of transfers
      spi: davinci: handle DMA completion errors correctly
      spi: davinci: remove usage of additional completion variables for DMA
      spi: davinci: let DMA operation be specified on per-device basis
      spi: davinci: remove non-useful "clk_internal" platform data
      spi: davinci: enable and power-up SPI only when required
      spi: davinci: setup the driver owner
      spi: davinci: add additional comments
      spi: davinci: add EF Johnson Technologies copyright

Feng Tang (3):
      spi/dw_spi: Fix too short timeout in spi polling loop
      spi/dw_spi: change to EXPORT_SYMBOL_GPL for exported APIs
      spi/dw_spi: add DMA support

Grant Likely (6):
      spi/xilinx: Eliminate pdata references from common code.
      spi/xilinx: fold platform_driver support into main body
      spi/xilinx: merge OF support code into main driver
      Merge commit 'v2.6.37-rc7' into spi/next
      Merge branch 'for-grant' of
git://arago-project.org/git/projects/linux-davinci into spi/next
      Merge branch 'spi' of git://git.linutronix.de/users/bigeasy/soda
into spi/next

Joe Perches (1):
      drivers/spi: Remove unnecessary semicolons

Justin P. Mattock (2):
      spi/dw_spi Typo change diable to disable.
      spi/topcliff: Typo fix threhold to threshold

Linus Walleij (4):
      spi/pl022: map the buffers on the DMA engine
      spi/pl022: pass the returned sglen to the DMA engine
      spi/pl022: convert busy flag to a bool
      spi/pl022: convert running variable

Mingkai Hu (1):
      spi/fsl_espi: change the read behaviour of the SPIRF

Richard Genoud (1):
      spi/imx: correct the test on platform_get_irq() return value

Russell King - ARM Linux (1):
      spi/omap: Fix DMA API usage in OMAP MCSPI driver

Sebastian Andrzej Siewior (9):
      spi/pxa2xx: register driver properly
      spi/pxa2xx: add support for shared IRQ handler
      spi/pxa2xx: Use define for SSSR_TFL_MASK instead of plain numbers
      arm/pxa2xx: reorgazine SSP and SPI header files
      spi/pxa2xx: Add CE4100 support
      spi/pxa2xx: Consider CE4100's FIFO depth
      spi/pxa2xx: Add chipselect support for Sodaville
      spi/pxa2xx: Modify RX-Tresh instead of busy-loop for the
remaining RX bytes.
      spi/pxa2xx: pass of_node to spi device and set a parent device

Sekhar Nori (7):
      spi: davinci: removed unused #defines
      spi: davinci: remove unnecessary typecast
      spi: davinci: do not treat Tx interrupt being set as error
      spi: davinci: do not allocate DMA channels during SPI device setup
      spi: davinci: remove unnecessary private data member 'region_size'
      spi: davinci: shorten variable names
      spi: davinci: kconfig: add manufacturer name to prompt string

Tomoya MORINAGA (1):
      spi/topcliff_pch: Fix data transfer issue

Uwe Kleine-König (1):
      spi/imx: remove autodetection

Wolfram Sang (1):
      spi/mpc52xx-psc-spi: move probe/remove to proper sections

 Documentation/spi/pxa2xx                           |    4 +-
 arch/arm/mach-davinci/dm355.c                      |    7 +-
 arch/arm/mach-davinci/dm365.c                      |    6 -
 arch/arm/mach-davinci/include/mach/spi.h           |   52 +-
 arch/arm/mach-pxa/cm-x255.c                        |    2 +-
 arch/arm/mach-pxa/cm-x270.c                        |    2 +-
 arch/arm/mach-pxa/corgi.c                          |    2 +-
 arch/arm/mach-pxa/devices.c                        |    2 +-
 arch/arm/mach-pxa/em-x270.c                        |    2 +-
 arch/arm/mach-pxa/hx4700.c                         |    2 +-
 arch/arm/mach-pxa/icontrol.c                       |    2 +-
 arch/arm/mach-pxa/include/mach/pxa2xx_spi.h        |   47 -
 arch/arm/mach-pxa/littleton.c                      |    2 +-
 arch/arm/mach-pxa/lubbock.c                        |    2 +-
 arch/arm/mach-pxa/pcm027.c                         |    2 +-
 arch/arm/mach-pxa/poodle.c                         |    2 +-
 arch/arm/mach-pxa/spitz.c                          |    3 +-
 arch/arm/mach-pxa/stargate2.c                      |    2 +-
 arch/arm/mach-pxa/tosa.c                           |    2 +-
 arch/arm/mach-pxa/trizeps4.c                       |    1 -
 arch/arm/mach-pxa/z2.c                             |    2 +-
 arch/arm/mach-pxa/zeus.c                           |    2 +-
 arch/arm/plat-pxa/ssp.c                            |    2 +-
 drivers/spi/Kconfig                                |   38 +-
 drivers/spi/Makefile                               |    6 +-
 drivers/spi/amba-pl022.c                           |   56 +-
 drivers/spi/davinci_spi.c                          | 1314 ++++++++------------
 drivers/spi/dw_spi.c                               |   52 +-
 drivers/spi/dw_spi_mid.c                           |  223 ++++
 drivers/spi/dw_spi_pci.c                           |   20 +-
 drivers/spi/mpc52xx_psc_spi.c                      |   35 +-
 drivers/spi/omap2_mcspi.c                          |   11 +-
 drivers/spi/pxa2xx_spi.c                           |  190 ++-
 drivers/spi/pxa2xx_spi_pci.c                       |  201 +++
 drivers/spi/spi_fsl_espi.c                         |   19 +-
 drivers/spi/spi_imx.c                              |   32 +-
 drivers/spi/spi_nuc900.c                           |    2 +-
 drivers/spi/spi_topcliff_pch.c                     |   12 +-
 drivers/spi/xilinx_spi.c                           |  133 ++-
 drivers/spi/xilinx_spi.h                           |   32 -
 drivers/spi/xilinx_spi_of.c                        |  133 --
 drivers/spi/xilinx_spi_pltfm.c                     |  102 --
 .../plat/ssp.h => include/linux/pxa2xx_ssp.h       |   39 +-
 include/linux/spi/dw_spi.h                         |   24 +-
 include/linux/spi/pxa2xx_spi.h                     |  152 +++
 sound/soc/pxa/pxa-ssp.c                            |    2 +-
 46 files changed, 1612 insertions(+), 1368 deletions(-)
 delete mode 100644 arch/arm/mach-pxa/include/mach/pxa2xx_spi.h
 create mode 100644 drivers/spi/dw_spi_mid.c
 create mode 100644 drivers/spi/pxa2xx_spi_pci.c
 delete mode 100644 drivers/spi/xilinx_spi.h
 delete mode 100644 drivers/spi/xilinx_spi_of.c
 delete mode 100644 drivers/spi/xilinx_spi_pltfm.c
 rename arch/arm/plat-pxa/include/plat/ssp.h => include/linux/pxa2xx_ssp.h (90%)
 create mode 100644 include/linux/spi/pxa2xx_spi.h


2011/1/7 Grant Likely <grant.likely@secretlab.ca>:
> Hi Linus,
>
> Here are the spi subsystem changes to be merged for 2.6.38
>
> Thanks,
> g.
>
> The following changes since commit 3c0cb7c31c206aaedb967e44b98442bbeb17a6c4:
>
>  Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
> (2011-01-06 16:50:35 -0800)
>
> are available in the git repository at:
>
>  git://git.secretlab.ca/git/linux-2.6 next-spi
>
> Brian Niebuhr (42):
>      spi: davinci: fix checkpatch errors
>      spi: davinci: whitespace cleanup
>      spi: davinci: remove unused variable 'pdata'
>      spi: davinci: set chip-select mode in SPIDEF only once
>      spi: davinci: enable both activation and deactivation of chip-selects
>      spi: davinci: remove unnecessary data transmit on CS disable
>      spi: davinci: enable GPIO lines to be used as chip selects
>      spi: davinci: simplify prescalar calculation
>      spi: davinci: remove 'wait_enable' platform data member
>      spi: davinci: make chip-slect specific parameters really
> chip-select specific
>      spi: davinci: consolidate setup of SPIFMTn in one function
>      spi: davinci: setup chip-select timers values only if timer enabled
>      spi: davinci: add support for wait enable timeouts
>      spi: davinci: remove unused members of davinci_spi_slave
>      spi: davinci: eliminate the single member structure davinci_spi_slave
>      spi: davinci: eliminate unnecessary update of davinci_spi->count
>      spi: davinci: simplify calculation of edma acount value
>      spi: davinci: check for NULL buffer pointer before using it
>      spi: davinci: remove unnecessary disable of SPI
>      spi: davinci: remove unnecessary 'count' variable in driver private data
>      spi: davinci: remove unnecessary completion variable initialization
>      spi: davinci: remove non-useful interrupt mode support
>      spi: davinci: simplify poll mode transfers
>      spi: davinci: add support for interrupt mode
>      spi: davinci: configure the invariable bits in spipc0 only once
>      spi: davinci: remove unnecessary function davinci_spi_bufs_prep()
>      spi: davinci: remove unnecessary call to davinci_spi_setup_transfer()
>      spi: davinci: do not store DMA channel information per chip select
>      spi: davinci: always start transmit DMA
>      spi: davinci: do not use temporary buffer if no transmit data provided
>      spi: davinci: always start receive DMA
>      spi: davinci: use edma_write_slot() to setup EDMA PaRAM slot
>      spi: davinci: fix DMA event generation stoppage
>      spi: davinci: fix EDMA CC errors at end of transfers
>      spi: davinci: handle DMA completion errors correctly
>      spi: davinci: remove usage of additional completion variables for DMA
>      spi: davinci: let DMA operation be specified on per-device basis
>      spi: davinci: remove non-useful "clk_internal" platform data
>      spi: davinci: enable and power-up SPI only when required
>      spi: davinci: setup the driver owner
>      spi: davinci: add additional comments
>      spi: davinci: add EF Johnson Technologies copyright
>
> Feng Tang (3):
>      spi/dw_spi: Fix too short timeout in spi polling loop
>      spi/dw_spi: change to EXPORT_SYMBOL_GPL for exported APIs
>      spi/dw_spi: add DMA support
>
> Grant Likely (6):
>      spi/xilinx: Eliminate pdata references from common code.
>      spi/xilinx: fold platform_driver support into main body
>      spi/xilinx: merge OF support code into main driver
>      Merge commit 'v2.6.37-rc7' into spi/next
>      Merge branch 'for-grant' of
> git://arago-project.org/git/projects/linux-davinci into spi/next
>      Merge branch 'spi' of git://git.linutronix.de/users/bigeasy/soda
> into spi/next
>
> Joe Perches (1):
>      drivers/spi: Remove unnecessary semicolons
>
> Justin P. Mattock (2):
>      spi/dw_spi Typo change diable to disable.
>      spi/topcliff: Typo fix threhold to threshold
>
> Linus Walleij (4):
>      spi/pl022: map the buffers on the DMA engine
>      spi/pl022: pass the returned sglen to the DMA engine
>      spi/pl022: convert busy flag to a bool
>      spi/pl022: convert running variable
>
> Mingkai Hu (1):
>      spi/fsl_espi: change the read behaviour of the SPIRF
>
> Richard Genoud (1):
>      spi/imx: correct the test on platform_get_irq() return value
>
> Sebastian Andrzej Siewior (9):
>      spi/pxa2xx: register driver properly
>      spi/pxa2xx: add support for shared IRQ handler
>      spi/pxa2xx: Use define for SSSR_TFL_MASK instead of plain numbers
>      arm/pxa2xx: reorgazine SSP and SPI header files
>      spi/pxa2xx: Add CE4100 support
>      spi/pxa2xx: Consider CE4100's FIFO depth
>      spi/pxa2xx: Add chipselect support for Sodaville
>      spi/pxa2xx: Modify RX-Tresh instead of busy-loop for the
> remaining RX bytes.
>      spi/pxa2xx: pass of_node to spi device and set a parent device
>
> Sekhar Nori (7):
>      spi: davinci: removed unused #defines
>      spi: davinci: remove unnecessary typecast
>      spi: davinci: do not treat Tx interrupt being set as error
>      spi: davinci: do not allocate DMA channels during SPI device setup
>      spi: davinci: remove unnecessary private data member 'region_size'
>      spi: davinci: shorten variable names
>      spi: davinci: kconfig: add manufacturer name to prompt string
>
> Tomoya MORINAGA (1):
>      spi/topcliff_pch: Fix data transfer issue
>
> Uwe Kleine-König (1):
>      spi/imx: remove autodetection
>
> Wolfram Sang (1):
>      spi/mpc52xx-psc-spi: move probe/remove to proper sections
>
>  Documentation/spi/pxa2xx                           |    4 +-
>  arch/arm/mach-davinci/dm355.c                      |    7 +-
>  arch/arm/mach-davinci/dm365.c                      |    6 -
>  arch/arm/mach-davinci/include/mach/spi.h           |   52 +-
>  arch/arm/mach-pxa/cm-x255.c                        |    2 +-
>  arch/arm/mach-pxa/cm-x270.c                        |    2 +-
>  arch/arm/mach-pxa/corgi.c                          |    2 +-
>  arch/arm/mach-pxa/devices.c                        |    2 +-
>  arch/arm/mach-pxa/em-x270.c                        |    2 +-
>  arch/arm/mach-pxa/hx4700.c                         |    2 +-
>  arch/arm/mach-pxa/icontrol.c                       |    2 +-
>  arch/arm/mach-pxa/include/mach/pxa2xx_spi.h        |   47 -
>  arch/arm/mach-pxa/littleton.c                      |    2 +-
>  arch/arm/mach-pxa/lubbock.c                        |    2 +-
>  arch/arm/mach-pxa/pcm027.c                         |    2 +-
>  arch/arm/mach-pxa/poodle.c                         |    2 +-
>  arch/arm/mach-pxa/spitz.c                          |    3 +-
>  arch/arm/mach-pxa/stargate2.c                      |    2 +-
>  arch/arm/mach-pxa/tosa.c                           |    2 +-
>  arch/arm/mach-pxa/trizeps4.c                       |    1 -
>  arch/arm/mach-pxa/z2.c                             |    2 +-
>  arch/arm/mach-pxa/zeus.c                           |    2 +-
>  arch/arm/plat-pxa/ssp.c                            |    2 +-
>  drivers/spi/Kconfig                                |   38 +-
>  drivers/spi/Makefile                               |    6 +-
>  drivers/spi/amba-pl022.c                           |   56 +-
>  drivers/spi/davinci_spi.c                          | 1314 ++++++++------------
>  drivers/spi/dw_spi.c                               |   52 +-
>  drivers/spi/dw_spi_mid.c                           |  223 ++++
>  drivers/spi/dw_spi_pci.c                           |   20 +-
>  drivers/spi/mpc52xx_psc_spi.c                      |   35 +-
>  drivers/spi/pxa2xx_spi.c                           |  190 ++-
>  drivers/spi/pxa2xx_spi_pci.c                       |  201 +++
>  drivers/spi/spi_fsl_espi.c                         |   19 +-
>  drivers/spi/spi_imx.c                              |   32 +-
>  drivers/spi/spi_nuc900.c                           |    2 +-
>  drivers/spi/spi_topcliff_pch.c                     |   12 +-
>  drivers/spi/xilinx_spi.c                           |  133 ++-
>  drivers/spi/xilinx_spi.h                           |   32 -
>  drivers/spi/xilinx_spi_of.c                        |  133 --
>  drivers/spi/xilinx_spi_pltfm.c                     |  102 --
>  .../plat/ssp.h => include/linux/pxa2xx_ssp.h       |   39 +-
>  include/linux/spi/dw_spi.h                         |   24 +-
>  include/linux/spi/pxa2xx_spi.h                     |  152 +++
>  sound/soc/pxa/pxa-ssp.c                            |    2 +-
>  45 files changed, 1609 insertions(+), 1360 deletions(-)
>  delete mode 100644 arch/arm/mach-pxa/include/mach/pxa2xx_spi.h
>  create mode 100644 drivers/spi/dw_spi_mid.c
>  create mode 100644 drivers/spi/pxa2xx_spi_pci.c
>  delete mode 100644 drivers/spi/xilinx_spi.h
>  delete mode 100644 drivers/spi/xilinx_spi_of.c
>  delete mode 100644 drivers/spi/xilinx_spi_pltfm.c
>  rename arch/arm/plat-pxa/include/plat/ssp.h => include/linux/pxa2xx_ssp.h (90%)
>  create mode 100644 include/linux/spi/pxa2xx_spi.h
>
>
> --
> Grant Likely, B.Sc., P.Eng.
> Secret Lab Technologies Ltd.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
