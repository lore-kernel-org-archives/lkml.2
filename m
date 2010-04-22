Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab0DVVVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 17:21:54 -0400
Received: from xenotime.net ([72.52.64.118]:59741 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757045Ab0DVVVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 17:21:51 -0400
Message-ID: <4BD0BDEC.4020608@xenotime.net>
Date: Thu, 22 Apr 2010 14:21:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Francis Galiegue <fgaliegue@gmail.com>
CC: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Documentation/: it's -> its where appropriate
References: <1271970765-11856-1-git-send-email-fgaliegue@gmail.com> <1271970765-11856-2-git-send-email-fgaliegue@gmail.com>
In-Reply-To: <1271970765-11856-2-git-send-email-fgaliegue@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Galiegue wrote:
> Fix obvious cases of "it's" being used when "its" was meant.
> 
> Signed-off-by: Francis Galiegue <fgaliegue@gmail.com>

I didn't check every last one of them, but the ones that I did check
looked correct.

Would the trivial patch maintainer mind merging this one, please?

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
>  Documentation/ABI/testing/sysfs-devices-memory     |    2 +-
>  Documentation/DMA-API-HOWTO.txt                    |    2 +-
>  Documentation/DocBook/libata.tmpl                  |    2 +-
>  Documentation/PCI/pci-error-recovery.txt           |    4 ++--
>  Documentation/Smack.txt                            |    2 +-
>  Documentation/arm/SA1100/ADSBitsy                  |    2 +-
>  Documentation/arm/Sharp-LH/ADC-LH7-Touchscreen     |    2 +-
>  Documentation/atomic_ops.txt                       |    2 +-
>  Documentation/blackfin/bfin-gpio-notes.txt         |    2 +-
>  Documentation/cachetlb.txt                         |    6 +++---
>  Documentation/cgroups/memcg_test.txt               |    2 +-
>  Documentation/cgroups/memory.txt                   |    2 +-
>  Documentation/connector/connector.txt              |    2 +-
>  Documentation/dvb/ci.txt                           |    2 +-
>  Documentation/dvb/contributors.txt                 |    2 +-
>  .../filesystems/autofs4-mount-control.txt          |    2 +-
>  Documentation/filesystems/ceph.txt                 |    2 +-
>  Documentation/filesystems/dlmfs.txt                |    2 +-
>  Documentation/filesystems/fiemap.txt               |   12 ++++++------
>  Documentation/filesystems/fuse.txt                 |    4 ++--
>  Documentation/filesystems/hpfs.txt                 |    2 +-
>  Documentation/filesystems/nfs/rpc-cache.txt        |    2 +-
>  Documentation/filesystems/proc.txt                 |    4 ++--
>  Documentation/filesystems/smbfs.txt                |    2 +-
>  Documentation/filesystems/vfs.txt                  |    2 +-
>  Documentation/hwmon/lm85                           |    2 +-
>  Documentation/input/joystick.txt                   |    2 +-
>  Documentation/intel_txt.txt                        |    2 +-
>  Documentation/kbuild/kconfig-language.txt          |    2 +-
>  Documentation/kernel-docs.txt                      |   10 +++++-----
>  Documentation/kprobes.txt                          |    2 +-
>  Documentation/laptops/laptop-mode.txt              |    2 +-
>  Documentation/lguest/lguest.c                      |    2 +-
>  Documentation/md.txt                               |    2 +-
>  Documentation/netlabel/lsm_interface.txt           |    2 +-
>  Documentation/networking/ifenslave.c               |    2 +-
>  Documentation/networking/packet_mmap.txt           |    4 ++--
>  Documentation/power/regulator/consumer.txt         |   10 +++++-----
>  Documentation/power/regulator/machine.txt          |    2 +-
>  Documentation/power/regulator/overview.txt         |    6 +++---
>  Documentation/powerpc/booting-without-of.txt       |    2 +-
>  Documentation/powerpc/phyp-assisted-dump.txt       |    2 +-
>  Documentation/rt-mutex-design.txt                  |    2 +-
>  Documentation/scsi/ChangeLog.lpfc                  |    4 ++--
>  Documentation/scsi/FlashPoint.txt                  |    2 +-
>  Documentation/scsi/dtc3x80.txt                     |    2 +-
>  Documentation/scsi/ncr53c8xx.txt                   |    2 +-
>  Documentation/scsi/osst.txt                        |    2 +-
>  Documentation/scsi/scsi_fc_transport.txt           |    4 ++--
>  Documentation/scsi/sym53c8xx_2.txt                 |    2 +-
>  Documentation/sound/alsa/soc/dapm.txt              |    4 ++--
>  Documentation/sound/alsa/soc/machine.txt           |    2 +-
>  Documentation/sound/alsa/soc/overview.txt          |    2 +-
>  Documentation/usb/WUSB-Design-overview.txt         |    2 +-
>  Documentation/vm/numa_memory_policy.txt            |    4 ++--
>  Documentation/w1/w1.generic                        |    2 +-
>  56 files changed, 81 insertions(+), 81 deletions(-)

