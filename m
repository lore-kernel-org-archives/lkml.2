Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab1DLAke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 20:40:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49420 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756467Ab1DLAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 20:40:33 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Apr 2011 17:40:11 -0700
Message-ID: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com>
Subject: Linux 2.6.39-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been another almost spookily calm week. Usually this kind of
calmness happens much later in the -rc series (during -rc7 or -rc8,
say), but I'm not going to complain. I'm just still waiting for the
other shoe to drop.

And it is possible that this really ended up being a very calm release
cycle. We certainly didn't have any big revolutionary changes like the
name lookup stuff we had last cycle. So I'm quietly optimistic that no
shoe-drop will happen.

Anyway, not only has it been calm, it's been pretty normal. Two thirds
drivers is pretty normal, with the rest being fairly spread out all
over:

   3.5% Documentation/
   2.8% arch/arm/
  10.2% arch/
   2.0% drivers/media/video/
   3.3% drivers/media/
   2.6% drivers/net/wireless/
  10.3% drivers/net/
   5.5% drivers/scsi/
   8.4% drivers/staging/memrar/
  24.2% drivers/staging/
   3.5% drivers/video/
  62.0% drivers/
   2.0% fs/xfs/linux-2.6/
   4.3% fs/xfs/
   9.6% fs/
   2.2% include/linux/
   3.7% include/
   4.4% net/
   2.5% sound/

and the appended shortlog shows more details if you care. Nothing
earth-shattering.

Let's hope the release cycle continues like this. I _like_ it when
people really seem to follow the whole "big changes during the merge
window" rules.

Thanks guys,

                   Linus

---

Aaron Plattner (1):
      ALSA: hda - HDMI: Fix MCP7x audio infoframe checksums

Ajit Khaparde (1):
      be2net: Fix a potential crash during shutdown.

Alan Cox (1):
      staging: sep: remove last memrar remnants

Alexandre Courbot (5):
      sh: mach-ecovec24: support for main lcd backlight
      sh: mach-ap325rxa: move backlight control code
      fbdev: sh_mobile_lcdcfb: add blanking support
      fbdev: sh_mobile_lcdcfb: fix module lock acquisition
      serial: sh-sci: prevent setup of uninitialized serial console

Andre Przywara (2):
      KVM: fix XSAVE bit scanning
      KVM: move and fix substitue search for missing CPUID entries

Antonio Ospite (1):
      ASoC: zylonite: set .codec_dai_name in initializer

Arjan Mels (4):
      staging: usbip: fix shutdown problems.
      staging: usbip: bugfixes related to kthread conversion
      staging: usbip: bugfix add number of packets for isochronous frames
      staging: usbip: bugfix for isochronous packets and optimization

Artem Bityutskiy (10):
      UBIFS: do not read flash unnecessarily
      UBIFS: fix oops on error path in read_pnode
      UBIFS: fix assertion warnings
      UBIFS: do not select KALLSYMS_ALL
      UBIFS: unify error path dbg_debugfs_init_fs
      UBIFS: fix error path in dbg_debugfs_init_fs
      UBIFS: fix debugging failure in dbg_check_space_info
      UBI: check if we are in RO mode in the erase routine
      UBI: do not compare array with NULL
      UBI: do not select KALLSYMS_ALL

Ben Dooks (1):
      gpio/pca953x: fix error handling path in probe() call

Bryan Schumaker (2):
      NFS: Fix a signed vs. unsigned secinfo bug
      NFS: Change initial mount authflavor only when server returns
NFS4ERR_WRONGSEC

Chase Douglas (1):
      HID: hid-magicmouse: Increase evdev buffer size

Christian Lamparter (1):
      p54usb: IDs for two new devices

Christoph Hellwig (3):
      xfs: fix variable set but not used warnings
      xfs: fix xfs_debug warnings
      xfs: use proper interfaces for on-stack plugging

Curt Wohlgemuth (1):
      ext4: sync the directory inode in ext4_sync_parent()

Dan Carpenter (1):
      Staging: westbridge/astoria: unlock on error path

Dave Chinner (10):
      xfs: fix unreferenced var error in xfs_buf.c
      xfs: fix extent format buffer allocation size
      xfs: introduce a xfssyncd workqueue
      xfs: convert ENOSPC inode flushing to use new syncd workqueue
      xfs: introduce background inode reclaim work
      xfs: convert the xfsaild threads to a workqueue
      xfs: clean up code layout in xfs_trans_ail.c
      xfs: push the AIL from memory reclaim and periodic sync
      xfs: catch bad block numbers freeing extents.
      xfs: convert log tail checking to a warning

Dave Jones (1):
      staging: hv: fix reversed memset arguments in hv_mouse

David Henningsson (2):
      ALSA: HDA: Fix dock mic for Lenovo X220-tablet
      ALSA: HDA: Fix single internal mic on ALC275 (Sony Vaio VPCSB1C5E)

David Sterba (1):
      netfilter: h323: bug in parsing of ASN1 SEQOF field

Davidlohr Bueso (1):
      efifb: support AMD Radeon HD 6490

Enric Balletbo i Serra (2):
      smsc911x: fix mac_lock acquision before calling smsc911x_mac_read
      can: mcp251x: Allow pass IRQ flags through platform data.

Feng Tang (2):
      rtc, x86/mrst/vrtc: Fix boot crash in rtc_read_alarm()
      x86/mrst/vrtc: Fix boot crash in mrst_rtc_init()

Florian Tobias Schandinat (2):
      viafb: refresh rate bug collection
      viafb: initialize margins correct

Florian Westphal (4):
      netfilter: af_info: add network namespace parameter to route hook
      netfilter: af_info: add 'strict' parameter to limit lookup to .oif
      netfilter: xt_addrtype: replace rt6_lookup with nf_afinfo->route
      netfilter: xt_conntrack: fix inverted conntrack direction test

Gleb Natapov (1):
      KVM: Enable async page fault processing

Greg Kroah-Hartman (2):
      Staging: vt665?: prevent modules from being built into the kernel.
      staging: memrar: remove driver from tree

Guennadi Liakhovetski (1):
      ARM: arch-shmobile: only run HDMI init on respective boards

H. Peter Anvin (1):
      x86, hibernate: Initialize mmu_cr4_features during boot

Haiyang Zhang (1):
      staging: hv: Fix GARP not sent after Quick Migration

Hans Rosenfeld (1):
      x86-32, fpu: Fix FPU exception handling on non-SSE systems

Hans Schillstrom (1):
      IPVS: fix NULL ptr dereference in ip_vs_ctl.c ip_vs_genl_dump_daemons()

Helmut Schaa (1):
      mac80211: Fix duplicate frames on cooked monitor

Hong Xu (2):
      mtd: atmel_nand: fix support for CPUs that do not support DMA access
      mtd: atmel_nand: use CPU I/O when buffer is in vmalloc(ed) region

Ian Campbell (1):
      MAINTAINERS: add entry for Xen network backend

Ira W. Snyder (1):
      dt/fsldma: fix build warning caused by of_platform_device changes

J. Bruce Fields (2):
      nfsd: fix auth_domain reference leak on nlm operations
      nfsd4: fix oops on lock failure

Jan Glauber (1):
      [S390] oprofile s390: prevent stack corruption

Jan Kara (2):
      quota: Don't write quota info in dquot_commit()
      ext4: remove unnecessary [cm]time update of quota file

Javier M. Mellid (1):
      staging: sm7xx: fixed defines

Jingoo Han (1):
      video: s3c-fb: fix checkpatch errors and warning

Jiri Kosina (2):
      HID: add support for Skycable 0x3f07 wireless presenter
      HID: Add support for CH Pro Throttle

Johannes Berg (1):
      mac80211: fix comment regarding aggregation buf_size

John W. Linville (2):
      b43: allocate receive buffers big enough for max frame len + offset
      iwlwifi: accept EEPROM version 0x423 for iwl6000

Jozsef Kadlecsik (2):
      netfilter: ipset: list:set timeout variant fixes
      netfilter: ipset: references are protected by rwlock instead of mutex

Julia Lawall (1):
      drivers/video/bfin-lq035q1-fb.c: introduce missing kfree

Jussi Kivilinna (2):
      zd1211rw: remove URB_SHORT_NOT_OK flag in zd_usb_iowrite16v_async()
      zd1211rw: reset rx idle timer from tasklet

Kazuya Mio (1):
      ext4: Allow indirect-block file to grow the file size to max file size

Kuninori Morimoto (1):
      ARM: arch-shmobile: only run FSI init on respective boards

Larry Finger (1):
      rtlwifi: Fix some warnings/bugs

Linus Torvalds (3):
      mm: avoid wrapping vm_pgoff in mremap()
      pci: fix PCI bus allocation alignment handling
      Linux 2.6.39-rc3

Lucas De Marchi (1):
      Fix common misspellings

Luciano Coelho (2):
      wl12xx: fix module author's email address in the spi and sdio modules
      wl12xx: fix potential buffer overflow in testmode nvs push

Martin Schwidefsky (1):
      [S390] compile fix for latest binutils

Masami Hiramatsu (5):
      perf probe: Fix to ensure function declared file
      perf probe: Fix to remove redundant close
      perf probe: Fix multiple --vars options behavior
      perf probe: Fix to find recursively inlined function
      perf probe: Fix listing incorrect line number with inline function

Matthew Garrett (2):
      fb: Reduce priority of resource conflict message
      efifb: Add override for 11" Macbook Air 3,1

Michael Hennerich (6):
      staging: IIO: IMU: ADIS16400: Fix up SPI messages cs_change behavior
      staging: IIO: IMU: ADIS16400: Add delay after self test
      staging: IIO: IMU: ADIS16400: Fix addresses of GYRO and ACCEL
calibration offset
      staging: IIO: IMU: ADIS16400: Make sure only enabled
scan_elements are pushed into the ring
      staging: IIO: IMU: ADIS16400: Fix product ID check, skip
embedded revision number
      staging: IIO: IMU: ADIS16400: Avoid using printk facility directly

Michael Holzheu (1):
      [S390] Fix parameter passing for smp_switch_to_cpu()

Michael S. Tsirkin (1):
      KVM: fix crash on irqfd deassign

Neil Horman (1):
      ipv6: Enable RFS sk_rxhash tracking for ipv6 sockets (v2)

Nicolas Ferre (2):
      mtd: atmel_nand: trivial: change DMA usage information trace
      mtd: atmel_nand: modify test case for using DMA operations

Nobuhiro Iwamatsu (3):
      sh: sh-sci: Fix double initialization by serial_console_setup
      sh: landisk: Remove mv_nr_irqs
      sh: landisk: Remove whitespace

OGAWA Hirofumi (1):
      ipv4: Fix "Set rt->rt_iif more sanely on output routes."

Olaf Hering (2):
      staging: hv: use sync_bitops when interacting with the hypervisor
      staging: hv: update dist release parsing in hv_kvp_daemon

Ondrej Zary (1):
      s3fb: fix Virge/GX2

Padmanabh Ratnakar (2):
      be2net: Rename some struct members for clarity
      be2net: Fix suspend/resume operation

Paul Mundt (1):
      sh: select ARCH_NO_SYSDEV_OPS.

Peter Jones (1):
      efifb: Support overriding fields FW tells us with the DMI data.

Peter Korsgaard (2):
      dsa/mv88e6131: add support for mv88e6085 switch
      watchdog: mpc8xxx_wdt: fix build

Peter Oberparleiter (1):
      [S390] cio: prevent purging of CCW devices in the online state

Peter Tyser (2):
      gpio/ml_ioh_gpio: Fix output value of ioh_gpio_direction_output()
      gpio/pch_gpio: Fix output value of pch_gpio_direction_output()

Peter Zijlstra (1):
      sched: Clean up rebalance_domains() load-balance interval calculation

Randy Dunlap (4):
      mtd: mtdswap: fix printk format warning
      staging: fix hv_mouse build, needs delay.h
      staging/rtl81*: build as loadable modules only
      signal.c: fix erroneous syscall kernel-doc

Rasesh Mody (1):
      bna: Fix for handling firmware heartbeat failure

Roland Vossen (3):
      staging: brcm80211: fix for 'AC_BE txop..' logs spammed problem
      staging: brcm80211: fix for 'Short CCK' log spam
      staging: brcm80211: removed 'is_amsdu causing toss' log spam

Sascha Silbe (1):
      staging: fix olpc_dcon build errors

Sebastian Ott (1):
      [S390] qdio: fix init sequence

Senthil Balasubramanian (1):
      ath9k: Fix phy info print message with AR9485 chipset.

Sergey Senozhatsky (1):
      fbcon: Remove unused 'display *p' variable from fb_flashcursor()

Simon Horman (1):
      ARM: mach-shmobile: Correctly check for CONFIG_MACH_MACKEREL

Simon Wood (1):
      HID: add FF support for Logitech G25/G27

Stanislaw Gruszka (1):
      rt2x00: fix cancelling uninitialized work

Stefan Achatz (1):
      HID: roccat: Add support for wireless variant of Pyra

Stephen Boyd (1):
      HID: Fix typo Keyoutch -> Keytouch

Stephen Warren (1):
      ASoC: format_register_str: Don't clip register values

Steve Glendinning (1):
      net: Add support for SMSC LAN9530, LAN9730 and LAN89530

Takashi Iwai (1):
      ALSA: hda - Don't query connections for widgets have no connections

Tao Ma (2):
      ext4: fix a double free in ext4_register_li_request
      ext4: init timer earlier to avoid a kernel panic in __save_error_info

Tarek Soliman (1):
      ALSA: usb-audio: define another USB ID for a buggy USB MIDI cable

Tejun Heo (1):
      x86-32, NUMA: Fix ACPI NUMA init broken by recent x86-64 change

Theodore Ts'o (1):
      ext4: fix data corruption regression by reverting commit 6de9843dab3f

Thomas Gleixner (1):
      x86: visws: Fixup irq overhaul fallout

Tony Luck (1):
      xfs_destroy_workqueues() should not be tagged with__exit

Tormod Volden (3):
      savagefb: Replace magic register address with define
      savagefb: Set up I2C based on chip family instead of card id
      savagefb: Remove obsolete else clause in savage_setup_i2c_bus

Trond Myklebust (1):
      Revert "net/sunrpc: Use static const char arrays"

Ulrich Weber (1):
      pppoe: drop PPPOX_ZOMBIEs in pppoe_flush_dev

Vasily Khoruzhick (2):
      ASoC: PXA: Fix oops in __pxa2xx_pcm_prepare
      spi: Fix race condition in stop_queue()

Xiaotian Feng (1):
      genirq: Fix cpumask leak in __setup_irq()

Yevgeny Petrilin (2):
      mlx4: Sensing link type at device initialization
      mlx4_en: Restoring RX buffer pointer in case of failure

Yongqiang Yang (3):
      ext3: Fix writepage credits computation for ordered mode
      ext4: fix credits computing for indirect mapped files
      ext4: allow an active handle to be started when freezing

Yoshihiro Shimoda (2):
      dma: shdma: add checking the DMAOR_AE in sh_dmae_err
      sh: fix build error in board-sh7757lcr.c

Youquan Song (1):
      fix build fail for hv_mouse indefine udelay

Zhang Huan (1):
      jbd2: fix potential memory leak on transaction commit

Zhu Yanhai (1):
      jbd2: move bdget out of critical section

pixo (1):
      staging: ft1000-pcmcia: Fix ft1000_dnld() to work also on 64bit
architectures.

wwang (2):
      staging: rts_pstor: modify initial card clock
      staging: rts_pstor: set lun_mode in a different place
