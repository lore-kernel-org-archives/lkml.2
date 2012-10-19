Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2JSDKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:10:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:51813 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab2JSCsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:48:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/76] 3.6.3-stable review
Date: Thu, 18 Oct 2012 19:46:24 -0700
Message-Id: <20121019024350.087156547@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.6.3 release.
There are 76 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Oct 21 02:43:30 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.6.3-rc1.gz
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

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Stop LPIB delay counting on broken hardware

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix registration race of VGA switcheroo

Fabio Porcedda <fabio.porcedda@gmail.com>
    usb: gadget: at91_udc: fix dt support

Peter Huewe <peter.huewe@infineon.com>
    tpm: Propagate error from tpm_transmit to fix a timeout hang

Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
    e1000e: Change wthresh to 1 to avoid possible Tx stalls

Brian Norris <computersforpeace@gmail.com>
    mtd: nand: allow NAND_NO_SUBPAGE_WRITE to be set from driver

Jan Kara <jack@suse.cz>
    jbd: Fix assertion failure in commit code due to lacking transaction credits

Ondrej Zary <linux@rainbow-software.org>
    mcs7830: Fix link state detection

Jani Nikula <jani.nikula@intel.com>
    drm/i915: use adjusted_mode instead of mode for checking the 6bpc force flag

Ben Skeggs <bskeggs@redhat.com>
    drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB

Kenneth Graunke <kenneth@whitecape.org>
    drm/i915: Set guardband clipping workaround bit in the right register.

Willy Tarreau <w@1wt.eu>
    drm/i915: remove useless BUG_ON which caused a regression in 3.5.

Egbert Eich <eich@suse.de>
    drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy().

Sasha Levin <sasha.levin@oracle.com>
    fs: prevent use after free in auditing when symlink following was denied

Sasha Levin <sasha.levin@oracle.com>
    fs: handle failed audit_log_start properly

Jean-Christian de Rivaz <jc@eclis.ch>
    Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

Michal Marek <mmarek@suse.cz>
    kbuild: Fix accidental revert in commit fe04ddf

Gabor Juhos <juhosg@openwrt.org>
    MIPS: ath79: Fix CPU/DDR frequency calculation for SRIF PLLs

Amerigo Wang <amwang@redhat.com>
    pktgen: fix crash when generating IPv6 packets

Jason Wessel <jason.wessel@windriver.com>
    kdb,vt_console: Fix missed data due to pager overruns

Dan Carpenter <dan.carpenter@oracle.com>
    md/raid10: use correct limit variable

Felix Fietkau <nbd@openwrt.org>
    mac80211: use ieee80211_free_txskb to fix possible skb leaks

Felix Fietkau <nbd@openwrt.org>
    ath9k: use ieee80211_free_txskb

Frederic Weisbecker <fweisbec@gmail.com>
    nohz: Fix one jiffy count too far in idle cputime

Hildner, Christian <christian.hildner@siemens.com>
    timers: Fix endless looping between cascade() and internal_add_timer()

Dan Carpenter <dan.carpenter@oracle.com>
    timekeeping: Cast raw_interval to u64 to avoid shift overflow

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

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/pv-on-hvm kexec: add quirk for Xen 3.4 and shutdown watches.

Alex Williamson <alex.williamson@redhat.com>
    vfio: Fix PCI INTx disable consistency

Alex Williamson <alex.williamson@redhat.com>
    vfio: Move PCI INTx eventfd setting earlier

Roland Dreier <roland@purestorage.com>
    qla2xxx: Fix endianness of task management response code

Nicholas Bellinger <nab@linux-iscsi.org>
    target/file: Re-enable optional fd_buffered_io=1 operation

Peter Senna Tschudin <peter.senna@gmail.com>
    target: fix return code in target_core_init_configfs error path

Paolo Bonzini <pbonzini@redhat.com>
    target: fix truncation of mode data, support zero allocation length

Paolo Bonzini <pbonzini@redhat.com>
    target: support zero allocation length in INQUIRY

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT

Stefan Richter <stefanr@s5r6.in-berlin.de>
    firewire: cdev: fix user memory corruption (i386 userland on amd64 kernel)

Colin Cross <ccross@android.com>
    ARM: OMAP: counter: add locking to read_persistent_clock

Simon Horman <horms@verge.net.au>
    ARM: 7541/1: Add ARM ERRATA 775420 workaround

Richard W.M. Jones <rjones@redhat.com>
    SCSI: virtio-scsi: initialize scatterlist structure

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

Hugh Dickins <hughd@google.com>
    tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Jason Wessel <jason.wessel@windriver.com>
    mips,kgdb: fix recursive page fault with CONFIG_KPROBES

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix memory leaks at error path in patch_cirrus.c

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - do not detect jack on internal speakers for Realtek

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add missing hda_gen_spec to struct via_spec

Feng Tang <feng.tang@intel.com>
    ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Feng Tang <feng.tang@intel.com>
    ACPI: EC: Make the GPE storm threshold a module parameter

Stanislav Kinsbursky <skinsbursky@parallels.com>
    lockd: create and use per-net NSM RPC clients on MON/UNMON requests

Stanislav Kinsbursky <skinsbursky@parallels.com>
    lockd: use rpc client's cl_nodename for id encoding

Stanislav Kinsbursky <skinsbursky@parallels.com>
    lockd: per-net NSM client creation and destruction helpers introduced

Malahal Naineni <malahal@us.ibm.com>
    NFSD: pass null terminated buf to kstrtouint()

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix nfs4 stateid leak

J. Bruce Fields <bfields@redhat.com>
    nfsd4: don't pin clientids to pseudoflavors

Bryan Schumaker <bjschuma@netapp.com>
    NFS: Remove bad delegations during open recovery

Peng Tao <bergwolf@gmail.com>
    NFS41: fix error of setting blocklayoutdriver

Peng Tao <bergwolf@gmail.com>
    pnfsblock: fix partial page buffer wirte

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels


-------------

Diffstat:

 Makefile                                        |   4 +-
 arch/arm/Kconfig                                |  10 +++++
 arch/arm/include/asm/vfpmacros.h                |   4 +-
 arch/arm/mm/cache-v7.S                          |   3 ++
 arch/arm/plat-omap/counter_32k.c                |  21 ++++++----
 arch/mips/ath79/clock.c                         | 109 ++++++++++++++++++++++++++++++++++++-------------
 arch/mips/include/asm/mach-ath79/ar71xx_regs.h  |  23 +++++++++++
 arch/mips/kernel/kgdb.c                         |   9 ++++
 arch/x86/Makefile                               |   2 +-
 arch/x86/xen/enlighten.c                        |  18 +++++++-
 block/blk-core.c                                |   2 +-
 drivers/acpi/ec.c                               |  30 +++++++++++---
 drivers/char/tpm/tpm.c                          |  21 ++++++----
 drivers/firewire/core-cdev.c                    |   4 +-
 drivers/gpu/drm/i915/i915_gem.c                 |   1 -
 drivers/gpu/drm/i915/i915_reg.h                 |   2 +-
 drivers/gpu/drm/i915/intel_display.c            |   4 +-
 drivers/gpu/drm/i915/intel_pm.c                 |   4 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c          |  22 +++++-----
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |   6 +--
 drivers/md/raid10.c                             |   2 +-
 drivers/mtd/nand/nand_base.c                    |   8 ++--
 drivers/net/ethernet/intel/e1000e/e1000.h       |   6 +--
 drivers/net/ethernet/intel/e1000e/netdev.c      |   2 +-
 drivers/net/usb/mcs7830.c                       |  30 ++++++++++----
 drivers/net/wireless/ath/ath9k/beacon.c         |   2 +-
 drivers/net/wireless/ath/ath9k/main.c           |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c           |  53 +++++++++++++-----------
 drivers/scsi/qla2xxx/qla_target.c               |   2 +-
 drivers/scsi/scsi_debug.c                       |   2 +-
 drivers/scsi/storvsc_drv.c                      |   5 +++
 drivers/scsi/virtio_scsi.c                      |   2 +-
 drivers/target/iscsi/iscsi_target.c             |   2 +-
 drivers/target/iscsi/iscsi_target_core.h        |   4 +-
 drivers/target/iscsi/iscsi_target_tpg.c         |  12 ++++++
 drivers/target/target_core_configfs.c           |   8 +++-
 drivers/target/target_core_file.c               |  41 +++++++++++++++++--
 drivers/target/target_core_file.h               |   1 +
 drivers/target/target_core_spc.c                |  48 ++++++----------------
 drivers/tty/vt/vt.c                             |  13 ++++++
 drivers/usb/class/cdc-acm.c                     |   3 ++
 drivers/usb/gadget/at91_udc.c                   |   2 +-
 drivers/vfio/pci/vfio_pci_intrs.c               |  18 ++++++--
 drivers/video/udlfb.c                           |   2 +-
 drivers/video/via/via_clock.c                   |  19 +++++++++
 drivers/xen/xenbus/xenbus_xs.c                  |  21 ++++++++++
 fs/autofs4/root.c                               |   6 ++-
 fs/ceph/export.c                                |  18 ++++++--
 fs/gfs2/export.c                                |   4 ++
 fs/isofs/export.c                               |   2 +-
 fs/jbd/commit.c                                 |  45 +++++++++++++++-----
 fs/jbd/transaction.c                            |  64 ++++++++++++++++++++---------
 fs/lockd/mon.c                                  |  86 ++++++++++++++++++++++++++++++--------
 fs/lockd/netns.h                                |   4 ++
 fs/lockd/svc.c                                  |   1 +
 fs/namei.c                                      |   2 +-
 fs/nfs/blocklayout/blocklayout.c                | 177 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/nfs/blocklayout/blocklayout.h                |   1 +
 fs/nfs/client.c                                 |   1 -
 fs/nfs/nfs4proc.c                               |   9 +++-
 fs/nfsd/nfs4idmap.c                             |   2 +-
 fs/nfsd/nfs4state.c                             |  19 ++++++++-
 fs/reiserfs/inode.c                             |   6 ++-
 fs/xfs/xfs_export.c                             |   3 ++
 include/linux/mtd/nand.h                        |   3 --
 kernel/audit.c                                  |   2 +
 kernel/debug/kdb/kdb_io.c                       |  33 ++++++++++++---
 kernel/module.c                                 |   4 ++
 kernel/time/tick-sched.c                        |   2 +-
 kernel/time/timekeeping.c                       |   2 +-
 kernel/timer.c                                  |  10 +++--
 mm/shmem.c                                      |   6 ++-
 net/core/pktgen.c                               |   2 +-
 net/mac80211/status.c                           |   4 +-
 net/mac80211/tx.c                               |  22 +++++-----
 net/sunrpc/xprtsock.c                           |  21 +++++++---
 scripts/Makefile.fwinst                         |   4 +-
 sound/pci/ac97/ac97_codec.c                     |   2 +
 sound/pci/emu10k1/emu10k1_main.c                |   9 ++++
 sound/pci/hda/hda_intel.c                       |  40 +++++++++++-------
 sound/pci/hda/patch_cirrus.c                    |   6 +--
 sound/pci/hda/patch_realtek.c                   |   6 ++-
 sound/pci/hda/patch_via.c                       |   4 ++
 sound/soc/codecs/wm2200.c                       |   3 +-
 sound/soc/omap/omap-abe-twl6040.c               |   2 +-
 sound/soc/sh/fsi.c                              |  15 +++----
 86 files changed, 951 insertions(+), 310 deletions(-)


