Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab1ANOWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:22:08 -0500
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:41816
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757415Ab1ANOTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:19:09 -0500
X-Greylist: delayed 357 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jan 2011 09:19:09 EST
From: matt mooney <mfm@muteddisk.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 00/27] update makefiles to use the newer flag variables
Date: Fri, 14 Jan 2011 06:12:23 -0800
Message-Id: <cover.1295006561.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

These are the patches that never made their way into the linux-next tree.
I have added all of the acks that came through.

Thanks,
matt


matt mooney (27):
  kernel: change to new flag variable
  alpha: change to new flag variables
  arm: change to new flag variables
  h8300: change to new flag variable
  ia64: change to new flag variables
  m68k: change to new flag variables
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

 arch/alpha/kernel/Makefile                  |    4 ++--
 arch/alpha/lib/Makefile                     |    4 ++--
 arch/alpha/math-emu/Makefile                |    2 +-
 arch/alpha/mm/Makefile                      |    2 +-
 arch/alpha/oprofile/Makefile                |    2 +-
 arch/arm/boot/compressed/Makefile           |    4 ++--
 arch/arm/vfp/Makefile                       |    4 ++--
 arch/h8300/boot/compressed/Makefile         |    2 +-
 arch/ia64/kvm/Makefile                      |    4 ++--
 arch/ia64/sn/kernel/Makefile                |    2 +-
 arch/ia64/sn/kernel/sn2/Makefile            |    2 +-
 arch/ia64/sn/pci/Makefile                   |    2 +-
 arch/ia64/sn/pci/pcibr/Makefile             |    2 +-
 arch/ia64/uv/kernel/Makefile                |    2 +-
 arch/m68k/math-emu/Makefile                 |    4 ++--
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
 drivers/rapidio/switches/Makefile           |    4 -----
 drivers/rtc/Makefile                        |    4 +---
 drivers/scsi/aacraid/Makefile               |    2 +-
 drivers/scsi/aic94xx/Makefile               |    4 +---
 drivers/scsi/libsas/Makefile                |    6 ++----
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
 73 files changed, 95 insertions(+), 149 deletions(-)

-- 
1.7.3.4

