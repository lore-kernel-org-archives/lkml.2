Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab1JZVhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 17:37:50 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58849 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab1JZVht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 17:37:49 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Oct 2011 23:37:28 +0200
X-Google-Sender-Auth: uw2F98cStFxo5_SrL9BbxTVRJFc
Message-ID: <CACxGe6teZPZudqbq_=W91Av9FOEe072+YOmWN3kU8w9UEHZvYg@mail.gmail.com>
Subject: [GIT PULL] devicetree changes for v3.1
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Cc: Jamie Iles <jamie@jamieiles.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <robherring2@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Stephen Warren <SWarren@nvidia.com>,
        Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the device tree changes I've got queued up.  Nothing earth
shattering here.  Some bug fixes, minor new features, minor cleanups
and documentation

The following changes since commit 138c4ae9cfda8fdcf9e137457853b09ef8cf8f77:

  Merge branch 'slab/for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux
(2011-10-26 21:46:18 +0200)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/next

Commit id: ae97159aed6eff68f4ac86472b018985f071fed5

Ben Dooks (2):
      OF: Add of_match_ptr() macro
      tty: use of_match_ptr() for of_match_table entry

Grant Likely (6):
      devicetree: Add a registry of vendor prefixes
      devicetree: Document Qualcomm and Atmel prefixes
      Merge branch 'for-grant' of git://git.jdl.com/software/linux-3.0
into devicetree/next
      devicetree: fix build error on drivers/tty/serial/altera_jtaguart.c
      Merge commit 'v3.1' into devicetree/next
      Devicetree: Expand on ARM Primecell binding documentation

Jamie Iles (1):
      dt: add helper to read 64-bit integers

Kyle Moffett (1):
      of_mdio: Don't phy_scan_fixups() twice

Nicolas Ferre (1):
      dt: Add empty of_match_node() macro

Rajendra Nayak (1):
      dt: add empty dt helpers for non-dt build

Rob Herring (4):
      MAINTAINERS: update devicetree maintainers
      of/irq: of_irq_find_parent: check for parent equal to child
      devicetree: Add ARM pl061 gpio controller binding doc
      devicetree: Add ARM pl022 spi controller binding doc

Shawn Guo (2):
      dt: add of_alias_scan and of_alias_get_id
      serial/imx: add of_alias_get_id() reference back

Stephen Warren (1):
      dt: add empty for_each_child_of_node, of_find_property

 .../devicetree/bindings/arm/primecell.txt          |    4 +-
 .../devicetree/bindings/gpio/pl061-gpio.txt        |   10 ++
 .../devicetree/bindings/spi/spi_pl022.txt          |   12 ++
 .../devicetree/bindings/vendor-prefixes.txt        |   40 +++++
 MAINTAINERS                                        |    2 +
 drivers/of/base.c                                  |  150 ++++++++++++++++++++
 drivers/of/fdt.c                                   |    6 +-
 drivers/of/irq.c                                   |   14 +-
 drivers/of/of_mdio.c                               |    1 -
 drivers/of/pdt.c                                   |    8 +
 drivers/tty/serial/altera_jtaguart.c               |    5 +-
 drivers/tty/serial/altera_uart.c                   |    4 +-
 drivers/tty/serial/imx.c                           |   11 +-
 drivers/tty/serial/uartlite.c                      |    4 +-
 include/linux/of.h                                 |   41 ++++++
 15 files changed, 286 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/pl061-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/spi/spi_pl022.txt
 create mode 100644 Documentation/devicetree/bindings/vendor-prefixes.txt
