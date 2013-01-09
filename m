Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3AIUgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:40798 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AIUgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/123] 3.7.2-stable review
Date: Wed,  9 Jan 2013 12:33:59 -0800
Message-Id: <20130109201458.392601412@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, there are still a lot of patches submitted for inclusion in the
stable releases that I have not gotten to yet.  I wanted to get this
release out now, instead of delaying for a week or so while I dig
through all of the pending patches.

This is the start of the stable review cycle for the 3.7.2 release.
There are 123 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 11 20:11:16 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.2-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.7.2-rc1

Jeff Layton <jlayton@redhat.com>
    cifs: don't compare uniqueids in cifs_prime_dcache unless server inode numbers are in use

Jeff Layton <jlayton@redhat.com>
    cifs: rename cifs_readdir_lookup to cifs_prime_dcache and make it void return

Alexander Stein <alexander.stein@systec-electronic.com>
    can: Do not call dev_put if restart timer is running upon close

Ben Hutchings <ben@decadent.org.uk>
    HID: Add Apple wireless keyboard 2011 ANSI to special driver list

Guenter Roeck <linux@roeck-us.net>
    linux/kernel.h: fix DIV_ROUND_CLOSEST with unsigned divisors

Michal Hocko <mhocko@suse.cz>
    mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Tony Prisk <linux@prisktech.co.nz>
    drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time

Tony Prisk <linux@prisktech.co.nz>
    drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield

Andrew Morton <akpm@linux-foundation.org>
    revert "rtc: recycle id when unloading a rtc driver"

Corey Minyard <cminyard@mvista.com>
    CRIS: fix I/O macros

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    proc: pid/status: show all supplementary groups

Stephen Boyd <sboyd@codeaurora.org>
    lib: atomic64: Initialize locks statically to fix early users

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Revert "Bluetooth: Fix possible deadlock in SCO code"

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: cancel power_on work when unregistering the device

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: Add missing lock nesting notation

Jeff Cook <jeff@deserettechnology.com>
    Bluetooth: Add support for BCM20702A0 [0b05, 17b5]

Myron Stowe <myron.stowe@redhat.com>
    PCI: Work around Stratus ftServer broken PCIe hierarchy (fix DMI check)

Huang Ying <ying.huang@intel.com>
    PCI/PM: Do not suspend port if any subordinate device needs PME polling

Andy Lutomirski <luto@amacapital.net>
    PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

Huang Ying <ying.huang@intel.com>
    PCI/PM: Keep runtime PM enabled for unbound PCI devices

David Woodhouse <dwmw2@infradead.org>
    solos-pci: fix double-free of TX skb in DMA mode

Jeff Layton <jlayton@redhat.com>
    cifs: adjust sequence number downward after signing NT_CANCEL request

Jeff Layton <jlayton@redhat.com>
    cifs: move check for NULL socket into smb_send_rqst

Jan Kara <jack@suse.cz>
    fs: Fix imbalance in freeze protection in mark_files_ro()

Will Deacon <will.deacon@arm.com>
    ARM: 7606/1: cache: flush to LoUU instead of LoUIS on uniprocessor CPUs

Will Deacon <will.deacon@arm.com>
    ARM: 7607/1: realview: fix private peripheral memory base for EB rev. B boards

Al Viro <viro@ZenIV.linux.org.uk>
    ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Will Deacon <will.deacon@arm.com>
    ARM: mm: use pteval_t to represent page protection values

Al Viro <viro@ZenIV.linux.org.uk>
    arm64: compat for clock_adjtime(2) is miswired

Dave Chinner <dchinner@redhat.com>
    xfs: fix stray dquot unlock when reclaiming dquots

Dave Chinner <dchinner@redhat.com>
    xfs: fix direct IO nested transaction deadlock.

Oleg Nesterov <oleg@redhat.com>
    signals: sys_ssetmask() uses uninitialized newmask

Roland Dreier <roland@purestorage.com>
    printk: fix incorrect length from print_time() when seconds > 99999

Eric Dumazet <edumazet@google.com>
    tcp: fix MSG_SENDPAGE_NOTLAST logic

Daniel Borkmann <dborkman@redhat.com>
    sctp: jsctp_sf_eat_sack: fix jprobes function signature mismatch

Stefan Hasko <hasko.stevo@gmail.com>
    net: sched: integer overflow fix

Alexander Aring <alex.aring@googlemail.com>
    mac802154: fix NOHZ local_softirq_pending 08 warning

Duan Jiong <djduanjiong@gmail.com>
    ipv6: Change skb->data before using icmpv6_notify() to propagate redirect

Christoph Paasch <christoph.paasch@uclouvain.be>
    inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and dccp_v4/6_request_recv_sock

Akinobu Mita <akinobu.mita@gmail.com>
    batman-adv: fix random jitter calculation

David S. Miller <davem@davemloft.net>
    sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in CAMELLIA code.

David S. Miller <davem@davemloft.net>
    sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in DES code.

David S. Miller <davem@davemloft.net>
    sparc64: Fix ECB looping constructs in AES code.

David S. Miller <davem@davemloft.net>
    sparc64: Set CRYPTO_TFM_REQ_MAY_SLEEP consistently in AES code.

David S. Miller <davem@davemloft.net>
    sparc64: Fix AES ctr mode block size.

David S. Miller <davem@davemloft.net>
    sparc64: Fix unrolled AES 256-bit key loops.

Dave Kleikamp <dave.kleikamp@oracle.com>
    sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

Tejun Heo <tj@kernel.org>
    freezer: add missing mb's to freezer_count() and freezer_should_skip()

Steve French <smfrench@gmail.com>
    SMB3 mounts fail with access denied to some servers

Andy Gross <andy.gross@ti.com>
    staging: drm/omap: Fix include error during make

Jianguo Wu <wujianguo@huawei.com>
    mm/hugetlb: create hugetlb cgroup file in hugetlb_init

Gao feng <gaofeng@cn.fujitsu.com>
    cgroup_rm_file: don't delete the uncreated files

Tejun Heo <tj@kernel.org>
    cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Tejun Heo <tj@kernel.org>
    cgroup: cgroup_subsys->fork() should be called after the task is added to css_set

Russell Webb <russell.webb@linux.intel.com>
    xhci: Add Lynx Point LP to list of Intel switchable hosts

Alexis R. Cortes <alexis.cortes@ti.com>
    usb: host: xhci: Stricter conditional for Z1 system models for Compliance Mode Patch

Alan Stern <stern@rowland.harvard.edu>
    USB: fix endpoint-disabling for failed config changes

Julius Werner <jwerner@chromium.org>
    xhci: fix null-pointer dereference when destroying half-built segment rings

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xHCI: Fix TD Size calculation on 1.0 hosts.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix conditional check in bandwidth calculation.

Afzal Mohammed <afzal@ti.com>
    Revert "usb: musb: dsps: remove explicit NOP device creation"

Sergei Shtylyov <sshtylyov@ru.mvista.com>
    usb: musb: cppi_dma: export cppi_interrupt()

Thomas Gleixner <tglx@linutronix.de>
    genirq: Always force thread affinity

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: gpio_keys - defer probing if GPIO probing is deferred

Gabor Juhos <juhosg@openwrt.org>
    Input: gpio_keys_polled - defer probing if GPIO probing is deferred

Christophe TORDEUX <christophe@tordeux.net>
    Input: sentelic - only report position of first finger as ST coordinates

Diego Calleja <diegocg@gmail.com>
    Input: wacom - fix touch support for Bamboo Fun CTH-461

Peter Popovec <popovec@oko.fei.tuke.sk>
    Input: walkera0701 - fix crash on startup

NeilBrown <neilb@suse.de>
    vfs: d_obtain_alias() needs to use "/" as default name.

Nickolai Zeldovich <nickolai@csail.mit.edu>
    nfs: avoid dereferencing null pointer in initiate_bulk_draining

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Ensure that we free the rpc_task after read and write cleanups are done

Xi Wang <xi.wang@gmail.com>
    nfs: fix null checking in nfs_get_option_str()

Yanchuan Nian <ycnian@gmail.com>
    pnfs: Increase the refcount when LAYOUTGET fails the first time

Weston Andros Adamson <dros@netapp.com>
    NFS: Fix access to suid/sgid executables

Neil Brown <neilb@suse.de>
    nfsd: avoid permission checks on EXCLUSIVE_CREATE replay

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix oops on unusual readlike compound

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix v4 reply caching

Yanchuan Nian <ycnian@gmail.com>
    nfs: fix wrong object type in lockowner_slab

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Don't use SetPageError in the NFS writeback code

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix calls to drop_nlink()

NeilBrown <neilb@suse.de>
    NFS: avoid NULL dereference in nfs_destroy_server

Jeff Layton <jlayton@redhat.com>
    nfs: don't zero out the rest of the page if we hit the EOF on a DIO READ

Sven Wegener <sven.wegener@stealer.net>
    NFSv4: Check for buffer length in __nfs4_get_acl_uncached

Jeff Layton <jlayton@redhat.com>
    nfs: don't extend writes to cover entire page if pagecache is invalid

Bryan Schumaker <bjschuma@netapp.com>
    NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / scan: Do not use dummy HID for system bus ACPI nodes

Aaron Lu <aaron.lu@intel.com>
    libata: restore acpi disable functionality

Zhang Rui <rui.zhang@intel.com>
    ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: network: fix bind() error path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: uvc: fix error path in uvc_function_bind()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: tcm_usb_gadget: NULL terminate the FS descriptor list

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: phonet: free requests in pn_bind()'s error path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: midi: free hs descriptors

Lothar Waßmann <LW@KARO-electronics.de>
    USB: chipidea: fix use after free bug

Christian Lamparter <chunkeey@googlemail.com>
    p54usb: add USBIDs for two more p54usb devices

Tomasz Guszkowski <tsg@o2.pl>
    p54usb: add USB ID for T-Com Sinus 154 data II

Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg

Dan Williams <dcbw@redhat.com>
    qmi_wwan/cdc_ether: add Dell Wireless 5800 (Novatel E362) USB IDs

David Henningsson <david.henningsson@canonical.com>
    ALSA: hda - add mute LED for HP Pavilion 17 (Realtek codec)

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix pin configuration of HP Pavilion dv7

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Always turn on pins for HDMI/DP

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Add stereo-dmic fixup for Acer Aspire One 522

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Move runtime PM check to runtime_idle callback

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Fix missing autopm for MIDI input

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Avoid autopm calls after disconnection

Hugh Dickins <hughd@google.com>
    tmpfs mempolicy: fix /proc/mounts corrupting memory

Christoffer Dall <cdall@cs.columbia.edu>
    mm: Fix PageHead when !CONFIG_PAGEFLAGS_EXTENDED

Sonny Rao <sonnyrao@chromium.org>
    mm: fix calculation of dirtyable memory

Will Deacon <will.deacon@arm.com>
    virtio: force vring descriptors to be allocated from lowmem

Will Deacon <will.deacon@arm.com>
    virtio: 9p: correctly pass physical address to userspace for high pages

Will Deacon <will.deacon@arm.com>
    mm: highmem: export kmap_to_page for modules

Ondrej Zary <linux@rainbow-software.org>
    x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

Will Deacon <will.deacon@arm.com>
    arm64: signal: push the unwinding prologue on the signal stack

Catalin Marinas <catalin.marinas@arm.com>
    arm64: Make !dirty ptes read-only

Kees Cook <keescook@chromium.org>
    exec: do not leave bprm->interp on stack

Robin Holt <holt@sgi.com>
    SGI-XP: handle non-fatal traps

Alan Cox <alan@lxorguk.ukuu.org.uk>
    pnpacpi: fix incorrect TEST_ALPHA() test

Felix Fietkau <nbd@openwrt.org>
    b43: fix tx path skb leaks

Larry Finger <Larry.Finger@lwfinger.net>
    b43legacy: Fix firmware loading when driver is built into the kernel

Chuansheng Liu <chuansheng.liu@intel.com>
    firmware loader: Fix the concurrent request_firmware() race for kref_get/put

Chuansheng Liu <chuansheng.liu@intel.com>
    firmware loader: Fix the race FW_STATUS_DONE is followed by class_timeout

Eric Dumazet <edumazet@google.com>
    net: fix a race in gro_cell_poll()


-------------

Diffstat:

 Makefile                                       |   4 +-
 arch/arm/kernel/swp_emulate.c                  |   2 +
 arch/arm/mach-realview/include/mach/board-eb.h |   2 +-
 arch/arm/mm/cache-v7.S                         |   6 +-
 arch/arm/mm/mmu.c                              |   2 +-
 arch/arm64/include/asm/pgtable.h               |   2 +
 arch/arm64/include/asm/unistd32.h              |   2 +-
 arch/arm64/kernel/signal.c                     |  37 ++--
 arch/cris/include/asm/io.h                     |  39 +++-
 arch/sparc/crypto/aes_asm.S                    |  20 ++-
 arch/sparc/crypto/aes_glue.c                   |  31 +++-
 arch/sparc/crypto/camellia_glue.c              |   3 +
 arch/sparc/crypto/des_asm.S                    |   1 +
 arch/sparc/crypto/des_glue.c                   |   6 +
 arch/sparc/include/asm/hugetlb.h               |  10 +-
 arch/x86/pci/common.c                          |   3 +-
 drivers/acpi/scan.c                            |   2 +-
 drivers/acpi/sleep.c                           | 348 ++++++++++++++++++------------------
 drivers/ata/libata-acpi.c                      |   4 +
 drivers/atm/solos-pci.c                        |   5 +-
 drivers/base/firmware_class.c                  |  30 ++--
 drivers/bluetooth/btusb.c                      |   1 +
 drivers/hid/hid-core.c                         |   1 +
 drivers/input/joystick/walkera0701.c           |   7 +-
 drivers/input/keyboard/gpio_keys.c             |  13 +-
 drivers/input/keyboard/gpio_keys_polled.c      |  13 +-
 drivers/input/mouse/sentelic.c                 |   2 +-
 drivers/input/serio/i8042-x86ia64io.h          |   9 +
 drivers/input/tablet/wacom_wac.c               |   3 +-
 drivers/misc/sgi-xp/xpc_main.c                 |  34 +++-
 drivers/net/can/dev.c                          |   3 +-
 drivers/net/usb/cdc_ether.c                    |  15 ++
 drivers/net/usb/qmi_wwan.c                     |  14 ++
 drivers/net/wireless/b43/dma.c                 |   7 +-
 drivers/net/wireless/b43/main.c                |  12 +-
 drivers/net/wireless/b43/pio.c                 |   4 +-
 drivers/net/wireless/b43legacy/b43legacy.h     |   5 +
 drivers/net/wireless/b43legacy/main.c          |  37 +++-
 drivers/net/wireless/p54/p54usb.c              |   4 +
 drivers/net/wireless/rtlwifi/usb.c             |   7 +-
 drivers/pci/pci-driver.c                       |  67 ++++---
 drivers/pci/pci.c                              |   2 +
 drivers/pci/pcie/portdrv_pci.c                 |  20 ++-
 drivers/pci/quirks.c                           |   7 +-
 drivers/pnp/pnpacpi/core.c                     |   2 +-
 drivers/rtc/class.c                            |   1 -
 drivers/rtc/rtc-vt8500.c                       |  11 +-
 drivers/staging/omapdrm/omap_crtc.c            |   2 +-
 drivers/usb/chipidea/core.c                    |   3 +-
 drivers/usb/core/message.c                     |  54 +++---
 drivers/usb/gadget/f_ecm.c                     |   4 +-
 drivers/usb/gadget/f_eem.c                     |   5 +-
 drivers/usb/gadget/f_midi.c                    |   1 +
 drivers/usb/gadget/f_ncm.c                     |   4 +-
 drivers/usb/gadget/f_phonet.c                  |   8 +-
 drivers/usb/gadget/f_rndis.c                   |   4 +-
 drivers/usb/gadget/f_subset.c                  |   4 +-
 drivers/usb/gadget/f_uvc.c                     |  39 ++--
 drivers/usb/gadget/tcm_usb_gadget.c            |   1 +
 drivers/usb/host/ehci-pci.c                    |   3 +-
 drivers/usb/host/pci-quirks.c                  |   4 +-
 drivers/usb/host/xhci-mem.c                    |   9 +-
 drivers/usb/host/xhci-ring.c                   |  32 ++--
 drivers/usb/host/xhci.c                        |   4 +-
 drivers/usb/musb/cppi_dma.c                    |   1 +
 drivers/usb/musb/musb_dsps.c                   |   3 +-
 drivers/virtio/virtio_ring.c                   |   7 +
 fs/binfmt_misc.c                               |   5 +-
 fs/binfmt_script.c                             |   4 +-
 fs/cifs/readdir.c                              |  59 +++---
 fs/cifs/smb1ops.c                              |   7 +
 fs/cifs/smb2pdu.c                              |   2 +-
 fs/cifs/transport.c                            |   6 +-
 fs/dcache.c                                    |   2 +-
 fs/exec.c                                      |  15 ++
 fs/file_table.c                                |   2 +-
 fs/nfs/callback_proc.c                         |   2 +-
 fs/nfs/client.c                                |   3 +-
 fs/nfs/dir.c                                   |  27 +--
 fs/nfs/direct.c                                |   8 -
 fs/nfs/nfs4proc.c                              |  46 +++--
 fs/nfs/pnfs.c                                  |   2 +-
 fs/nfs/read.c                                  |  10 +-
 fs/nfs/super.c                                 |   2 +-
 fs/nfs/write.c                                 |  13 +-
 fs/nfsd/nfs4proc.c                             |   8 +-
 fs/nfsd/nfs4state.c                            |   2 +-
 fs/nfsd/nfs4xdr.c                              |  11 +-
 fs/nfsd/nfssvc.c                               |   2 +-
 fs/nfsd/vfs.c                                  |  10 +-
 fs/proc/array.c                                |   2 +-
 fs/splice.c                                    |   4 +-
 fs/xfs/xfs_aops.c                              |  81 +++------
 fs/xfs/xfs_log.c                               |   3 +-
 fs/xfs/xfs_qm.c                                |  15 +-
 include/asm-generic/tlb.h                      |   9 +
 include/linux/binfmts.h                        |   1 +
 include/linux/cgroup.h                         |   1 -
 include/linux/freezer.h                        |  50 +++++-
 include/linux/hugetlb_cgroup.h                 |   5 +-
 include/linux/kernel.h                         |   6 +-
 include/linux/libata.h                         |   1 +
 include/linux/page-flags.h                     |   8 +-
 include/linux/pci_ids.h                        |   1 +
 include/net/gro_cells.h                        |  14 +-
 include/net/inet_connection_sock.h             |   1 +
 include/net/ndisc.h                            |   7 +
 kernel/cgroup.c                                |  76 ++++----
 kernel/cgroup_freezer.c                        |  13 +-
 kernel/fork.c                                  |   9 +-
 kernel/irq/manage.c                            |  23 ++-
 kernel/printk.c                                |   5 +-
 kernel/signal.c                                |   1 +
 lib/atomic64.c                                 |  17 +-
 mm/highmem.c                                   |   1 +
 mm/hugetlb.c                                   |  11 +-
 mm/hugetlb_cgroup.c                            |  19 +-
 mm/memory.c                                    |   5 +
 mm/mempolicy.c                                 |  64 +++----
 mm/page-writeback.c                            |  25 ++-
 net/9p/trans_virtio.c                          |   3 +-
 net/batman-adv/bat_iv_ogm.c                    |   2 +-
 net/bluetooth/hci_core.c                       |   2 +
 net/bluetooth/rfcomm/sock.c                    |   4 +-
 net/bluetooth/sco.c                            |  19 +-
 net/dccp/ipv4.c                                |   4 +-
 net/dccp/ipv6.c                                |   3 +-
 net/ipv4/inet_connection_sock.c                |  16 ++
 net/ipv4/tcp_ipv4.c                            |   6 +-
 net/ipv6/ndisc.c                               |  17 ++
 net/ipv6/tcp_ipv6.c                            |   3 +-
 net/mac802154/wpan.c                           |   2 +-
 net/sched/sch_htb.c                            |   2 +-
 net/sctp/probe.c                               |   3 +-
 sound/pci/hda/hda_intel.c                      |  19 +-
 sound/pci/hda/patch_conexant.c                 |   1 +
 sound/pci/hda/patch_hdmi.c                     |  18 +-
 sound/pci/hda/patch_realtek.c                  |  34 +++-
 sound/pci/hda/patch_sigmatel.c                 |   2 +-
 sound/usb/midi.c                               |  91 ++++++----
 140 files changed, 1280 insertions(+), 749 deletions(-)


