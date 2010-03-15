Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937168Ab0COXUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:20:33 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:15026 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937130Ab0COXUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:20:31 -0400
Date: Mon, 15 Mar 2010 23:20:27 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, Vasily Khoruzhick <anarsoul@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PULL] Please pull bjdooks' for-linus/samsung-fixes
Message-ID: <20100315232027.GA11570@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the following ARM/Samsung fixes:

The following changes since commit a3d3203e4bb40f253b1541e310dc0f9305be7c84:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6

are available in the git repository at:

  git://git.fluff.org/bjdooks/linux.git for-linus/samsung-fixes

Ben Dooks (2):
      ARM: SAMSUNG: Fix build error from stale define in <plat/uncompress.h>
      ARM: SAMSUNG: Fixup commit 4e6d488af37980d224cbf298224db6173673f362

Vasily Khoruzhick (2):
      ARM: S3C2440: Fix s3c2440 cpufreq compilation post move.
      ARM: SAMSUNG: Add suspend/resume support for S3C PWM driver

 .../s3c2440-cpufreq.c                              |    0
 arch/arm/mach-s3c64xx/include/mach/debug-macro.S   |    2 +-
 arch/arm/mach-s5p6440/include/mach/debug-macro.S   |    2 +-
 arch/arm/mach-s5p6442/include/mach/debug-macro.S   |    2 +-
 arch/arm/plat-samsung/include/plat/uncompress.h    |    2 -
 arch/arm/plat-samsung/pwm.c                        |   35 ++++++++++++++++++++
 6 files changed, 38 insertions(+), 5 deletions(-)
 rename arch/arm/{plat-s3c24xx => mach-s3c2440}/s3c2440-cpufreq.c (100%)

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
