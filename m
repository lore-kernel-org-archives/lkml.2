Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab1CaTMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:12:51 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42008 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1CaTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:12:46 -0400
Date: Thu, 31 Mar 2011 21:12:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, lwn@lwn.net,
        tim.bird@am.sony.com
Subject: [ANNOUNCEMENT] The longterm Linux kernel 2.6.35.12 has been released
Message-ID: <20110331191244.GP21838@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new longterm 2.6.35.12 kernel has been released. This release contains
security fixes and everyone is encouraged to update.

Full tarball
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/linux-2.6.35.12.tar.gz
SHA1: 71bd9d5af3493c80d78303901d4c28b3710e2f40

Patch against 2.6.35:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/patch-2.6.35.12.gz
SHA1: 30305ebca67509470a6cc2a80767769efdd2073e

Patch against 2.6.35.11
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/longterm/v2.6.35/incr/patch-2.6.35.11-12.gz
SHA1: e2c30774474f0a3f109a8cb6ca2a95f647c196b8

Git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/longterm/linux-2.6.35.y.git

Aaro Koskinen (1):
      procfs: fix /proc/<pid>/maps heap check

Alan Stern (7):
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: usb-storage: unusual_devs entry for Coby MP3 player
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in module parameter definitions
      USB: prevent buggy hubs from crashing the USB stack
      USB: add quirks entry for Keytouch QWERTY Panel
      ehci-hcd: Bug fix: don't set a QH's Halt bit

Alex Deucher (5):
      drm/radeon/kms: add quirk for Mac Radeon HD 2600 card
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: add pll debugging output
      drm/radeon: remove 0x4243 pci id
      drm/radeon/kms: fix s/r issues with bios scratch regs

Alex He (2):
      USB: EHCI: ASPM quirk of ISOC on AMD SB800
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Alexander van Heukelum (1):
      x86, binutils, xen: Fix another wrong size directive

Amir Goldstein (1):
      ext3: skip orphan cleanup on rocompat fs

Amitkumar Karwar (1):
      ieee80211: correct IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK macro

Andi Kleen (1):
      Release 2.6.35.12

Andre Przywara (1):
      KVM: enlarge number of possible CPUID leaves

Andreas Herrmann (2):
      x86 quirk: Fix polarity for IRQ0 pin2 override on SB800 systems
      x86, quirk: Fix SB600 revision check

Andrey Vagin (1):
      x86/mm: Handle mm_fault_error() in kernel space

Anton Blanchard (3):
      kernel/smp.c: fix smp_call_function_many() SMP race
      RxRPC: Fix v1 keys
      perf, powerpc: Handle events that raise an exception without overflowing

Arnaldo Carvalho de Melo (1):
      perf session: Invalidate last_match when removing threads from rb_tree

Arvid Ephraim Picciani (1):
      USB: cdc-acm: Adding second ACM channel support for Nokia N8

Avi Kivity (3):
      KVM: i8259: initialize isr_ack
      KVM: Fix fs/gs reload oops with invalid ldt
      KVM: Correct ordering of ldt reload wrt fs/gs reload

Axel Lin (1):
      mtd: add "platform:" prefix for platform modalias

Ben Hutchings (2):
      bonding/vlan: Avoid mangled NAs on slaves without VLAN tag insertion
      PCI: sysfs: Fix failure path for addition of "vpd" attribute

Benjamin Herrenschmidt (1):
      powerpc: Fix some 6xx/7xxx CPU setup functions

Bjørn Mork (1):
      USB: io_edgeport: fix the reported firmware major and minor

Brian King (1):
      scsi_dh_alua: Add IBM Power Virtual SCSI ALUA device to dev list

Bruce Allan (1):
      e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead

Bud Brown (1):
      cciss: fix lost command issue

Chris Wilson (1):
      drm/i915: Add dependency on CONFIG_TMPFS

Christian Lamparter (3):
      p54: fix sequence no. accounting off-by-one error
      p54pci: update receive dma buffers before and after processing
      p54usb: add Senao NUB-350 usbid

Chuck Ebbert (1):
      revert misc: uss720.c: add another vendor/product ID

Chuck Lever (1):
      NFS: Fix "kernel BUG at fs/aio.c:554!"

Clemens Ladisch (1):
      ALSA: hrtimer: handle delayed timer interrupts

Craig Shelley (2):
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

Dan Carpenter (2):
      av7110: check for negative array offset
      keyboard: integer underflow bug

Dan Rosenberg (2):
      sctp: Fix out-of-bounds reading in sctp_asoc_get_hmac()
      sound/oss/opl3: validate voice and channel indexes

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

Dave Airlie (1):
      drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.

Dave Young (1):
      sched: Remove unused PF_ALIGNWARN flag

David Henningsson (2):
      ALSA: HDA: Fix dmesg output of HDMI supported bits
      ALSA: HDA: Add position_fix quirk for an Asus device

David Howells (2):
      Fix cred leak in AF_NETLINK
      Patch cab9e9848b9a8283b0504a2d7c435a9f5ba026de to the 2.6.35.y stable tree

David Miller (1):
      klist: Fix object alignment on 64-bit.

David S. Miller (1):
      x25: Do not reference freed memory.

Davide Libenzi (1):
      epoll: prevent creating circular epoll structures

Dimitris Papastamos (1):
      ASoC: WM8990: msleep() takes milliseconds not jiffies

Don Fry (1):
      iwlagn: Re-enable RF_KILL interrupt when down

Don Skidmore (1):
      ixgbe: fix for 82599 erratum on Header Splitting

Don Zickus (1):
      x86: Use u32 instead of long to set reset vector back to 0

Edgar (gimli) Hucek (1):
      input: bcm5974: Add support for MacBookAir3

Eric Paris (2):
      SELinux: define permissions for DCB netlink messages
      SELinux: do not compute transition labels on mountpoint labeled filesystems

Eric Sandeen (1):
      ext3: Always set dx_node's fake_dirent explicitly.

Eric W. Biederman (1):
      net: Fix ip link add netns oops

Felix Fietkau (1):
      mac80211: initialize sta->last_rx in sta_info_alloc

Florian Fainelli (1):
      MIPS: MTX-1: Make au1000_eth probe all PHY addresses

Frederic Weisbecker (1):
      perf: Better fit max unprivileged mlock pages for tools needs

Geert Uytterhoeven (1):
      radio-aimslab.c needs #include <linux/delay.h>

Gerrit Renker (1):
      dccp: fix oops on Reset after close

Greg Kroah-Hartman (1):
      rt2x00: add device id for windy31 usb device

Guenter Roeck (1):
      hwmon: (w83627ehf) Driver cleanup

Guy Martin (1):
      parisc : Remove broken line wrapping handling pdc_iodc_print()

Haiyang Zhang (1):
      staging: hv: Enable sending GARP packet after live migration

Hans de Goede (1):
      hwmon/f71882fg: Set platform drvdata to NULL later

Henrique de Moraes Holschuh (3):
      thinkpad-acpi: lock down size of hotkey keymap
      thinkpad-acpi: add support for model-specific keymaps
      thinkpad-acpi: avoid keymap pitfall

Henry Nestler (1):
      fbcon: Bugfix soft cursor detection in Tile Blitting

Hugh Dickins (2):
      mm: fix possible cause of a page_mapped BUG
      shmem: let shared anonymous be nonlinear again

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Ian Campbell (1):
      arp_notify: unconditionally send gratuitous ARP for NETDEV_NOTIFY_PEERS.

Ingo Molnar (1):
      sched: Export account_system_vtime()

Ionut Nicu (1):
      USB: ti_usb: fix module removal

Ivan Vecera (1):
      r8169: use RxFIFO overflow workaround for 8168c chipset.

J. R. Okajima (1):
      NFS: fix the return value of nfs_file_fsync()

James Bottomley (2):
      fix medium error problems with some arrays which can cause data corruption
      libsas: fix runaway error handler problem

Jan Engelhardt (1):
      netfilter: nf_log: avoid oops in (un)bind with invalid nfproto values

Jean Delvare (2):
      hwmon: (via686a) Initialize fan_div values
      i2c: Unregister dummy devices last on adapter removal

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: ftdi_sio: add ST Micro Connect Lite uart support

Jens Taprogge (1):
      thinkpad-acpi: Add KEY_CAMERA (Fn-F6) for Lenovo keyboards

Jeremy Fitzhardinge (1):
      x86/pvclock: Zero last_value on resume

Jiri Slaby (3):
      USB: serial/kobil_sct, fix potential tty NULL dereference
      PCI: add more checking to ICH region quirks
      PCI: do not create quirk I/O regions below PCIBIOS_MIN_IO for ICH

Jochen Friedrich (1):
      mfd: Fix NULL pointer due to non-initialized ucb1x00-ts absinfo

Johan Hovold (4):
      usb: musb: omap2430: fix kernel panic on reboot
      USB: cdc-acm: fix memory corruption / panic
      USB: cdc-acm: fix potential null-pointer dereference
      USB: cdc-acm: fix potential null-pointer dereference on disconnect

John Hughes (1):
      ses: show devices for enclosures with no page 7

Jon Thomas (1):
      sierra: add new ID for Airprime/Sierra USB IP modem

Josef Bacik (1):
      fs: call security_d_instantiate in d_obtain_alias V2

Josh Hunt (1):
      ext2: Fix link count corruption under heavy link+rename load

Julien Tinnes (1):
      Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code

Kamal Mostafa (2):
      x86: Fix panic when handling "mem={invalid}" param
      x86: Emit "mem=nopentium ignored" warning when not supported

Karsten Wiese (1):
      ALSA: snd-usb-us122l: Fix missing NULL checks

Kashyap, Desai (5):
      mpt2sas: Fix device removal handshake for zoned devices
      mpt2sas: Correct resizing calculation for max_queue_depth
      mpt2sas: Kernel Panic during Large Topology discovery
      mptfusion: mptctl_release is required in mptctl.c
      mptfusion: Fix Incorrect return value in mptscsih_dev_reset

Kees Cook (2):
      usb: iowarrior: don't trust report_size for buffer size
      proc: protect mm start_code/end_code in /proc/pid/stat

Knut Petersen (1):
      drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

Konstantin Khorenko (1):
      NFSD: memory corruption due to writing beyond the stat array

Krishnasamy, Somasundaram (1):
      ses: Avoid kernel panic when lun 0 is not mapped

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Li Zefan (1):
      cpuset: add a missing unlock in cpuset_write_resmask()

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Maciej Szmigiero (2):
      USB: Add Samsung SGH-I500/Android modem ID switch to visor driver
      USB: Add quirk for Samsung Android phone modem

Marcelo Tosatti (2):
      Revert "KVM: Correct ordering of ldt reload wrt fs/gs reload"
      KVM: VMX: Fix host userspace gsbase corruption

Mark Mentovai (1):
      cfg80211: fix can_beacon_sec_chan, reenable HT40

Martin Schwidefsky (1):
      s390: remove task_show_regs

Matt Evans (1):
      powerpc/kexec: Fix orphaned offline CPUs across kexec

Matthew Garrett (1):
      acer-wmi: Fix capitalisation of GUID

Mauro Carvalho Chehab (2):
      radio-aimslab.c: Fix gcc 4.5+ bug
      em28xx: Fix audio input for Terratec Grabby

Max Vozeler (4):
      staging: usbip: vhci: update reference count for usb_device
      staging: usbip: vhci: give back URBs from in-flight unlink requests
      staging: usbip: vhci: refuse to enqueue for dead connections
      staging: usbip: vhci: use urb->dev->portnum to find port

Mi Jinlong (1):
      nfsd41: modify the members value of nfsd4_op_flags

Michael Williamson (1):
      USB: ftdi_sio: Add VID=0x0647, PID=0x0100 for Acton Research spectrograph

Mike Christie (1):
      scsi_dh_alua: add netapp to dev list

Mike Frysinger (1):
      ASoC: Blackfin AC97: fix build error after multi-component update

Mike Snitzer (2):
      dm: dont take i_mutex to change device size
      dm mpath: disable blk_abort_queue

Miklos Szeredi (1):
      fuse: fix hang of single threaded fuseblk filesystem

Milton Miller (4):
      virtio: remove virtio-pci root device
      call_function_many: fix list delete vs add race
      call_function_many: add missing ordering
      smp_call_function_many: handle concurrent clearing of mask

Márton Németh (1):
      staging: usbip: remove double giveback of URB

Namhyung Kim (1):
      kernel/user.c: add lock release annotation on free_user()

NeilBrown (4):
      md: fix regression with re-adding devices to arrays with no metadata
      nfsd: correctly handle return value from nfsd_map_name_to_*
      md: correctly handle probe of an 'mdp' device.
      md: Fix - again - partition detection when array becomes active

Nick Holloway (1):
      USB: Storage: Add unusual_devs entry for VTech Kidizoom

Nicolaus Colberg (1):
      USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Nikhil Rao (4):
      sched: Do not consider SCHED_IDLE tasks to be cache hot
      sched: Set group_imb only a task can be pulled from the busiest cpu
      sched: Force balancing on newidle balance if local group has capacity
      sched: Drop group_capacity to 1 only if local group has extra capacity

Olaf Hering (1):
      Input: xen-kbdfront - advertise either absolute or relative coordinates

Pablo Neira Ayuso (1):
      netfilter: arpt_mangle: fix return values of checkentry

Paul E. McKenney (1):
      sched: suppress RCU lockdep splat in task_fork_fair

Paul Fox (1):
      rtc-cmos: fix suspend/resume

Paul Zimmerman (4):
      xhci: Avoid BUG() in interrupt context
      xhci: Clarify some expressions in the TRB math
      xhci: Fix errors in the running total calculations in the TRB math
      xhci: Fix an error in count_sg_trbs_needed()

Pavel Machek (1):
      serial: unbreak billionton CF card

Pavel Shilovsky (1):
      CIFS: Fix oplock break handling (try #2)

Pekka Enberg (1):
      Revert "slab: Fix missing DEBUG_SLAB last user"

Peter Holik (1):
      USB: uss720 fixup refcount position

Peter Zijlstra (2):
      sched, cgroup: Fixup broken cgroup movement
      perf: Fix tear-down of inherited group events

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Przemyslaw Bruski (3):
      ALSA: ctxfi - Fix incorrect SPDIF status bit mask
      ALSA: ctxfi - Fix SPDIF status retrieval
      ALSA: ctxfi - Clear input settings before initialization

Rafael J. Wysocki (2):
      PM / Hibernate: Improve comments in hibernate_preallocate_memory()
      PM / Hibernate: Make default image size depend on total RAM size

Rajiv Andrade (1):
      TPM: Long default timeout fix

Raymond Yau (1):
      ALSA : au88x0 - Limit number of channels to fix Oops via OSS emu

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation maxi g.u external hard drive enclosure

Roberto Sassu (1):
      eCryptfs: ecryptfs_keyring_auth_tok_for_sig() bug fix

Roland Dreier (2):
      aio: wake all waiters when destroying ctx
      Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo

Roman Fietze (1):
      i2c: Fix typo in instantiating-devices document

Ruben Smits (1):
      staging: comedi: add support for newer jr3 1-channel pci board

Russell King (1):
      ARM: Ensure predictable endian state on signal handler entry

Sarah Sharp (3):
      usb: Realloc xHCI structures after a hub is verified.
      xhci: Fix cycle bit calculation during stall handling.
      xhci: Update internal dequeue pointers after stalls.

Sean Hefty (2):
      RDMA/cma: Fix crash in request handlers
      IB/cm: Bump reference count on cm_id before invoking callback

Sebastian Andrzej Siewior (1):
      USB: isp1760: Implement solution for erratum 2

Senthil Balasubramanian (1):
      ath9k_hw: Fix incorrect macversion and macrev checks

Seth Heasley (3):
      ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
      ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller

Shaohua Li (1):
      x86: Flush TLB if PGD entry is changed in i386 PAE mode

Stanislaw Gruszka (6):
      iwlagn: enable only rfkill interrupt when device is down
      hostap_cs: fix sleeping function called from invalid context
      PM / Hibernate: Return error code when alloc_image_page() fails
      r8169: disable ASPM
      myri10ge: fix rmmod crash
      iwl3945: remove plcp check

Stefan Berger (1):
      tpm_tis: Use timeouts returned from TPM

Stefan Nilsson XK (1):
      mmc: sdio: remember new card RCA when redetecting card

Stefano Stabellini (2):
      PCI hotplug: acpiphp: set current_state to D0 in register_slot
      xen: set max_pfn_mapped to the last pfn mapped

Stephan Lachowsky (1):
      uvcvideo: Fix uvc_fixup_video_ctrl() format search

Steven Rostedt (2):
      sched: Try not to migrate higher priority RT tasks
      ftrace: Fix memory leak with function graph and cpu hotplug

Stuart Hayes (1):
      dcdbas: force SMI to happen when expected

Suresh Siddha (4):
      x86, mtrr: Avoid MTRR reprogramming on BP during boot on UP platforms
      x86, mm: avoid possible bogus tlb entries by clearing prev mm_cpumask after switching mm
      sched: Move sched_avg_update() to update_cpu_load()
      sched: Use group weight, idle cpu metrics to fix imbalances during idle

Sven Neumann (1):
      ds2760_battery: Fix calculation of time_to_empty_now

Takashi Iwai (4):
      ALSA: hda - Fix memory leaks in conexant jack arrays
      ALSA: caiaq - Fix possible string-buffer overflow
      ALSA: hda - Fix SPDIF out regression on ALC889
      ALSA: Fix yet another race in disconnection

Tejun Heo (4):
      PCI: pci-stub: ignore zero-length id parameters
      ptrace: use safer wake up on ptrace_detach()
      pata_mpc52xx: inherit from ata_bmdma_port_ops
      libata: no special completion processing for EH commands

Tetsuo Handa (3):
      CRED: Fix kernel panic upon security_file_alloc() failure.
      CRED: Fix BUG() upon security_cred_alloc_blank() failure
      CRED: Fix memory and refcount leaks upon security_prepare_creds() failure

Thadeu Lima de Souza Cascardo (1):
      classmate-laptop: depends on RFKILL or RFKILL=n

Thomas Gleixner (4):
      isdn: hisax: Replace the bogus access to irq stats
      genirq: Disable the SHIRQ_DEBUG call in request_threaded_irq for now
      clockevents: Prevent oneshot mode when broadcast device is periodic
      fix per-cpu flag problem in the cpu affinity checkers

Thomas Taranowski (1):
      rapidio: fix hang on RapidIO doorbell queue full condition

Tim Deegan (1):
      fix jiffy calculations in calibrate_delay_direct to handle overflow

Timo Warns (2):
      fs/partitions: Validate map_count in Mac partition tables
      ldm: corrupted partition table can cause kernel oops

Tristan Ye (1):
      Ocfs2/refcounttree: Fix a bug for refcounttree to writeback clusters in a right number.

Trond Myklebust (2):
      SUNRPC: Ensure we always run the tk_callback before tk_action
      SUNRPC: Never reuse the socket port after an xs_close()

Tyler Hicks (2):
      eCryptfs: Copy up lower inode attrs in getattr
      eCryptfs: Unlock page in write_begin error path

Vasanthakumar Thiagarajan (1):
      ath9k: Fix bug in delimiter padding computation

Vasiliy Kulikov (4):
      platform: x86: acer-wmi: world-writable sysfs threeg file
      platform: x86: asus_acpi: world-writable procfs files
      platform: x86: tc1100-wmi: world-writable sysfs wireless and jogdial files
      net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules

Venkatesh Pallipadi (9):
      sched: Increment cache_nice_tries only on periodic lb
      sched: Fix softirq time accounting
      sched: Consolidate account_system_vtime extern declaration
      sched: Add a PF flag for ksoftirqd identification
      sched: Add IRQ_TIME_ACCOUNTING, finer accounting of irq time
      x86: Add IRQ_TIME_ACCOUNTING
      sched: Do not account irq time to current task
      sched: Remove irq time from available CPU power
      sched: Call tick_check_idle before __irq_enter

Vitaliy Kulikov (1):
      ALSA: hda - fix digital mic selection in mixer on 92HD8X codecs

Vivien Didelot (1):
      hwmon: (sht15) Fix integer overflow in humidity calculation

[Dstephen hemminger (1):
      ip6ip6-autoload-ip6-tunnel

dann frazier (1):
      ocfs2_connection_find() returns pointer to bad structure

roel (1):
      nfsd: wrong index used in inner loop

stable-bot for Steven Rostedt (1):
      sched: Give CPU bound RT tasks preference

wangyanqing (1):
      USB: serial: ch341: add new id

 Documentation/i2c/instantiating-devices    |    2 +-
 Documentation/kernel-parameters.txt        |    4 +
 Documentation/power/interface.txt          |    2 +-
 Makefile                                   |    2 +-
 arch/arm/kernel/signal.c                   |    4 +-
 arch/ia64/include/asm/system.h             |    4 -
 arch/mips/alchemy/mtx-1/platform.c         |    9 ++
 arch/parisc/kernel/firmware.c              |   13 +---
 arch/parisc/kernel/irq.c                   |    2 +-
 arch/powerpc/include/asm/reg.h             |    1 +
 arch/powerpc/include/asm/system.h          |    4 -
 arch/powerpc/kernel/cpu_setup_6xx.S        |   40 ++++----
 arch/powerpc/kernel/machine_kexec_64.c     |   26 +++++-
 arch/powerpc/kernel/perf_event.c           |   24 +++++-
 arch/powerpc/sysdev/fsl_rio.c              |    1 -
 arch/s390/include/asm/processor.h          |    5 -
 arch/s390/include/asm/system.h             |    1 -
 arch/s390/kernel/traps.c                   |   37 --------
 arch/x86/Kconfig                           |   11 ++
 arch/x86/include/asm/acpi.h                |    1 +
 arch/x86/include/asm/kvm_host.h            |   26 +-----
 arch/x86/include/asm/mmu_context.h         |    5 +-
 arch/x86/include/asm/pgtable-3level.h      |   11 +--
 arch/x86/include/asm/pvclock.h             |    1 +
 arch/x86/include/asm/smpboot_hooks.h       |    2 +-
 arch/x86/kernel/acpi/boot.c                |   14 ++-
 arch/x86/kernel/cpu/mtrr/main.c            |   10 ++-
 arch/x86/kernel/e820.c                     |   10 ++-
 arch/x86/kernel/early-quirks.c             |   21 +++--
 arch/x86/kernel/entry_64.S                 |    2 +-
 arch/x86/kernel/pvclock.c                  |    5 +
 arch/x86/kernel/tsc.c                      |    8 ++
 arch/x86/kvm/i8259.c                       |    2 +
 arch/x86/kvm/svm.c                         |   15 ++-
 arch/x86/kvm/vmx.c                         |   35 +++----
 arch/x86/mm/fault.c                        |    7 ++
 arch/x86/mm/pgtable.c                      |    3 +-
 arch/x86/xen/mmu.c                         |   13 ++-
 arch/x86/xen/time.c                        |    2 +
 drivers/ata/ahci.c                         |    5 +
 drivers/ata/libata-core.c                  |   24 +++--
 drivers/ata/pata_mpc52xx.c                 |    2 +-
 drivers/block/cciss.h                      |    1 +
 drivers/char/tpm/tpm.c                     |   28 +++++-
 drivers/char/tpm/tpm.h                     |    2 +
 drivers/char/tpm/tpm_tis.c                 |    4 +-
 drivers/firmware/dcdbas.c                  |    4 +-
 drivers/gpu/drm/Kconfig                    |    3 +
 drivers/gpu/drm/drm_irq.c                  |    3 +-
 drivers/gpu/drm/i915/intel_lvds.c          |    8 ++
 drivers/gpu/drm/radeon/radeon_atombios.c   |   16 +++-
 drivers/gpu/drm/radeon/radeon_display.c    |    4 +
 drivers/hwmon/f71882fg.c                   |    2 +-
 drivers/hwmon/sht15.c                      |    4 +-
 drivers/hwmon/via686a.c                    |   14 ++-
 drivers/hwmon/w83627ehf.c                  |   59 +++++++++++-
 drivers/i2c/i2c-core.c                     |   14 +++-
 drivers/infiniband/core/cm.c               |    1 +
 drivers/infiniband/core/cma.c              |   15 +++
 drivers/input/mouse/bcm5974.c              |   40 ++++++++
 drivers/input/xen-kbdfront.c               |   45 +++++----
 drivers/isdn/hisax/config.c                |   18 +++-
 drivers/isdn/hisax/hisax.h                 |    1 +
 drivers/md/dm-mpath.c                      |   12 ---
 drivers/md/dm.c                            |    5 +-
 drivers/md/md.c                            |   30 ++++++-
 drivers/md/md.h                            |    2 +
 drivers/media/dvb/ttpci/av7110_ca.c        |    2 +-
 drivers/media/radio/radio-aimslab.c        |   24 ++----
 drivers/media/video/em28xx/em28xx-cards.c  |    4 +-
 drivers/media/video/uvc/uvc_video.c        |   14 ++-
 drivers/message/fusion/mptctl.c            |    8 ++
 drivers/message/fusion/mptscsih.c          |    7 +-
 drivers/mfd/ucb1x00-ts.c                   |   12 ++-
 drivers/mmc/core/sdio.c                    |    8 ++
 drivers/mtd/nand/omap2.c                   |    2 +-
 drivers/mtd/onenand/generic.c              |    2 +-
 drivers/mtd/onenand/omap2.c                |    2 +-
 drivers/net/bonding/bond_ipv6.c            |    9 ++-
 drivers/net/e1000e/netdev.c                |    3 +-
 drivers/net/ixgbe/ixgbe_main.c             |    4 +
 drivers/net/myri10ge/myri10ge.c            |    1 +
 drivers/net/r8169.c                        |   12 ++-
 drivers/net/wireless/ath/ath9k/ath9k.h     |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c        |    4 +-
 drivers/net/wireless/hostap/hostap_cs.c    |   15 +--
 drivers/net/wireless/iwlwifi/iwl-3945.c    |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   15 ++-
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    6 +
 drivers/net/wireless/p54/p54pci.c          |   14 ++-
 drivers/net/wireless/p54/p54usb.c          |    1 +
 drivers/net/wireless/p54/txrx.c            |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c      |    1 +
 drivers/pci/hotplug/acpiphp_glue.c         |    1 +
 drivers/pci/pci-stub.c                     |    3 +
 drivers/pci/pci-sysfs.c                    |    2 +-
 drivers/pci/quirks.c                       |   63 +++++++++++--
 drivers/platform/x86/Kconfig               |    1 +
 drivers/platform/x86/acer-wmi.c            |    4 +-
 drivers/platform/x86/asus_acpi.c           |    8 +--
 drivers/platform/x86/tc1100-wmi.c          |    2 +-
 drivers/platform/x86/thinkpad_acpi.c       |   78 ++++++++++++----
 drivers/power/ds2760_battery.c             |    2 +-
 drivers/rtc/rtc-cmos.c                     |   16 ++--
 drivers/s390/char/keyboard.c               |    3 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |    2 +
 drivers/scsi/libsas/sas_scsi_host.c        |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   19 +++-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c       |    3 -
 drivers/scsi/sd.c                          |    9 ++-
 drivers/scsi/ses.c                         |    4 +-
 drivers/serial/8250.c                      |    3 +-
 drivers/staging/comedi/drivers/jr3_pci.c   |    7 ++
 drivers/staging/comedi/drivers/ni_labpc.c  |    3 +-
 drivers/staging/hv/blkvsc_drv.c            |    1 +
 drivers/staging/hv/netvsc_drv.c            |    1 +
 drivers/staging/usbip/vhci.h               |    6 +-
 drivers/staging/usbip/vhci_hcd.c           |   68 +++++++++-----
 drivers/staging/usbip/vhci_rx.c            |   15 ++-
 drivers/usb/class/cdc-acm.c                |    8 ++-
 drivers/usb/core/hub.c                     |   26 +++++
 drivers/usb/core/quirks.c                  |    8 ++
 drivers/usb/gadget/printer.c               |   14 ++--
 drivers/usb/host/ehci-hcd.c                |   27 ++++--
 drivers/usb/host/ehci-pci.c                |   39 ++++++++
 drivers/usb/host/ehci-q.c                  |   12 ---
 drivers/usb/host/ehci-sched.c              |   79 ++++++++++++++++
 drivers/usb/host/ehci.h                    |    1 +
 drivers/usb/host/isp1760-hcd.c             |   22 +++-
 drivers/usb/host/isp1760-hcd.h             |    1 +
 drivers/usb/host/xhci-ring.c               |   79 ++++++++++++----
 drivers/usb/host/xhci.h                    |    9 ++
 drivers/usb/misc/iowarrior.c               |    2 +-
 drivers/usb/misc/uss720.c                  |   11 +--
 drivers/usb/musb/omap2430.c                |    1 +
 drivers/usb/serial/ch341.c                 |   11 ++
 drivers/usb/serial/cp210x.c                |   14 +---
 drivers/usb/serial/digi_acceleport.c       |   10 --
 drivers/usb/serial/ftdi_sio.c              |   39 ++++++++-
 drivers/usb/serial/ftdi_sio_ids.h          |   32 ++++++-
 drivers/usb/serial/generic.c               |   20 ++++
 drivers/usb/serial/io_edgeport.c           |    4 +-
 drivers/usb/serial/keyspan_pda.c           |   17 ----
 drivers/usb/serial/kobil_sct.c             |    2 +-
 drivers/usb/serial/option.c                |   23 ++++-
 drivers/usb/serial/pl2303.c                |   12 +++
 drivers/usb/serial/pl2303.h                |    1 +
 drivers/usb/serial/sierra.c                |    4 +-
 drivers/usb/serial/spcp8x5.c               |    5 +-
 drivers/usb/serial/ti_usb_3410_5052.c      |    2 +-
 drivers/usb/serial/visor.c                 |   12 +++
 drivers/usb/storage/unusual_cypress.h      |    5 +
 drivers/usb/storage/unusual_devs.h         |   32 +++++++
 drivers/video/console/tileblit.c           |    2 +-
 drivers/virtio/virtio_pci.c                |   20 +----
 fs/aio.c                                   |    4 +-
 fs/cifs/cifsproto.h                        |    2 +-
 fs/cifs/cifssmb.c                          |    4 +-
 fs/cifs/file.c                             |   21 ++--
 fs/dcache.c                                |    3 +
 fs/ecryptfs/inode.c                        |    2 +
 fs/ecryptfs/keystore.c                     |    1 +
 fs/ecryptfs/mmap.c                         |    5 +
 fs/eventpoll.c                             |   95 +++++++++++++++++++
 fs/ext2/namei.c                            |    9 +--
 fs/ext3/namei.c                            |    2 +-
 fs/ext3/super.c                            |    7 ++
 fs/file_table.c                            |    2 +-
 fs/fuse/file.c                             |   52 +++++++++--
 fs/fuse/fuse_i.h                           |    6 +-
 fs/nfs/direct.c                            |   34 ++++---
 fs/nfs/file.c                              |    2 +-
 fs/nfsd/nfs4proc.c                         |    4 +-
 fs/nfsd/nfs4xdr.c                          |   11 +--
 fs/nfsd/vfs.c                              |    2 +-
 fs/ocfs2/refcounttree.c                    |    7 +-
 fs/ocfs2/stack_user.c                      |    2 +-
 fs/partitions/ldm.c                        |    5 +
 fs/partitions/mac.c                        |   17 ++--
 fs/proc/array.c                            |    7 +-
 fs/proc/task_mmu.c                         |    4 +-
 include/drm/drmP.h                         |    2 +-
 include/drm/drm_pciids.h                   |    1 -
 include/keys/rxrpc-type.h                  |    1 -
 include/linux/ftrace.h                     |    2 +
 include/linux/hardirq.h                    |    9 ++-
 include/linux/ieee80211.h                  |    2 +-
 include/linux/klist.h                      |    2 +-
 include/linux/netdevice.h                  |    4 +
 include/linux/sched.h                      |   25 ++++-
 include/linux/usb/serial.h                 |    3 +
 include/scsi/scsi_device.h                 |    2 +-
 init/calibrate.c                           |    6 +-
 kernel/cpuset.c                            |    7 +-
 kernel/cred.c                              |   16 ++-
 kernel/irq/manage.c                        |    2 +-
 kernel/perf_event.c                        |   16 ++-
 kernel/power/main.c                        |    1 +
 kernel/power/power.h                       |    9 ++-
 kernel/power/snapshot.c                    |   20 +++--
 kernel/ptrace.c                            |    2 +-
 kernel/sched.c                             |  129 +++++++++++++++++++++++++--
 kernel/sched_fair.c                        |  137 ++++++++++++++++++++++------
 kernel/sched_features.h                    |    5 +
 kernel/sched_rt.c                          |   34 ++++---
 kernel/signal.c                            |   16 +++-
 kernel/smp.c                               |   67 +++++++++++++-
 kernel/softirq.c                           |   64 +++++++++----
 kernel/time/tick-broadcast.c               |   10 ++
 kernel/time/tick-common.c                  |    6 +-
 kernel/time/tick-internal.h                |    3 +
 kernel/trace/ftrace.c                      |   52 +++++++++--
 kernel/user.c                              |    1 +
 mm/mremap.c                                |    4 +-
 mm/shmem.c                                 |    1 +
 mm/slab.c                                  |    8 +-
 net/core/dev.c                             |   13 ++-
 net/core/rtnetlink.c                       |    3 +
 net/dccp/input.c                           |    7 +-
 net/ipv4/devinet.c                         |   30 ++++--
 net/ipv4/ip_gre.c                          |    1 +
 net/ipv4/ipip.c                            |    1 +
 net/ipv4/netfilter/arpt_mangle.c           |    6 +-
 net/ipv6/ip6_tunnel.c                      |    1 +
 net/ipv6/sit.c                             |    2 +-
 net/mac80211/sta_info.c                    |    1 +
 net/netfilter/nf_log.c                     |    4 +
 net/netlink/af_netlink.c                   |   19 +++-
 net/sched/cls_cgroup.c                     |    2 +-
 net/sctp/auth.c                            |    8 +-
 net/sunrpc/sched.c                         |   14 +--
 net/sunrpc/xprtsock.c                      |    2 +
 net/wireless/chan.c                        |    2 +
 net/x25/x25_link.c                         |    5 +-
 security/selinux/hooks.c                   |   11 ++-
 security/selinux/nlmsgtab.c                |    2 +
 sound/core/hrtimer.c                       |    5 +-
 sound/core/init.c                          |    4 +
 sound/oss/opl3.c                           |   15 +++-
 sound/pci/au88x0/au88x0_pcm.c              |   24 ++++-
 sound/pci/ctxfi/ctatc.c                    |    2 +-
 sound/pci/ctxfi/ctdaio.c                   |    2 +
 sound/pci/ctxfi/ctmixer.c                  |   19 +---
 sound/pci/hda/hda_eld.c                    |    2 +-
 sound/pci/hda/hda_intel.c                  |    1 +
 sound/pci/hda/patch_conexant.c             |    8 ++-
 sound/pci/hda/patch_realtek.c              |    2 +-
 sound/pci/hda/patch_sigmatel.c             |   11 ++-
 sound/soc/blackfin/bf5xx-ac97.c            |    4 +-
 sound/soc/codecs/wm8990.c                  |   10 +-
 sound/usb/caiaq/audio.c                    |    2 +-
 sound/usb/caiaq/midi.c                     |    2 +-
 sound/usb/usx2y/us122l.c                   |   41 ++++----
 tools/perf/util/session.c                  |    1 +
 254 files changed, 2282 insertions(+), 845 deletions(-)
-- 
ak@linux.intel.com -- Speaking for myself only.
