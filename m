Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab2JKCDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:03:34 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33931 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750810Ab2JKCDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:03:31 -0400
X-Sasl-enc: Evm2Nb9NeVxUMXewv2SNYVMlfsrfnn75ZwDQRmA6m9C3 1349921009
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk
Subject: =?UTF-8?q?=5B=2000/84=5D=203=2E0=2E46-stable=20review?=
Date: Thu, 11 Oct 2012 11:01:48 +0900
Message-Id: <20121011015417.017144658@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.46 release.
There are 84 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Oct 13 01:53:52 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.46-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

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

Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
    CPU hotplug, cpusets, suspend: Don't modify cpusets during suspend/resume

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

Devendra Naga <devendra.aaru@gmail.com>
    r8169: call netif_napi_del at errpaths and at driver unload

Julien Ducourthial <jducourt@free.fr>
    r8169: fix unsigned int wraparound with TSO

Francois Romieu <romieu@fr.zoreil.com>
    r8169: 8168c and later require bit 0x20 to be set in Config2 for PME signaling.

Francois Romieu <romieu@fr.zoreil.com>
    r8169: Config1 is read-only on 8168c and later.

françois romieu <romieu@fr.zoreil.com>
    r8169: runtime resume before shutdown.

Francois Romieu <romieu@fr.zoreil.com>
    r8169: missing barriers.

françois romieu <romieu@fr.zoreil.com>
    r8169: fix Config2 MSIEnable bit setting.

Francois Romieu <romieu@fr.zoreil.com>
    r8169: Rx FIFO overflow fixes.

hayeswang <hayeswang@realtek.com>
    r8169: increase the delay parameter of pm_schedule_suspend

Francois Romieu <romieu@fr.zoreil.com>
    r8169: expand received packet length indication.

Francois Romieu <romieu@fr.zoreil.com>
    r8169: jumbo fixes.

Francois Romieu <romieu@fr.zoreil.com>
    r8169: remove erroneous processing of always set bit.

Hayes Wang <hayeswang@realtek.com>
    r8169: don't enable rx when shutdown.

Hayes Wang <hayeswang@realtek.com>
    r8169: fix wake on lan setting for non-8111E.

Paul E. McKenney <paul.mckenney@linaro.org>
    rcu: Fix day-one dyntick-idle stall-warning bug

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: force MSIs on RS690 asics

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: Add MSI quirk for gateway RS690

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: only adjust default clocks on NI GPUs

Marko Friedemann <mfr@bmx-chemnitz.de>
    ALSA: USB: Support for (original) Xbox Communicator

David Henningsson <david.henningsson@canonical.com>
    ALSA: usb - disable broken hw volume for Tenx TP6911

Omair Mohammed Abdullah <omair.m.abdullah@linux.intel.com>
    ALSA: aloop - add locking to timer access

Andrea Arcangeli <aarcange@redhat.com>
    mm: thp: fix pmd_present for split_huge_page and PROT_NONE with THP

Hugh Dickins <hughd@google.com>
    mm: fix invalidate_complete_page2() lock ordering

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm9712: Fix name of Capture Switch

Jan Kara <jack@suse.cz>
    ext4: fix fdatasync() for files with only i_size changes

Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
    ext4: always set i_op in ext4_mknod()

Dmitry Monakhov <dmonakhov@openvz.org>
    ext4: online defrag is not supported for journaled files

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
    SCSI: zfcp: Make trace record tags unique

Matt Carlson <mcarlson@broadcom.com>
    tg3: Fix TSO CAP for 5704 devs w / ASF enabled

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

Tejun Heo <tj@kernel.org>
    workqueue: add missing smp_wmb() in process_one_work()

Martin Michlmayr <tbm@cyrius.com>
    drivers/scsi/atp870u.c: fix bad use of udelay

Shawn Guo <shawn.guo@linaro.org>
    kernel/sys.c: call disable_nonboot_cpus() in kernel_restart()

Davidlohr Bueso <dave@gnu.org>
    lib/gcd.c: prevent possible div by 0

Bjorn Helgaas <bhelgaas@google.com>
    PCI: acpiphp: check whether _ADR evaluation succeeded

Lin Ming <ming.m.lin@intel.com>
    ACPI: run _OSC after ACPI_FULL_INITIALIZATION

Ben Hutchings <ben@decadent.org.uk>
    media: rc: ite-cir: Initialise ite_dev::rdev earlier

Sascha Hauer <s.hauer@pengutronix.de>
    kbuild: make: fix if_changed when command contains backslashes

Geert Uytterhoeven <geert@linux-m68k.org>
    mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it


-------------

Diffstat:

 Makefile                                |   4 +-
 arch/mn10300/Makefile                   |   2 +-
 arch/x86/include/asm/pgtable.h          |  11 ++-
 drivers/acpi/bus.c                      |   8 +-
 drivers/block/aoe/aoecmd.c              |   1 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c |  10 ++
 drivers/gpu/drm/radeon/radeon_pm.c      |   8 +-
 drivers/media/rc/ite-cir.c              |   2 +-
 drivers/mtd/maps/autcpu12-nvram.c       |  19 ++--
 drivers/mtd/nand/nand_bbt.c             |   2 +-
 drivers/mtd/nand/nandsim.c              |   1 +
 drivers/mtd/nand/omap2.c                |   3 +-
 drivers/net/davinci_cpdma.c             |   1 +
 drivers/net/netxen/netxen_nic_main.c    |   4 +
 drivers/net/pppoe.c                     |   2 +-
 drivers/net/r8169.c                     | 444 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------
 drivers/net/tg3.c                       |  14 ++-
 drivers/net/usb/sierra_net.c            |   2 +-
 drivers/net/wan/ixp4xx_hss.c            |   1 +
 drivers/pci/hotplug/acpiphp_glue.c      |   7 +-
 drivers/pci/probe.c                     |   6 +-
 drivers/s390/scsi/zfcp_aux.c            |   1 +
 drivers/s390/scsi/zfcp_ccw.c            |  73 +++++++++++++--
 drivers/s390/scsi/zfcp_cfdc.c           |   2 +-
 drivers/s390/scsi/zfcp_dbf.c            |  20 ++++
 drivers/s390/scsi/zfcp_dbf.h            |   1 +
 drivers/s390/scsi/zfcp_def.h            |   2 +
 drivers/s390/scsi/zfcp_ext.h            |   2 +
 drivers/s390/scsi/zfcp_fsf.c            |  23 +++--
 drivers/s390/scsi/zfcp_sysfs.c          |  18 +++-
 drivers/s390/scsi/zfcp_unit.c           |  36 +++++--
 drivers/scsi/atp870u.c                  |  11 ++-
 fs/ext4/inode.c                         |   8 +-
 fs/ext4/move_extent.c                   |   7 +-
 fs/ext4/namei.c                         |   2 -
 include/linux/mempolicy.h               |   2 +-
 include/linux/xfrm.h                    |   2 +
 include/net/xfrm.h                      |   3 +
 kernel/cpuset.c                         |   3 +
 kernel/rcutree.c                        |   4 +-
 kernel/sched.c                          |  40 +++++++-
 kernel/sys.c                            |   1 +
 kernel/workqueue.c                      |   2 +
 lib/gcd.c                               |   3 +
 mm/mempolicy.c                          | 137 +++++++++++++++++----------
 mm/truncate.c                           |   3 +-
 net/8021q/vlan_core.c                   |   3 +-
 net/core/dev.c                          |  14 +--
 net/core/sock.c                         |   3 +-
 net/ipv4/raw.c                          |  14 +--
 net/ipv4/tcp.c                          |  10 +-
 net/ipv6/mip6.c                         |  20 ++--
 net/ipv6/raw.c                          |  21 ++---
 net/ipv6/route.c                        |  11 ++-
 net/l2tp/l2tp_eth.c                     |   2 +-
 net/netrom/af_netrom.c                  |   7 +-
 net/sched/sch_cbq.c                     |   5 +-
 net/sched/sch_qfq.c                     |   5 +-
 net/sctp/output.c                       |  21 ++++-
 net/xfrm/xfrm_input.c                   |   2 +-
 net/xfrm/xfrm_policy.c                  |   2 +-
 net/xfrm/xfrm_replay.c                  |  15 +++
 net/xfrm/xfrm_user.c                    |  57 +++++++++---
 scripts/Kbuild.include                  |   2 +-
 sound/drivers/aloop.c                   |   6 ++
 sound/soc/codecs/wm9712.c               |   2 +-
 sound/usb/mixer.c                       |   7 ++
 sound/usb/quirks-table.h                |  53 +++++++++++
 68 files changed, 945 insertions(+), 295 deletions(-)


