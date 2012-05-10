Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190Ab2EJRcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:32:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33072 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2EJRcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:32:33 -0400
Date: Thu, 10 May 2012 10:32:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/52] 3.3.6-stable review
Message-ID: <20120510173229.GA5678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.3.6 release.
There are 52 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat May 12 17:31:31 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.3.6-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
 Documentation/networking/ip-sysctl.txt             |    4 +-
 Makefile                                           |    4 +-
 arch/arm/kernel/ptrace.c                           |   24 ++--
 arch/arm/kernel/smp.c                              |    4 +-
 arch/arm/kernel/sys_arm.c                          |    2 +-
 .../include/mach/ctrl_module_pad_core_44xx.h       |    8 +-
 arch/arm/mach-orion5x/mpp.h                        |    4 +-
 arch/arm/mm/cache-l2x0.c                           |   25 ++--
 arch/ia64/kvm/kvm-ia64.c                           |    5 +
 arch/s390/kvm/intercept.c                          |   20 +--
 arch/s390/kvm/kvm-s390.c                           |    2 +-
 arch/x86/boot/compressed/relocs.c                  |    2 -
 arch/x86/kernel/setup_percpu.c                     |   14 +-
 arch/x86/kvm/pmu.c                                 |    2 +-
 arch/x86/kvm/vmx.c                                 |   10 +-
 arch/x86/kvm/x86.c                                 |   19 ++-
 arch/x86/xen/enlighten.c                           |    7 +-
 arch/x86/xen/mmu.c                                 |    7 +-
 drivers/block/mtip32xx/Kconfig                     |    2 +-
 drivers/block/mtip32xx/mtip32xx.c                  |   34 ++---
 drivers/gpu/drm/i915/intel_hdmi.c                  |    2 +-
 drivers/gpu/drm/i915/intel_ringbuffer.c            |    9 +-
 drivers/gpu/drm/i915/intel_sdvo.c                  |    6 +
 drivers/net/ethernet/broadcom/tg3.c                |   18 ++-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   35 +++--
 drivers/net/ethernet/intel/igb/igb_main.c          |    3 +-
 drivers/net/ethernet/marvell/sky2.c                |   31 +++--
 drivers/net/ethernet/marvell/sky2.h                |    1 -
 drivers/net/ethernet/sun/sungem.c                  |    2 +-
 drivers/net/usb/asix.c                             |    4 +-
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/platform/x86/sony-laptop.c                 |    2 +-
 drivers/regulator/max8997.c                        |    2 +-
 fs/cifs/cifssmb.c                                  |    6 +-
 fs/hugetlbfs/inode.c                               |   54 +++-----
 fs/nfsd/nfs4proc.c                                 |    8 +-
 fs/nfsd/vfs.c                                      |    2 +-
 include/asm-generic/statfs.h                       |    2 +-
 include/linux/hugetlb.h                            |   14 +-
 include/linux/kvm_host.h                           |    7 +
 include/linux/netdevice.h                          |   50 +++++---
 include/linux/seqlock.h                            |    2 +-
 mm/hugetlb.c                                       |  135 ++++++++++++++++----
 net/core/dev.c                                     |   20 +++
 net/ipv4/tcp.c                                     |    9 +-
 net/ipv4/tcp_input.c                               |   11 +-
 net/l2tp/l2tp_ip.c                                 |    3 +-
 net/sched/sch_netem.c                              |    6 +-
 sound/soc/codecs/tlv320aic23.c                     |    4 +-
 sound/soc/soc-core.c                               |    6 +-
 virt/kvm/iommu.c                                   |   23 ++--
 virt/kvm/kvm_main.c                                |   23 ++--
 52 files changed, 462 insertions(+), 239 deletions(-)

