Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0HRFOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:14:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64001 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab0HRFOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:14:47 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Aug 2010 23:14:27 -0600
X-Google-Sender-Auth: B3hxLsNutzv5SmfkWG47Ldeb8bw
Message-ID: <AANLkTinP6QBHmzfgfKqk+wv8YWDRqB4T7b0d9qGmqtpE@mail.gmail.com>
Subject: [git pull] OF regression fixes and plus one spi documentation fix
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Ernst Schwab <eschwab@online.de>,
        Graeme Smecher <graeme.smecher@mail.mcgill.ca>,
        Michal Simek <monstr@monstr.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a round of regression fixes for merging.

Cheers,
g.

The following changes since commit da5cabf80e2433131bf0ed8993abc0f7ea618c73:
  Linus Torvalds (1):
        Linux 2.6.36-rc1

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge-devicetree

Anton Vorontsov (1):
      booting-without-of: Remove nonexistent chapters from TOC, fix numbering

Ernst Schwab (1):
      spi.h: missing kernel-doc notation, please fix

Graeme Smecher (1):
      of: fix missing headers for of_address_to_resource() in MTD and
SysACE drivers

Grant Likely (1):
      of: Fix missing includes

Michal Simek (2):
      microblaze: Fix of/address: Merge all of the bus translation code
      microblaze: Fix of: eliminate of_device->node and
dev_archdata->{of,prom}_node

Stephen Rothwell (1):
      ata: update for of_device to platform_device replacement

 Documentation/powerpc/booting-without-of.txt |   31 +------------------------
 arch/microblaze/kernel/prom_parse.c          |    2 +-
 arch/microblaze/pci/pci-common.c             |    5 ++-
 arch/microblaze/pci/xilinx_pci.c             |    1 +
 drivers/ata/sata_dwc_460ex.c                 |    4 +-
 drivers/block/xsysace.c                      |    1 +
 drivers/char/xilinx_hwicap/xilinx_hwicap.c   |    1 +
 drivers/mtd/maps/physmap_of.c                |    1 +
 drivers/serial/of_serial.c                   |    3 +-
 include/linux/spi/spi.h                      |    3 ++
 10 files changed, 16 insertions(+), 36 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
