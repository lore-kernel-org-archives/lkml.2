Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2KZEWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 23:22:03 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54167 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2KZEWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 23:22:00 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 25 Nov 2012 20:21:38 -0800
X-Google-Sender-Auth: sMzj71i4MgEPlJ2CE2pIgEKdnq0
Message-ID: <CA+55aFyetqyMa2BQu7kE=cqFdAysUh9gV=O5as5Chgg1EMCW7g@mail.gmail.com>
Subject: Linux 3.7-rc7
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A week ago, I had even considered skipping -rc7 entirely as things had
been so calm, but decided that there was little reason to hurry the
release.

And oh, how sadly right I was. -rc7 is out now, and is not at all
smaller than the previous rc's, and in fact slightly scarier. For some
reason the block layer came up on the radar, and there are md, scsi
and generic block layer changes in there. So we definitely want
another week of testing, and hopefully things really are solid.

There's also a few filesystem fixes (reiserfs, xfs and ext3) and
various other driver updates (sound, networking and drm).

Shortlog appended. Go out and test,

                    Linus

---

Aaro Koskinen (1):
      OMAPDSS: do not fail if dpll4_m4_ck is missing

Aaron Lu (1):
      libata-acpi: Fix NULL ptr derference in ata_acpi_dev_handle

Abhilash Kesavan (1):
      i2c: s3c2410: Fix code to free gpios

Al Cooper (1):
      MIPS: Fix crash that occurs when function tracing is enabled

Al Viro (5):
      missing const in alpha callers of do_mount()
      kill bogus BUG_ON() in do_close_on_exec()
      fanotify: fix FAN_Q_OVERFLOW case of fanotify_read()
      sparc64: not any error from do_sigaltstack() should fail rt_sigreturn()
      [PARISC] fix user-triggerable panic on parisc

Alan Cox (1):
      ne2000: add the right platform device

Albert Pool (1):
      rtlwifi: rtl8192cu: Add new USB ID

Alex Deucher (2):
      drm/radeon: properly track the crtc not_enabled case evergreen_mc_stop()
      drm/radeon: add new SI pci id

Alex Williamson (1):
      intel-iommu: Fix lookup in add device

Alexander Shiyan (1):
      irda: sir_dev: Fix copy/paste typo

Alexey Kardashevskiy (1):
      powerpc/pseries: Fix oops with MSIs when missing EEH PEs

Anatolij Gustschin (1):
      powerpc/mpc5200: move lpbfifo node and fix its interrupt property

Anders Hedlund (1):
      ARM: OMAP3: igep0020: Set WIFI/BT GPIO pins in correct mux mode

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Andreas Herrmann (1):
      x86, microcode_amd: Change email addresses, MAINTAINERS entry

Andreas Larsson (1):
      of/address: sparc: Declare of_iomap as an extern function for sparc again

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions

Ariel Elior (1):
      bnx2x: remove redundant warning log

Arnd Bergmann (2):
      pinctrl/samsung: don't allow enabling pinctrl-samsung standalone
      sata_highbank: mark ahci_highbank_probe as __devinit

Avi Kivity (1):
      KVM: Retire as maintainer

Bartlomiej Zolnierkiewicz (1):
      ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of Exynos4210 SOC

Bing Zhao (2):
      mwifiex: fix system hang issue in cmd timeout error case
      mwifiex: report error to MMC core if we cannot suspend

Boris Ostrovsky (1):
      x86, microcode, AMD: Add support for family 16h processors

Borislav Petkov (4):
      x86, AMD: Change Boris' email address
      EDAC: Change Boris' email address
      MAINTAINERS: Change Boris' email address
      libata debugging: Warn when unable to find timing descriptor
based on xfer_mode

Brian Norris (3):
      mtd: nand: fix Samsung SLC NAND identification regression
      mtd: nand: fix Samsung SLC NAND identification regression
      mtd: nand: fix Samsung SLC detection regression

Cesar Eduardo Barros (1):
      x86: remove dummy long from EFI stub

Chun-Yi Lee (1):
      sign-file: fix the perl warning message when extracting ASN.1

Clemens Ladisch (1):
      ALSA: ua101, usx2y: fix broken MIDI output

Cyril Roelandt (1):
      iommu/tegra-smmu.c: fix dentry reference leak in
smmu_debugfs_stats_show().

Daniel M. Weeks (1):
      gpio-mcp23s08: Build I2C support even when CONFIG_I2C=m

Daniel Mack (2):
      ASoC: cs4271: free allocated GPIO
      ALSA: snd-usb: properly initialize the sync endpoint

Dave Chinner (3):
      xfs: fix attr tree double split corruption
      xfs: fix broken error handling in xfs_vm_writepage
      xfs: drop buffer io reference when a bad bio is built

Dave Hansen (1):
      fix incorrect NR_FREE_PAGES accounting (appears like memory leak)

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference

David Henningsson (2):
      ALSA: hda - Add support for Realtek ALC292
      ALSA: hda - Cirrus: Correctly clear line_out_pins when moving to speaker

David Milburn (1):
      sata_svw: check DMA start bit before reset

Dimitris Papastamos (1):
      ASoC: arizona: Fix typo - Swap value in 48k_rates[] and 44k1_rates[]

Dmitry Torokhov (1):
      Input: mousedev - move /dev/input/mice to the correct minor

Ed L. Cashin (1):
      aoe: avoid running request handler on plugged queue

Emmanuel Grumbach (1):
      iwlwifi: don't WARN when a non empty queue is disabled

Eric Dumazet (1):
      ipv6: fix inet6_csk_update_pmtu() return value

Eric Millbrandt (1):
      powerpc/pcm030: add pcm030-audio-fabric to dts

Felipe Balbi (1):
      i2c: omap: ensure writes to dev->buf_len are ordered

Florian Fainelli (1):
      x86/ce4100: Fix pm_poweroff

Florian Westphal (1):
      netfilter: cttimeout: fix buffer overflow

Francois Romieu (1):
      sis900: fix sis900_set_mode call parameters.

Gavin Shan (1):
      powerpc/eeh: Do not invalidate PE properly

Gleb Natapov (1):
      KVM: taking co-maintenance

Guennadi Liakhovetski (1):
      PM / QoS: fix wrong error-checking condition

H. Peter Anvin (1):
      x86-32: Export kernel_stack_pointer() for modules

Henrik Rydberg (1):
      Input: MT - document new 'flags' argument of input_mt_init_slots()

Ian Campbell (1):
      xen/netfront: handle compound page fragments on transmit

Igor Grinberg (2):
      Input: ads7846 - enable pendown GPIO debounce time setting
      ARM - OMAP: ads7846: fix pendown debounce setting

James Bottomley (1):
      [PARISC] fix virtual aliasing issue in get_shared_area()

Jamie Lentin (1):
      mvebu-gpio: Disable blinking when enabling a GPIO for output

Jan Beulich (1):
      x86-64: Fix ordering of CFI directives and recent ASM_CLAC additions

Jan Kara (4):
      reiserfs: Fix lock ordering during remount
      reiserfs: Protect reiserfs_quota_on() with write lock
      reiserfs: Protect reiserfs_quota_write() with write lock
      reiserfs: Move quota calls out of write lock

Javier Martinez Canillas (1):
      ARM: OMAP: Add maintainer entry for IGEP machines

Jeff Mahoney (1):
      net: fix build failure in xilinx

Jens Axboe (2):
      dm: fix deadlock with request based dm and queue request_fn recursion
      mtip32xx: fix shift larger than type warning

Jiri Engelthaler (1):
      mtd: slram: invalid checking of absolute end address

Jiri Kosina (1):
      floppy: destroy floppy workqueue before cleaning up the queue

Jiri Pirko (1):
      team: bcast: convert return value of team_dev_queue_xmit() to
bool correctly

Joerg Roedel (1):
      iommu/amd: Update MAINTAINERS entry

Johannes Berg (2):
      iwlwifi: fix monitor mode FCS flag
      wireless: add back sysfs directory

Joonsoo Kim (1):
      x86, mm: Correct vmflag test for checking VM_HUGETLB

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix range bug in hash:ip,port,net

Julian Anastasov (1):
      ipv4: do not cache looped multicasts

Kelly Doran (1):
      drm/nvc0/disp: fix thinko in vblank regression fix..

Kevin Hilman (1):
      ARM: OMAP4: TWL: mux sys_drm_msecure as output for PMIC

Lad, Prabhakar (1):
      ARM: davinci: dm644x: fix out range signal for ED

Laurent Pinchart (1):
      omapdss: dss: Fix clocks on OMAP363x

Linus Torvalds (1):
      Linux 3.7-rc7

Ludovic Desroches (1):
      i2c: at91: fix SMBus quick command

Lukas Czerner (1):
      ext3: Avoid underflow of in ext3_trim_fs()

Maarten Lankhorst (2):
      drm/nouveau: add missing pll_calc calls
      drm/nouveau: use the correct fence implementation for nv50

Maciej Patelczyk (1):
      [SCSI] isci: copy fis 0x34 response into proper buffer

Manuel Lauss (1):
      MPI: Fix compilation on MIPS with GCC 4.4 and newer

Marcin Slusarz (3):
      drm/nv40: allocate ctxprog with kmalloc
      drm/nouveau: fix crash with noaccel=1
      drm/nouveau/bios: fix DCB v1.5 parsing

Marek Vasut (1):
      i2c: mxs: Handle i2c DMA failure properly

Mark Brown (1):
      ASoC: bells: Fix up git patch application failure

Martin K. Petersen (3):
      [SCSI] Add a report opcode helper
      [SCSI] sd: Permit merged discard requests
      [SCSI] sd: Implement support for WRITE SAME

Mats Petersson (1):
      xen/privcmd: Correctly return success from IOCTL_PRIVCMD_MMAPBATCH

Matt Fleming (1):
      x86, efi: Fix processor-specific memcpy() build error

Maxime Bizon (2):
      x86/ce4100: Fix reboot by forcing the reboot method to be KBD
      x86/ce4100: Fix PCI configuration register access for devices
without interrupts

NeilBrown (6):
      md: make sure everything is freed when dm-raid stops an array.
      md/raid5: round discard alignment up to power of 2.
      md/raid5: move resolving of reconstruct_state earlier in
stripe_handle.
      md/raid5: Make sure we clear R5_Discard when discard is finished.
      md/raid10: close race that lose writes lost when replacement completes.
      md/raid10: decrement correct pending counter when writing to replacement.

Paul Bolle (1):
      radeon: add AGPMode 1 quirk for RV250

Paul Walmsley (1):
      Revert "ARM: OMAP: convert I2C driver to PM QoS for MPU latency
constraints"

Ralf Baechle (1):
      MIPS: Merge overlapping bootmem ranges

Robert Richter (2):
      MAINTAINERS: Update email address for Robert Richter
      x86-32: Fix invalid stack address while in softirq

Roland Dreier (1):
      block: Don't access request after it might be freed

Russell King (5):
      ASoC: kirkwood-dma: fix use of virt_to_phys()
      ASoC: kirkwood-dma: don't ignore other irq causes on error
      ASoC: kirkwood-i2s: fix DCO lock detection
      ASoC: kirkwood-i2s: fix DMA underruns
      ASoC: kirkwood-i2s: more pause-mode fixes

Sachin Kamat (2):
      mtd: ofpart: Fix incorrect NULL check in parse_ofoldpart_partitions()
      mtd: onenand: Make flexonenand_set_boundary static

Sarveshwar Bandi (1):
      bonding: Bonding driver does not consider the
gso_max_size/gso_max_segs setting of slave devices.

Selvan Mani (4):
      mtip32xx: fix potential crash on SEC_ERASE_UNIT
      mtip32xx: Fix to make lba address correct in big-endian systems
      mtip32xx: Fix incorrect mask used for erase mode
      mtip32xx: Fix padding issue

Simon Wunderlich (1):
      mac80211: deinitialize ibss-internals after emptiness check

Srinivas Kandagatla (1):
      of/net/mdio-gpio: Fix pdev->id issue when using devicetrees.

Steffen Klassert (1):
      xfrm: Fix the gc threshold value for ipv4

Sujith Manoharan (1):
      ath9k_hw: Fix regression in device reset

Szymon Janc (2):
      NFC: pn533: Fix missing lock while operating on commands list
      NFC: pn533: Fix use after free

Takashi Iwai (3):
      ALSA: hda - Fix recursive suspend/resume call
      ALSA: hda - Limit runtime PM support only to known Intel chips
      ALSA: hda - Fix build without CONFIG_PM

Tang Chen (1):
      x86/mce: Do not change worker's running cpu in cmci_rediscover().

Thierry Escande (2):
      NFC: Fix nfc_llcp_local chained list insertion
      NFC: Fix pn533 target mode memory leak

Thierry Reding (1):
      gpio: adnp: Depend on OF_GPIO instead of OF

Thomas Betker (1):
      jffs2: Fix lock acquisition order bug in jffs2_write_begin

Tomi Valkeinen (1):
      OMAPDSS: DSI: fix dsi_get_dsidev_from_id()

Tushar Behera (1):
      OMAPFB: Fix possible null pointer dereferencing

Vipul Kumar Samar (1):
      pata_arasan: Initialize cf clock to 166MHz

Waldemar Rymarkiewicz (1):
      NFC: pn533: Fix mem leak in pn533_in_dep_link_up

Wei Yongjun (2):
      OMAPDSS: HDMI: fix missing unlock on error in hdmi_dump_regs()
      mtip32xx: fix potential NULL pointer dereference in
mtip_timeout_function()

Wolfram Sang (1):
      powerpc: 52xx: nop out unsupported critical IRQs

Xi Wang (2):
      ixp4xx_eth: avoid calling dma_pool_create() with NULL dev
      ixp4xx_hss: avoid calling dma_pool_create() with NULL dev

Yuanhan Liu (1):
      [libata] PM callbacks should be conditionally compiled on CONFIG_PM_SLEEP

Zhi Yong Wu (1):
      vxlan: fix command usage in its doc

françois romieu (1):
      8139cp: revert "set ring address before enabling receiver"

majianpeng (2):
      md: Reassigned the parameters if read_seqretry returned true in
func md_is_badblock.
      md: Avoid write invalid address if read_seqretry returned true.
