Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161259Ab2GLQBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:01:06 -0400
Received: from mga14.intel.com ([143.182.124.37]:44146 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030320Ab2GLQBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:01:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="121631368"
Date: Thu, 12 Jul 2012 18:00:59 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Axel Lin <axel.lin@gmail.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Paul Bolle <pebolle@tiscali.nl>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Russ Dill <Russ.Dill@gmail.com>
Subject: [GIT] [3.5] MFD fixes
Message-ID: <20120712160059.GB23772@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is a pull request for the 3.5 MFD fixes.
With this one we have:

- 3 Palmas fixes, 1 of them being a build error fix.
- 2 mc13xx fixes. 1 for fixing an SPI regmap configuration and another one for
  working around an i.Mx hardware bug.
- 1 omap-usb regression fix.
- 1 twl6040 build breakage fix.
- 1 file deletion (ab5500-core.h) that was overlooked during the last merge
  window.

Thanks in advance for pulling them in.

The following changes since commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a:

  Linux 3.5-rc6 (2012-07-07 17:23:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git tags/mfd-for-linus-3.5

for you to fetch changes up to b330f85d3d42cbe091736a0abd8f005b448d133a:

  mfd: Add missing hunk to change palmas irq to clear on read (2012-07-09 00:16:26 +0200)

----------------------------------------------------------------
MFD Fixes for 3.5

- 3 Palmas fixes, 1 of them being a build error fix.
- 2 mc13xx fixes. 1 for fixing an SPI regmap configuration and another one for
  working around an i.Mx hardware bug.
- 1 omap-usb regression fix.
- 1 twl6040 build breakage fix.
- 1 file deletion (ab5500-core.h) that was overlooked during the last merge
  window.

----------------------------------------------------------------
Axel Lin (1):
      mfd: Add terminating entry for i2c_device_id palmas table

Graeme Gregory (2):
      mfd: Fix palmas regulator pdata missing
      mfd: Add missing hunk to change palmas irq to clear on read

Paul Bolle (1):
      mfd: Delete ab5500-core.h

Peter Ujfalusi (1):
      mfd: Update twl6040 Kconfig to avoid build breakage

Philippe Rétornaz (2):
      mfd: Fix mc13xxx SPI regmap
      mfd: mc13xxx workaround SPI hardware bug on i.Mx

Russ Dill (1):
      mfd: USB: Fix the omap-usb EHCI ULPI PHY reset fix issues.

 drivers/mfd/Kconfig          |    1 +
 drivers/mfd/ab5500-core.h    |   87 ------------------------------------------
 drivers/mfd/mc13xxx-spi.c    |   67 +++++++++++++++++++++++++++++++-
 drivers/mfd/omap-usb-host.c  |   48 ++++++++++++++++++++++-
 drivers/mfd/palmas.c         |   13 ++++++-
 drivers/usb/host/ehci-omap.c |   18 ++++-----
 6 files changed, 133 insertions(+), 101 deletions(-)
 delete mode 100644 drivers/mfd/ab5500-core.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
