Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1CSJUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 05:20:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:51749 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948Ab1CSJUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 05:20:05 -0400
Date: Sat, 19 Mar 2011 10:20:03 +0100
From: Michal Marek <mmarek@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mfm@muteddisk.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] kbuild: Makefile cleanups all over the tree
Message-ID: <20110319092003.GA19739@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

there is one more branch this time. Matt Mooney did a cleanup of our
Makefiles, mostly getting rid of EXTRA_CFLAGS assignments in favor of
cflags-y.  These are commits that haven't been picked up by the
respective subsystem maintainers. The branch is based on v2.6.38 to
avoid some conflicts. The only one happens in drivers/hwmon/Makefile and
is trivial to resolve. Please pull.

Thanks,
Michal

The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:

  Linux 2.6.38 (2011-03-14 18:20:32 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git trivial

matt mooney (25):
      kernel: change to new flag variable
      arm: change to new flag variables
      h8300: change to new flag variable
      ia64: change to new flag variables
      microblaze: change to new flag variable
      mips: change to new flag variable
      s390: change to new flag variable
      um: change to new flag variables
      xtensa: change to new flag variable
      fs: change to new flag variable
      char: change to new flag variable
      dma: change to new flag variable
      hwmon: change to new flag variable
      ide: change to new flag variable
      ieee802154: change to new flag variable
      isdn: change to new flag variable
      memstick: change to new flag variable
      message: change to new flag variable
      misc: change to new flag variable
      net: change to new flag variable
      pps: change to new flag variable
      rapidio: change to new flag variable
      rtc: change to new flag variable
      scsi: change to new flag variable
      video: change to new flag variable

 arch/arm/boot/compressed/Makefile           |    4 ++--
 arch/arm/vfp/Makefile                       |    4 ++--
 arch/h8300/boot/compressed/Makefile         |    2 +-
 arch/ia64/kvm/Makefile                      |    4 ++--
 arch/ia64/sn/kernel/Makefile                |    2 +-
 arch/ia64/sn/kernel/sn2/Makefile            |    2 +-
 arch/ia64/sn/pci/Makefile                   |    2 +-
 arch/ia64/sn/pci/pcibr/Makefile             |    2 +-
 arch/ia64/uv/kernel/Makefile                |    2 +-
 arch/microblaze/kernel/cpu/Makefile         |    2 +-
 arch/mips/Makefile                          |    4 ++--
 arch/mips/bcm63xx/boards/Makefile           |    2 +-
 arch/mips/fw/arc/Makefile                   |    2 +-
 arch/mips/jz4740/Makefile                   |    2 +-
 arch/mips/oprofile/Makefile                 |    2 +-
 arch/mips/pmc-sierra/yosemite/Makefile      |    2 +-
 arch/mips/powertv/Makefile                  |    2 +-
 arch/mips/powertv/asic/Makefile             |    2 +-
 arch/mips/powertv/pci/Makefile              |    2 +-
 arch/s390/boot/Makefile                     |    2 +-
 arch/s390/kvm/Makefile                      |    2 +-
 arch/s390/math-emu/Makefile                 |    2 +-
 arch/um/sys-ppc/Makefile                    |   10 +++++-----
 arch/xtensa/boot/Makefile                   |    2 +-
 arch/xtensa/boot/lib/Makefile               |    2 +-
 drivers/char/mwave/Makefile                 |    4 ++--
 drivers/char/mwave/README                   |    2 +-
 drivers/dma/Makefile                        |    8 ++------
 drivers/hwmon/Makefile                      |    4 +---
 drivers/ide/Makefile                        |    2 +-
 drivers/ieee802154/Makefile                 |    2 +-
 drivers/isdn/hisax/Makefile                 |    2 +-
 drivers/memstick/Makefile                   |    4 +---
 drivers/memstick/core/Makefile              |    4 ----
 drivers/memstick/host/Makefile              |    4 ----
 drivers/message/fusion/Makefile             |    2 +-
 drivers/misc/cb710/Makefile                 |    4 +---
 drivers/misc/sgi-gru/Makefile               |    4 +---
 drivers/net/caif/Makefile                   |    4 +---
 drivers/net/skfp/Makefile                   |    2 +-
 drivers/net/wan/lmc/Makefile                |    2 +-
 drivers/net/wireless/hostap/hostap_config.h |    4 ++--
 drivers/net/wireless/zd1211rw/Makefile      |    4 +---
 drivers/pps/clients/Makefile                |    4 +---
 drivers/rapidio/Makefile                    |    4 +---
 drivers/rapidio/switches/Makefile           |    4 ----
 drivers/rtc/Makefile                        |    4 +---
 drivers/scsi/aacraid/Makefile               |    2 +-
 drivers/scsi/aic94xx/Makefile               |    4 +---
 drivers/scsi/libsas/Makefile                |    2 +-
 drivers/scsi/lpfc/Makefile                  |    6 ++----
 drivers/scsi/mvsas/Makefile                 |    4 +---
 drivers/scsi/pcmcia/Makefile                |    2 +-
 drivers/video/intelfb/Makefile              |    5 +----
 fs/affs/Makefile                            |    2 +-
 fs/coda/Makefile                            |    2 +-
 fs/gfs2/Makefile                            |    2 +-
 fs/jfs/Makefile                             |    2 +-
 fs/ncpfs/Makefile                           |    2 +-
 fs/ntfs/Makefile                            |   19 +++++++------------
 fs/ocfs2/Makefile                           |    4 ++--
 fs/ocfs2/dlm/Makefile                       |    2 +-
 fs/ocfs2/dlmfs/Makefile                     |    2 +-
 fs/reiserfs/Makefile                        |    4 +---
 fs/xfs/Makefile                             |    7 ++-----
 kernel/gcov/Makefile                        |    2 +-
 kernel/power/Makefile                       |    3 ++-
 67 files changed, 85 insertions(+), 137 deletions(-)
