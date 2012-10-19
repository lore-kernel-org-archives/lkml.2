Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2JSCqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:46:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:50967 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab2JSCqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:46:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/62] 3.4.15-stable review
Date: Thu, 18 Oct 2012 19:44:28 -0700
Message-Id: <20121019024255.944999470@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.15 release.
There are 62 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 21 02:42:38 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.15-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Maxim Kachur <mcdebugger@duganet.ru>
    ALSA: emu10k1: add chip details for E-mu 1010 PCIe card

Takashi Iwai <tiwai@suse.de>
    ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()

Peter Ujfalusi <peter.ujfalusi@ti.com>
    ASoC: omap-abe-twl6040: Fix typo of Vibrator

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm2200: Fix non-inverted OUT2 mute control

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm2200: Use rev A register patches on rev B

Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    ASoC: fsi: don't reschedule DMA from an atomic context

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - Always check array bounds in alc_get_line_out_pfx

Fabio Porcedda <fabio.porcedda@gmail.com>
    usb: gadget: at91_udc: fix dt support

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Call lower ->flush() from ecryptfs_flush()

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Write out all dirty pages just before releasing the lower file

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Revert to a writethrough cache model

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Initialize empty lower files when opening them

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Unlink lower inode when ecryptfs_create() fails

Peter Huewe <peter.huewe@infineon.com>
    tpm: Propagate error from tpm_transmit to fix a timeout hang

Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
    e1000e: Change wthresh to 1 to avoid possible Tx stalls

Jan Kara <jack@suse.cz>
    jbd: Fix assertion failure in commit code due to lacking transaction credits

Jani Nikula <jani.nikula@intel.com>
    drm/i915: use adjusted_mode instead of mode for checking the 6bpc force flag

Egbert Eich <eich@suse.de>
    drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().

Jean-Christian de Rivaz <jc@eclis.ch>
    Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

Jan Engelhardt <jengelh@inai.de>
    netfilter: xt_limit: have r->cost != 0 case work

Florian Westphal <fw@strlen.de>
    netfilter: limit, hashlimit: avoid duplicated inline

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_ct_expect: fix possible access to uninitialized timer

Patrick McHardy <kaber@trash.net>
    netfilter: nf_nat_sip: fix via header translation with multiple parameters

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expectation

Lin Ming <mlin@ss.pku.edu.cn>
    ipvs: fix oops on NAT reply in br_nf context

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: ipset: timeout fixing bug broke SET target special timeout value

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
    netfilter: ipset: fix timeout value overflow bug

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_conntrack: fix racy timer handling with reliable events

Julian Anastasov <ja@ssi.bg>
    ipvs: fix oops in ip_vs_dst_event on rmmod

Amerigo Wang <amwang@redhat.com>
    pktgen: fix crash when generating IPv6 packets

Jason Wessel <jason.wessel@windriver.com>
    kdb,vt_console: Fix missed data due to pager overruns

Dan Carpenter <dan.carpenter@oracle.com>
    md/raid10: use correct limit variable

Felix Fietkau <nbd@openwrt.org>
    ath9k: use ieee80211_free_txskb

Hildner, Christian <christian.hildner@siemens.com>
    timers: Fix endless looping between cascade() and internal_add_timer()

Daniel Drake <dsd@laptop.org>
    viafb: don't touch clock state on OLPC XO-1.5

Alexander Holler <holler@ahsoftware.de>
    video/udlfb: fix line counting in fb_write

Matthew Garrett <mjg59@srcf.ucam.org>
    module: taint kernel when lve module is loaded

Ian Kent <raven@themaw.net>
    autofs4 - fix reset pending flag on mount fail

Tejun Heo <tj@kernel.org>
    block: fix request_queue->flags initialization

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/bootup: allow read_tscp call for Xen PV guests.

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/bootup: allow {read|write}_cr8 pvops call.

Peter Senna Tschudin <peter.senna@gmail.com>
    target: fix return code in target_core_init_configfs error path

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: cdev: fix user memory corruption (i386 userland on amd64 kernel)

Simon Horman <horms@verge.net.au>
    ARM: 7541/1: Add ARM ERRATA 775420 workaround

Lukas Czerner <lczerner@redhat.com>
    SCSI: scsi_debug: Fix off-by-one bug when unmapping region

K. Y. Srinivasan <kys@microsoft.com>
    SCSI: storvsc: Account for in-transit packets in the RESET path

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeout values

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Add explicit set of cache_dynamic_acls=1 for TPG demo-mode

Christoph Hellwig <hch@infradead.org>
    iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp

Nicholas Bellinger <nab@linux-iscsi.org>
    iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT PDU

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: dial down lockup detection during firmware flash

Hugh Dickins <hughd@google.com>
    tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Jason Wessel <jason.wessel@windriver.com>
    mips,kgdb: fix recursive page fault with CONFIG_KPROBES

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix memory leaks at error path in patch_cirrus.c

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - do not detect jack on internal speakers for Realtek

Feng Tang <feng.tang@intel.com>
    ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Feng Tang <feng.tang@intel.com>
    ACPI: EC: Make the GPE storm threshold a module parameter

Stanislav Kinsbursky <skinsbursky@parallels.com>
    lockd: use rpc client's cl_nodename for id encoding

Malahal Naineni <malahal@us.ibm.com>
    NFSD: pass null terminated buf to kstrtouint()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix nfs4 stateid leak

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels


-------------

Diffstat:

 Makefile                                        |   4 ++--
 arch/arm/Kconfig                                |  10 ++++++++
 arch/arm/include/asm/vfpmacros.h                |   4 ++--
 arch/arm/mm/cache-v7.S                          |   3 +++
 arch/mips/kernel/kgdb.c                         |   9 ++++++++
 arch/x86/xen/enlighten.c                        |  18 ++++++++++++++-
 block/blk-core.c                                |   2 +-
 drivers/acpi/ec.c                               |  30 ++++++++++++++++++++----
 drivers/char/tpm/tpm.c                          |  21 +++++++++++------
 drivers/firewire/core-cdev.c                    |   4 ++--
 drivers/gpu/drm/i915/intel_display.c            |   4 ++--
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   6 +----
 drivers/md/raid10.c                             |   2 +-
 drivers/net/ethernet/intel/e1000e/e1000.h       |   6 ++---
 drivers/net/ethernet/intel/e1000e/netdev.c      |   2 +-
 drivers/net/wireless/ath/ath9k/beacon.c         |   2 +-
 drivers/net/wireless/ath/ath9k/main.c           |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |  53 +++++++++++++++++++++++-------------------
 drivers/scsi/hpsa.c                             |  39 +++++++++++++++++++++++++++----
 drivers/scsi/hpsa.h                             |   2 ++
 drivers/scsi/hpsa_cmd.h                         |   1 +
 drivers/scsi/scsi_debug.c                       |   2 +-
 drivers/scsi/storvsc_drv.c                      |   5 ++++
 drivers/target/iscsi/iscsi_target.c             |   2 +-
 drivers/target/iscsi/iscsi_target_core.h        |   4 ++--
 drivers/target/iscsi/iscsi_target_tpg.c         |  12 ++++++++++
 drivers/target/target_core_configfs.c           |   8 ++++++-
 drivers/tty/vt/vt.c                             |  13 +++++++++++
 drivers/usb/class/cdc-acm.c                     |   3 +++
 drivers/usb/gadget/at91_udc.c                   |   2 +-
 drivers/video/udlfb.c                           |   2 +-
 drivers/video/via/via_clock.c                   |  19 +++++++++++++++
 fs/autofs4/root.c                               |   6 +++--
 fs/ceph/export.c                                |  18 +++++++++++----
 fs/ecryptfs/ecryptfs_kernel.h                   |   2 ++
 fs/ecryptfs/file.c                              | 100 ++++++++++++++++++++++++++++++++++++++-----------------------------------------
 fs/ecryptfs/inode.c                             |  65 ++++++++++++++++++++++++++-------------------------
 fs/ecryptfs/main.c                              |   1 +
 fs/ecryptfs/mmap.c                              |  39 +++++++++++--------------------
 fs/gfs2/export.c                                |   4 ++++
 fs/isofs/export.c                               |   2 +-
 fs/jbd/commit.c                                 |  45 +++++++++++++++++++++++++++---------
 fs/jbd/transaction.c                            |  64 ++++++++++++++++++++++++++++++++++----------------
 fs/lockd/mon.c                                  |   4 +++-
 fs/nfsd/nfs4idmap.c                             |   2 +-
 fs/nfsd/nfs4state.c                             |   1 +
 fs/reiserfs/inode.c                             |   6 ++++-
 fs/xfs/xfs_export.c                             |   3 +++
 include/linux/netfilter/ipset/ip_set_timeout.h  |   4 ++++
 include/net/ip_vs.h                             |   2 +-
 include/net/netfilter/nf_conntrack_ecache.h     |   1 +
 kernel/debug/kdb/kdb_io.c                       |  33 ++++++++++++++++++++++----
 kernel/module.c                                 |   4 ++++
 kernel/timer.c                                  |  10 ++++----
 mm/shmem.c                                      |   6 +++--
 net/core/pktgen.c                               |   2 +-
 net/ipv4/netfilter/nf_nat_sip.c                 |  10 +++++---
 net/netfilter/ipvs/ip_vs_ctl.c                  |   5 ++--
 net/netfilter/nf_conntrack_core.c               |  16 +++++++++----
 net/netfilter/nf_conntrack_expect.c             |  29 +++++------------------
 net/netfilter/xt_hashlimit.c                    |   8 +++----
 net/netfilter/xt_limit.c                        |  13 +++++------
 net/netfilter/xt_set.c                          |  17 ++++++++++++--
 net/sunrpc/xprtsock.c                           |  21 +++++++++++++----
 sound/pci/ac97/ac97_codec.c                     |   2 ++
 sound/pci/emu10k1/emu10k1_main.c                |   9 ++++++++
 sound/pci/hda/patch_cirrus.c                    |   6 ++---
 sound/pci/hda/patch_realtek.c                   |   6 ++++-
 sound/soc/codecs/wm2200.c                       |   3 ++-
 sound/soc/omap/omap-abe-twl6040.c               |   2 +-
 sound/soc/sh/fsi.c                              |  15 ++++++------
 71 files changed, 584 insertions(+), 298 deletions(-)


