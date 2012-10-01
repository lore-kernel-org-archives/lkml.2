Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab2JANQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:16:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab2JANQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:16:17 -0400
Date: Mon, 1 Oct 2012 15:16:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial
Message-ID: <alpine.LNX.2.00.1210011514450.27440@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive updates queued in trivial tree.


Tiny usual fixes all over the place.


Alan Cox (1):
      tmiofb: missing NULL pointer checks

Anatol Pomozov (1):
      treewide: fix comment/printk/variable typos

Fengguang Wu (1):
      Coccinelle: fix typo in memdup_user.cocci

Javi Merino (1):
      bootmem: Fix the short description of reserve_bootmem()

Jesper Juhl (2):
      doc: aliasing-test: close fd on write error
      doc: getdelays.c: remember to close() socket on error in create_nl_socket()

Jiri Kosina (1):
      Revert "backlight: fix memory leak on obscure error path"

Jon Mason (4):
      megaraid: remove unnecessary #defines
      gdt: remove unnecessary #defines
      hpet: Remove unused PCI Vendor ID #define
      ioat: remove unused #defines

Kleber Sacilotto de Souza (1):
      ipr: fix small coding style issues

Liu Bo (3):
      btrfs: fix comment typo in btrfs_finish_ordered_io
      fs/fs-writeback.c: cleanup riteback_sb_inodes kerneldoc
      doc: fix old config name of kprobetrace

Masanari Iida (7):
      scsi: fix various printk and comment typos
      tools/testing: fix comment / output typos
      tools: perf: Fix typo in tools/perf
      spi: fix comment/printk typos in spi
      dma: fix comments
      mmc: fix comment typos
      mfd: printk/comment fixes

Maxim Nikulin (1):
      platform/x86: fix asus_laptop.wled_type module parameter

Oskar Schirmer (1):
      doc: fix broken utf8 encoding

Paul Bolle (5):
      powerpc: remove four unused files from .gitignore
      pci: remove unused .gitignore file
      AppArmor: remove af_names.h from .gitignore
      oss: remove maui_boot.h from .gitignore and dontdiff
      b43: Kconfig: drop unknown symbol 'BRCMSMAC_MODULE'

Paul Gortmaker (1):
      irqdesc: delete now orphaned references to timer_rand_state

Peter Meerwald (1):
      nfs: comment fix

Wang Sheng-Hui (2):
      btrfs: fix trivial typo for the comment of BTRFS_FREE_INO_OBJECTID
      btrfs: fix the commment for the action flags in delayed-ref.h

Yanchuan Nian (1):
      vfs: fix kerneldoc for generic_fh_to_parent()


 Documentation/accounting/getdelays.c               |    5 +-
 Documentation/dontdiff                             |    1 -
 Documentation/ia64/aliasing-test.c                 |    1 +
 Documentation/power/swsusp.txt                     |    2 +-
 Documentation/trace/kprobetrace.txt                |    2 +-
 arch/powerpc/boot/.gitignore                       |    4 -
 arch/x86/include/asm/hpet.h                        |    2 -
 drivers/dma/at_hdmac.c                             |    8 +-
 drivers/dma/ep93xx_dma.c                           |    2 +-
 drivers/dma/fsldma.c                               |    2 +-
 drivers/dma/imx-dma.c                              |    4 +-
 drivers/dma/intel_mid_dma.c                        |    2 +-
 drivers/dma/intel_mid_dma_regs.h                   |    6 +-
 drivers/dma/ioat/hw.h                              |    4 -
 drivers/dma/pl330.c                                |    2 +-
 drivers/dma/ppc4xx/adma.c                          |    2 +-
 drivers/dma/ste_dma40_ll.h                         |    2 +-
 drivers/mfd/ab8500-gpadc.c                         |    2 +-
 drivers/mfd/rc5t583.c                              |    2 +-
 drivers/mfd/rdc321x-southbridge.c                  |    2 +-
 drivers/mfd/tps65911-comparator.c                  |    2 +-
 drivers/mmc/core/sdio.c                            |    2 +-
 drivers/mmc/host/at91_mci.c                        |    2 +-
 drivers/mmc/host/atmel-mci.c                       |    2 +-
 drivers/mmc/host/omap_hsmmc.c                      |    2 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    2 +-
 drivers/mmc/host/vub300.c                          |    2 +-
 drivers/net/ethernet/3com/typhoon.c                |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.h     |    2 +-
 drivers/net/wireless/b43/Kconfig                   |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c  |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c        |    6 +-
 drivers/pci/.gitignore                             |    4 -
 drivers/scsi/aic7xxx/aic79xx_core.c                |    2 +-
 drivers/scsi/bfa/bfa_ioc.c                         |    2 +-
 drivers/scsi/bfa/bfa_ioc.h                         |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    4 +-
 drivers/scsi/gdth.h                                |    9 ---
 drivers/scsi/ipr.c                                 |   66 ++++++++++----------
 drivers/scsi/isci/host.c                           |    2 +-
 drivers/scsi/isci/init.c                           |    2 +-
 drivers/scsi/isci/port.c                           |    2 +-
 drivers/scsi/isci/request.c                        |    2 +-
 drivers/scsi/isci/task.c                           |    2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |    4 +-
 drivers/scsi/megaraid.c                            |    5 +-
 drivers/scsi/megaraid.h                            |   35 ----------
 drivers/scsi/mvumi.c                               |    6 +-
 drivers/scsi/qla4xxx/ql4_os.c                      |    6 +-
 drivers/scsi/vmw_pvscsi.c                          |    4 +-
 drivers/spi/spi-au1550.c                           |    2 +-
 drivers/spi/spi-bfin-sport.c                       |    2 +-
 drivers/spi/spi-oc-tiny.c                          |    2 +-
 drivers/spi/spi-ppc4xx.c                           |    4 +-
 drivers/spi/spi-topcliff-pch.c                     |    2 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |    4 +-
 drivers/video/backlight/88pm860x_bl.c              |    1 -
 drivers/video/exynos/exynos_mipi_dsi.c             |    2 +-
 drivers/video/tmiofb.c                             |    4 +
 drivers/w1/masters/ds1wm.c                         |    2 +-
 fs/btrfs/ctree.h                                   |    2 +-
 fs/btrfs/delayed-ref.h                             |    2 +-
 fs/btrfs/inode.c                                   |    4 +-
 fs/ext2/balloc.c                                   |    2 +-
 fs/ext3/balloc.c                                   |    2 +-
 fs/ext3/inode.c                                    |    2 +-
 fs/ext4/inode.c                                    |   14 ++--
 fs/ext4/mballoc.c                                  |    2 +-
 fs/fs-writeback.c                                  |    4 -
 fs/libfs.c                                         |    2 +-
 fs/nfs/super.c                                     |    2 +-
 include/linux/irqdesc.h                            |    2 -
 include/linux/mfd/max8998.h                        |    2 +-
 include/trace/define_trace.h                       |    2 +-
 mm/bootmem.c                                       |    2 +-
 net/8021q/vlanproc.c                               |    2 +-
 scripts/coccinelle/api/memdup_user.cocci           |    4 +-
 security/apparmor/.gitignore                       |    1 -
 sound/oss/.gitignore                               |    1 -
 tools/perf/util/callchain.h                        |    2 +-
 tools/perf/util/parse-events-test.c                |    2 +-
 tools/perf/util/python-ext-sources                 |    2 +-
 tools/testing/ktest/examples/include/defaults.conf |    2 +-
 tools/testing/ktest/examples/include/tests.conf    |    2 +-
 tools/testing/selftests/vm/run_vmtests             |    6 +-
 87 files changed, 142 insertions(+), 207 deletions(-)

-- 
Jiri Kosina
SUSE Labs
