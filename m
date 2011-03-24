Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab1CXFy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 01:54:58 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59985 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1CXFy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 01:54:57 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 23 Mar 2011 23:54:36 -0600
X-Google-Sender-Auth: eMzSeal3Tw0KtzbjOYvZPgW-R2I
Message-ID: <AANLkTi=_o_WPfvH7jh9zr87+JXT4wRsVEzUzMvrgOrgf@mail.gmail.com>
Subject: [git pull] last device tree and spi changes for 2.6.39 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andres Salomon <dilinger@queued.net>,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A few last patches for .39.  It's such a small set that I put them all
into one branch.  Please pull!

Thanks,
g.

The following changes since commit 4bbba111d94781d34081c37856bbc5eb33f6c72a:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
(2011-03-23 07:58:09 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux-2.6 devicetree/merge

Andres Salomon (1):
      of/flattree: minor cleanups

Grant Likely (3):
      dt: Refactor of_platform_bus_probe()
      dt: protect against NULL matches passed to of_match_node()
      dt: eliminate OF_NO_DEEP_PROBE and test for NULL match table

Jarkko Nikula (1):
      spi/omap_mcspi: Fix broken last word xfer

Philippe Langlais (1):
      spi/pl022: Add loopback support for the SPI on 5500

 drivers/of/base.c           |    3 ++
 drivers/of/fdt.c            |    6 ++-
 drivers/of/platform.c       |   72 ++++++++++++++-----------------------------
 drivers/spi/amba-pl022.c    |   20 +++++++++++-
 drivers/spi/omap2_mcspi.c   |    6 ++--
 include/linux/of_platform.h |    3 --
 6 files changed, 52 insertions(+), 58 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
