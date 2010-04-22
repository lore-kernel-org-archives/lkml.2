Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab0DVVNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:13:13 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57828 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab0DVVNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=jPhPKy6L6wLt83aNcle58Xdb10OHu9xpd3TSaVwrzaTju6irrtuo/4XUoLIfMTTeiS
         ctH5Z5mkcDeKfJew1ig+IdfroYdnupZPSOO9BNDTvIC0KVvQa1OBLq46R39Rgn/Q1gzN
         QiEj/XizIXJzFWUk3zcmriElqHHGUX2Txprac=
From: Francis Galiegue <fgaliegue@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Francis Galiegue <fgaliegue@gmail.com>
Subject: Should I really bother all maintainers with this?
Date: Thu, 22 Apr 2010 23:12:44 +0200
Message-Id: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch only fixes quite a common mistake in Documentation/, and if I
scripts/get_maintainer.pl on the patch (which is recommended), I potentially
mail thousands of people who probably have more useful/exciting stuff to do
anyway. So, I submit it as is.

[Note: I am not on the list, so any replies should Cc: me]

Francis Galiegue (1):
  Documentation/: it's -> its where appropriate

 Documentation/ABI/testing/sysfs-devices-memory     |    2 +-
 Documentation/DMA-API-HOWTO.txt                    |    2 +-
 Documentation/DocBook/libata.tmpl                  |    2 +-
 Documentation/PCI/pci-error-recovery.txt           |    4 ++--
 Documentation/Smack.txt                            |    2 +-
 Documentation/arm/SA1100/ADSBitsy                  |    2 +-
 Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen     |    2 +-
 Documentation/atomic_ops.txt                       |    2 +-
 Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
 Documentation/cachetlb.txt                         |    6 +++---
 Documentation/cgroups/memcg_test.txt               |    2 +-
 Documentation/cgroups/memory.txt                   |    2 +-
 Documentation/connector/connector.txt              |    2 +-
 Documentation/dvb/ci.txt                           |    2 +-
 Documentation/dvb/contributors.txt                 |    2 +-
 .../filesystems/autofs4-mount-control.txt          |    2 +-
 Documentation/filesystems/ceph.txt                 |    2 +-
 Documentation/filesystems/dlmfs.txt                |    2 +-
 Documentation/filesystems/fiemap.txt               |   12 ++++++------
 Documentation/filesystems/fuse.txt                 |    4 ++--
 Documentation/filesystems/hpfs.txt                 |    2 +-
 Documentation/filesystems/nfs/rpc-cache.txt        |    2 +-
 Documentation/filesystems/proc.txt                 |    4 ++--
 Documentation/filesystems/smbfs.txt                |    2 +-
 Documentation/filesystems/vfs.txt                  |    2 +-
 Documentation/hwmon/lm85                           |    2 +-
 Documentation/input/joystick.txt                   |    2 +-
 Documentation/intel_txt.txt                        |    2 +-
 Documentation/kbuild/kconfig-language.txt          |    2 +-
 Documentation/kernel-docs.txt                      |   10 +++++-----
 Documentation/kprobes.txt                          |    2 +-
 Documentation/laptops/laptop-mode.txt              |    2 +-
 Documentation/lguest/lguest.c                      |    2 +-
 Documentation/md.txt                               |    2 +-
 Documentation/netlabel/lsm_interface.txt           |    2 +-
 Documentation/networking/ifenslave.c               |    2 +-
 Documentation/networking/packet_mmap.txt           |    4 ++--
 Documentation/power/regulator/consumer.txt         |   10 +++++-----
 Documentation/power/regulator/machine.txt          |    2 +-
 Documentation/power/regulator/overview.txt         |    6 +++---
 Documentation/powerpc/booting-without-of.txt       |    2 +-
 Documentation/powerpc/phyp-assisted-dump.txt       |    2 +-
 Documentation/rt-mutex-design.txt                  |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |    4 ++--
 Documentation/scsi/FlashPoint.txt                  |    2 +-
 Documentation/scsi/dtc3x80.txt                     |    2 +-
 Documentation/scsi/ncr53c8xx.txt                   |    2 +-
 Documentation/scsi/osst.txt                        |    2 +-
 Documentation/scsi/scsi_fc_transport.txt           |    4 ++--
 Documentation/scsi/sym53c8xx_2.txt                 |    2 +-
 Documentation/sound/alsa/soc/dapm.txt              |    4 ++--
 Documentation/sound/alsa/soc/machine.txt           |    2 +-
 Documentation/sound/alsa/soc/overview.txt          |    2 +-
 Documentation/usb/WUSB-Design-overview.txt         |    2 +-
 Documentation/vm/numa_memory_policy.txt            |    4 ++--
 Documentation/w1/w1.generic                        |    2 +-
 56 files changed, 81 insertions(+), 81 deletions(-)

