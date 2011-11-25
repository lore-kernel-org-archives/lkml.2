Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1KYEsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 23:48:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:38159 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab1KYEsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 23:48:30 -0500
Message-ID: <1322196490.32635.18.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 25 Nov 2011 15:48:10 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a handful of tiny fixes for ppc, essentially embedded bits and
all reasonably trivial.

Cheers,
Ben.

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Alexandre Rusev (1):
      powerpc/fsl-lbc: Fix for fsl_upm

Joakim Tjernlund (1):
      powerpc/qe: Fixup QE_General4 errata

Julia Lawall (1):
      arch/powerpc/sysdev/ehv_pic.c: add missing kfree

Kumar Gala (2):
      powerpc/85xx: Fix compile error on p3060_qds.c
      powerpc: Fix compiliation with hugetlbfs enabled

Paul Bolle (1):
      powerpc/p3060qds: Fix select of 'MPC8xxx_GPIO'

Roy Zang (1):
      powerpc/p1023: set IRQ[4:6,11] to active-high level sensitive for PCIe

Shaohui Xie (1):
      drivers/edac/mpc85xx_edac.c: fix memory controller compatible for edac

Tony Breeds (1):
      powerpc/44x: Add mtd ndfc to the ppx44x defconfig

 arch/powerpc/boot/dts/p1023rds.dts      |   17 +++++++++++++----
 arch/powerpc/configs/ppc44x_defconfig   |    2 ++
 arch/powerpc/mm/hugetlbpage.c           |    1 +
 arch/powerpc/platforms/85xx/Kconfig     |    2 +-
 arch/powerpc/platforms/85xx/p3060_qds.c |    2 +-
 arch/powerpc/sysdev/ehv_pic.c           |    1 +
 arch/powerpc/sysdev/fsl_lbc.c           |    1 +
 arch/powerpc/sysdev/qe_lib/qe.c         |    2 +-
 drivers/edac/mpc85xx_edac.c             |    2 +-
 9 files changed, 22 insertions(+), 8 deletions(-)


