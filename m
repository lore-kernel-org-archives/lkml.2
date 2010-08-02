Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab0HBTDU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:03:20 -0400
Received: from kroah.org ([198.145.64.141]:37008 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754577Ab0HBTDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:03:14 -0400
Date: Mon, 2 Aug 2010 12:02:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.17
Message-ID: <20100802190205.GC17098@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.17 kernel.

All users of the 2.6.32 kernel series should upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Makefile                                        |    2 
 arch/arm/kernel/kprobes-decode.c                |    5 
 arch/arm/mach-omap2/board-rx51-peripherals.c    |   17 -
 arch/arm/mach-realview/Kconfig                  |    2 
 arch/arm/mach-realview/include/mach/barriers.h  |    8 
 arch/ia64/mm/tlb.c                              |    2 
 arch/mips/include/asm/mipsregs.h                |    9 
 arch/mips/math-emu/cp1emu.c                     |   15 -
 arch/sparc/include/asm/stat.h                   |    4 
 arch/x86/include/asm/msr-index.h                |    1 
 arch/x86/include/asm/suspend_32.h               |    2 
 arch/x86/include/asm/suspend_64.h               |    2 
 arch/x86/include/asm/system.h                   |    2 
 arch/x86/kernel/acpi/cstate.c                   |    9 
 arch/x86/kernel/acpi/sleep.c                    |    2 
 arch/x86/kernel/apic/apic.c                     |    2 
 arch/x86/kernel/hpet.c                          |    2 
 arch/x86/kernel/pci-calgary_64.c                |   17 -
 arch/x86/kvm/mmu.c                              |    5 
 arch/x86/kvm/svm.c                              |   99 ++++++
 arch/x86/power/cpu.c                            |    4 
 drivers/acpi/processor_idle.c                   |    2 
 drivers/acpi/sleep.c                            |  157 ----------
 drivers/base/firmware_class.c                   |   26 +
 drivers/char/agp/amd64-agp.c                    |   27 +
 drivers/char/tpm/tpm.h                          |    1 
 drivers/char/tpm/tpm_tis.c                      |    9 
 drivers/cpufreq/cpufreq.c                       |   11 
 drivers/gpu/drm/i915/i915_drv.c                 |    1 
 drivers/gpu/drm/i915/i915_gem.c                 |   10 
 drivers/gpu/drm/i915/i915_reg.h                 |   64 ++++
 drivers/gpu/drm/i915/intel_display.c            |    4 
 drivers/gpu/drm/radeon/r200.c                   |    2 
 drivers/gpu/drm/radeon/radeon_atombios.c        |    9 
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 
 drivers/hwmon/coretemp.c                        |   32 ++
 drivers/hwmon/it87.c                            |   22 +
 drivers/hwmon/k8temp.c                          |   12 
 drivers/ide/cmd640.c                            |    6 
 drivers/ide/ide-taskfile.c                      |    6 
 drivers/infiniband/ulp/ipoib/ipoib_main.c       |    4 
 drivers/input/keyboard/twl4030_keypad.c         |   17 -
 drivers/input/serio/i8042-x86ia64io.h           |    7 
 drivers/media/dvb/dvb-core/dvb_net.c            |   12 
 drivers/media/dvb/ttpci/Kconfig                 |    5 
 drivers/media/video/cx23885/cx23885-i2c.c       |   12 
 drivers/media/video/cx88/cx88-i2c.c             |   16 +
 drivers/media/video/uvc/uvc_driver.c            |   30 +-
 drivers/media/video/uvc/uvcvideo.h              |    7 
 drivers/mmc/host/sdhci-s3c.c                    |   20 +
 drivers/net/cpmac.c                             |    3 
 drivers/net/cxgb3/ael1002.c                     |    2 
 drivers/net/dm9000.c                            |   38 +-
 drivers/net/forcedeth.c                         |    2 
 drivers/net/igb/e1000_82575.c                   |   13 
 drivers/net/igb/e1000_hw.h                      |    2 
 drivers/net/igb/e1000_mac.c                     |   17 -
 drivers/net/sky2.c                              |   19 -
 drivers/net/wireless/ath/ath5k/attach.c         |    1 
 drivers/net/wireless/ath/ath5k/base.c           |    7 
 drivers/net/wireless/ath/ath9k/initvals.h       |    8 
 drivers/net/wireless/ath/ath9k/main.c           |    7 
 drivers/net/wireless/hostap/hostap_cs.c         |   10 
 drivers/net/wireless/hostap/hostap_hw.c         |   13 
 drivers/net/wireless/hostap/hostap_wlan.h       |    2 
 drivers/net/wireless/iwlwifi/iwl-scan.c         |    1 
 drivers/net/wireless/iwlwifi/iwl-tx.c           |    5 
 drivers/net/wireless/libertas/if_sdio.c         |   22 +
 drivers/net/wireless/p54/p54pci.c               |    2 
 drivers/pci/pci.c                               |    1 
 drivers/platform/x86/eeepc-laptop.c             |   18 +
 drivers/rtc/rtc-ds1307.c                        |    4 
 drivers/scsi/aacraid/commctrl.c                 |    4 
 drivers/serial/cpm_uart/cpm_uart_core.c         |  143 +++++----
 drivers/ssb/driver_chipcommon.c                 |    3 
 drivers/ssb/driver_chipcommon_pmu.c             |   17 -
 drivers/ssb/pci.c                               |   46 ++-
 drivers/ssb/sprom.c                             |   15 +
 drivers/staging/rtl8192su/r8192U_core.c         |    4 
 drivers/usb/core/driver.c                       |   15 -
 drivers/usb/core/quirks.c                       |    7 
 drivers/usb/gadget/u_serial.c                   |   16 -
 drivers/usb/misc/sisusbvga/sisusb.c             |    5 
 drivers/usb/serial/ftdi_sio.c                   |    9 
 drivers/usb/serial/ftdi_sio_ids.h               |   15 +
 drivers/usb/serial/option.c                     |    4 
 drivers/usb/serial/sierra.c                     |    1 
 drivers/virtio/virtio_pci.c                     |    3 
 fs/btrfs/ioctl.c                                |    4 
 fs/cifs/cifsfs.c                                |    6 
 fs/cifs/dns_resolve.c                           |   69 ++++
 fs/cifs/dns_resolve.h                           |    4 
 fs/cifs/inode.c                                 |    4 
 fs/cifs/sess.c                                  |   10 
 fs/ecryptfs/messaging.c                         |   17 -
 fs/ext4/dir.c                                   |   12 
 fs/ext4/ext4.h                                  |  157 +++++++++-
 fs/ext4/ext4_extents.h                          |    3 
 fs/ext4/ext4_jbd2.c                             |    2 
 fs/ext4/ext4_jbd2.h                             |    6 
 fs/ext4/extents.c                               |  251 +++++++++++++---
 fs/ext4/file.c                                  |    6 
 fs/ext4/fsync.c                                 |   49 ++-
 fs/ext4/ialloc.c                                |   98 +++---
 fs/ext4/inode.c                                 |  360 ++++++++++++++----------
 fs/ext4/ioctl.c                                 |   37 ++
 fs/ext4/mballoc.c                               |  138 +++++----
 fs/ext4/migrate.c                               |   37 +-
 fs/ext4/move_extent.c                           |   28 +
 fs/ext4/namei.c                                 |   24 +
 fs/ext4/resize.c                                |    3 
 fs/ext4/super.c                                 |   67 ++--
 fs/ext4/xattr.c                                 |   28 +
 fs/gfs2/acl.c                                   |  170 +++++++----
 fs/gfs2/acl.h                                   |   24 -
 fs/gfs2/xattr.c                                 |   18 -
 fs/jbd2/checkpoint.c                            |   15 +
 fs/jbd2/commit.c                                |   19 -
 fs/nfs/nfs4xdr.c                                |    4 
 fs/nfs/super.c                                  |   22 +
 include/acpi/processor.h                        |    3 
 include/linux/acpi.h                            |    1 
 include/linux/ethtool.h                         |    2 
 include/linux/fb.h                              |    4 
 include/linux/firmware.h                        |    1 
 include/linux/ieee80211.h                       |    2 
 include/linux/jbd2.h                            |    1 
 include/linux/mmc/sdio.h                        |    2 
 include/linux/ssb/ssb.h                         |    1 
 include/linux/ssb/ssb_driver_chipcommon.h       |    2 
 include/linux/ssb/ssb_regs.h                    |    3 
 include/math-emu/op-common.h                    |    2 
 kernel/futex.c                                  |   17 -
 kernel/irq/manage.c                             |    3 
 kernel/module.c                                 |    4 
 kernel/sched.c                                  |    9 
 net/core/ethtool.c                              |   43 ++
 net/core/neighbour.c                            |    5 
 net/ipv4/tcp_output.c                           |    3 
 net/ipv6/netfilter/ip6t_REJECT.c                |    6 
 net/mac80211/mlme.c                             |   17 -
 net/mac80211/rx.c                               |    5 
 net/mac80211/scan.c                             |   21 -
 net/netfilter/ipvs/ip_vs_conn.c                 |    4 
 net/sunrpc/xprtsock.c                           |   38 +-
 scripts/mod/modpost.c                           |    2 
 sound/pci/echoaudio/echoaudio.c                 |    4 
 sound/pci/hda/patch_realtek.c                   |    1 
 sound/soc/codecs/wm8776.c                       |    1 
 tools/perf/util/callchain.h                     |    3 
 150 files changed, 2122 insertions(+), 1027 deletions(-)

Adam Jackson (1):
      drm/i915: Make G4X-style PLL search more permissive

Akira Fujita (3):
      ext4: Fix insertion point of extent in mext_insert_across_blocks()
      ext4: Fix the NULL reference in double_down_write_data_sem()
      ext4: Code cleanup for EXT4_IOC_MOVE_EXT ioctl

Alan Jenkins (1):
      eeepc-laptop: check wireless hotplug events

Alan Stern (1):
      USB: obey the sysfs power/wakeup setting

Alex Deucher (2):
      drm/radeon/kms: add quirk for ASUS HD 3600 board
      drm/radeon/kms: fix legacy LVDS dpms sequence

Alex,Shi (1):
      sched: Fix over-scheduling bug

Alexander Duyck (1):
      igb: change how we handle alternate mac addresses

Andi Kleen (1):
      x86: Fix vsyscall on gcc 4.5 with -Os

Andre Osterhues (1):
      ecryptfs: Bugfix for error related to ecryptfs_hash_buckets

Andreas Herrmann (1):
      hwmon: (k8temp) Fix temperature reporting for ASB1 processor revisions

Andrej Gelenberg (1):
      revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"

Aneesh Kumar K.V (4):
      ext4: Ensure zeroout blocks have no dirty metadata
      ext4: Handle -EDQUOT error on write
      ext4: Fix quota accounting error with fallocate
      ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag

Ang Way Chuang (1):
      V4L/DVB: dvb-core: Fix ULE decapsulation bug

Avi Kivity (1):
      KVM: MMU: Remove user access when allowing kernel access to gpte.w=0 page

Ayaz Abdulla (1):
      forcedeth: fix tx limit2 flag check

Baruch Siach (1):
      dm9000: fix "BUG: spinlock recursion"

Ben Hutchings (6):
      amd64-agp: Probe unknown AGP devices the right way
      ethtool: Fix potential kernel buffer overflow in ETHTOOL_GRXCLSRLALL
      ethtool: Fix potential user buffer overflow for ETHTOOL_{G, S}RXFH
      ext4: Conditionally define compat ioctl numbers
      ext4: Fix compat EXT4_IOC_ADD_GROUP
      V4L/DVB: budget: Select correct frontends

Bob Copeland (1):
      ath5k: initialize ah->ah_current_channel

Brandon Philips (1):
      sky2: enable rx/tx in sky2_phy_reinit()

Catalin Marinas (1):
      ARM: 6201/1: RealView: Do not use outer_sync() on ARM11MPCore boards with L220

Christian Borntraeger (1):
      ext4: allow defrag (EXT4_IOC_MOVE_EXT) in 32bit compat mode

Christoph Fritz (1):
      ssb: Handle Netbook devices where the SPROM address is changed

Colin Leitner (1):
      USB: ftdi_sio: support for Signalyzer tools based on FTDI chips

Corey Minyard (1):
      USB: FTDI: Add support for the RT System VX-7 radio programming cable

Curt Wohlgemuth (5):
      ext4: Fix BUG_ON at fs/buffer.c:652 in no journal mode
      ext4: Fix possible lost inode write in no journal mode
      ext4: Fix buffer head leaks after calls to ext4_get_inode_loc()
      ext4: Remove extraneous newlines in ext4_msg() calls
      ext4: check for a good block group before loading buddy pages

Dan Rosenberg (1):
      Btrfs: fix checks in BTRFS_IOC_CLONE_RANGE

Daniel J Blueman (1):
      i915: fix lock imbalance on error path...

Daniel Mack (1):
      libertas/sdio: 8686: set ECSI bit for 1-bit transfers

Daniel Ritz (1):
      V4L/DVB (13830): uvcvideo: add another YUYV format GUID for iSight cameras

Darrick J. Wong (2):
      x86, Calgary: Increase max PHB number
      x86, Calgary: Limit the max PHB number to 256

Dave Airlie (2):
      fb: fix colliding defines for fb flags.
      drm/i915: enable low power render writes on GEN3 hardware.

David Howells (1):
      CIFS: Fix a malicious redirect problem in the DNS lookup code

David Woodhouse (1):
      firmware_class: fix memory leak - free allocated pages

Dennis Jansen (1):
      USB: option: Add support for AMOI Skypephone S2

Dmitry Monakhov (11):
      ext4: Fix potential quota deadlock
      ext4: fix error handling in migrate
      ext4: explicitly remove inode from orphan list after failed direct io
      ext4: Handle non empty on-disk orphan link
      ext4: check missed return value in ext4_sync_file()
      ext4: fix quota accounting in case of fallocate
      ext4: Do not zero out uninitialized extents beyond i_size
      ext4: clean up inode bitmaps manipulation in ext4_free_inode
      ext4: init statistics after journal recovery
      ext4: Use bitops to read/modify i_flags in struct ext4_inode_info
      ext4: restart ext4_ext_remove_space() after transaction restart

Dmitry Torokhov (2):
      Input: twl40300-keypad - fix handling of "all ground" rows
      Input: RX51 keymap - fix recent compile breakage

Dongdong Deng (1):
      serial: cpm_uart: implement the cpm_uart_early_write() function for console poll

Doug Kehn (1):
      net/core: neighbour update Oops

Eric Dumazet (1):
      netfilter: ip6t_REJECT: fix a dst leak in ipv6 REJECT

Eric Sandeen (5):
      ext4: Fixed inode allocator to correctly track a flex_bg's used_dirs
      ext4: check s_log_groups_per_flex in online resize code
      ext4: don't return to userspace after freezing the fs with a mutex held
      ext4: stop issuing discards if not supported by device
      ext4: don't scan/accumulate more pages than mballoc will allocate

Florian Fainelli (1):
      cpmac: do not leak struct net_device on phy_connect errors

Frank Mayhar (1):
      ext4: Make fsync sync new parent directories in no-journal mode

Frederic Weisbecker (1):
      perf: Resurrect flat callchains

Giuliano Pochini (1):
      ALSA: Echoaudio, fix Guru Meditation #00000005.48454C50

Greg Kroah-Hartman (1):
      Linux 2.6.32.17

Hiroshi Shimamoto (1):
      cxgb3: fix linkup issue

Ilpo Järvinen (1):
      tcp: fix crash in tcp_xmit_retransmit_queue

Jan Kara (2):
      ext4: Fix estimate of # of blocks needed to write indirect-mapped files
      ext4: Show journal_checksum option

Jason Baron (1):
      dynamic debug: move ddebug_remove_module() down into free_module()

Javier Cardona (1):
      mac80211: Handle mesh action frames in ieee80211_rx_h_action

Jean Delvare (5):
      hwmon: (k8temp) Bypass core swapping on single-core processors
      hwmon: (coretemp) Properly label the sensors
      hwmon: (coretemp) Skip duplicate CPU entries
      hwmon: (it87) Fix in7 on IT8720F
      V4L/DVB: FusionHDTV: Use quick reads for I2C IR device probing

Jeff Layton (2):
      cifs: remove bogus first_time check in NTLMv2 session setup code
      cifs: don't attempt busy-file rename unless it's in same directory

Jiaying Zhang (1):
      ext4: Add flag to files with blocks intentionally past EOF

Jing Zhang (3):
      ext4: fix memory leaks in error path handling of ext4_ext_zeroout()
      ext4: Remove unnecessary call to ext4_get_group_desc() in mballoc
      ext4: rename ext4_mb_release_desc() to ext4_mb_unload_buddy()

Joakim Tjernlund (1):
      rtc: fix ds1388 time corruption

Joerg Albert (1):
      p54pci: add Symbol AP-300 minipci adapters pciid

Joerg Roedel (2):
      KVM: SVM: Handle MCEs early in the vmexit process
      KVM: SVM: Implement workaround for Erratum 383

John W. Linville (1):
      iwlwifi: cancel scan watchdog in iwl_bg_abort_scan

Jon Povey (2):
      USB: g_serial: don't set low_latency flag
      USB: g_serial: fix tty cleanup on unload

Julia Lawall (2):
      SCSI: aacraid: Eliminate use after free
      ext4: Eliminate potential double free on error path

Kamal Mostafa (1):
      Input: i8042 - add Gigabyte Spring Peak to dmi_noloop_table

Keith Packard (1):
      drm/i915: Define MI_ARB_STATE bits

Krzysztof Halasa (1):
      kbuild: Fix modpost segfault

Laurent Pinchart (3):
      V4L/DVB: uvcvideo: Add support for unbranded Arkmicro 18ec:3290 webcams
      V4L/DVB: uvcvideo: Add support for Packard Bell EasyNote MX52 integrated webcam
      V4L/DVB: uvcvideo: Add support for V4L2_PIX_FMT_Y16

Len Brown (1):
      ACPI: skip checking BM_STS if the BIOS doesn't ask for it

Luis R. Rodriguez (2):
      ath5k: drop warning on jumbo frames
      ath9k: re-enable ps by default for new single chip families

Luke Yelavich (1):
      ALSA: hda - Add Macbook 5,2 quirk

Marcelo Tosatti (1):
      KVM: MMU: invalidate and flush on spte small->large page size change

Marek Szyprowski (1):
      sdhci-s3c: add missing remove function

Mark Brown (1):
      ASoC: Remove duplicate AUX definition from WM8776

Matthew Garrett (1):
      ACPI: Unconditionally set SCI_EN on resume

Michael S. Tsirkin (1):
      virtio-pci: disable msi at startup

Michal Hocko (1):
      futex: futex_find_get_task remove credentails check

Mikael Pettersson (1):
      math-emu: correct test for downshifting fraction in _FP_FROM_INT()

Mikulas Patocka (1):
      ide: Fix IDE taskfile with cfq scheduler

Nicolas Pitre (1):
      ARM: 6226/1: fix kprobe bug in ldr instruction emulation

Nikanth Karthikesan (1):
      ext4: Prevent creation of files larger than RLIMIT_FSIZE using fallocate

Oliver Neukum (2):
      USB: sisusbvga: Fix for USB 3.0
      USB: add quirk for Broadcom BT dongle

Ondrej Zary (1):
      PM / x86: Save/restore MISC_ENABLE register

Or Gerlitz (1):
      IPoIB: Fix world-writable child interface control sysfs attributes

Paul Mortier (1):
      USB: adds Artisman USB dongle to list of quirky devices

Pavel Roskin (1):
      Staging: rtl8192su: add USB ID for 0bda:8171

Rajiv Andrade (2):
      TPM: ReadPubEK output struct fix
      tpm_tis: fix subsequent suspend failures

Richard Airlie (1):
      staging: rtl8192su: add Support for Belkin F5D8053 v6

Richard Kennedy (1):
      ext4: return correct wbc.nr_to_write in ext4_da_writepages

Rob Landley (1):
      sparc: Fix use of uid16_t and gid16_t in asm/stat.h

Roland Scheidegger (1):
      drm/radeon/r200: handle more hw tex coord types

Sergei Shtylyov (1):
      cmd640: fix kernel oops in test_irq() method

Shane McDonald (1):
      MIPS FPU emulator: allow Cause bits of FCSR to be writeable by ctc1

Shanyu Zhao (1):
      iwlagn: verify flow id in compressed BA packet

Stanislaw Gruszka (2):
      mac80211: do not wip out old supported rates
      mac80211: fix supported rates IE if AP doesn't give us it's rates

Stefano Stabellini (1):
      x86: Do not try to disable hpet if it hasn't been initialized before

Stephane Glondu (1):
      staging: rtl8192su: add USB VID/PID for HWNUm-300

Steven Whitehouse (1):
      GFS2: Fix up system xattrs

Surbhi Palande (1):
      ext4: replace BUG() with return -EIO in ext4_ext_get_blocks

Sven Wegener (1):
      ipvs: Add missing locking during connection table hashing and unhashing

Tao Ma (1):
      ext4: Fix fencepost error in chosing choosing group vs file preallocation.

Theodore Ts'o (8):
      ext4, jbd2: Add barriers for file systems with exernal journals
      ext4: Patch up how we claim metadata blocks for quota purposes
      ext4: Fix accounting of reserved metadata blocks
      ext4: Calculate metadata requirements more accurately
      ext4: Use bitops to read/modify EXT4_I(inode)->i_state
      ext4: Issue the discard operation *before* releasing the blocks to be reused
      ext4: Avoid crashing on NULL ptr dereference on a filesystem error
      ext4: Clear the EXT4_EOFBLOCKS_FL flag only when warranted

Thomas Gleixner (1):
      genirq: Deal with desc->set_type() changing desc->chip

Tim Gardner (1):
      hostap: Protect against initialization interrupt

Tony Luck (1):
      Fix spinaphore down_spin()

Toshiyuki Okajima (1):
      ext4: make "offset" consistent in ext4_check_dir_entry()

Trond Myklebust (3):
      NFSv4: Fix an embarassing typo in encode_attrs()
      NFSv4: Ensure that /proc/self/mountinfo displays the minor version number
      SUNRPC: Fix a re-entrancy bug in xs_tcp_read_calldir()

Vivek Natarajan (1):
      ath9k: Avoid corrupt frames being forwarded to mac80211.

Will Deacon (1):
      sched: Prevent compiler from optimising the sched_avg_update() loop

Yinghai Lu (1):
      x86: Fix x2apic preenabled system with kexec

august huber (1):
      USB: Add PID for Sierra 250U to drivers/usb/serial/sierra.c

Ömer Sezgin Ugurlu (1):
      USB: option: add support for 1da5:4518

