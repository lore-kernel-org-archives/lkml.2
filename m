Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751020Ab1HNWsn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 18:48:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab1HNWsl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 18:48:41 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Aug 2011 15:45:28 -0700
Message-ID: <CA+55aFycTvbuNzdgbHjoiNkTeDpzgu6Yf=vx9DU+PDOtC_17zA@mail.gmail.com>
Subject: Linux 3.1-rc2
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, nice calm first week after the merge window. Good job. Or maybe
people are just being lazy, and everybody is on vacation. Whatever.
Don't tell me. I'm reasonably happy, I want to stay that way.

That said, I would be happy if it calmed down further. 300+ commits
for -rc2 is good, but please make me even happier for -rc3 by ONLY
sending me real fixes. Think of it as "fairly late in the -rc series",
because I really want to compensate for the merge window being fairly
chaotic.

             Linus

---
Aaron Lu (1):
      mmc: sdhci: fix retuning timer wrongly deleted in sdhci_tasklet_finish

Ajeet Yadav (1):
      "xfs: fix error handling for synchronous writes" revisited

Akinobu Mita (1):
      slub: fix check_bytes() for slub debugging

Alan Cox (2):
      gma500: Fix clashes with DRM updates
      gma500: Fix clashes with DRM updates

Alex Elder (1):
      xfs: set cursor in xfs_ail_splice() even when AIL was empty

Alex Hacker (1):
      ath9k: fix a misprint which leads to incorrect calibration

Anatolij Gustschin (1):
      MAINTAINERS: change maintainership of mpc5xxx

Andrei Warkentin (1):
      Bridge: Always send NETDEV_CHANGEADDR up on br MAC change.

Andrew Bird (4):
      USB: option driver: add PID for Vodafone-Huawei K3770
      USB: option driver: add PID for Vodafone-Huawei K3771
      USB: option driver: add PID for Vodafone-Huawei K4510
      USB: option driver: add PID for Vodafone-Huawei K4511

Andrew Morton (5):
      drivers/staging/speakup/devsynth.c: fix "buffer size is not
provably correct" error
      drivers/staging/dt3155v4l/dt3155v4l.c needs slab.h
      drivers/staging/solo6x10/core.c needs slab.h
      drivers/staging/solo6x10/p2m.c needs slab.h
      staging: more missing slab.h inclusions

Andy Lutomirski (9):
      x86-64: Pad vDSO to a page boundary
      x86-64: Move the "user" vsyscall segment out of the data segment.
      x86-64: Work around gold bug 13023
      x86-64, xen: Enable the vvar mapping
      x86-64: Add user_64bit_mode paravirt op
      x86-64: Add vsyscall:emulate_vsyscall trace event
      x86: Remove unnecessary compile flag tweaks for vsyscall code
      x86-64: Wire up getcpu syscall
      x86-64: Rework vsyscall emulation and add vsyscall= parameter

Andy Shevchenko (5):
      mmc: mmc_test: avoid stalled file in debugfs
      mmc: Revert "mmc: sdhci: Fix SDHCI_QUIRK_TIMEOUT_USES_SDCLK"
      mmc: sdhci: check host->clock before using it as a denominator
      mmc: sdhci: move timeout_clk calculation farther down
      mmc: sdhci: use f_max instead of host->clock for timeouts

Anthony Bourguignon (1):
      rt2x00: Add rt2870 device id for Dvico usb key

Anton Blanchard (10):
      powerpc: Fix device tree claim code
      powerpc: Clean up some panic messages in prom_init
      powerpc: Jump label misalignment causes oops at boot
      powerpc: pseries: Fix kexec on machines with more than 4TB of RAM
      powerpc: Move kdump default base address to half RMO size on 64bit
      powerpc: Lack of ibm,io-events not that important!
      powerpc: Make KVM_GUEST default to n
      powerpc/pseries: Fix kexec on recent firmware versions
      powerpc/pseries: Cleanup VPA registration and deregistration errors
      powerpc/pseries: Simplify vpa deregistration functions

Arnaldo Carvalho de Melo (4):
      perf evlist: Introduce 'disable' method
      perf python: Add PERF_RECORD_{LOST,READ,SAMPLE} routine tables
      perf report: Use ui__warning in some more places
      perf tools: Check $HOME/.perfconfig ownership

Arnaud Lacombe (1):
      usb/host/pci-quirks.c: correct annotation of `ehci_dmi_nohandoff_table'

Arnaud Patard (4):
      efikasb/mx: fix usbh1 initialisation
      efikasb: fix gpio keys.
      efika: Fix board id detection
      iMX: Fix build for iMX53

Artur Zimmer (1):
      USB: Serial: Add PID(0xF7C0) to FTDI SIO driver for a zeitcontrol-device

Arvid Brodin (1):
      usb/isp1760: Added missing call to usb_hcd_check_unlink_urb()
during unlink

Axel Lin (2):
      usb: gadget: s3c2410_udc: fix unterminated platform_device_id table
      mmc: tmio: eliminate unused variable 'mmc' warning

Ben Dooks (1):
      ARM: mx5: board-cpuimx51.c fixup irq_to_gpio() usage

Benjamin Herrenschmidt (3):
      powerpc/4xx: Fix build of PCI code on 405
      powerpc: Fix build without CONFIG_PCI
      powerpc: Really fix build without CONFIG_PCI

Boaz Harrosh (1):
      pnfs: Automatically select blocks & objects layouts

Bob Copeland (1):
      ath5k: fix error handling in ath5k_beacon_send

Boris Todorov (1):
      USB: EHCI: Fix test mode sequence

Borislav Petkov (1):
      EDAC: Correct Kconfig dependencies

Brian S. Julin (1):
      ARM: 7005/1: freshen up mm/proc-arm946.S

Bruce Allan (4):
      e1000e: alternate MAC address does not work on device id 0x1060
      e1000e: do not disable receiver on 82574/82583
      e1000e: alternate MAC address update
      e1000e: increase driver version number

Chandra Seetharaman (13):
      xfs: Remove the macro XFS_BUF_BFLAGS
      xfs: Remove the macro XFS_BUF_ERROR and family
      xfs: Remove macro XFS_BUF_BUSY and family
      xfs: Remove macro XFS_BUF_HOLD
      xfs: Remove macro XFS_BUF_SET_START
      xfs: Remove the macro XFS_BUF_PTR
      xfs: Remove the macro XFS_BUF_SET_PTR
      Replace the macro XFS_BUF_ISPINNED with helper xfs_buf_ispinned
      xfs: Remove the macro XFS_BUF_SET_TARGET
      xfs: Remove the macro XFS_BUF_TARGET
      xfs: Remove the macro XFS_BUFTARG_NAME
      xfs: Check the return value of xfs_buf_read() for NULL
      xfs: replace xfs_buf_geterror() with bp->b_error

Christoph Lameter (2):
      slub: Fix full list corruption if debugging is on
      slub: Fix partial count comparison confusion

Clemens Ladisch (2):
      ALSA: snd-usb: Accept UAC2 FORMAT_TYPE descriptors with bLength > 6
      mm: fix wrong vmap address calculations with odd NR_CPUS values

Colin Cross (1):
      OMAP2+: PM: SmartReflex: use put_sync_suspend for IRQ-safe disabling

Dan Carpenter (1):
      Staging: iio: add some unlocks to raw_read() functions

Daniel Baluta (1):
      ipv4: Fix ip_getsockopt for IP_PKTOPTIONS

Daniel Mack (4):
      ALSA: snd-usb: operate on given mixer interface only
      ALSA: snd-usb: Fix uninitialized variable usage
      ALSA: snd-usb-caiaq: Fix keymap for RigKontrol3
      ALSA: snd-usb-caiaq: Correct offset fields of outbound iso_frame_desc

Dave Martin (2):
      ARM: 7007/1: alignment: Prevent ignoring of faults with ARMv6
unaligned access model
      ARM: 7008/1: alignment: Make SIGBUS sent to userspace POSIXly correct

David Ahern (1):
      powerpc/perf: Disable pagefaults during callchain stack read

David Howells (1):
      CRED: Restore const to current_cred()

David S. Miller (2):
      net: Make userland include of netlink.h more sane.
      sparc: Don't do hypervisor calls on non-sun4v in DS driver.

Deepak Saxena (1):
      sound: oss/pas2: Remove CLOCK_TICK_RATE dependency from PAS16 driver

Dmitry Kravkov (3):
      bnx2x: prevent race between undi_unload and load flows
      bnx2x: properly clean indirect addresses
      bnx2x: disable dcb on 578xx since not supported yet

Eric Miao (1):
      ARM: mx53: add pad configuration for I2C signals

Eric Sandeen (2):
      ext3: Properly count journal credits for long symlinks
      ext4: Properly count journal credits for long symlinks

Fabio Estevam (3):
      ARM: mach-imx/mx31ads: Fix section mismatches
      ARM: mach-imx/mx31lilly: Fix section mismatches
      ARM: board-mx51_babbage: Fix UART2 registration

Florian Echtler (1):
      USB: Serial: Add device ID for Sierra Wireless MC8305

Florian Westphal (2):
      compat_ioctl: add compat handler for PPPIOCGL2TPSTATS
      net_sched: prio: use qdisc_dequeue_peeked

Geert Uytterhoeven (1):
      usb: gadget: net2272 - Correct includes

Guenter Roeck (2):
      hwmon: (pmbus) Virtualize pmbus_write_byte
      hwmon: (pmbus/lm25066) Ignore byte writes to non-zero pages

Han Pingtian (1):
      perf buildid-cache: Zero out buffer of filenames when
adding/removing buildid

Hauke Mehrtens (1):
      b43: read correct register on bcma bus.

Hemant Pedanekar (1):
      omap: timer: Set dmtimer used as clocksource in autoreload mode

Ionut Nicu (1):
      USB: ftdi_sio: fix minor typo in get_ftdi_divisor

Ivo van Doorn (1):
      rt2x00: Add new rt73 buffalo USB id

Jaehoon Chung (3):
      mmc: sdhci-s3c: add BROKEN_ADMA_ZEROLEN_DESC quirk
      mmc: core: use defined R1_STATE_PRG macro for card status
      mmc: remove unused "ddr" parameter in struct mmc_ios

Jamie Iles (1):
      ARM: 7010/1: mm: fix invalid loop for poison_init_mem

Jarkko Nikula (1):
      ASoC: omap: Update e-mail address of Jarkko Nikula

Jason Baron (1):
      jump label: Reduce the cycle count by changing the link order

Jason Liu (1):
      ARM: iMX5: Don't enable DPLL if it already enabled

Javier Martin (1):
      Add tlv320aic32x4 platform data to Visstrim_M10.

Jean-Christophe PLAGNIOL-VILLARD (1):
      USB: at91_udc: include linux/prefetch.h explicitly

Jesper Juhl (1):
      trace events: Update version number reference to new 3.x scheme
for EVENT_POWER_TRACING_DEPRECATED

JiSheng Zhang (1):
      USB: xhci: fix OS want to own HC

Jiri Olsa (3):
      perf tools: Add support to install perf python extension
      perf sched: Do not delete session object prematurely
      perf sched: Usage leftover from trace -> script rename

Johan Hovold (1):
      OMAP3: am3517crane: remove NULL board_mux from board file

John Johansen (1):
      Ecryptfs: Add mount option to check uid of device being mounted
= expect uid

John Stultz (1):
      usb: musb: fix oops on musb_gadget_pullup

Jonathan Nieder (2):
      perf tools: do not look at ./config for configuration
      cap_syslog: don't use WARN_ONCE for CAP_SYS_ADMIN deprecation warning

Jovi Zhang (1):
      perf probe: Fix coredump introduced by probe module option

Julia Lawall (7):
      drivers/staging/ath6kl/miscdrv/ar3kps/ar3kpsparser.c: adjust array index
      drivers/staging/hv/blkvsc_drv.c: eliminate NULL pointer dereference
      ALSA: azt3328 - adjust error handling code to include debugging code
      drivers/net/wireless/wl1251: add missing kfree
      net/netlabel/netlabel_kapi.c: add missing cleanup code
      net/bridge/netfilter/ebtables.c: use available error handling code
      hwmon: (ibmaem) add missing kfree

Julian Anastasov (6):
      netfilter: avoid double free in nf_reinject
      ipv4: fix the reusing of routing cache entries
      netfilter: TCP and raw fix for ip_route_me_harder
      ipv4: route non-local sources for raw socket
      ipv4: use dst with ref during bcast/mcast loopback
      ipv4: some rt_iif -> rt_route_iif conversions

Kazutomo Yoshii (1):
      ALSA: usb-audio - Add quirk for BOSS Micro BR-80

Kevin Hilman (3):
      OMAP2+: Kconfig: don't select PM in OMAP2PLUS_TYPICAL
      OMAP1: enable GENERIC_IRQ_CHIP
      OMAP3: beagle: don't touch omap_device internals

Kuninori Morimoto (5):
      usb: renesas_usbhs: fix DMA build by including dma-mapping.h
      usb: renesas_usbhs: fixup usbhsg_for_each_uep 1st pos
      net/irda: sh_irda: add missing header
      net/irda: sh_sir: add missing header
      net/irda: sh_sir: tidyup compile warning

Kusanagi Kouichi (1):
      perf tools: Make clean leaves some files

Kyungmin Park (1):
      mmc: core: Detect eMMC v4.5 ext_csd entries

Larry Finger (1):
      rtlwifi: rtl892cu: New USB IDs

Lennert Buytenhek (4):
      ARM: pxa: fix logic error in PJ4 iWMMXt handling
      ARM: mmp: Also start timer 1 on boot.
      ARM: mmp: Switch to using timer 1 as clocksource timer.
      ARM: mmp: Change the way we use timer 0 as clockevent timer.

Linus Torvalds (5):
      cred: use 'const' in get_current_{user,groups}
      autofs4: clean up uaotfs use of debug/info/warning printouts
      autofs4: fix debug printk warning uncovered by cleanup
      Revert "EDAC: Correct Kconfig dependencies"
      Linux 3.1-rc2

Linus Walleij (1):
      mach-sa1100: fix PCI build problem

Luis de Bethencourt (1):
      Documentation: drop Linux Source Driver from kernel-docs references

Marcos Souza (1):
      Documentation: befs.txt: no maintainer, orphaned

Mark Brown (10):
      ASoC: Disable wm_hubs periodic DC servo update
      ASoC: Rename WM8915 to WM8996
      ASoC: Acknowledge WM8996 interrupts before acting on them
      ASoC: Fix binding of WM8750 on Jive
      ASoC: Fix SPI driver binding for WM8987
      ASoC: Fix warning in Speyside WM8962
      ASoC: Fix typo in wm8750 spi_ids
      ASoC: Add missing break in WM8994 probe
      ASoC: Terminate WM8750 SPI device ID table
      mmc: sdhci-s3c: Fix build for header change

Matvejchikov Ilya (1):
      slip: fix NOHZ local_softirq_pending 08 warning

Maxim Nikulin (1):
      USB: assign instead of equal in usbtmc.c

Maxin John (1):
      arch:arm:plat-omap:iovmm: remove unused variable 'va'

Mehnert, Torsten (1):
      i.MX25 GPT clock fix: ensure correct the clock source

Michal Hocko (1):
      Revert "memcg: get rid of percpu_charge_mutex lock"

Michał Mirosław (1):
      mmc: cb710: fix possible pci_dev leak in cb710_pci_configure()

Mike Waychison (1):
      tcp: initialize variable ecn_ok in syncookies path

Miller Puckette (1):
      ALSA: usb-audio - add quirk for Keith McMillen StringPort

Ming Lei (1):
      usb: host: ehci-omap: fix .remove and failure handling path of .probe(v1)

Nick Bowler (1):
      USB: usb-storage: unusual_devs entry for ARM V2M motherboard.

Nicolai Krakowiak (1):
      ALSA: snd-usb: avoid dividing by zero on invalid input

Nicolas de Pesloüan (1):
      bonding: document two undocumented options.

Nishanth Aravamudan (1):
      powerpc/kvm: Fix build errors with older toolchains

Nishanth Menon (1):
      OMAP3+: SR: ensure pm-runtime callbacks can be invoked with IRQs disabled

Nitin Gupta (1):
      zcache: Fix build error when sysfs is not defined

Oleg Drokin (1):
      Update Nook Color machine 3284 to common Encore name

Oliver Hartkopp (1):
      slcan: ldisc generated skbs are received in softirq context

Paul Gortmaker (1):
      staging: ft1000_proc needs asm/io.h for inw/outw on sparc

Paul Mcquade (1):
      Documentation: email-clients: Add better Thunderbird information

Paul Walmsley (1):
      OMAP: hwmod: fix build break on non-OMAP4 multi-OMAP2 builds

Pekka Enberg (1):
      perf symbols: Check '/tmp/perf-' symbol file ownership

Peng Tao (1):
      NFS41: make PNFS_BLOCK selectable

Peter Ujfalusi (1):
      OMAP: Fix linking error in twl-common.c for OMAP2/3/4 only builds

Peter Zijlstra (2):
      ppc: Remove duplicate definition of PV_POWER7
      mm: Fix fixup_user_fault() for MMU=n

Philip Rakity (1):
      mmc: sdhci: pxav3: controller needs 32 bit ADMA addressing

Rabin Vincent (1):
      usb: musb: fix Kconfig

Rajkumar Manoharan (2):
      ath9k_hw: Fix incorrect Tx control power in AR9003 template
      ath9k_hw: update PMU to improve ripple issue for AR9485

Ralf Baechle (1):
      PCnet: Fix section mismatch

Ralf Thielow (1):
      Documentation: SubmittingDrivers: fix Linus's git tree URL

Randy Dunlap (1):
      Documentation: kernel-parameters.txt cleanups

Raphaël Assénat (1):
      am3505/3517: Various platform defines for UART4

Richard Cochran (2):
      gianfar: fix fiper alignment after resetting the time
      dp83640: increase receive time stamp buffer size

Roberto Sassu (1):
      eCryptfs: fix compile error

Russell King (4):
      Staging: Add clk API note to nvec/TODO
      ARM: Fix build error for SMP=n builds
      dmaengine: PL08x: Fix trivial build error
      ARM: drop experimental status for ARM_PATCH_PHYS_VIRT

Sangbeom Kim (1):
      ASoC: SAMSUNG: Add I2S0 internal dma driver

Sarah Sharp (1):
      xhci: Don't submit commands or URBs to halted hosts.

Scott Wood (2):
      powerpc: mtspr/mtmsr should take an unsigned long
      powerpc: Return the_cpu_ spec from identify_cpu

Sebastian Andrzej Siewior (3):
      usb/config: use proper endian access for wMaxPacketSize
      usb: gadget: fusb300: remove #if 0 block
      usb: gadget: composite: fix bMaxPacketSize for SuperSpeed

Sebastian Bauer (1):
      usb: gadget: hid: don't STALL when processing a HID Descriptor request

Sergei Trofimovich (1):
      usb: musb: tusb6010_omap: fix build failure: error: 'musb' undeclared

Sergiu Iordache (1):
      Documentation: add Ramoops usage description

Seungwon Jeon (1):
      mmc: dw_mmc: Fix DDR mode support.

Shashidhar Hiremath (1):
      mmc: dw_mmc: Fix mask in IDMAC_SET_BUFFER1_SIZE macro

Shawn Guo (1):
      usb/ehci-mxc: add missing inclusion of mach/hardware.h

Stefan Lippers-Hollmann (1):
      staging: rtl8192u: declare MODULE_FIRMWARE

Stephen Boyd (1):
      Documentation: add ARM user_debug to kernel-parameters.txt

Stephen Warren (4):
      ASoC: Tegra: tegra_pcm_deallocate_dma_buffer: Don't OOPS
      ASoC: Tegra: wm8903 machine driver: Allow re-insertion of module
      ASoC: WM8903: Free IRQ on device removal
      dt: add empty of_get_property for non-dt

Takashi Iwai (7):
      ALSA: hda - Fix digital-mic mono recording on ASUS Eee PC
      ALSA: hda - Use auto-parser for ASUS UX50, Eee PC P901, S101 and P1005
      ALSA: hdspm - Fix uninitialized compile warnings
      ALSA: Fix dependency of CONFIG_SND_TEA575X
      ALSA: timer - Fix Oops at closing slave timer
      ALSA: timer - Add NULL-check for invalid slave timer
      ASoC: Fix compile warning in wm8750.c

Tanmay Upadhyay (2):
      ARM: pxa168/gplugd: get rid of mfp-gplugd.h
      ARM: pxa168/gplugd: free correct GPIO

Tetsuo Handa (1):
      TOMOYO: Fix incomplete read of /sys/kernel/security/tomoyo/profile

Thadeu Lima de Souza Cascardo (4):
      staging: fix zcache building
      staging: zcache: module is GPL
      staging: zcache: include module.h for MODULE_LICENSE
      zcache: Use div_u64 for 64-bit division

Thomas Meyer (2):
      ALSA: asihpi - use kzalloc()
      arm: mach-omap2: mux: use kstrdup()

Tim Chen (1):
      scm: Capture the full credentials of the scm sender

Tony Lin (1):
      mmc: esdhc-imx: fix card interrupt loss on freescale eSDHC

Tracey Dent (1):
      MAINTAINERS: Update linus' git repository

Tyler Hicks (2):
      eCryptfs: Return error when lower file pointer is NULL
      eCryptfs: Fix payload_len unitialized variable warning

Uwe Bonnes (1):
      usb: serial: ftdi_sio.c: For the FT232H
FTDI_SIO_SET_BAUDRATE_REQUEST, index needs to be shifted too

Vasiliy Kulikov (1):
      move RLIMIT_NPROC check from set_user() to do_execve_common()

Vijay Chavan (1):
      USB: Serial: Added device ID for Qualcomm Modem in Sagemcom's HiLo3G

Vladislav Zolotarov (2):
      bnx2x: init FCOE FP only once
      bnx2x: fix select_queue when FCoE is disabled

Wang Shaoyan (3):
      ALSA: hda - Fix a complile warning in patch_via.c
      sound: pss - don't use the deprecated function check_region
      ALSA: hda - Add CONFIG_SND_HDA_POWER_SAVE to stac_vrefout_set()

Wanlong Gao (1):
      drivers:staging:solo6x10:add the missed slab.h

Willem de Bruijn (1):
      net: add Documentation/networking/scaling.txt

Wolfram Sang (1):
      ASoC: sgtl5000: fix cache handling

Youquan Song (1):
      perf, x86: Add model 45 SandyBridge support

Zac Storer (1):
      Documentation: fix spelling error in SubmittingPatches

Zhu Yanhai (1):
      perf lock: Dropping unsupported ':r' modifier

huajun li (1):
      rtl8150: rtl8150_disconnect(...) does not need tasklet_disable(...)

wwang (1):
      staging:rts_pstor: fix thread synchronization flow
