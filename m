Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab0D3RCN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:02:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757825Ab0D3RBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:01:55 -0400
Date: Thu, 29 Apr 2010 20:18:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.34-rc6
Message-ID: <alpine.LFD.2.00.1004292014090.5478@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hmm.. Not much exciting here. A bit more noise than I'd like (silly 
powerpc defconfig updates is like a quarter of the diff, with a couple of 
new drivers being much of the rest).

But there are a number of regression fixes here too, and hopefully we're 
getting closer to a final 34. 

			Linus

---
Aaro Koskinen (2):
      omap: fix clocksource_32k to start from zero
      omap: delete unused bootloader tag variables

Abraham Arce (2):
      KS8851: NULL pointer dereference if list is empty
      OMAP4: Clocks: Change SPI Instance Names

Adam Jackson (2):
      drm/i915: Attempt to fix watermark setup on 85x (v2)
      drm/i915: Fix 82854 PCI ID, and treat it like other 85X

Ajay Kumar Gupta (1):
      USB: ehci: omap: fix kernel panic with rmmod

Al Viro (1):
      nfs d_revalidate() is too trigger-happy with d_drop()

Alan Cox (1):
      e100: Fix the TX workqueue race

Alan Stern (3):
      USB: fix remote wakeup settings during system sleep
      USB: EHCI: defer reclamation of siTDs
      USB: put claimed interfaces in the "suspended" state

Albin Tonnerre (1):
      lib: fix the use of LZO to decompress initramfs images

Alex Deucher (2):
      drm/radeon/kms/evergreen: fix LUT setup
      drm/radeon/kms/evergreen: No EnableYUV table

Alex Manoussakis (1):
      USB: ti_usb_3410_5052: adding multitech dialup fax/modem devices

Alexander Duyck (1):
      PCI aerdrv: use correct bit defines and add 2ms delay to aer_root_reset

Alexander Kurz (2):
      net: 3c574_cs fix stats.tx_bytes counter
      pcmcia: fix matching rules for pseudo-multi-function cards

Alexander Kuznetsov (1):
      8139too: Fix a typo in the function name.

Amerigo Wang (1):
      [CPUFREQ] fix a lockdep warning

Amit Kucheria (1):
      w1: fix omap 1-wire driver compilation

Andre Detsch (2):
      tg3: Fix INTx fallback when MSI fails
      cxgb3: Wait longer for control packets on initialization

Andre Przywara (1):
      KVM: allow bit 10 to be cleared in MSR_IA32_MC4_CTL

Andrea Arcangeli (1):
      memcg: fix prepare migration

Andreas Hartmann (1):
      drivers/usb/net/kaweth.c: add device "Allied Telesyn AT-USB10 USB Ethernet Adapter"

Andreas Schwab (1):
      kernel/sys.c: fix compat uname machine

Andy Fleming (1):
      gianfar: Wait for both RX and TX to stop

Anil Veerabhadrappa (1):
      [SCSI] bnx2i: Bug fixes related to MTU change issue when there are active iscsi sessions

Anton Blanchard (2):
      fs/block_dev.c: fix performance regression in O_DIRECT|O_SYNC writes to block devices
      powerpc/numa: Add form 1 NUMA affinity

Anton Vorontsov (4):
      powerpc/85xx/86xx: Fix build w/ CONFIG_PCI=n
      fsl_pq_mdio: Fix kernel oops during OF address translation
      gianfar: Fix potential oops during OF address translation
      watchdog: booke_wdt: fix build - unconstify watchdog_info

Arnaud Patard (1):
      i2c-imx: fix error handling

Arnd Bergmann (1):
      pktcdvd: improve BKL and compat_ioctl.c usage

Avi Kivity (2):
      KVM: Don't spam kernel log when injecting exceptions due to bad cr writes
      KVM: VMX: Save/restore rflags.vm correctly in real mode

Axel Lin (1):
      mc13783-regulator: fix a memory leak in mc13783_regulator_remove

Balbir Singh (1):
      virtio: Fix GFP flags passed from the virtio balloon driver

Becky Bruce (1):
      powerpc/fsl_booke: Correct test for MMU_FTR_BIG_PHYS

Ben Hutchings (3):
      sfc: Wait at most 10ms for the MC to finish reading out MAC statistics
      sfc: Always close net device at the end of a disabling reset
      sfc: Change falcon_probe_board() to fail for unsupported boards

Benjamin Herrenschmidt (1):
      powerpc/pseries: Flush lazy kernel mappings after unplug operations

Bill Pemberton (1):
      jfs: fix diAllocExt error in resizing filesystem

Bjorn Helgaas (5):
      x86/PCI: ignore Consumer/Producer bit in ACPI window descriptions
      PCI: revert broken device warning
      x86/PCI: parse additional host bridge window resource types
      x86/PCI: never allocate PCI MMIO resources below BIOS_END
      x86/PCI: compute Address Space length rather than using _LEN

Boaz Harrosh (1):
      exofs: Fix "add bdi backing to mount session" fall out

Bruce Allan (1):
      e1000e: enable/disable ASPM L0s and L1 and ERT according to hardware errata

Changli Gao (1):
      flex_array: fix the panic when calling flex_array_alloc() without __GFP_ZERO

Christof Schmitt (2):
      [SCSI] zfcp: Update MAINTAINERS entry
      [SCSI] zfcp: Fix tracing of requests with error status

Christoph Egger (1):
      Remove redundant check for CONFIG_MMU

Christoph Hellwig (1):
      x86: correctly wire up the newuname system call

Chuck Lever (1):
      NFS: rsize and wsize settings ignored on v4 mounts

Clemens Ladisch (4):
      firewire: core: fix retries calculation in iso manage_channel()
      firewire: core: fw_iso_resource_manage: return -EBUSY when out of resources
      firewire: ohci: prevent aliasing of locally handled register addresses
      firewire: ohci: wait for local CSR lock access to finish

Colin Tuckley (1):
      ARM: 5957/1: ARM: RealView SD/MMC Card detection and write-protect using GPIOLIB

Corentin Chary (1):
      eeepc-laptop: add missing sparse_keymap_free

Curt Wohlgemuth (2):
      ext4: Fix possible lost inode write in no journal mode
      ext4: Fix buffer head leaks after calls to ext4_get_inode_loc()

Dan Carpenter (14):
      [SCSI] dpt_i2o: several use after free issues
      [SCSI] wd7000: fix reset handler typo spin_unlock_irq() => spin_lock_irq()
      asus: don't modify bluetooth/wlan on boot
      pcmcia: fix error handling in cm4000_cs.c
      i2c-stu300: off by one issue
      security: testing the wrong variable in create_by_name()
      drbd: fix memory leak
      nfs: testing for null instead of ERR_PTR()
      rtnetlink: potential ERR_PTR dereference
      rdma: potential ERR_PTR dereference
      ksm: check for ERR_PTR from follow_page()
      ipheth: potential null dereferences on error path
      bluetooth: handle l2cap_create_connless_pdu() errors
      nfs: fix some issues in nfs41_proc_reclaim_complete()

Dan Williams (1):
      USB: qcaux: add LG Rumor and Sanyo Katana LX device IDs

Daniel Mack (1):
      jfs_dmap.[ch]: trivial typo fix: s/heigth/height/g

Daniel T Chen (4):
      ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio XPS 1645
      ALSA: hda: Use ALC880_F1734 quirk for Fujitsu Siemens AMILO Xi 1526
      ALSA: hda: Use LPIB quirk for DG965OT board version AAD63733-203
      ALSA: hda: Use STAC_DELL_M6_BOTH quirk for Dell Studio 1558

Daniel Vetter (1):
      drm/i915: fix tiling limits for i915 class hw v2

Dave Airlie (1):
      drm/radeon/kms: don't print error for legal crtcs.

Dave Chinner (2):
      xfs: more swap extent fixes for dynamic fork offsets
      xfs: add a shrinker to background inode reclaim

David Howells (7):
      CRED: Fix double free in prepare_usermodehelper_creds() error handling
      net: Fix an RCU warning in dev_pick_tx()
      AFS: Don't pass error value to page_cache_release() in error handling
      CRED: Fix a race in creds_are_invalid() in credentials debugging
      keys: fix an RCU warning
      keys: don't need to use RCU in keyring_read() as semaphore is held
      keys: the request_key() syscall should link an existing key to the dest keyring

David Miller (1):
      drm/radeon: Fix sparc regression in r300_scratch()

David S. Miller (6):
      sparc64: Allocate sufficient stack space in ftrace stubs.
      sparc64: Run NMIs on the hardirq stack.
      sparc64: Fix PREEMPT_ACTIVE value.
      sparc64: Use correct pt_regs in decode_access_size() error paths.
      sparc64: Fix hardirq tracing in trap return path.
      Revert "tcp: bind() fix when many ports are bound"

David Vrabel (1):
      usb: wusb: don't overflow the Keep Alive IE buffer

Denis Turischev (2):
      watchdog: sbc_fitpc2_wdt: fixed I/O operations order
      watchdog: sbc_fitpc2_wdt: fixed "scheduling while atomic" bug.

Diego Giagio (1):
      drivers/net/usb: Add new driver ipheth

Dinh Nguyen (1):
      usb: Increase timeout value for device reset

Dmitry Monakhov (1):
      jfs: add jfs specific ->setattr call

Dmitry Torokhov (1):
      VMware Balloon driver

Dominik Brodowski (7):
      [CPUFREQ] use max load in conservative governor
      pcmcia: use previously assigned IRQ for all card functions
      pcmcia: fix io_probe due to parent (PCI) resources
      pcmcia: re-start on MFC override
      pcmcia: fix ioport size calculation in rsrc_nonstatic
      pcmcia: avoid late calls to pccard_validate_cis
      pcmcia: pcmcia_dev_present bugfix

Elina Pasheva (1):
      net/usb: add sierra_net.c driver

Enric Balletbo i Serra (1):
      omap3: Fix EHCI port for IGEP v2 board

Eric Dumazet (3):
      bridge: add a missing ntohs()
      tcp: bind() fix when many ports are bound
      ipv6: Fix inet6_csk_bind_conflict()

FUJITA Tomonori (1):
      [SCSI] ibmvscsi: fix DMA API misuse

Felipe Balbi (1):
      arm: omap1: remove dead code from timer32k.c

Francisco Alecrim (1):
      n8x0_defconfig: remove CONFIG_NILFS2_FS override

Frederic Weisbecker (2):
      perf: Fix unsafe frame rewinding with hot regs fetching
      sparc: Fix forgotten kmemleak headers inclusion

Geoff Levand (2):
      powerpc/ps3: Update platform maintainer
      powerpc/ps3: Update ps3_defconfig

Gleb Natapov (1):
      KVM: take srcu lock before call to complete_pio()

Greg Ungerer (1):
      m68knommu: remove a duplicate vector setting line for 68360

Guenter Roeck (1):
      Watchdog: sb_wdog.c: Fix sibyte watchdog initialization

H. Peter Anvin (2):
      x86-64: Clear a 64-bit FS/GS base on fork if selector is nonzero
      x86: Disable large pages on CPUs with Atom erratum AAE44

Hans J. Koch (1):
      can: Fix possible NULL pointer dereference in ems_usb.c

Hans Verkuil (1):
      lib/vsprintf.c: add missing EXPORT_SYMBOL(simple_strtoll)

Hans de Goede (2):
      ALSA: snd-meastro3: Add amp_gpio quirk for Compaq EVO N600C
      ALSA: snd-meastro3: Ignore spurious HV interrupts during suspend / resume

Haojian Zhuang (1):
      regulator: fix enabling regulator issue on max8925

Harrison Metzger (1):
      USB: fixed bug in usbsevseg using USB autosuspend incorrectly

Hendrik Brueckner (1):
      [S390] vdso: use ntp adjusted clock multiplier

Herbert Xu (2):
      ipv6: Fix tcp_v6_send_response transport header setting.
      crypto: authenc - Add EINPROGRESS check

Hiroshi Shimamoto (1):
      cxgb3: fix linkup issue

Ian Dall (1):
      w1: w1 temp: fix negative termperature calculation

Ingo Molnar (1):
      eeepc-wmi: Build fix

Jacob Pan (1):
      x86, mrst: Conditionally register cpu hotplug notifier for apbt

Jan Kara (1):
      quota: Convert __DQUOT_PARANOIA symbol to standard config option

Jan Kiszka (2):
      uml: Fix build breakage after slab.h changes
      KVM: x86: Fix TSS size check for 16-bit tasks

Janusz Krzysztofik (1):
      omap: gpio: fix incorrect matching of IRQ_TYPE_EDGE_BOTH

Jarkko Nikula (2):
      omap: rx51_defconfig: Remove duplicate phonet
      omap: rx51_defconfig: Remove CONFIG_SYSFS_DEPRECATED*=y options

Jean Delvare (1):
      regulator: Let drivers know when they use the stub API

Jeff Garzik (1):
      libata: ensure NCQ error result taskfile is fully initialized     before returning it via qc->result_tf.

Jeff Mahoney (2):
      reiserfs: fix permissions on .reiserfs_priv
      reiserfs: fix corruption during shrinking of xattrs

Jens Axboe (13):
      bdi: add helper function for doing init and register of a bdi for a file system
      9p: add bdi backing to mount session
      afs: add bdi backing to mount session.
      cifs: add bdi backing to mount session
      coda: add bdi backing to mount session
      ecryptfs: add bdi backing to mount session
      exofs: add bdi backing to mount session
      ncpfs: add bdi backing to mount session
      smbfs: add bdi backing to mount session
      btrfs: convert to using bdi_setup_and_register()
      mtd: ensure that bdi entries are properly initialized and registered
      coda: move backing-dev.h kernel include inside __KERNEL__
      fs: fs/super.c needs to include backing-dev.h for !CONFIG_BLOCK

Jerome Marchand (1):
      procfs: fix tid fdinfo

Jesse Barnes (5):
      drm: delay vblank cleanup until after driver unload
      drm/i915: cleanup FBC buffers at unload time
      drm/i915: use PIPE_CONTROL instruction on Ironlake and Sandy Bridge
      drm/i915: fix non-Ironlake 965 class crashes
      drm: make sure vblank interrupts are disabled at DPMS time

Jiri Kosina (1):
      sysfs: use sysfs_attr_init in ASUS atk0110 driver

Jiri Olsa (1):
      net: ipv6 bind to device issue

Jiri Slaby (3):
      [SCSI] be2iscsi: fix lock imbalance
      [SCSI] lpfc: fix lock imbalances
      [SCSI] qla2xxx: fix lock imbalance

Joern Engel (7):
      [LogFS] Remove unused method
      [LogFS] Prevent memory corruption on large deletes
      [LogFS] Plug 8 byte information leak
      [LogFS] Move assertion
      [LogFS] Prevent mempool_destroy NULL pointer dereference
      [LogFS] Set s_bdi
      [LogFS] Split large truncated into smaller chunks

Johannes Berg (2):
      iwlwifi: fix scan races
      mac80211: remove bogus TX agg state assignment

Josef Bacik (1):
      Cleanup generic block based fiemap

Julia Lawall (1):
      drivers/pcmcia: Add missing local_irq_restore

Jun Sun (1):
      uclinux: error message when FLAT reloc symbol is invalid, v2

Jörn Engel (3):
      Fix JFFS2 sync silent failure
      Catch filesystems lacking s_bdi
      Move mtd_bdi_*mappable to mtdcore.c

KAMEZAWA Hiroyuki (1):
      cgroups: fix procs documentation

Ken Kawasaki (1):
      smc91c92_cs: spin_unlock_irqrestore before calling smc_interrupt()

Kevin Wells (2):
      i2c-pnx: Limit maximum divider to 1023
      i2c-pnx: Add stop conditions for end of transfer

Kim Phillips (4):
      powerpc/83xx: add RTC drivers in 83xx defconfig
      powerpc/83xx: enable EPOLL syscall in defconfig
      powerpc/83xx: configure SIL SATA driver in 83xx-wide defconfig
      powerpc/mpc8xxx defconfigs - turn off SYSFS_DEPRECATED

Kristoffer Ericson (1):
      pata_pcmcia/ide-cs: add IDs for transcend and kingston cards

Kumar Gala (2):
      powerpc: 2.6.34 update of defconfigs for embedded 6xx/7xxx, 8xx, 8xxx
      powerpc/fsl-booke: Fix CONFIG_RELOCATABLE support on FSL Book-E ppc32

Lai Jiangshan (1):
      KVM: Add missing srcu_read_lock() for kvm_mmu_notifier_release()

Leo Chen (1):
      ARM: 6023/1: update bcmring_defconfig to latest version and fix build error

Linus Torvalds (1):
      Linux 2.6.34-rc6

Manuel Jander (1):
      USB: pl2303: add AdLink ND-6530 USB IDs

Marc Zyngier (1):
      gpio: fix pca953x set_type 'scheduling while atomic' bug

Matthew Garrett (1):
      PCI: Ensure we re-enable devices on resume

Maxim Kuvyrkov (1):
      Fix m68k-uclinux's rt_sigreturn trampoline

Mel Gorman (1):
      hugetlb: fix infinite loop in get_futex_key() when backed by huge pages

Michael Chan (3):
      bnx2: Fix lost MSI-X problem on 5709 NICs.
      bnx2: Prevent "scheduling while atomic" warning with cnic, bonding and vlan.
      bnx2: Update version to 2.0.9.

Michael Holzheu (1):
      [S390] zcore: Fix reipl device detection

Mika Westerberg (1):
      i2c-omap: fix OOPS in omap_i2c_unidle() during probe

Mike Christie (1):
      [SCSI] iscsi_tcp: fix relogin/shutdown hang

Neil Brown (1):
      nfsd4: bug in read_buf

NeilBrown (2):
      md/raid5: allow for more than 2^31 chunks.
      md/raid5: fix previous patch.

Nicolas Dichtel (1):
      xfrm6: ensure to use the same dev when building a bundle

Oleg Nesterov (1):
      rmap: anon_vma_prepare() can leak anon_vma_chain

Paulius Zaleckas (1):
      mtd: fix Orion NAND driver compilation with ARM OABI

Peter Huewe (1):
      arch/avr32: fix build failure caused by wrong prototype

Peter Waskiewicz (1):
      ixgbe: Power down PHY during driver resets

Philip Nye (1):
      m68knommu: correct the CC flags for Coldfire M5272 targets

Philipp Reisner (1):
      drbd: Terminate a connection early if sending the protocol fails

Philippe De Muyter (2):
      m68knommu: fix coldfire tcdrain
      m68knommu: allow 4 coldfire serial ports

Phillip Lougher (5):
      squashfs: fix locking bug in zlib wrapper
      initramfs: handle unrecognised decompressor when unpacking
      squashfs: fix warn_on when root inode is corrupted
      squashfs: add missing buffer free
      squashfs: fix potential buffer over-run on 4K block file systems

Rajendra Nayak (1):
      OMAP4: prcm: Use logical OR instead of bitwise OR

Randy Dunlap (3):
      staging: fix dt3155 build
      scsi: fix operator precedence warning
      Documentation/HOWTO: update git home URL

Ranjith Lohithakshan (1):
      OMAP3: clock: fix enable bit used for dpll4_m4x2 clock

Reinette Chatre (1):
      mac80211: pass HT changes to driver when off channel

Richard Kennedy (1):
      block: ensure jiffies wrap is handled correctly in blk_rq_timed_out_timer

Richard Woodruff (1):
      omap4: Fix build break when used with gcc-4.4.1 (2009-q3)

Rik van Riel (1):
      mmap: check ->vm_ops before dereferencing

Roman Fietze (1):
      libata: fix docs, RE port and device of libata.force ID separated by point

Russell King (1):
      ARM: fix build error in arch/arm/kernel/process.c

Santosh Shilimkar (2):
      OMAP4: Fix for CONTROL register Base
      omap4: Fix McBSP4 base address

Sebastian Ott (3):
      [S390] cio: allow enable_facility from outside init functions
      [S390] add hook to reenable mss after hibernation
      [S390] cio: use exception-save stsch

Sergei Shtylyov (1):
      USB: OHCI: DA8xx/OMAP-L1x: fix up macro rename

Sergio Aguirre (7):
      OMAP3: serial: Check for zero-based physical addr
      OMAP3: serial: Use dev_* macros instead of printk
      omap2/3/4: serial: Remove condition for getting uart4_phys
      omap3: zoom2/3 / 3630sdp: Don't init always all uarts
      omap3: 3630sdp: Explicitly enable all UARTs
      omap3: zoom 2/3: Change debugboard serial port id
      omap3: zoom2/3: Register only 1 8250 port

Shan Wei (1):
      ipv6: allow to send packet after receiving ICMPv6 Too Big message with MTU field less than IPV6_MIN_MTU

Shanyu Zhao (1):
      iwlwifi: correct 6000 EEPROM regulatory address

Sridhar Samudrala (1):
      KVM: Increase NR_IOBUS_DEVS limit to 200

Stefan Haberland (1):
      [S390] dasd: fix endless loop in erp

Stefan Richter (2):
      firewire: cdev: fix cut+paste mistake in disclaimer
      Documentation: -stable rules: upstream commit ID requirement reworded

Stefan Schmidt (1):
      ieee802154: Fix oops during ieee802154_sock_ioctl

Takashi Iwai (2):
      ALSA: hda - Fix resume from StR of HP 2510p with docking-station
      lis3: add support for HP ProBook 432x/442x/452x/522x

Takuya Yoshikawa (2):
      KVM: SVM: Fix memory leaks that happen when svm_create_vcpu() fails
      KVM: fix the handling of dirty bitmaps to avoid overflows

Tejun Heo (1):
      libata: fix locking around blk_abort_request()

Thara Gopinath (2):
      OMAP: HWMOD: Adding clockdomain check
      OMAP: HWMOD: Bug fixes in hwmod structure definitions

Theodore Ts'o (1):
      ext4: Issue the discard operation *before* releasing the blocks to be reused

Thomas Gerlach (1):
      drivers/video/efifb.c: support framebuffer for NVIDIA 9400M in MacBook Pro 5,1

Thomas Weber (8):
      omap: Devkit8000: Fix wrong usb port on Devkit8000
      omap: board-sdp-flash.c: Fix typos in debug output
      omap: Devkit8000: Fix typo in supplies
      omap: Devkit8000: Add missing package selection
      omap: Devkit8000: Fix typo in pin name
      omap: Devkit8000: Remove unnecessary include file
      omap: Devkit8000: Change position of init calls
      omap: Devkit8000: Remove unused pins

Timur Maximov (1):
      serial_cs: MD55x support (PCMCIA GPRS/EDGE modem) (kernel 2.6.33)

Tony Lindgren (2):
      omap2: Fix ARM processor check for 24xx
      omap: Fix n8x0 mmc_mmc_init compile warnings and typos

Torgny Johansson (1):
      cdc_ether: fix autosuspend for mbm devices

Tormod Volden (1):
      drm/radeon: 9800 SE has only one quadpipe

Trond Myklebust (4):
      SUNRPC: Fix a bug in rpcauth_prune_expired
      NFSv4: Don't attempt an atomic open if the file is a mountpoint
      NFS: Fix an unstable write data integrity race
      NFS: Ensure that nfs_wb_page() waits for Pg_writeback to clear

Valdis Kletnieks (1):
      dri-devel mailing list moved - update MAINTAINERS

Vlad Yasevich (3):
      sctp: fix potential reference of a freed pointer
      sctp: per_cpu variables should be in bh_disabled section
      sctp: Fix oops when sending queued ASCONF chunks

Wei Yongjun (2):
      sctp: avoid irq lock inversion while call sk->sk_data_ready()
      sctp: fix to calc the INIT/INIT-ACK chunk length correctly is set

William Lightning (1):
      USB: Add id for HP ev2210 a.k.a Sierra MC5725 miniPCI-e Cell Modem.

Wolfgang Ocker (1):
      powerpc/fsl-cpm: Configure clock correctly for SCC

Wufei (1):
      kgdb: don't needlessly skip PAGE_USER test for Fsl booke

Xiao Guangrong (1):
      KVM: MMU: fix kvm_mmu_zap_page() and its calling path

Xiaotian Feng (1):
      nfs: fix memory leak in nfs_get_sb with CONFIG_NFS_V4

YOSHIFUJI Hideaki / 吉藤英明 (1):
      bridge br_multicast: Ensure to initialize BR_INPUT_SKB_CB(skb)->mrouters_only.

Yegor Yefremov (1):
      ARM: 6030/1: KS8695: enable console

Yong Wang (4):
      eeepc-wmi: add an eeepc_wmi context structure
      eeepc-wmi: use a platform device as parent device of all sub-devices
      eeepc-wmi: add backlight support
      dell-wmi: Fix memory leak

Zhang Rui (1):
      drm/i915: set DIDL using the ACPI video output device _ADR method return.

andrew hendry (1):
      X25 fix dead unaccepted sockets

françois romieu (2):
      r8169: failure to enable mwi should not be fatal
      r8169: more broken register writes workaround

kishore kadiyala (1):
      OMAP4-HSMMC: FIX for MMC5 Controller IRQ Base

manjugk manjugk (1):
      omap: DMA: Init CDAC to zero

stanley.miao (4):
      omap: fix the compile error if CONFIG_MTD_NAND_OMAP2 is notenabled
      omap: remove one of the define of INT_34XX_BENCH_MPU_EMUL
      AM3517: initialize i2c subsystem after mux subsystem
      omap: fix a gpmc nand problem

viresh kumar (3):
      ARM: 6059/1: PL061 GPIO: Changing *_irq_chip_data with *_irq_data for real irqs.
      ARM: 6060/1: PL061 GPIO: Setting gpio val after changing direction to OUT.
      ARM: 6061/1: PL061 GPIO: Bug fix - setting gpio for HIGH_LEVEL interrupt is not working.

