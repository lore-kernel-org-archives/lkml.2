Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab3AIUgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:36:21 -0500
Received: from mail.kernel.org ([198.145.19.201]:40832 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab3AIUgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:36:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 00/80] 3.4.25-stable review
Date: Wed,  9 Jan 2013 12:34:52 -0800
Message-Id: <20130109201500.410171651@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, there are still a lot of patches submitted for inclusion in the
stable releases that I have not gotten to yet.  I wanted to get this
release out now, instead of delaying for a week or so while I dig
through all of the pending patches.

This is the start of the stable review cycle for the 3.4.25 release.
There are 80 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Jan 11 20:13:17 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.25-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.25-rc1

Alexander Stein <alexander.stein@systec-electronic.com>
    can: Do not call dev_put if restart timer is running upon close

Ben Hutchings <ben@decadent.org.uk>
    HID: Add Apple wireless keyboard 2011 ANSI to special driver list

Michal Hocko <mhocko@suse.cz>
    mm: limit mmu_gather batching to fix soft lockups on !CONFIG_PREEMPT

Tony Prisk <linux@prisktech.co.nz>
    drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time

Tony Prisk <linux@prisktech.co.nz>
    drivers/rtc/rtc-vt8500.c: correct handling of CR_24H bitfield

Corey Minyard <cminyard@mvista.com>
    CRIS: fix I/O macros

Stephen Boyd <sboyd@codeaurora.org>
    lib: atomic64: Initialize locks statically to fix early users

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: cancel power_on work when unregistering the device

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: Add missing lock nesting notation

Marcos Chaparro <marcos@mrkindustries.com.ar>
    Bluetooth: ath3k: Add support for VAIO VPCEH [0489:e027]

Andy Lutomirski <luto@amacapital.net>
    PCI: Reduce Ricoh 0xe822 SD card reader base clock frequency to 50MHz

David Woodhouse <dwmw2@infradead.org>
    solos-pci: fix double-free of TX skb in DMA mode

Will Deacon <will.deacon@arm.com>
    ARM: 7607/1: realview: fix private peripheral memory base for EB rev. B boards

Al Viro <viro@ZenIV.linux.org.uk>
    ARM: missing ->mmap_sem around find_vma() in swp_emulate.c

Will Deacon <will.deacon@arm.com>
    ARM: mm: use pteval_t to represent page protection values

Eric Dumazet <edumazet@google.com>
    tcp: RFC 5961 5.2 Blind Data Injection Attack Mitigation

Eric Dumazet <edumazet@google.com>
    tcp: tcp_replace_ts_recent() should not be called from tcp_validate_incoming()

Eric Dumazet <edumazet@google.com>
    tcp: refine SYN handling in tcp_validate_incoming

Eric Dumazet <edumazet@google.com>
    tcp: implement RFC 5961 4.2

Eric Dumazet <edumazet@google.com>
    tcp: implement RFC 5961 3.2

Eric Dumazet <edumazet@google.com>
    tcp: fix MSG_SENDPAGE_NOTLAST logic

Stefan Hasko <hasko.stevo@gmail.com>
    net: sched: integer overflow fix

Christoph Paasch <christoph.paasch@uclouvain.be>
    inet: Fix kmemleak in tcp_v4/6_syn_recv_sock and dccp_v4/6_request_recv_sock

Akinobu Mita <akinobu.mita@gmail.com>
    batman-adv: fix random jitter calculation

Dave Kleikamp <dave.kleikamp@oracle.com>
    sparc: huge_ptep_set_* functions need to call set_huge_pte_at()

Andre Przywara <andre.przywara@amd.com>
    x86, amd: Disable way access filter on Piledriver CPUs

Tejun Heo <tj@kernel.org>
    freezer: add missing mb's to freezer_count() and freezer_should_skip()

Tejun Heo <tj@kernel.org>
    cgroup: remove incorrect dget/dput() pair in cgroup_create_dir()

Russell Webb <russell.webb@linux.intel.com>
    xhci: Add Lynx Point LP to list of Intel switchable hosts

Alexis R. Cortes <alexis.cortes@ti.com>
    usb: host: xhci: Stricter conditional for Z1 system models for Compliance Mode Patch

Julius Werner <jwerner@chromium.org>
    xhci: fix null-pointer dereference when destroying half-built segment rings

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xHCI: Fix TD Size calculation on 1.0 hosts.

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix conditional check in bandwidth calculation.

Sergei Shtylyov <sshtylyov@ru.mvista.com>
    usb: musb: cppi_dma: export cppi_interrupt()

Thomas Gleixner <tglx@linutronix.de>
    genirq: Always force thread affinity

Christophe TORDEUX <christophe@tordeux.net>
    Input: sentelic - only report position of first finger as ST coordinates

Peter Popovec <popovec@oko.fei.tuke.sk>
    Input: walkera0701 - fix crash on startup

Xi Wang <xi.wang@gmail.com>
    nfs: fix null checking in nfs_get_option_str()

Neil Brown <neilb@suse.de>
    nfsd: avoid permission checks on EXCLUSIVE_CREATE replay

J. Bruce Fields <bfields@redhat.com>
    nfsd4: fix oops on unusual readlike compound

J. Bruce Fields <bfields@redhat.com>
    nfsd: fix v4 reply caching

Yanchuan Nian <ycnian@gmail.com>
    nfs: fix wrong object type in lockowner_slab

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix calls to drop_nlink()

NeilBrown <neilb@suse.de>
    NFS: avoid NULL dereference in nfs_destroy_server

Bryan Schumaker <bjschuma@netapp.com>
    NFS: Add sequence_priviliged_ops for nfs4_proc_sequence()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI / scan: Do not use dummy HID for system bus ACPI nodes

Zhang Rui <rui.zhang@intel.com>
    ACPI: do acpisleep dmi check when CONFIG_ACPI_SLEEP is set

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: network: fix bind() error path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: uvc: fix error path in uvc_function_bind()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: phonet: free requests in pn_bind()'s error path

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    usb: gadget: midi: free hs descriptors

Christian Lamparter <chunkeey@googlemail.com>
    p54usb: add USBIDs for two more p54usb devices

Tomasz Guszkowski <tsg@o2.pl>
    p54usb: add USB ID for T-Com Sinus 154 data II

Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
    rtlwifi: fix incorrect use of usb_alloc_coherent with usb_control_msg

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix pin configuration of HP Pavilion dv7

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix the wrong pincaps set in ALC861VD dallas/hp fixup

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

Ondrej Zary <linux@rainbow-software.org>
    x86, 8042: Enable A20 using KBC to fix S3 resume on some MSI laptops

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

Neal Cardwell <ncardwell@google.com>
    inet_diag: validate port comparison byte code to prevent unsafe reads

Neal Cardwell <ncardwell@google.com>
    inet_diag: avoid unsafe and nonsensical prefix matches in inet_diag_bc_run()

Neal Cardwell <ncardwell@google.com>
    inet_diag: validate byte code to prevent oops in inet_diag_bc_run()

Neal Cardwell <ncardwell@google.com>
    inet_diag: fix oops for IPv4 AF_INET6 TCP SYN-RECV state

Jay Purohit <jspurohit@velocitylimitless.com>
    usb/ipheth: Add iPhone 5 support

Johannes Berg <johannes.berg@intel.com>
    ipv4: ip_check_defrag must not modify skb before unsharing

Alexander Shiyan <shc_work@mail.ru>
    irda: sir_dev: Fix copy/paste typo

Alan Cox <alan@linux.intel.com>
    ne2000: add the right platform device

Tommi Rantala <tt.rantala@gmail.com>
    sctp: fix -ENOMEM result with invalid user space pointer in sendto() syscall

Tommi Rantala <tt.rantala@gmail.com>
    sctp: fix memory leak in sctp_datamsg_from_user() when copy from user space fails

nikolay@redhat.com <nikolay@redhat.com>
    bonding: fix race condition in bonding_store_slaves_active

Sarveshwar Bandi <sarveshwar.bandi@emulex.com>
    bonding: Bonding driver does not consider the gso_max_size/gso_max_segs setting of slave devices.


-------------

Diffstat:

 Documentation/networking/ip-sysctl.txt         |   5 +
 Makefile                                       |   4 +-
 arch/arm/kernel/swp_emulate.c                  |   2 +
 arch/arm/mach-realview/include/mach/board-eb.h |   2 +-
 arch/arm/mm/mmu.c                              |   2 +-
 arch/cris/include/asm/io.h                     |  39 ++-
 arch/sparc/include/asm/hugetlb.h               |  10 +-
 arch/x86/kernel/cpu/amd.c                      |  14 +
 drivers/acpi/scan.c                            |   2 +-
 drivers/acpi/sleep.c                           | 348 +++++++++++++------------
 drivers/atm/solos-pci.c                        |   5 +-
 drivers/bluetooth/ath3k.c                      |   1 +
 drivers/bluetooth/btusb.c                      |   1 +
 drivers/hid/hid-core.c                         |   1 +
 drivers/input/joystick/walkera0701.c           |   7 +-
 drivers/input/mouse/sentelic.c                 |   2 +-
 drivers/input/serio/i8042-x86ia64io.h          |   9 +
 drivers/misc/sgi-xp/xpc_main.c                 |  34 ++-
 drivers/net/bonding/bond_main.c                |   7 +
 drivers/net/bonding/bond_sysfs.c               |   2 +
 drivers/net/can/dev.c                          |   3 +-
 drivers/net/ethernet/8390/ne.c                 |   1 +
 drivers/net/irda/sir_dev.c                     |   2 +-
 drivers/net/usb/ipheth.c                       |   5 +
 drivers/net/wireless/b43/dma.c                 |   7 +-
 drivers/net/wireless/b43/main.c                |  12 +-
 drivers/net/wireless/b43/pio.c                 |   4 +-
 drivers/net/wireless/b43legacy/b43legacy.h     |   5 +
 drivers/net/wireless/b43legacy/main.c          |  37 ++-
 drivers/net/wireless/p54/p54usb.c              |   4 +
 drivers/net/wireless/rtlwifi/usb.c             |   7 +-
 drivers/pci/quirks.c                           |   7 +-
 drivers/pnp/pnpacpi/core.c                     |   2 +-
 drivers/rtc/rtc-vt8500.c                       |  11 +-
 drivers/usb/gadget/f_ecm.c                     |   4 +-
 drivers/usb/gadget/f_eem.c                     |   5 +-
 drivers/usb/gadget/f_midi.c                    |   1 +
 drivers/usb/gadget/f_ncm.c                     |   4 +-
 drivers/usb/gadget/f_phonet.c                  |   8 +-
 drivers/usb/gadget/f_rndis.c                   |   4 +-
 drivers/usb/gadget/f_subset.c                  |   4 +-
 drivers/usb/gadget/f_uvc.c                     |  39 +--
 drivers/usb/host/ehci-pci.c                    |   3 +-
 drivers/usb/host/pci-quirks.c                  |   4 +-
 drivers/usb/host/xhci-mem.c                    |   9 +-
 drivers/usb/host/xhci-ring.c                   |  32 ++-
 drivers/usb/host/xhci.c                        |   4 +-
 drivers/usb/musb/cppi_dma.c                    |   1 +
 drivers/virtio/virtio_ring.c                   |   7 +
 fs/binfmt_misc.c                               |   5 +-
 fs/binfmt_script.c                             |   4 +-
 fs/exec.c                                      |  15 ++
 fs/nfs/client.c                                |   3 +-
 fs/nfs/dir.c                                   |  11 +-
 fs/nfs/nfs4proc.c                              |  21 +-
 fs/nfs/super.c                                 |   2 +-
 fs/nfsd/nfs4proc.c                             |   8 +-
 fs/nfsd/nfs4state.c                            |   2 +-
 fs/nfsd/nfs4xdr.c                              |  11 +-
 fs/nfsd/nfssvc.c                               |   2 +-
 fs/nfsd/vfs.c                                  |  10 +-
 fs/splice.c                                    |   4 +-
 include/asm-generic/tlb.h                      |   9 +
 include/linux/binfmts.h                        |   1 +
 include/linux/freezer.h                        |  50 +++-
 include/linux/page-flags.h                     |   8 +-
 include/linux/pci_ids.h                        |   1 +
 include/linux/snmp.h                           |   3 +-
 include/net/inet_connection_sock.h             |   1 +
 include/net/tcp.h                              |   1 +
 kernel/cgroup.c                                |   2 -
 kernel/irq/manage.c                            |  23 +-
 lib/atomic64.c                                 |  17 +-
 mm/memory.c                                    |   5 +
 mm/mempolicy.c                                 |  64 ++---
 mm/page-writeback.c                            |  25 +-
 net/batman-adv/bat_iv_ogm.c                    |   2 +-
 net/bluetooth/hci_core.c                       |   2 +
 net/bluetooth/rfcomm/sock.c                    |   4 +-
 net/dccp/ipv4.c                                |   4 +-
 net/dccp/ipv6.c                                |   3 +-
 net/ipv4/inet_connection_sock.c                |  16 ++
 net/ipv4/inet_diag.c                           | 154 ++++++++---
 net/ipv4/ip_fragment.c                         |  19 +-
 net/ipv4/proc.c                                |   3 +-
 net/ipv4/sysctl_net_ipv4.c                     |   7 +
 net/ipv4/tcp_input.c                           |  93 +++++--
 net/ipv4/tcp_ipv4.c                            |   6 +-
 net/ipv6/tcp_ipv6.c                            |   3 +-
 net/sched/sch_htb.c                            |   2 +-
 net/sctp/chunk.c                               |  20 +-
 net/sctp/socket.c                              |   4 +-
 sound/pci/hda/patch_realtek.c                  |   4 +-
 sound/pci/hda/patch_sigmatel.c                 |   2 +-
 sound/usb/midi.c                               |  91 ++++---
 95 files changed, 993 insertions(+), 487 deletions(-)


