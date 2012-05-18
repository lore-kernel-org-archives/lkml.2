Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762554Ab2ERCw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762517Ab2ERCwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:24 -0400
Message-Id: <20120518023254.339945758@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:32:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/53] 3.2.18-stable review
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.2.18 release.
There are 53 patches in this series, which will be posted as responses
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun May 20 13:00:00 UTC 2012.
Anything received after that time might be too late.

The whole patch series should soon be available in one patch at:
	kernel.org/pub/linux/kernel/v3.x/stable-review/patch-3.2.18-rc1.gz
and the diffstat can be found below.

Ben.

-------------
 Documentation/networking/ip-sysctl.txt             |    4 +-
 Makefile                                           |    4 +-
 .../include/mach/ctrl_module_pad_core_44xx.h       |    8 +-
 arch/arm/mach-orion5x/mpp.h                        |    4 +-
 arch/arm/mm/fault.c                                |    4 +-
 arch/arm/vfp/vfpmodule.c                           |   10 ++-
 arch/ia64/include/asm/unistd.h                     |    3 +-
 arch/ia64/kernel/entry.S                           |    1 +
 arch/sparc/kernel/central.c                        |    2 +-
 arch/sparc/mm/ultra.S                              |    6 +-
 arch/tile/kernel/compat_signal.c                   |   12 ++-
 drivers/crypto/Kconfig                             |    1 +
 drivers/gpio/gpio-ml-ioh.c                         |    1 +
 drivers/md/dm-mpath.c                              |    4 +-
 drivers/md/md.c                                    |    2 +
 drivers/media/rc/ene_ir.c                          |   32 ++++----
 drivers/media/rc/fintek-cir.c                      |   20 ++---
 drivers/media/rc/ite-cir.c                         |   20 ++---
 drivers/media/rc/nuvoton-cir.c                     |   36 ++++-----
 drivers/media/rc/winbond-cir.c                     |   78 ++++++++++----------
 drivers/media/video/marvell-ccic/mmp-driver.c      |    1 -
 drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                |   18 ++++-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |    6 +-
 drivers/net/ethernet/marvell/sky2.c                |   31 +++++---
 drivers/net/ethernet/marvell/sky2.h                |    1 -
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |    1 +
 drivers/net/ethernet/sun/sungem.c                  |    2 +-
 drivers/net/phy/icplus.c                           |    3 +-
 drivers/net/usb/asix.c                             |    4 +-
 drivers/net/usb/cdc_ether.c                        |   30 +++++++-
 drivers/net/usb/usbnet.c                           |   54 ++++++++++----
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    2 +-
 drivers/regulator/max8997.c                        |    2 +-
 drivers/spi/spi-topcliff-pch.c                     |   78 +++++++++++++++++---
 drivers/target/target_core_file.c                  |   22 ++++--
 drivers/target/target_core_pr.c                    |    3 +
 drivers/target/target_core_tpg.c                   |   22 ------
 fs/ext4/xattr.c                                    |    7 +-
 fs/jffs2/gc.c                                      |    2 +-
 fs/nfs/nfs4proc.c                                  |    1 +
 include/linux/mtd/map.h                            |    2 +-
 include/linux/usb/usbnet.h                         |    3 +-
 kernel/fork.c                                      |    3 +
 mm/hugetlb.c                                       |    1 -
 mm/nobootmem.c                                     |    3 +-
 mm/percpu.c                                        |   10 +++
 net/core/dev.c                                     |   20 +++++
 net/ipv4/tcp.c                                     |   12 +--
 net/ipv4/tcp_input.c                               |   11 ++-
 net/l2tp/l2tp_ip.c                                 |    3 +-
 net/sched/sch_netem.c                              |    6 +-
 sound/pci/echoaudio/echoaudio_dsp.c                |    2 +-
 sound/pci/hda/hda_intel.c                          |    6 +-
 sound/pci/hda/patch_sigmatel.c                     |    6 +-
 sound/soc/codecs/wm8994.c                          |    2 +-
 57 files changed, 401 insertions(+), 239 deletions(-)

-- 
Ben Hutchings
Every program is either trivial or else contains at least one bug

