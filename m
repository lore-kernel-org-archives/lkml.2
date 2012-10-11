Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab2JKBD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:03:27 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54400 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757885Ab2JKBDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:03:20 -0400
X-Sasl-enc: yp8Wn8ZtT1An9CRJ0U5V//dTInUAw/hMYEGjkH8ijbJr 1349917398
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk
Subject: =?UTF-8?q?=5B=20000/120=5D=203=2E4=2E14-stable=20review?=
Date: Thu, 11 Oct 2012 09:59:12 +0900
Message-Id: <20121011005825.364610894@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.14 release.
There are 120 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Oct 13 00:57:53 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.14-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Mike Galbraith <mgalbraith@suse.de>
    sched: Fix migration thread runtime bogosity

Nikola Pajkovsky <npajkovs@redhat.com>
    udf: fix retun value on error path in udf_load_logicalvol

Frediano Ziglio <frediano.ziglio@citrix.com>
    Convert properly UTF-8 to UTF-16

Jeff Layton <jlayton@redhat.com>
    cifs: reinstate the forcegid option

Brian Norris <computersforpeace@gmail.com>
    JFFS2: don't fail on bitflips in OOB

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    mmc: sh-mmcif: avoid oops on spurious interrupts

Vaibhav Bedia <vaibhav.bedia@ti.com>
    mmc: omap_hsmmc: Pass on the suspend failure to the PM core

Andreas Bießmann <andreas@biessmann.de>
    mtd: omap2: fix module loading

Andreas Bießmann <andreas@biessmann.de>
    mtd: omap2: fix omap_nand_remove segfault

Shmulik Ladkani <shmulik.ladkani@gmail.com>
    mtd: nand: Use the mirror BBT descriptor when reading its version

Richard Genoud <richard.genoud@gmail.com>
    mtd: nandsim: bugfix: fail if overridesize is too big

Alexander Shiyan <shc_work@mail.ru>
    mtd: autcpu12-nvram: Fix compile breakage

Huang Shijie <shijie8@gmail.com>
    mtd: mtdpart: break it as soon as we parse out the partitions

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/resume

Seiji Aguchi <seiji.aguchi@hds.com>
    efi: initialize efi.runtime_version to make query_variable_info/update_capsule workable

Matthew Garrett <mjg@redhat.com>
    efi: Build EFI stub with EFI-appropriate options

Mel Gorman <mgorman@suse.de>
    mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mempolicy: fix refcount leak in mpol_set_shared_policy()

Mel Gorman <mgorman@suse.de>
    mempolicy: fix a race in shared_policy_replace()

KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    mempolicy: remove mempolicy sharing

KOSAKI Motohiro <kosaki.motohiro@gmail.com>
    revert "mm: mempolicy: Let vma_merge and vma_split handle vma->vm_policy linkages"

Francois Romieu <romieu@fr.zoreil.com>
    r8169: 8168c and later require bit 0x20 to be set in Config2 for PME signaling.

Francois Romieu <romieu@fr.zoreil.com>
    r8169: Config1 is read-only on 8168c and later.

Paul E. McKenney <paul.mckenney@linaro.org>
    rcu: Fix day-one dyntick-idle stall-warning bug

Frederic Weisbecker <fweisbec@gmail.com>
    score: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    m32r: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    cris: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    alpha: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    m68k: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    mn10300: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    frv: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    xtensa: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    parisc: Add missing RCU idle APIs on idle loop

Frederic Weisbecker <fweisbec@gmail.com>
    h8300: Add missing RCU idle APIs on idle loop

Paul E. McKenney <paul.mckenney@linaro.org>
    ia64: Add missing RCU idle APIs on idle loop

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: force MSIs on RS690 asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: Add MSI quirk for gateway RS690

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: only adjust default clocks on NI GPUs

Chris Wilson <chris@chris-wilson.co.uk>
    drm: Destroy the planes prior to destroying the associated CRTC

Marko Friedemann <mfr@bmx-chemnitz.de>
    ALSA: USB: Support for (original) Xbox Communicator

David Henningsson <david.henningsson@canonical.com>
    ALSA: usb - disable broken hw volume for Tenx TP6911

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    ALSA: hda/realtek - Fix detection of ALC271X codec

Omair Mohammed Abdullah <omair.m.abdullah@linux.intel.com>
    ALSA: aloop - add locking to timer access

Andrea Arcangeli <aarcange@redhat.com>
    mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

Hugh Dickins <hughd@google.com>
    mm: fix invalidate_complete_page2() lock ordering

Michal Hocko <mhocko@suse.cz>
    hugetlb: do not use vma_hugecache_offset() for vma_prio_tree_foreach

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    kpageflags: fix wrong KPF_THP on non-huge compound pages

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm9712: Fix name of Capture Switch

Jan Kara <jack@suse.cz>
    ext4: fix fdatasync() for files with only i_size changes

Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
    ext4: always set i_op in ext4_mknod()

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: online defrag is not supported for journaled files

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: move_extent code cleanup

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    ext4: fix crash when accessing /proc/mounts concurrently

Theodore Ts'o <tytso@mit.edu>
    ext4: fix potential deadlock in ext4_nonda_switch()

Yongqiang Yang <xiaoqiangnk@gmail.com>
    ext4: avoid duplicate writes of the backup bg descriptor blocks

Yongqiang Yang <xiaoqiangnk@gmail.com>
    ext4: don't copy non-existent gdt blocks when resizing

Yongqiang Yang <xiaoqiangnk@gmail.com>
    ext4: ignore last group w/o enough space when resizing instead of BUG'ing

Yinghai Lu <yinghai@kernel.org>
    PCI: Check P2P bridge for invalid secondary/subordinate range

Martin Peschke <mpeschke@linux.vnet.ibm.com>
    SCSI: zfcp: only access zfcp_scsi_dev for valid scsi_device

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: restore refcount check on port_remove

Julia Lawall <Julia.Lawall@lip6.fr>
    SCSI: zfcp: remove invalid reference to list iterator variable

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Do not wakeup while suspended

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Bounds checking for deferred error trace

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Make trace record tags unique

Steffen Maier <maier@linux.vnet.ibm.com>
    SCSI: zfcp: Adapt to new FC_PORTSPEED semantics

Florian Zumbiehl <florz@florz.de>
    drm/savage: re-add busmaster enable, regression fix

Ed L. Cashin <ecashin@coraid.com>
    aoe: assert AoE packets marked as requiring no checksum

Ed L. Cashin <ecashin@coraid.com>
    net: do not disable sg for packets requiring no checksum

Alan Cox <alan@linux.intel.com>
    netrom: copy_datagram_iovec can fail

Eric Dumazet <edumazet@google.com>
    l2tp: fix a typo in l2tp_eth_dev_recv()

Eric Dumazet <edumazet@google.com>
    ipv6: mip6: fix mip6_mh_filter()

Eric Dumazet <edumazet@google.com>
    ipv6: raw: fix icmpv6_filter()

Eric Dumazet <edumazet@google.com>
    ipv4: raw: fix icmp_filter()

Eric Dumazet <edumazet@google.com>
    net: guard tcp_set_keepalive() to tcp sockets

Chema Gonzalez <chema@google.com>
    net: small bug on rxhash calculation

Xiaodong Xu <stid.smth@gmail.com>
    pppoe: drop PPPOX_ZOMBIEs in pppoe_release

Thomas Graf <tgraf@suug.ch>
    sctp: Don't charge for data in sndbuf again when transmitting packet

Michal Kubeček <mkubecek@suse.cz>
    tcp: flush DMA queue before sk_wait_data if rcv_wnd is zero

Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    ipv6: fix return value check in fib6_add()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: del unreachable route when an addr is deleted on lo

Gao feng <gaofeng@cn.fujitsu.com>
    ipv6: release reference of ip6_null_entry's dst entry in __ip6_del_rt

Antonio Quartulli <ordex@autistici.org>
    8021q: fix mac_len recomputation in vlan_untag()

Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
    sierra_net: Endianess bug fix.

Paolo Valente <paolo.valente@unimore.it>
    pkt_sched: fix virtual-start-time update in QFQ

Eric Dumazet <edumazet@google.com>
    net-sched: sch_cbq: avoid infinite loop

Nikolay Aleksandrov <nikolay@redhat.com>
    netxen: check for root bus in netxen_mask_aer_correctable

Florian Fainelli <florian@openwrt.org>
    ixp4xx_hss: fix build failure due to missing linux/module.h inclusion

htbegin <hotforest@gmail.com>
    net: ethernet: davinci_cpdma: decrease the desc count when cleaning up the remaining packets

Mathias Krause <minipli@googlemail.com>
    xfrm_user: ensure user supplied esn replay window is valid

Mathias Krause <minipli@googlemail.com>
    xfrm_user: don't copy esn replay window twice for new states

Mathias Krause <minipli@googlemail.com>
    xfrm_user: fix info leak in copy_to_user_tmpl()

Mathias Krause <minipli@googlemail.com>
    xfrm_user: fix info leak in copy_to_user_policy()

Mathias Krause <minipli@googlemail.com>
    xfrm_user: fix info leak in copy_to_user_state()

Mathias Krause <minipli@googlemail.com>
    xfrm_user: fix info leak in copy_to_user_auth()

Li RongQing <roy.qing.li@gmail.com>
    xfrm: fix a read lock imbalance in make_blackhole

Mathias Krause <minipli@googlemail.com>
    xfrm_user: return error pointer instead of NULL #2

Mathias Krause <minipli@googlemail.com>
    xfrm_user: return error pointer instead of NULL

Steffen Klassert <steffen.klassert@secunet.com>
    xfrm: Workaround incompatibility of ESN and async crypto

Michal Schmidt <mschmidt@redhat.com>
    bnx2x: fix rx checksum validation for IPv6

Yuta Ando <yuta.and@gmail.com>
    localmodconfig: Fix localyesconfig to set to 'y' not 'm'

Eric Sandeen <sandeen@redhat.com>
    jbd2: don't write superblock when if its empty

Tejun Heo <tj@kernel.org>
    workqueue: add missing smp_wmb() in process_one_work()

Feng Hong <hongfeng@marvell.com>
    PM / Sleep: use resume event when call dpm_resume_early

Alexandre Bounine <alexandre.bounine@idt.com>
    rapidio/rionet: fix multicast packet transmit logic

Gavin Shan <shangw@linux.vnet.ibm.com>
    powerpc/eeh: Fix crash on converting OF node to edev

Rusty Russell <rusty@rustcorp.com.au>
    lguest: fix occasional crash in example launcher.

Fabio Estevam <fabio.estevam@freescale.com>
    drivers/dma/dmaengine.c: lower the priority of 'failed to get' dma channel message

Martin Michlmayr <tbm@cyrius.com>
    drivers/scsi/atp870u.c: fix bad use of udelay

Shawn Guo <shawn.guo@linaro.org>
    kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Davidlohr Bueso <dave@gnu.org>
    lib/gcd.c: prevent possible div by 0

Mark Brown <broonie@opensource.wolfsonmicro.com>
    mfd: max8925: Move _IO resources out of ioport_ioresource

Bjorn Helgaas <bhelgaas@google.com>
    PCI: acpiphp: check whether _ADR evaluation succeeded

Lin Ming <ming.m.lin@intel.com>
    ACPI: run _OSC after ACPI_FULL_INITIALIZATION

Frank Schäfer <fschaefer.oss@googlemail.com>
    media: gspca_pac7302: add support for device 1ae7:2001 Speedlink Snappy Microphone SL-6825-SBK

Ben Hutchings <ben@decadent.org.uk>
    media: rc: ite-cir: Initialise ite_dev::rdev earlier

Alex Williamson <alex.williamson@redhat.com>
    intel-iommu: Default to non-coherent for domains unattached to iommus

Michael Wang <wangyun@linux.vnet.ibm.com>
    slab: fix the DEADLOCK issue on l3 alien lock

Jean Delvare <jdelvare@suse.de>
    kbuild: Fix gcc -x syntax

Sascha Hauer <s.hauer@pengutronix.de>
    kbuild: make: fix if_changed when command contains backslashes

Geert Uytterhoeven <geert@linux-m68k.org>
    mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it


-------------

Diffstat:

 Makefile                                             |   4 +-
 arch/alpha/kernel/process.c                          |   4 ++
 arch/cris/kernel/process.c                           |   3 ++
 arch/frv/kernel/process.c                            |   3 ++
 arch/h8300/kernel/process.c                          |   3 ++
 arch/ia64/kernel/process.c                           |   3 ++
 arch/m32r/kernel/process.c                           |   3 ++
 arch/m68k/kernel/process.c                           |   3 ++
 arch/mips/Makefile                                   |   2 +-
 arch/mips/kernel/Makefile                            |   2 +-
 arch/mn10300/Makefile                                |   2 +-
 arch/mn10300/kernel/process.c                        |   3 ++
 arch/parisc/kernel/process.c                         |   3 ++
 arch/powerpc/include/asm/pci-bridge.h                |   8 ++++
 arch/powerpc/platforms/pseries/eeh.c                 |   2 +-
 arch/score/kernel/process.c                          |   4 +-
 arch/x86/Makefile                                    |   2 +-
 arch/x86/boot/compressed/Makefile                    |   3 ++
 arch/x86/include/asm/pgtable.h                       |  11 +++--
 arch/x86/platform/efi/efi.c                          |   1 +
 arch/xtensa/kernel/process.c                         |   3 ++
 drivers/acpi/bus.c                                   |   8 +++-
 drivers/base/power/main.c                            |   2 +-
 drivers/block/aoe/aoecmd.c                           |   1 +
 drivers/dma/dmaengine.c                              |   2 +-
 drivers/gpu/drm/drm_crtc.c                           |   8 ++--
 drivers/gpu/drm/radeon/radeon_irq_kms.c              |  10 +++++
 drivers/gpu/drm/radeon/radeon_pm.c                   |   8 +++-
 drivers/gpu/drm/savage/savage_bci.c                  |   2 +
 drivers/iommu/intel-iommu.c                          |   4 +-
 drivers/media/rc/ite-cir.c                           |   2 +-
 drivers/media/video/gspca/pac7302.c                  |   1 +
 drivers/mfd/max8925-core.c                           |  10 +++++
 drivers/mmc/host/omap_hsmmc.c                        |   3 +-
 drivers/mmc/host/sh_mmcif.c                          |   4 ++
 drivers/mtd/maps/autcpu12-nvram.c                    |  19 ++++----
 drivers/mtd/mtdpart.c                                |   5 ++-
 drivers/mtd/nand/nand_bbt.c                          |   2 +-
 drivers/mtd/nand/nandsim.c                           |   1 +
 drivers/mtd/nand/omap2.c                             |   3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c      |  12 +++---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |   4 ++
 drivers/net/ethernet/realtek/r8169.c                 |  21 ++++++++-
 drivers/net/ethernet/ti/davinci_cpdma.c              |   1 +
 drivers/net/ppp/pppoe.c                              |   2 +-
 drivers/net/rionet.c                                 |  20 +++++++--
 drivers/net/usb/sierra_net.c                         |   2 +-
 drivers/net/wan/ixp4xx_hss.c                         |   1 +
 drivers/pci/hotplug/acpiphp_glue.c                   |  13 ++++--
 drivers/pci/probe.c                                  |   6 ++-
 drivers/s390/scsi/zfcp_aux.c                         |   1 +
 drivers/s390/scsi/zfcp_ccw.c                         |  73 ++++++++++++++++++++++++++-----
 drivers/s390/scsi/zfcp_cfdc.c                        |   2 +-
 drivers/s390/scsi/zfcp_dbf.c                         |  22 +++++++++-
 drivers/s390/scsi/zfcp_dbf.h                         |   1 +
 drivers/s390/scsi/zfcp_def.h                         |   2 +
 drivers/s390/scsi/zfcp_ext.h                         |   2 +
 drivers/s390/scsi/zfcp_fsf.c                         |  57 ++++++++++++++++++++----
 drivers/s390/scsi/zfcp_qdio.c                        |  16 ++++---
 drivers/s390/scsi/zfcp_sysfs.c                       |  18 +++++++-
 drivers/s390/scsi/zfcp_unit.c                        |  36 +++++++++++-----
 drivers/scsi/atp870u.c                               |  11 ++++-
 fs/cifs/cifs_unicode.c                               |  22 ++++++++++
 fs/cifs/connect.c                                    |   9 ++++
 fs/ext4/inode.c                                      |  25 +++++++----
 fs/ext4/move_extent.c                                | 174 +++++++++++++++++++++++---------------------------------------------------
 fs/ext4/namei.c                                      |   2 -
 fs/ext4/resize.c                                     |  26 ++++++++---
 fs/ext4/super.c                                      |   2 +-
 fs/fs-writeback.c                                    |   1 +
 fs/jbd2/journal.c                                    |   5 +++
 fs/jffs2/wbuf.c                                      |   8 ++--
 fs/proc/page.c                                       |   8 +++-
 fs/udf/super.c                                       |   5 ++-
 include/linux/mempolicy.h                            |   2 +-
 include/linux/xfrm.h                                 |   2 +
 include/net/xfrm.h                                   |   3 ++
 kernel/cpuset.c                                      |   3 ++
 kernel/rcutree.c                                     |   4 +-
 kernel/sched/core.c                                  |  40 +++++++++++++++--
 kernel/sched/stop_task.c                             |  22 +++++++++-
 kernel/sys.c                                         |   1 +
 kernel/workqueue.c                                   |   2 +
 lib/gcd.c                                            |   3 ++
 mm/hugetlb.c                                         |   3 +-
 mm/mempolicy.c                                       | 137 +++++++++++++++++++++++++++++++++++++---------------------
 mm/slab.c                                            |   6 +--
 mm/truncate.c                                        |   3 +-
 net/8021q/vlan_core.c                                |   3 +-
 net/core/dev.c                                       |  14 +++---
 net/core/sock.c                                      |   3 +-
 net/ipv4/raw.c                                       |  14 +++---
 net/ipv4/tcp.c                                       |  10 ++++-
 net/ipv6/addrconf.c                                  |  10 ++++-
 net/ipv6/ip6_fib.c                                   |   4 ++
 net/ipv6/mip6.c                                      |  20 +++++----
 net/ipv6/raw.c                                       |  21 +++++----
 net/ipv6/route.c                                     |  11 ++---
 net/l2tp/l2tp_eth.c                                  |   2 +-
 net/netrom/af_netrom.c                               |   7 ++-
 net/sched/sch_cbq.c                                  |   5 ++-
 net/sched/sch_qfq.c                                  |   5 ++-
 net/sctp/output.c                                    |  21 ++++++++-
 net/xfrm/xfrm_input.c                                |   2 +-
 net/xfrm/xfrm_policy.c                               |   2 +-
 net/xfrm/xfrm_replay.c                               |  15 +++++++
 net/xfrm/xfrm_user.c                                 |  57 +++++++++++++++++-------
 scripts/Kbuild.include                               |  14 +++---
 scripts/gcc-version.sh                               |   6 +--
 scripts/gcc-x86_32-has-stack-protector.sh            |   2 +-
 scripts/gcc-x86_64-has-stack-protector.sh            |   2 +-
 scripts/kconfig/check.sh                             |   2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh           |   2 +-
 scripts/kconfig/streamline_config.pl                 |   2 +
 sound/drivers/aloop.c                                |   6 +++
 sound/pci/hda/patch_realtek.c                        |  12 +++---
 sound/soc/codecs/wm9712.c                            |   2 +-
 sound/usb/mixer.c                                    |   7 +++
 sound/usb/quirks-table.h                             |  53 +++++++++++++++++++++++
 tools/lguest/lguest.c                                |   1 +
 tools/perf/Makefile                                  |   2 +-
 tools/power/cpupower/Makefile                        |   2 +-
 122 files changed, 959 insertions(+), 390 deletions(-)


