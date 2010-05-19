Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0ESIdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:33:36 -0400
Received: from trinity.fluff.org ([89.16.178.74]:35131 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0ESIde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:33:34 -0400
Date: Wed, 19 May 2010 09:33:27 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: InKi Dae <inki.dae@samsung.com>, kgene.kim@samsung.com,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org,
       Linux Samsung SoC <linux-samsung-soc@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Please pull s3c-fb driver updates
Message-ID: <20100519083327.GV26401@trinity.fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following patches for the s3c-fb driver for fixes and
device support updates.

The following changes since commit 7ebd467551ed6ae200d7835a84bbda0dcadaa511:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-2635/s3c-fb

Ben Dooks (5):
      s3c-fb: Change to depending on CONFIG_S3C_FB_DEV
      s3c-fb: only init window colour key controls for windows with blending
      s3c-fb: Initial move to unifying the header files
      s3c-fb: udpate to support s3c2416/s3c2443 style hardware
      s3c-fb: Integrate palette setup code into main driver

InKi Dae (2):
      s3c-fb: add default window feature.
      s3c-fb: fixed distortedness situation for the mode more then 24bpp.

 arch/arm/mach-s3c64xx/include/mach/regs-fb.h    |   20 --
 arch/arm/mach-s5pc100/include/mach/regs-fb.h    |   34 --
 arch/arm/plat-samsung/include/plat/fb.h         |    3 +
 arch/arm/plat-samsung/include/plat/regs-fb-v4.h |   78 +-----
 arch/arm/plat-samsung/include/plat/regs-fb.h    |    5 +
 drivers/video/Kconfig                           |    2 +-
 drivers/video/s3c-fb.c                          |  412 +++++++++++++++++++----
 7 files changed, 362 insertions(+), 192 deletions(-)
