Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2HUAhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 20:37:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:62062 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab2HUAh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 20:37:26 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>, <stable@vger.kernel.org>,
        <lwn@lwn.net>
Subject: Linux 2.6.34.13
Date: Mon, 20 Aug 2012 20:34:12 -0400
Message-ID: <1345509252-5695-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.34.13 kernel.

All 2.6.34 users are strongly encouraged to update.

The updated 2.6.34.y git tree can be found at:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-2.6.34.y
and can be browsed at the normal kernel.org git web browser:
   http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=shortlog;h=refs/heads/linux-2.6.34.y

Thanks,
Paul.
---

The following changes since commit 744f2110ae5939ebb75b2a3dd57ec64708481f82:

  Linux 2.6.34.12 (2012-05-17 11:27:28 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git tags/v2.6.34.13

for you to fetch changes up to 5b765b08fa5fbbba1131dcc459f8991d81e4f8d7:

  Linux 2.6.34.13 (2012-08-20 14:45:22 -0400)

----------------------------------------------------------------
This is the 2.6.34.13 stable release

----------------------------------------------------------------
Al Viro (1):
      deal with races in /proc/*/{syscall,stack,personality}

Alan Stern (1):
      usb-storage: Accept 8020i-protocol commands longer than 12 bytes

Alex Williamson (2):
      KVM: Remove ability to assign a device without iommu support
      KVM: Device assignment permission checks

Alexandre Bounine (1):
      drivers/net/rionet.c: fix ethernet address macros for LE platforms

Andrew Vasquez (1):
      qla2xxx: Correct inadvertent loop state transitions during port-update handling.

Andrew Worsley (1):
      USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c

Aneesh Kumar K.V (1):
      fs/9p: Fid is not valid after a failed clunk.

Anton Blanchard (1):
      ipr: Always initiate hard reset in kdump kernel

Artur Zimmer (1):
      USB: Serial: Add PID(0xF7C0) to FTDI SIO driver for a zeitcontrol-device

Avi Kivity (1):
      KVM: Ensure all vcpus are consistent with in-kernel irqchip settings

Axel Lin (2):
      ASoC: wm8940: Properly set codec->dapm.bias_level
      ASoC: ak4535: fixup cache register table

Bart Van Assche (1):
      [SCSI] Make scsi_free_queue() kill pending SCSI commands

Ben Hutchings (1):
      rose: Add length checks to CALL_REQUEST parsing

Bernd Schubert (1):
      nfsd4: Remove check for a 32-bit cookie in nfsd4_readdir()

Borislav Petkov (1):
      kbuild: Add extra gcc checks

Carlos Maiolino (1):
      xfs: Fix possible memory corruption in xfs_readlink

Carsten Otte (1):
      KVM: s390: check cpu_id prior to using it

Chris Wilson (2):
      drm/i915: Sanity check pread/pwrite
      drm/i915: Rephrase pwrite bounds checking to avoid any potential overflow

Dan Carpenter (2):
      PM / Suspend: Off by one in pm_suspend()
      hfs: add sanity check for file name length

Daniel Schwierzeck (1):
      atm: br2684: Fix oops due to skb->dev being NULL

Dave Jones (1):
      kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0

David Henningsson (2):
      ALSA: HDA: Cirrus - fix "Surround Speaker" volume control name
      ALSA: HDA: Add new revision for ALC662

David Howells (1):
      KEYS: Fix a NULL pointer deref in the user-defined key type

David S. Miller (1):
      sparc: Allow handling signals when stack is corrupted.

Denis Pershin (1):
      usb: cdc-acm: Owen SI-30 support

Eric Benoit (1):
      USB: pl2303: add id for SMART device

Eric Dumazet (2):
      net_sched: Fix qdisc_notify()
      scm: lower SCM_MAX_FD

Eric Paris (1):
      fcaps: clear the same personality flags as suid when fcaps are used

Eric Van Hensbergen (1):
      net/9p: fix client code to fail more gracefully on protocol error

Filip Palian (1):
      Bluetooth: l2cap and rfcomm: fix 1 byte infoleak to userspace.

Florian Echtler (1):
      USB: Serial: Add device ID for Sierra Wireless MC8305

Greg Kroah-Hartman (1):
      hfsplus: Fix potential buffer overflows

H. Peter Anvin (6):
      regset: Prevent null pointer reference on readonly regsets
      x86, cpu: Add CPU flags for F16C and RDRND
      random: Add support for architectural random hooks
      x86, random: Architectural inlines to get random integers with RDRAND
      random: Adjust the number of loops when initializing
      random: mix in architectural randomness in extract_buf()

Hakan Kvist (1):
      USB: ftdi_sio: add PID for Sony Ericsson Urban

Hendrik Brueckner (1):
      hvc_console: Improve tty/console put_chars handling

Herbert Xu (1):
      ipv6: Add GSO support on forwarding path

Hugh Dickins (1):
      vm: fix vm_pgoff wrap in upward expansion

Ian Campbell (2):
      sparc: fix array bounds error setting up PCIC NMI trap
      xen/timer: Missing IRQF_NO_SUSPEND in timer code broke suspend.

Igor Mammedov (1):
      xen: x86_32: do not enable iterrupts when returning from exception in interrupt context

J. Bruce Fields (2):
      locks: fix checking of fcntl_setlease argument
      nfsd4: ignore WANT bits in open downgrade

Jack Wang (1):
      libsas: set sas_address and device type of rphy

James Bottomley (1):
      3w-9xxx: fix iommu_iova leak

Jan Kara (1):
      xfs: Fix missing xfs_iunlock() on error recovery path in xfs_readlink()

Jean Delvare (2):
      hwmon: (w83627ehf) Properly report thermal diode sensors
      carminefb: Fix module parameters permissions

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add Calao reference board support

Jeff Kirsher (1):
      e1000: Fix driver to be used on PA RISC C8000 workstations

Jeff Layton (2):
      cifs: fix possible memory corruption in CIFSFindNext
      cifs: fix dentry refcount leak when opening a FIFO on lookup

Jens Axboe (1):
      fs: assign sb->s_bdi to default_backing_dev_info if the bdi is going away

Jeremiah Matthey (1):
      HID: usbhid: Add support for SiGma Micro chip

Jerry Huang (1):
      QE/FHCI: fixed the CONTROL bug

Jiri Kosina (1):
      kmod: prevent kmod_loop_msg overflow in __request_module()

Joerg Roedel (1):
      iommu/amd: Fix wrong shift direction

Johan Hovold (1):
      USB: ftdi_sio: fix initial baud rate

Johannes Berg (1):
      netlink: validate NLA_MSECS length

Johannes Stezenbach (1):
      usbmon vs. tcpdump: fix dropped packet count

John Stultz (6):
      ntp: Fix leap-second hrtimer livelock
      ntp: Fix STA_INS/DEL clearing bug
      timekeeping: Fix CLOCK_MONOTONIC inconsistency during leapsecond
      hrtimer: Provide clock_was_set_delayed()
      timekeeping: Fix leapsecond triggered load spike issue
      hrtimer: Update hrtimer base offsets each hrtimer_interrupt

Jonghwan Choi (1):
      security: fix compile error in commoncap.c

Josh Boyer (2):
      Update email address for stable patch submission
      USB: add quirk for Logitech C600 web cam

Josh Stone (1):
      x86: Fix compilation bug in kprobes' twobyte_is_boostable

Jouni Malinen (1):
      cfg80211: Fix validation of AKM suites

Kautuk Consul (2):
      staging: quatech_usb2: Potential lost wakeup scenario in TIOCMIWAIT
      xhci-mem.c: Check for ring->first_seg != NULL

Kees Cook (1):
      x86, cpufeature: Update CPU feature RDRND to RDRAND

Konrad Rzeszutek Wilk (1):
      xen/smp: Warn user why they keel over - nosmp or noapic and what to use instead.

Kuninori Morimoto (1):
      ASoC: ak4642: fixup cache register table

Lan Tianyu (1):
      ACPI/AC: prevent OOPS on some boxes due to missing check power_supply_register() return value check

Linus Torvalds (3):
      vm: fix vm_pgoff wrap in stack expansion
      random: Use arch_get_random_int instead of cycle counter if avail
      random: create add_device_randomness() interface

Luben Tuikov (1):
      USB: storage: Use normalized sense when emulating autosense

Luciano Coelho (1):
      nl80211: fix overflow in ssid_len

Manoj Iyer (1):
      thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.

Manual Munz (1):
      b43: Fix beacon problem in ad-hoc mode

Marek Marczykowski (1):
      xen-blkfront: fix data size for xenbus_gather in blkfront_connect

Marek Vasut (1):
      ASIX: Add AX88772B USB ID

Mark Brown (3):
      ASoC: Fix reporting of partial jack updates
      rtc: wm831x: Feed the write counter into device_add_randomness()
      mfd: wm831x: Feed the device UUID into device_add_randomness()

Mark Nelson (1):
      ahci: Enable SB600 64bit DMA on Asus M3A

Mark Salyzyn (2):
      libsas: fix failure to revalidate domain for anything but the first expander child.
      libsas: fix panic when single phy is disabled on a wide port

Mathieu Desnoyers (1):
      drivers/char/random.c: fix boot id uniqueness race

Matt Mackall (1):
      random: simplify fips mode

Matthew Daley (1):
      x25: Prevent skb overreads when checking call user data

Mauro Carvalho Chehab (2):
      tuner_xc2028: Allow selection of the frequency adjustment code for XC3028
      [media] Remove the old V4L1 v4lgrab.c file

Mel Gorman (1):
      mm: vmalloc: check for page allocation failure before vmlist insertion

Michael Chan (1):
      cnic: Improve NETDEV_UP event handling

Michal Marek (1):
      kbuild: Fix passing -Wno-* options to gcc 4.4+

Michal Schmidt (1):
      GRO: fix merging a paged skb after non-paged skbs

Michał Sroczyński (1):
      USB: PL2303: correctly handle baudrates above 115200

Mike Christie (1):
      libiscsi_tcp: fix LLD data allocation

Milan Broz (1):
      kobj_uevent: Ignore if some listeners cannot handle message

Ming Lei (1):
      uvcvideo: Set alternate setting 0 on resume if the bus has been reset

Mitsuo Hayasaka (1):
      mm: avoid null pointer access in vm_struct via /proc/vmallocinfo

NeilBrown (3):
      md/linear: avoid corrupting structure while waiting for rcu_free to complete.
      NFS/sunrpc: don't use a credential with extra groups.
      md/raid5: abort any pending parity operations when array fails.

Nelson Elhage (1):
      epoll: fix spurious lockdep warnings

Oliver Neukum (1):
      USB: add RESET_RESUME for webcams shown to be quirky

Paul Fertser (1):
      plat-mxc: iomux-v3.h: implicitly enable pull-up/down when that's desired

Paul Gortmaker (1):
      Linux 2.6.34.13

Peter Huewe (2):
      TPM: Call tpm_transmit with correct size
      TPM: Zero buffer after copying to userspace

Peter Stuge (1):
      USB: ftdi_sio: Support TI/Luminary Micro Stellaris BD-ICDI Board

Peter Wippich (1):
      mtd: mtdchar: add missing initializer on raw write

Peter Zijlstra (1):
      perf: overflow/perf_count_sw_cpu_clock crashes recent kernels

Petr Uzel (1):
      [SCSI] st: fix race in st_scsi_execute_end

Rajashekhara, Sudhakar (1):
      ARM: davinci: da850 EVM: read mac address from SPI flash

Rajkumar Manoharan (1):
      wireless: Reset beacon_found while updating regulatory

Randy Dunlap (1):
      irda: fix smsc-ircc2 section mismatch warning

Richard Cochran (1):
      ntp: Correct TAI offset during leap second

Richard Weinberger (1):
      um: fix ubd cow size

Rigbert Hamisch (1):
      USB: qcserial: add device ID for "HP un2430 Mobile Broadband Module"

Sam Ravnborg (1):
      kbuild: implement several W= levels

Sebastian Ott (1):
      [S390] ccwgroup: move attributes to attribute group

Serge Hallyn (1):
      USB: pid_ns: ensure pid is not freed during kill_pid_info_as_uid

Sonny Rao (1):
      powerpc/pci: Check devices status property when scanning OF tree

Stanislaw Gruszka (1):
      rt2x00: do not drop usb dev reference counter on suspend

Takashi Iwai (1):
      ALSA: hda/realtek - Avoid bogus HP-pin assignment

Theodore Ts'o (11):
      ext2,ext3,ext4: don't inherit APPEND_FL or IMMUTABLE_FL for new inodes
      random: Use arch-specific RNG to initialize the entropy store
      random: make 'add_interrupt_randomness()' do something sane
      random: use lockless techniques in the interrupt path
      random: use the arch-specific rng in xfer_secondary_pool
      random: add new get_random_bytes_arch() function
      random: add tracepoints for easier debugging and verification
      MAINTAINERS: Theodore Ts'o is taking over the random driver
      usb: feed USB device information to the /dev/random driver
      net: feed /dev/random with the MAC address when registering a device
      random: remove rand_initialize_irq()

Thomas Gleixner (5):
      time: Move common updates to a function
      timekeeping: Maintain ktime_t based offsets for hrtimers
      hrtimers: Move lock held region in hrtimer_interrupt()
      timekeeping: Provide hrtimer update function
      timekeeping: Add missing update call in timekeeping_resume()

Tim Gardner (1):
      TPM: Zero buffer whole after copying to userspace

Tony Luck (3):
      fix typo/thinko in get_random_bytes()
      random: Add comment to random_initialize()
      dmi: Feed DMI table to /dev/random driver

Trond Myklebust (1):
      NLM: Don't hang forever on NLM unlock requests

Vasily Averin (1):
      aacraid: reset should disable MSI interrupt

Venkateswararao Jujjuri (JV) (1):
      net/9p: Fix the msize calculation.

Wang Zhi (1):
      USB: EHCI: Do not rely on PORT_SUSPEND to stop USB resuming in ehci_bus_resume().

Xi Wang (2):
      drm: integer overflow in drm_mode_dirtyfb_ioctl()
      ext4: fix undefined behavior in ext4_fill_flex_info()

hank (1):
      time: Change jiffies_to_clock_t() argument type to unsigned long

sordna (1):
      USB: quirks: adding more quirky webcams to avoid squeaky audio

wangyanqing (1):
      USB: serial: pl2303: rm duplicate id

 Documentation/Makefile                      |   2 +-
 Documentation/kbuild/kbuild.txt             |   5 +
 Documentation/kbuild/makefiles.txt          |  12 +
 Documentation/stable_kernel_rules.txt       |  14 +-
 Documentation/video4linux/Makefile          |   8 -
 Documentation/video4linux/v4lgrab.c         | 201 ---------------
 MAINTAINERS                                 |   2 +-
 Makefile                                    |  17 +-
 arch/arm/mach-davinci/board-da850-evm.c     |  28 ++
 arch/arm/plat-mxc/include/mach/iomux-v3.h   |  10 +-
 arch/ia64/kernel/irq_ia64.c                 |   1 -
 arch/ia64/kvm/kvm-ia64.c                    |   5 +
 arch/powerpc/kernel/pci_of_scan.c           |   2 +
 arch/s390/kvm/kvm-s390.c                    |  14 +-
 arch/sparc/include/asm/sigcontext.h         |  14 +
 arch/sparc/kernel/Makefile                  |   1 +
 arch/sparc/kernel/pcic.c                    |   4 +-
 arch/sparc/kernel/signal32.c                | 184 +++++++------
 arch/sparc/kernel/signal_32.c               | 172 ++++++-------
 arch/sparc/kernel/signal_64.c               | 108 ++++----
 arch/sparc/kernel/sigutil.h                 |   9 +
 arch/sparc/kernel/sigutil_32.c              | 120 +++++++++
 arch/sparc/kernel/sigutil_64.c              |  93 +++++++
 arch/um/drivers/ubd_kern.c                  |  31 ++-
 arch/x86/Kconfig                            |   9 +
 arch/x86/include/asm/archrandom.h           |  73 ++++++
 arch/x86/include/asm/cpufeature.h           |   2 +
 arch/x86/kernel/amd_iommu.c                 |   2 +-
 arch/x86/kernel/kprobes.c                   |   4 +-
 arch/x86/kvm/x86.c                          |   8 +
 arch/x86/xen/smp.c                          |  10 +
 arch/x86/xen/time.c                         |   4 +-
 arch/x86/xen/xen-asm_32.S                   |   8 +-
 drivers/acpi/ac.c                           |   4 +-
 drivers/ata/ahci.c                          |  12 +
 drivers/block/xen-blkfront.c                |   2 +-
 drivers/char/hvc_console.c                  |   8 +-
 drivers/char/random.c                       | 384 +++++++++++++++++++---------
 drivers/char/tpm/tpm.c                      |  10 +-
 drivers/firmware/dmi_scan.c                 |   3 +
 drivers/gpu/drm/drm_crtc.c                  |   4 +
 drivers/gpu/drm/i915/i915_gem.c             |  44 ++--
 drivers/hid/hid-ids.h                       |   3 +
 drivers/hid/usbhid/hid-quirks.c             |   1 +
 drivers/hwmon/w83627ehf.c                   |  15 +-
 drivers/md/linear.h                         |   2 +-
 drivers/md/raid5.c                          |  32 ++-
 drivers/media/video/cx23885/cx23885-dvb.c   |   2 +-
 drivers/media/video/uvc/uvc_driver.c        |   2 +-
 drivers/media/video/uvc/uvc_video.c         |  10 +-
 drivers/media/video/uvc/uvcvideo.h          |   2 +-
 drivers/mfd/ab3100-core.c                   |   5 -
 drivers/mfd/wm831x-otp.c                    |   8 +
 drivers/mtd/mtdchar.c                       |   1 +
 drivers/net/cnic.c                          |   4 +-
 drivers/net/e1000/e1000_hw.c                |   6 +
 drivers/net/irda/smsc-ircc2.c               |   2 +-
 drivers/net/rionet.c                        |   4 +-
 drivers/net/usb/asix.c                      |   4 +
 drivers/net/wireless/b43/main.c             |   3 +-
 drivers/net/wireless/rt2x00/rt2x00usb.c     |  14 +-
 drivers/platform/x86/thinkpad_acpi.c        |   6 +-
 drivers/rtc/rtc-wm831x.c                    |  24 +-
 drivers/s390/cio/ccwgroup.c                 |  42 +--
 drivers/scsi/3w-9xxx.c                      |   2 +
 drivers/scsi/aacraid/commsup.c              |   2 +
 drivers/scsi/hosts.c                        |   9 +-
 drivers/scsi/ipr.c                          |   2 +-
 drivers/scsi/libiscsi_tcp.c                 |  14 +-
 drivers/scsi/libsas/sas_expander.c          |  14 +-
 drivers/scsi/qla2xxx/qla_init.c             |   3 -
 drivers/scsi/qla2xxx/qla_isr.c              |   1 -
 drivers/scsi/scsi_lib.c                     |   9 +
 drivers/scsi/st.c                           |   4 +-
 drivers/staging/quatech_usb2/quatech_usb2.c |   9 +-
 drivers/usb/class/cdc-acm.c                 |   3 +
 drivers/usb/core/devio.c                    |   6 +-
 drivers/usb/core/hub.c                      |   9 +
 drivers/usb/core/quirks.c                   |  48 ++++
 drivers/usb/host/ehci-hub.c                 |   7 +-
 drivers/usb/host/fhci-sched.c               |  19 +-
 drivers/usb/host/xhci-mem.c                 |  22 +-
 drivers/usb/mon/mon_bin.c                   |   2 +-
 drivers/usb/serial/ftdi_sio.c               |  46 +++-
 drivers/usb/serial/ftdi_sio_ids.h           |  13 +-
 drivers/usb/serial/pl2303.c                 |  28 +-
 drivers/usb/serial/pl2303.h                 |   6 +-
 drivers/usb/serial/qcserial.c               |   2 +
 drivers/usb/storage/protocol.c              |   7 +-
 drivers/usb/storage/transport.c             |  34 +--
 drivers/video/carminefb.c                   |   6 +-
 fs/binfmt_elf.c                             |   2 +-
 fs/cifs/cifssmb.c                           |   3 +-
 fs/cifs/dir.c                               |  20 +-
 fs/eventpoll.c                              |  25 +-
 fs/ext4/ext4.h                              |   3 +-
 fs/ext4/super.c                             |   7 +-
 fs/hfs/trans.c                              |   2 +
 fs/hfsplus/catalog.c                        |   4 +
 fs/hfsplus/dir.c                            |  11 +
 fs/lockd/clntproc.c                         |   8 +-
 fs/locks.c                                  |   6 +-
 fs/nfsd/nfs4proc.c                          |   2 +-
 fs/nfsd/nfs4state.c                         |   2 +
 fs/proc/base.c                              |  69 +++--
 fs/super.c                                  |   2 +
 fs/sync.c                                   |   4 +-
 fs/xfs/xfs_vnodeops.c                       |  15 +-
 include/drm/drm_mode.h                      |   2 +
 include/linux/ext2_fs.h                     |   4 +-
 include/linux/ext3_fs.h                     |   4 +-
 include/linux/hrtimer.h                     |   9 +-
 include/linux/irq.h                         |   1 -
 include/linux/jiffies.h                     |   2 +-
 include/linux/kvm_host.h                    |   7 +
 include/linux/random.h                      |  19 +-
 include/linux/regset.h                      |   6 +
 include/linux/sunrpc/sched.h                |   1 +
 include/linux/timex.h                       |   2 +-
 include/linux/vmalloc.h                     |   1 +
 include/net/rose.h                          |   8 +-
 include/net/scm.h                           |   5 +-
 include/trace/events/random.h               | 134 ++++++++++
 kernel/hrtimer.c                            |  52 ++--
 kernel/irq/handle.c                         |   7 +-
 kernel/irq/manage.c                         |  17 --
 kernel/kmod.c                               |   4 +-
 kernel/perf_event.c                         |   8 +-
 kernel/power/suspend.c                      |   2 +-
 kernel/time.c                               |   2 +-
 kernel/time/ntp.c                           | 128 ++++------
 kernel/time/timekeeping.c                   |  93 +++++--
 lib/kobject_uevent.c                        |   2 +-
 lib/nlattr.c                                |   1 +
 mm/backing-dev.c                            |   2 +-
 mm/mmap.c                                   |  20 +-
 mm/vmalloc.c                                |  68 +++--
 net/9p/client.c                             |  13 +-
 net/atm/br2684.c                            |   7 +-
 net/bluetooth/l2cap.c                       |   1 +
 net/bluetooth/rfcomm/sock.c                 |   1 +
 net/core/dev.c                              |   3 +
 net/core/rtnetlink.c                        |   1 +
 net/core/scm.c                              |  10 +-
 net/core/skbuff.c                           |   8 +-
 net/ipv6/ip6_output.c                       |   2 +-
 net/rose/af_rose.c                          |   8 +-
 net/rose/rose_loopback.c                    |  13 +-
 net/rose/rose_route.c                       |  20 +-
 net/rose/rose_subr.c                        |  91 ++++---
 net/sched/sch_api.c                         |  14 +-
 net/sunrpc/auth_unix.c                      |   3 +
 net/sunrpc/clnt.c                           |   3 +
 net/sunrpc/sched.c                          |   1 +
 net/wireless/nl80211.c                      |   9 +-
 net/wireless/reg.c                          |   1 +
 net/x25/af_x25.c                            |   3 +-
 scripts/Kbuild.include                      |   5 +
 scripts/Makefile.build                      |  47 +++-
 security/commoncap.c                        |   6 +
 security/keys/user_defined.c                |   3 +-
 sound/pci/hda/patch_cirrus.c                |   2 +-
 sound/pci/hda/patch_realtek.c               |   6 +-
 sound/soc/codecs/ak4535.c                   |  10 +-
 sound/soc/codecs/ak4642.c                   |  22 +-
 sound/soc/codecs/wm8940.c                   |   2 +
 sound/soc/soc-jack.c                        |   2 +-
 virt/kvm/assigned-dev.c                     |  93 ++++++-
 virt/kvm/kvm_main.c                         |   4 +
 169 files changed, 2265 insertions(+), 1112 deletions(-)
 delete mode 100644 Documentation/video4linux/Makefile
 delete mode 100644 Documentation/video4linux/v4lgrab.c
 create mode 100644 arch/sparc/kernel/sigutil.h
 create mode 100644 arch/sparc/kernel/sigutil_32.c
 create mode 100644 arch/sparc/kernel/sigutil_64.c
 create mode 100644 arch/x86/include/asm/archrandom.h
 create mode 100644 include/trace/events/random.h
