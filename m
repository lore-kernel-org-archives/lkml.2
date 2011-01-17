Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1AQSvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 13:51:00 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43598 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1AQSu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 13:50:57 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 17 Jan 2011 11:50:36 -0700
X-Google-Sender-Auth: utMhFqiQH6SMBnmw7aL_HXTfHvw
Message-ID: <AANLkTikCJy4QWGxyRwv53JGMKf12Zqh_8pZOy82eAWWc@mail.gmail.com>
Subject: [git pull] and spi bugfix and a devicetree patch.
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Guennadi Liakhovetski <lg@denx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

To more minor changes.  This should be it from me for the merge window.

g.

The following changes since commit e78bf5e6cbe837daa6ab628a5f679548742994d3:

  drivers/nfc/pn544.c: fix min_t warnings (2011-01-16 17:28:21 -0800)

are available in the git repository at:
  git://git.secretlab.ca/git/linux-2.6 next-devicetree

Grant Likely (1):
      dt/flattree: Return virtual address from early_init_dt_alloc_memory_arch()

Guennadi Liakhovetski (1):
      spi/spi_sh_msiof: fix a wrong free_irq() parameter

 arch/microblaze/kernel/prom.c |    4 ++--
 arch/mips/kernel/prom.c       |    6 ++----
 arch/powerpc/kernel/prom.c    |    4 ++--
 drivers/of/fdt.c              |    8 +-------
 drivers/spi/spi_sh_msiof.c    |    2 +-
 include/linux/of_fdt.h        |    2 +-
 6 files changed, 9 insertions(+), 17 deletions(-)


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
