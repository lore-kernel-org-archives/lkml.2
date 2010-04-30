Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab0D3Rym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:54:42 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:44732 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933678Ab0D3Rxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:53:44 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Apr 2010 09:07:27 -0600
X-Google-Sender-Auth: 8e1b545c4eaf3f90
Message-ID: <q2qfa686aa41004300807wb5afdaf3s1f53980b39232119@mail.gmail.com>
Subject: [git pull] spi & OF fixes and documentation cleanup.
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "hector.palacios" <hector.palacios@digi.com>,
       Roman Tereshonkov <roman.tereshonkov@nokia.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the bug fixes and cleanups I've collected for 2.6.34.  All
pretty minor stuff.

g.

The following changes since commit 01bf0b64579ead8a82e7cfc32ae44bc667e7ad0f:
  Linus Torvalds (1):
        Linux 2.6.34-rc5

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 merge

Dan Carpenter (2):
      gpio: potential null dereference
      of: check for IS_ERR()

Hector Palacios (1):
      spi: spidev_test gives error upon 1-byte transfer

Roman Tereshonkov (4):
      spi: release device claimed by bus_find_device_by_name
      spi: spi_device memory should be released instead of device.
      omap2_mcspi: Flush posted writes
      omap2_mcspi: small fixes of output data format

Wolfram Sang (1):
      serial/mpc52xx_uart: Drop outdated comments

 Documentation/spi/spidev_test.c |    2 +-
 drivers/gpio/gpiolib.c          |    3 ++-
 drivers/of/of_mdio.c            |    2 +-
 drivers/serial/mpc52xx_uart.c   |   33 ---------------------------------
 drivers/spi/omap2_mcspi.c       |    5 +++--
 drivers/spi/spi.c               |    8 +++++---
 6 files changed, 12 insertions(+), 41 deletions(-)

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
