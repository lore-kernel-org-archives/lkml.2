Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab1BADfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 22:35:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520Ab1BADfl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 22:35:41 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Feb 2011 13:31:55 +1000
Message-ID: <AANLkTik4Ko==G5s3WR8HT3ALW_Yf6ybmC78=VgrS91G6@mail.gmail.com>
Subject: Linux 2.6.38-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So due to LCA -rc2 was a few days early, and to balance things out,
-rc3 is a few days late. So now we're back to a weekly schedule since
I'll be done with travel soon (I'm currently on my way back - at the
airport in Cairns, fleeing cyclone Yasi).

Nothing hugely special in here, and I'm happy to say that most of the
pull requests have been nice clear bug-fixes and fixing regressions.
Thanks to most of you for that.

So go out and test, we seem to be doing pretty well this release cycle.

             Linus "famous last words" Torvalds

---

Adrian Hunter (1):
      omap: DMA: clear interrupt status correctly

Akinobu Mita (1):
      x86: Use asm-generic/cacheflush.h

Alan Cox (2):
      Documentation: Fix kernel parameter ordering
      intel_scu_ipcutils: Fix the license tag

Alan Stern (6):
      USB: usb-storage: unusual_devs entry for CamSport Evo
      USB: EHCI: fix DMA deallocation bug
      USB: g_printer: fix bug in unregistration
      USB: g_printer: fix bug in module parameter definitions
      USB serial: add missing .usb_driver field in serial drivers
      PM / Runtime: Don't enable interrupts while running in_interrupt

Alex Deucher (9):
      drm/radeon/kms: fix a spelling error in an error message
      drm/radeon/kms: make the mac rv630 quirk generic
      drm/radeon/kms: match r6xx/r7xx/evergreen asic_reset with previous asics
      drm/radeon/kms: simplify atom adjust pll setup
      drm/radeon/kms: add new radeon_info ioctl query for clock crystal freq
      drm/radeon/kms: only enable HDMI mode if radeon audio is enabled
      drm/radeon/kms: clean up some magic numbers
      drm/radeon/kms: fix r6xx+ scanout on BE systems
      drm/radeon/kms: re-emit full context state for evergreen blits

Alex He (1):
      USB: EHCI: ASPM quirk of ISOC on AMD Hudson

Alexander Gordeev (2):
      parport: make lockdep happy with waitlist_lock
      pps: claim parallel port exclusively

Alexander Holler (1):
      Bluetooth: ath3k: reduce memory usage

Alexandre Peixoto Ferreira (2):
      Input: synaptics - fix reconnect logic on MT devices
      Input: synaptics - retry failed resets when reconnecting

Amerigo Wang (1):
      video: fix some comments in drivers/video/console/vgacon.c

Andiry Xu (6):
      xHCI: synchronize irq in xhci_suspend()
      xHCI: fix queue_trb in isoc transfer
      xHCI: remove redundant parameter in giveback_first_trb()
      xHCI: fix cycle bit set in giveback_first_trb()
      xHCI: replace dev_dbg() with xhci_dbg()
      xHCI: fix printk_ratelimit() usage

Andrea Arcangeli (2):
      thp: fix PARAVIRT x86 32bit noPAE
      mm: compaction: don't depend on HUGETLB_PAGE

Andreas Gruenbacher (1):
      Export the augmented rbtree helper functions

Andreas Mohr (1):
      ALSA: azt3328 -  fix broken AZF_FMT_XLATE macro

Andrew Morton (1):
      mm/pgtable-generic.c: fix CONFIG_SWAP=n build

Andy Adamson (4):
      NFS do not find client in NFSv4 pg_authenticate
      NFS fix cb_sequence error processing
      NFS improve pnfs_put_deviceid_cache debug print
      NFS construct consistent co_ownerid for v4.1

Andy Whitcroft (1):
      Input: sysrq - ensure sysrq_enabled and __sysrq_enabled are consistent

Anssi Hannula (1):
      ahci: add HFLAG_YES_FBS and apply it to 88SE9128

Anton Altaparmakov (1):
      NTFS: Fix invalid pointer dereference in ntfs_mft_record_alloc().

Anton Blanchard (1):
      powerpc, perf: Fix frequency calculation for overflowing
counters (FSL version)

Arend van Spriel (2):
      staging: brcm80211: remove assert to avoid panic since 2.6.37 kernel
      staging: brcm80211: fix suspend/resume issue in brcmsmac

Arnaldo Carvalho de Melo (5):
      perf test: Fix build on older glibcs
      perf tools: Fix 64 bit integer format strings
      perf tools: Add missing header, fixes build
      perf tools: Fix build when using gcc 3.4.6
      perf tools: Fix build by checking if extra warnings are supported

Arnaud Patard (1):
      USB: ehci-mxc: add work-around for efika mx/sb bug

Artem Bityutskiy (1):
      Revert "UBI: use mtd->writebufsize to set minimal I/O unit size"

Aurelien Jarno (1):
      sh: Fix sh build failure when CONFIG_SFC=m

Axel Köllhofer (1):
      staging: r8712u: Add new device IDs

Axel Lin (7):
      video: nuc900fb: fix compile error
      video: nuc900fb: properly free resources in nuc900fb_remove
      video: pxa3xx-gcu: Return -EFAULT when copy_from_user() fails
      video: da8xx-fb: fix fb_probe error path
      video: pxa168fb: remove a redundant pxa168fb_check_var call
      intel_scu_ipc: fix signedness bug
      leds: leds-pwm: return proper error if pwm_request failed

Ben Skeggs (6):
      drm/nouveau: remove dead function definition
      drm/nouveau: probe for adt7473 before f75375
      drm/nvc0: fix incorrect TPC register setup
      drm/nvc0: implement irq handler for whatever's at 0x14xxxx
      drm/nvc0/grctx: correct an off-by-one
      drm/nv50: fix regression on IGPs

Borislav Petkov (1):
      x86, hotplug: Fix powersavings with offlined cores on AMD

Catalin Marinas (2):
      ARM: 6637/1: Make the argument to virt_to_phys() "const volatile"
      kmemleak: Allow kmemleak metadata allocations to fail

Chris Wilson (11):
      drm/i915: Initialise ring vfuncs for old DRI paths
      drm/i915: Add dependency on CONFIG_TMPFS
      drm/i915: Don't kick-off hangcheck after a DRI interrupt
      drm/i915/ringbuffer: Fix use of stale HEAD position whilst
polling for space
      drm/i915: Fix use of invalid array size for ring->sync_seqno
      drm/i915: Recognise non-VGA display devices
      drm/i915,agp/intel: Do not clear stolen entries
      drm/i915: Increase the amount of defense before computing vblank
timestamps
      drm/i915: Disable high-precision vblank timestamping for UMS
      drm/i915: Handle the no-interrupts case for UMS by polling
      drm/i915: Prevent uninitialised reads during error state capture

Chuck Lever (7):
      NFS: Fix "kernel BUG at fs/aio.c:554!"
      NFS: Fix "kernel BUG at fs/nfs/nfs3xdr.c:1338!"
      NFS: nfsacl_{encode,decode} should return signed integer
      NFS: Prevent memory allocation failure in nfsacl_encode()
      NLM: Fix "kernel BUG at fs/lockd/host.c:417!" or ".../host.c:283!"
      NFS: Micro-optimize nfs4_decode_dirent()
      NFS: NFSv4 readdir loses entries

Colin Cross (2):
      ARM: tegra: irq: Rename gic pointers to avoid conflicts
      ARM: tegra: clock: Add forward reference to struct clk

Craig Shelley (2):
      USB: CP210x Add two device IDs
      USB: CP210x Removed incorrect device ID

Dan Carpenter (2):
      Staging: ste_rmi4: use after input_unregister_device()
      Staging: xgfib: put parenthesis in the right place

Dan Williams (1):
      USB: qcaux: add Pantech UML290 device ID

Daniel Morsing (1):
      OMAP3: Devkit8000: Fix tps65930 pullup/pulldown configuration

Daniel Walker (2):
      mmc: msm: fix dma usage not to use internal APIs
      drivers: mmc: msm: remove clock disable in probe

Dario Lombardo (1):
      drivers: update to pl2303 usb-serial to support Motorola cables

Dave Airlie (1):
      vt: fix issue when fbcon wants to takeover a second time.

Dave Chinner (8):
      xfs: fix log ticket leak on forced shutdown.
      xfs: fix efi item leak on forced shutdown
      xfs: speculative delayed allocation uses rounddown_power_of_2 badly
      xfs: limit extent length for allocation to AG size
      xfs: prevent extsize alignment from exceeding maximum extent size
      xfs: limit extsize to size of AGs and/or MAXEXTLEN
      xfs: handle CIl transaction commit failures correctly
      xfs: fix dquot shaker deadlock

Dave Jones (1):
      x86: Update CPU cache attributes table descriptors

David Engraf (1):
      Input: serio - allow registered drivers to get status flag

David Henningsson (2):
      ALSA: HDA: Fix dmesg output of HDMI supported bits
      ALSA: HDA: Fix automute on Thinkpad L412/L512

David Howells (1):
      KEYS: Fix __key_link_end() quota fixup on error

David Rientjes (2):
      mm: fix deferred congestion timeout if preferred zone is not allowed
      mm: clear pages_scanned only if draining a pcp adds pages to the
buddy allocator

David S. Miller (4):
      inetpeer: Use correct AVL tree base pointer in inet_getpeer().
      ipv6: Always clone offlink routes.
      ipv6: Revert 'administrative down' address handling changes.
      xfrm6: Don't forget to propagate peer into ipsec route.

David Sterba (2):
      Bluetooth: l2cap: fix misuse of logical operation in place of bitop
      USB: cdc-wdm: fix misuse of logical operation in place of bitop

Davidlohr Bueso (2):
      Input: ct82710c - return proper error code for ct82c710_open
      selinux: return -ENOMEM when memory allocation fails

Denis Kirjanov (1):
      staging: rt2860: Fix incorrect netif_stop_queue usage warning

Dimitris Michailidis (1):
      cxgb4: fix reported state of interfaces without link

Dimitris Papastamos (1):
      ASoC: WM8995: Fix incorrect use of snd_soc_update_bits()

Dmitry Eremin-Solenikov (1):
      ASoC: correct link specifications for corgi, poodle and spitz

Dmitry Torokhov (3):
      Input: sparse-keymap - fix KEY_VSW handling in sparse_keymap_setup
      module: show version information for built-in modules in sysfs
      Input: rc-keymap - return KEY_RESERVED for unknown mappings

Dr. David Alan Gilbert (1):
      perf symbols: Fix annotation of thumb code

Eric Bénard (1):
      USB: unbreak ehci-mxc on otg port of i.MX27

Eric Dumazet (4):
      net_sched: accurate bytes/packets stats/rates
      net: arp_ioctl() must hold RTNL
      tcp: fix bug in listening_get_next()
      percpu, x86: Fix percpu_xchg_op()

Eugene Teo (1):
      net: clear heap allocation for ethtool_get_regs()

Fabio Estevam (1):
      usb: otg: Make USB3319 ULPI ID generic

Felipe Balbi (2):
      OMAP: PRCM: remove duplicated headers
      arm: omap2: mux: fix compile warning

Felix Fietkau (2):
      ath9k: add missing ps wakeup/restore calls
      mac80211: fix a crash in ieee80211_beacon_get_tim on change_interface

Feng Tang (1):
      langwell_gpio: modify EOI handling following change of kernel
irq subsystem

Fenghua Yu (1):
      x86, mcheck, therm_throt.c: Export symbol
platform_thermal_notify to allow coretemp to handler intr

Francesco Antonacci (1):
      libata: DVR-212D can't do SETXFER DVD-RW DVR-212D

Francisco Jerez (2):
      drm/nouveau: Workaround incorrect DCB entry on a GeForce3 Ti 200.
      drm/nv50: Fix race with PFIFO during PGRAPH context destruction.

Fred Isaman (1):
      NFS: fix handling of malloc failure during nfs_flush_multi()

Geert Uytterhoeven (3):
      m68k: Uninline strchr()
      m68k/atari: Rename "scc" to "atari_scc"
      m68k/amiga: Fix "debug=mem"

Grant Likely (1):
      arm/tegra: Fix tegra irq_data conversion

Greg Kroah-Hartman (2):
      Staging: remove unintended Module.symvers file
      rt2x00: add device id for windy31 usb device

Guennadi Liakhovetski (1):
      sh: fix MSIOF0 SPI on ecovec: it conflicts with VOU

Guzman Lugo, Fernando (1):
      staging: tidspbridge: configure full L1 MMU range

Han Pingtian (1):
      perf test: Use cpu_map->[cpu] when setting affinity

Hank Janssen (1):
      staging: hv: Removed unneeded call to netif_stop_queue() in hv_netvsc

Hans-Christian Egtvedt (2):
      ALSA: fix invalid hardware.h include in ac97c for AVR32 architecture
      avr32: add missing include causing undefined pgtable_page_* references

Hartley Sweeten (1):
      ARM: 6636/1: ep93xx: default multiplexed gpio ports to gpio mode

Henrik Rydberg (1):
      hwmon: (applesmc) Properly initialize lockdep attributes

Huang Weiyi (1):
      intel_scu_ipc: remove duplicated #include

Ian Abbott (1):
      staging: comedi: ni_labpc: Use shared IRQ for PCMCIA card

Igor Grinberg (2):
      arm: omap3: cm-t3517: rtc fix
      arm: omap3: cm-t3517: minor comment fix

Jaehoon Chung (1):
      mmc: sdhci-s3c: add platform_8bit_width() hook

Jamie Iles (3):
      Input: tnetv107x-keypad - don't treat NULL clk as an error
      Input: tnetv107x-ts - don't treat NULL clk as an error
      mmc: jz4740: don't treat NULL clk as an error

Jeff Garzik (1):
      Delete zero-length drivers/staging/vme/bridges/Module.symvers

Jerome Glisse (1):
      radeon/kms: fix dp displayport mode validation

Jerry Chu (1):
      TCP: fix a bug that triggers large number of TCP RST by mistake

Jesper Dangaard Brouer (1):
      textsearch: doc - fix spelling in lib/textsearch.c.

Jesper Juhl (10):
      rtlwifi: Fix possible NULL dereference
      ALSA: Xonar, CS43xx: Don't overrun static array
      trusted keys: Fix a memory leak in trusted_update().
      CIFS: Remove pointless variable assignment in cifs_dfs_do_automount()
      x86-64: Don't use pointer to out-of-scope variable in dump_trace()
      USB NET KL5KUSB101: Fix mem leak in error path of
kaweth_download_firmware()
      NFS4: Avoid potential NULL pointer dereference in decode_and_add_ds().
      mm/memcontrol.c: fix uninitialized variable use in
mem_cgroup_move_parent()
      mmc: ushc: Remove duplicate include of usb.h
      kmemleak: remove memset by using kzalloc

Jesse Barnes (2):
      drm/i915: set more FBC chicken bits
      drm/i915: make the blitter report buffer modifications to the FBC unit

Johan Hedberg (6):
      Bluetooth: Fix leaking blacklist when unregistering a hci device
      Revert "Bluetooth: Update sec_level/auth_type for already
existing connections"
      Bluetooth: Fix MITM protection requirement preservation
      Bluetooth: Create a unified auth_type evaluation function
      Bluetooth: Fix authentication request for L2CAP raw sockets
      Bluetooth: Fix race condition with conn->sec_level

John Fastabend (1):
      dcbnl: make get_app handling symmetric for IEEE and CEE DCBx

John Stultz (3):
      rtc: Cleanup removed UIE emulation declaration
      RTC: Propagate error handling via rtc_timer_enqueue properly
      RTC: Properly handle rtc_read_alarm error propagation and fix bug

Julia Lawall (2):
      drivers/video/bf537-lq035.c: Add missing IS_ERR test
      arch/arm/mach-omap2/dma.c: Convert IS_ERR result to PTR_ERR

KAMEZAWA Hiroyuki (3):
      memcg: fix account leak at failure of memsw acconting
      memcg: bugfix check mem_cgroup_disabled() at split fixup
      memcg: fix race at move_parent around compound_order()

Kacper Kornet (1):
      Fix prlimit64 for suid/sgid processes

Kalhan Trisal (1):
      hwmon: (lis3) turn down the no IRQ message

Kay Sievers (1):
      tty: use for_each_console() and WARN() on sysfs failures

Konrad Rzeszutek Wilk (1):
      acpi_pm: Clear pmtmr_ioport if acpi_pm initialization fails

Kuninori Morimoto (2):
      ARM: mach-shmobile: clock-sh7372: fixup pllc2 set_rate
      ARM: mach-shmobile: ag5evm: Add IrDA support

Kurt Van Dijck (2):
      can: add driver for Softing card
      can: add driver for Softing card

Ky Srinivasan (1):
      Staging: hv: fix sysfs symlink on hv block device

Larry Finger (2):
      staging: rt2870sta: Add ID for Linksys WUSB100v2
      staging: r8712u: Fix memory leak in firmware loading

Lars-Peter Clausen (2):
      ASoC: Fix codec device id format used by some dai_links
      ASoC: Samsung: Fix outdated cpu_dai_name for s3c24xx i2s

Libor Pechacek (1):
      USB: serial: handle Data Carrier Detect changes

Linus Torvalds (1):
      Linux 2.6.38-rc3

Linus Walleij (3):
      param: add null statement to compiled-in module params
      ARM: 6632/3: mmci: stop using the blockend interrupts
      ARM: 6642/1: mmci: calculate remaining bytes at error correctly

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Override interface detection on Sabertooth X58

Luis R. Rodriguez (1):
      ath9k_hw: disabled PAPRD for AR9003

Lukáš Turek (1):
      Bluetooth: Never deallocate a session when some DLC points to it

Magnus Damm (7):
      ARM: mach-shmobile: sh7372 INTCS MFIS2 interrupt update
      ARM: mach-shmobile: remove sh7367 on-chip set_irq_type()
      ARM: mach-shmobile: sh73a0 CPGA fix for FRQCRA M3
      ARM: mach-shmobile: sh73a0 CPGA fix for IrDA MSTP
      sh: update INTC to clear IRQ sense valid flag
      ARM: mach-shmobile: sh73a0 CPGA fix for PLL CFG bit
      ARM: mach-shmobile: AG5EVM LCDC / MIPI-DSI platform data

Marc Kleine-Budde (3):
      can: at91_can: clean up usage of AT91_MB_RX_FIRST and AT91_MB_RX_NUM
      can: at91_can: don't use mailbox 0
      can: at91_can: make can_id of mailbox 0 configurable

Marek Olšák (1):
      drm/radeon/kms: release CMASK access in preclose_kms

Mark Brown (1):
      ASoC: Handle low measured DC offsets for wm_hubs devices

Matt Carlson (1):
      tg3: Use new VLAN code

Matthew Wilcox (1):
      xhci: Remove more doorbell-related reads

Matthieu CASTET (1):
      x86: Fix jump label with RO/NX module protection crash

Maulik Mankad (1):
      usb: gadget: composite: avoid access beyond array max length

Max Vozeler (7):
      staging: usbip: stub: update refcounts for devices and interfaces
      staging: usbip: vhci: update reference count for usb_device
      staging: usbip: vhci: give back URBs from in-flight unlink requests
      staging: usbip: vhci: refuse to enqueue for dead connections
      staging: usbip: vhci: friendly log messages for connection errors
      staging: usbip: vhci: handle EAGAIN from SO_RCVTIMEO
      staging: usbip: vhci: use urb->dev->portnum to find port

Melchior FRANZ (1):
      USB: DL100B webmail notifier: initialize return value

Michael Chan (3):
      bnx2: Always set ETH_FLAG_TXVLAN
      cnic: Fix big endian bug
      bnx2: Eliminate AER error messages on systems not supporting it

Michael Karcher (1):
      drm/i915: Use consistent mappings for OpRegion between ACPI and i915

Michael S. Tsirkin (1):
      virtio: update MAINTAINERS

Michal Schmidt (1):
      GRO: fix merging a paged skb after non-paged skbs

Michel Dänzer (1):
      drm/radeon/kms: Initialize pageflip spinlocks.

Mimi Zohar (3):
      trusted-keys: rename trusted_defined files to trusted
      encrypted-keys: rename encrypted_defined files to encrypted
      keys: add trusted and encrypted maintainers

Minchan Kim (1):
      mm: migration: clarify migrate_pages() comment

Ming Lei (1):
      usb: otg: nop: fix oops triggered by otg_register_notifier

Naveen Kumar Gaddipati (2):
      Input: bu21013_ts - remove duplicate resolution parameters
      Input: bu21013_ts - added regulator support

Neil Horman (1):
      bonding: Ensure that we unshare skbs prior to calling pskb_may_pull

Nicolas de Pesloüan (1):
      bonding: update documentation - alternate configuration.

Nicolaus Colberg (1):
      USB: adding USB support for Cinterion's HC2x, EU3 and PH8 products

Nobuhiro Iwamatsu (1):
      sh: Fix build of sh7750 base boards

Oleg Nesterov (3):
      perf: Fix find_get_context() vs perf_event_exit_task() race
      perf: Fix perf_event_init_task()/perf_event_free_task() interaction
      perf: perf_event_exit_task_context: s/rcu_dereference/rcu_dereference_raw/

Olof Johansson (1):
      tpm: fix panic caused by "tpm: Autodetect itpm devices"

Omar Ramirez Luna (1):
      staging: tidspbridge: replace mbox callback with notifier_call

Paul Fulghum (1):
      n_hdlc: fix read and write locking

Paul Mundt (4):
      sh: Fix up breakage from asm-generic/pgtable.h changes.
      sh: support XZ-compressed kernel.
      mmc: sh_mmcif: Convert to __raw_xxx() I/O accessors.
      mailmap: Add an entry for Axel Lin.

Paul Turner (3):
      sched: Fix sign under-flows in wake_affine
      sched: Fix/remove redundant cfs_rq checks
      sched: Use rq->clock_task instead of rq->clock for correctly
maintaining load averages

Paul Walmsley (2):
      OMAP: counter_32k: init clocksource as part of machine timer init
      OMAP4: clockdomain: bypass unimplemented wake-up dependency
functions on OMAP4

Pavankumar Kondeti (2):
      USB: gadget: Fix error path in ci13xxx_udc gadget probe function
      USB: gadget: Fix endpoint representation in ci13xxx_udc

Pavel Machek (1):
      serial: unbreak billionton CF card

Pavel Shilovsky (2):
      CIFS: Implement cifs_strict_writev (try #4)
      CIFS: Add strictcache mount option

Pawel Moll (1):
      ARM: 6635/2: Configure reference clock for Versatile Express timers

Peter Chen (1):
      usb: set ep_dev async suspend should be later than device_initialize

Peter Tyser (1):
      USB: ehci-fsl: Fix 'have_sysif_regs' detection

Peter Zijlstra (1):
      perf: Annotate cpuctx->ctx.mutex to avoid a lockdep splat

Philippe Langlais (1):
      Input: gpio_keys - switch to using request_any_context_irq

Phillip Lougher (1):
      squashfs: fix use of uninitialised variable in zlib & xz decompressors

Phillip Simbwa (1):
      Staging: ath6kl: fix potential buffer overflow

Pieter Maes (1):
      USB: serial: Updated support for ICOM devices

Ping Cheng (2):
      Input: wacom - add 2 Bamboo Pen and touch models
      Input: wacom - pass touch resolution to clients through input_absinfo

Qiao Zhou (1):
      ASoC: WM8994: fix wrong value in tristate function

Rajashekhara, Sudhakar (1):
      ASoC: da8xx/omap-l1xx: match codec_name with i2c ids

Rajiv Andrade (1):
      TPM: Long default timeout fix

Rakesh Iyer (3):
      Input: tegra-kbc - add tegra keyboard driver
      Input: tegra-kbc - fix build error
      Input: tegra-kbc - fix keymap entry for LeftMeta key

Randy Dunlap (5):
      tty/serial: fix apbuart build
      docbook: fix broken serial to tty/serial movement
      rapidio: fix new kernel-doc warnings
      fs: fix new dcache.c kernel-doc warnings
      kernel.h: fix kernel-doc warning

Reinette Chatre (1):
      MAINTAINERS: remove Reinette Chatre as iwlwifi maintainer

Richard Schütz (2):
      USB: usb-storage: unusual_devs update for Cypress ATACB
      USB: usb-storage: unusual_devs update for TrekStor DataStation
maxi g.u external hard drive enclosure

Rob Landley (1):
      Make CIFS mount work in a container.

Rodolfo Giometti (1):
      pps ktimer: remove noisy message

Roland Stigge (2):
      iio: Fixpoint formatted output bugfix
      Staging: iio: Aditional fixpoint formatted output bugfix

Russell King (13):
      ARM: realview,vexpress: fix section mismatch warning for pen_release
      ARM: realview: name configuration options after actual board names
      ARM: versatile: name configuration options after actual board names
      ARM: twd: ensure timer reload is reprogrammed on entry to periodic mode
      ALSA: AACI: fix timeout condition checking
      ALSA: AACI: fix timeout duration
      omap2+: Fix unused variable warning for omap_irq_base
      ARM: mmci: complete the transaction on error
      ARM: mmci: round down the bytes transferred on error
      ARM: footbridge: fix debug macros
      ARM: initrd: disable initrd if passed address overlaps reserved region
      ARM: io: ensure inb/outb() et.al. are properly ordered on ARMv6+
      ARM: smp_on_up: allow non-ARM SMP processors

Russell King - ARM Linux (1):
      mmc: mmci: don't read command response when invalid

Rusty Russell (4):
      module: fix linker error for MODULE_VERSION when !MODULE and
CONFIG_SYSFS=n
      module: fix missing semicolons in MODULE macro usage
      BUILD_BUG_ON: make it handle more cases
      Remove MAYBE_BUILD_BUG_ON

Ryusuke Konishi (1):
      nilfs2: fix crash after one superblock became unavailable

Sage Weil (6):
      ceph: fix xattr rbtree search
      ceph: fix cap_wanted_delay_{min,max} mount option initialization
      ceph: fix erroneous cap flush to non-auth mds
      ceph: fix flushing of caps vs cap import
      ceph: avoid immediate cap check after import
      ceph: avoid picking MDS that is not active

Sarah Sharp (3):
      xhci: Resume bus on any port status change.
      usb: Realloc xHCI structures after a hub is verified.
      xhci: Use GFP_NOIO during device reset.

Sergei Shtylyov (5):
      USB: uss720: remove duplicate USB device
      pata_hpt{366|37x}: use pr_warning(...) instead of printk(KERN_WARNING ...)
      pata_hpt{37x|3x2n}: use pr_*(DRV_NAME ...) instead of printk(KERN_* ...)
      pata_hpt37x: fold 'if' statement into 'switch'
      pata_hpt37x: inherit prereset() method for HPT374

Seth Heasley (1):
      ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs

Shaohua Li (1):
      fix a shutdown regression in intel_idle

Shirish Pargaonkar (1):
      cifs: More crypto cleanup (try #2)

Simon Horman (1):
      ARM: mach-shmobile: mackerel: clarify shdi/mmcif switch settings

Sonic Zhang (1):
      mmc: bfin_sdh: fix alloc size for private data

Stanislaw Gruszka (1):
      MAINTAINERS: add ueagle-atm entry

Stefan Bader (1):
      xen/p2m: Mark INVALID_P2M_ENTRY the mfn_list past max_pfn.

Stefano Stabellini (2):
      xen/e820: Guard against E820_RAM not having page-aligned size or start.
      xen/setup: Route halt operations to safe_halt pvop.

Stephen Boyd (1):
      hrtimers: Notify hrtimer users of switches to NOHZ mode

Steve French (1):
      [CIFS] Replace cifs md5 hashing functions with kernel crypto APIs

Takashi YOSHII (2):
      ARM: mach-shmobile: fix cpu_base of gic_init() on sh73a0
      ARM: mach-shmobile: ag5evm requires GPIOLIB

Tejun Heo (3):
      pch_gbe: don't use flush_scheduled_work()
      pata_mpc52xx: inherit from ata_bmdma_port_ops
      libata: set queue DMA alignment to sector size for ATAPI too

Thomas Renninger (1):
      perf tools: Fix time function double declaration with glibc

Timo Teräs (1):
      staging: hv: fix netvsc sleeping while atomic

Tomoya MORINAGA (1):
      USB: pch_udc: support new device ML7213 IOH

Tony Lindgren (4):
      omap1: Fix sched_clock for the MPU timer
      omap1: Fix booting for 15xx and 730 with omap1_defconfig
      omap1: Fix sched_clock implementation when both MPU timer and
32K timer are used
      omap1: Simplify use of omap_irq_flags

Torben Hohn (1):
      console: rename acquire/release_console_sem() to console_lock/unlock()

Toshiharu Okada (2):
      usb: pch_udc: Fixed issue which does not work with g_serial
      usb: pch_udc: Fix the worning log issue at gadget driver remove

Toshiyuki Okajima (1):
      radix_tree: radix_tree_gang_lookup_tag_slot() may never return

Trond Myklebust (2):
      NFS: nfs_wcc_update_inode() should set nfsi->attr_gencount
      NFS: Fix an NFS client lockdep issue

Uwe Kleine-König (1):
      RTC: Remove Kconfig symbol for UIE emulation

Vasiliy Kulikov (1):
      atm: idt77105: fix fetch_stats() result

Voss, Nikolaus (1):
      drivers/clocksource/tcb_clksrc.c: fix init sequence

Wey-Yi Guy (1):
      iwlwifi: don't read sku information from EEPROM for 4965

Yehuda Sadeh (1):
      ceph: fix getattr on directory when using norbytes

Yinghai Lu (1):
      x86: Remove left over system_64.h

Yong Zhang (1):
      sched: Fix poor interactivity on UP systems due to group
scheduler nice tune bug

Zhang Rui (1):
      xhci: Do not run xhci_cleanup_msix with irq disabled

bpm@sgi.com (1):
      xfs: xfs_bmap_add_extent_delay_real should init br_startblock

roel kluin (1):
      Staging: speakup: &&/|| confusion in silent_store()
