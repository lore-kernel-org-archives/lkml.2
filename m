Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2J1UAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 16:00:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62120 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2J1UAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 16:00:11 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Oct 2012 12:59:49 -0700
X-Google-Sender-Auth: 5Gml6zD9rpLK2vsYfhbMj6q74cg
Message-ID: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com>
Subject: Linux 3.7-rc3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been a week, time for -rc3!

Nothing particularly stands out here. Lots of small fixes, exemplified
by the series of memory leak fixes in usb serial drivers. Just a lot
of random stuff..

Most of it is drivers (all over: drm, wireless, staging, usb, sound),
but there's a few filesystem updates (nfs, btrfs, ext4), arch updates
(arm, x86 and m68k) and just random stuff. Shortlog appended.

And talking about the shortlog: christ people, some of you need to
change your names. I'm used to there being multiple "David"s and
"Peter"s etc, but there are three different Linus's in just this rc.
People, people, I want to feel like the unique snowflake I am, not
like just another anonymous guy in a crowd.

I'm getting myself a broadsword.

                Linus "there can be only one" Torvalds

---
Aaro Koskinen (2):
      spi: tsc2005: delete soon-obsolete e-mail address
      ARM: 7555/1: kexec: fix segment memory addresses check

Adrian Knoth (9):
      ALSA: hdspm - Allow DDS/Varispeed to be set from userspace
      ALSA: hdspm - Report external rate in slave mode on PCI MADI
      ALSA: hdspm - Fix sync check reporting on all RME HDSPM cards
      ALSA: hdspm - Fix reported autosync_sample_rate
      ALSA: hdspm - Also report autosync_sample_rate on MADI and MADIface
      ALSA: hdspm - Fix sync_in reporting on RME MADI cards
      ALSA: hdspm - Fix sync_in detection on AES/AES32
      ALSA: hdspm - Fix typo in kcontrol element on RME MADI cards
      ALSA: hdspm - Fix coding style in CTL_ELEM macros

Al Viro (1):
      alpha: separate thread-synchronous flags

Alan Cox (1):
      ACPI: missing break

Alex Deucher (6):
      drm/radeon: add some new SI PCI ids
      drm/radeon: fix sparse warning
      drm/radeon: give each backlight a unique id
      drm/radeon: add error output if VM CS fails on cayman
      drm/radeon: fix ATPX function documentation
      drm/radeon: fix ATPX regression in acpi rework

Alex Lyakas (1):
      Btrfs: Send: preserve ownership (uid and gid) also for symlinks.

Andre Przywara (1):
      x86/perf: Fix virtualization sanity check

Andreas Herrmann (1):
      cpufreq / powernow-k8: Remove usage of smp_processor_id() in
preemptible code

Andreas Larsson (1):
      iio: Remove duplicates for light/ in Kconfig and Makefile

Andrew Morton (1):
      amd64_edac:__amd64_set_scrub_rate(): avoid overindexing scrubrates[]

Andrew Vagin (1):
      pidns: limit the nesting depth of pid namespaces

Anisse Astier (2):
      ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions
      ehci: Add yet-another Lucid nohandoff pci quirk

Aristeu Rozanski (3):
      device_cgroup: rename deny_all to behavior
      device_cgroup: stop using simple_strtoul()
      device_cgroup: add proper checking when changing default behavior

Arnaldo Carvalho de Melo (2):
      perf trace: Validate syscall id before growing syscall table
      perf trace: Check if sample raw_data field is set

Arnd Bergmann (13):
      ipvs: initialize returned data in do_ip_vs_get_ctl
      ARM: kprobes: make more tests conditional
      ARM: export set_irq_flags
      ARM: Fix another build warning in arch/arm/mm/alignment.c
      ARM: export default read_current_timer
      ARM: Xen: fix initial build problems
      ARM: pass -marm to gcc by default for both C and assembler
      ARM: be really quiet when building with 'make -s'
      ARM: binfmt_flat: unused variable 'persistent'
      ARM: warnings in arch/arm/include/asm/uaccess.h
      ARM: at91: fix at91x40 build
      ARM: versatile: fix versatile_defconfig
      Revert "ARM i.MX25: Fix PWM per clock lookups"

Arne Jansen (1):
      Btrfs: send correct rdev and mode in btrfs-send

Arve Hjønnevåg (2):
      Staging: android: binder: Fix memory leak on thread/process exit
      Staging: android: binder: Allow using highmem for binder buffers

Axel Lin (4):
      extcon: adc-jack: Fix checking return value of request_any_context_irq
      extcon: adc-jack: Add missing MODULE_LICENSE
      extcon: Fix kerneldoc for extcon_set_cable_state and
extcon_set_cable_state_
      extcon: max77693: Use max77693_update_reg for rmw operations

Barry Song (2):
      dmaengine: sirf: fix a typo in dma_prep_interleaved
      dmaengine: sirf: fix a typo in moving running dma_desc to active queue

Ben Skeggs (4):
      drm/nouveau/bios: fetch full 4KiB block to determine ACPI ROM image size
      drm/nv41/vm: don't init hw pciegart on boards with agp bridge
      drm/nouveau/fb: fix reporting of memory type on GF8+ IGPs
      drm/nouveau/clock: fix missing pll type/addr when matching default entry

Bing Zhao (2):
      mwifiex: return -EBUSY if specific scan request cannot be honored
      mwifiex: clean up scan state on error

Bjørn Mork (1):
      net: qmi_wwan: adding more ZTE devices

Bo Shen (2):
      ARM: at91/i2c: change id to let i2c-gpio work
      ARM: at91/i2c: change id to let i2c-at91 work

Bob Liu (2):
      mm: cma: alloc_contig_range: return early for err path
      mm/page_alloc.c:alloc_contig_range(): return early for err path

Chanwoo Choi (1):
      extcon: MAX77693: Add platform data for MUIC device to
initialize registers

Chris Metcalf (3):
      arch/tile: avoid generating .eh_frame information in modules
      arch/tile: avoid build warnings from duplicate ELF_R_xxx #defines
      tilegx: fix some issues in the SW TSO support

Chris Wilson (2):
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H
      drm/i915: Initialize obj->pages before use by
i915_gem_object_do_bit17_swizzle()

Christian König (9):
      drm/radeon: fix PFP sync in vm_flush
      drm/radeon: fix cayman_vm_set_page v2
      drm/radeon: fix si_set_page v2
      drm/radeon: remove set_page check from VM code
      drm/radeon: fix header size estimation in VM code
      drm/radeon: fix and simplify pot argument checks v3
      drm/radeon: use vzalloc for gart pages
      drm/radeon: move size limits to gem_object_create.
      drm/radeon: move the retry to gem_object_create

Christian Lamparter (1):
      rtlwifi: pass rx setup error code to caller

Daisuke Nishimura (1):
      cgroup: notify_on_release may not be triggered in some cases

Dan Carpenter (2):
      oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()
      brcmfmac: fix end of loop check (signedness bug)

Dan Magenheimer (1):
      workqueue: cancel_delayed_work() should return %false if work item is idle

Dan Williams (1):
      qmi_wwan/cdc_ether: move Novatel 551 and E362 to qmi_wwan

Daniel Hazelton (1):
      tools/testing/selftests/epoll/test_epoll.c: fix build

Daniel Mack (1):
      usb: musb: dsps: fix res_name length

Daniel Vetter (2):
      Revert "drm/i915: Try harder to complete DP training pattern 1"
      drm/i915: shut up spurious WARN in the gtt fault handler

Dave Jones (1):
      USB: Add missing license tag to ezusb driver.

Dave Young (1):
      Revert "x86/mm: Fix the size calculation of mapping tables"

David Howells (4):
      UAPI: (Scripted) Disintegrate arch/m68k/include/asm
      UAPI: Make arch/ia64/include/asm/kvm_para.h generic
      s390,uapi: do not use uapi/asm-generic/kvm_para.h
      UAPI: fix tools/vm/page-types.c

David Rientjes (1):
      mm, numa: avoid setting zone_reclaim_mode unless a node is
sufficiently distant

David Vrabel (1):
      xen/x86: don't corrupt %eip when returning from a signal handler

Denis Kirjanov (1):
      ALSA: als3000: check for the kzalloc return value

Devendra Naga (1):
      extcon-max8997: remove usage of ret in
max8997_muic_handle_charger_type_detach

Dimitri Sivanich (1):
      x86/irq/ioapic: Check for valid irq_cfg pointer in
smp_irq_move_cleanup_interrupt

Dmitry Monakhov (2):
      ext4: serialize fallocate with ext4_convert_unwritten_extents
      ext4: race-condition protection for ext4_convert_unwritten_extents_endio

Dmitry Torokhov (2):
      char_dev: pin parent kobject
      Input: fix use-after-free introduced with dynamic minor changes

Dong Aisheng (1):
      regmap: select REGMAP if REGMAP_MMIO and REGMAP_IRQ enabled

Dotan Barak (2):
      mlx4_core: Perform correct resource cleanup if mlx4_QUERY_ADAPTER() fails
      net/mlx4_core: Unmap UAR also in the case of error flow

Doug Ledford (1):
      IB/mlx4: Fix build error on platforms where UL is not 64 bits

Egbert Eich (4):
      DRM/i915: Don't delete DPLL Multiplier during DAC init.
      DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
      DRM/i915: Don't clone SDVO LVDS with analog.
      DRM/i915: Restore sdvo_flags after dtd->mode->dtd Roundrtrip.

Eli Cohen (1):
      IB/mlx4: Synchronize cleanup of MCGs in MCG paravirtualization

Elison Niven (1):
      netfilter: xt_nat: fix incorrect hooks for SNAT and DNAT targets

Eric Dumazet (4):
      netfilter: xt_TEE: don't use destination address found in header
      netlink: use kfree_rcu() in netlink_release()
      tcp: fix FIONREAD/SIOCINQ
      net: fix secpath kmemleak

Fabio Estevam (3):
      ARM: imx_v6_v7_defconfig: Enable CONFIG_GPIO_MC9S08DZ60
      ARM: imx: clk-imx27: Fix divider width field
      ARM: mxc: platform-mxc-mmc: Fix register region size

Felipe Balbi (1):
      Revert "serial: omap: fix software flow control"

Felix Fietkau (2):
      mac80211: use ieee80211_free_txskb in a few more places
      Revert "ath9k_hw: Updated AR9003 tx gain table for 5GHz"

Franky Lin (2):
      brcmfmac: use control channel in roamed status reporting
      brcmfmac: set dongle mode accordingly when interface up

Fred Brooks (1):
      staging: comedi: ni_daq_700: fix dio subdevice regression

Gabriel de Perthuis (1):
      Fix a sign bug causing invalid memory access in the ino_paths ioctl.

Gavin Shan (1):
      mm/mmu_notifier: allocate mmu_notifier in advance

Geert Uytterhoeven (3):
      m68k: Remove empty #ifdef/#else/#endif block
      m68k: Wire up kcmp
      sysfs: sysfs_pathname/sysfs_add_one: Use strlcat() instead of strcat()

Gerald Schaefer (1):
      s390/thp: select HAVE_ARCH_TRANSPARENT_HUGEPAGE

Gleb Natapov (1):
      KVM: apic: fix LDR calculation in x2apic mode

H. Peter Anvin (1):
      Makefile: Documentation for external tool should be correct

Hante Meuleman (1):
      brcmfmac: handle all exceptions as an error.

Haojian Zhuang (1):
      pinctrl: remove mutex lock in groups show

Heiko Carstens (2):
      s390: fix linker script for 31 bit builds
      s390/cache: fix data/instruction cache output

Heiko Stuebner (1):
      ARM: SAMSUNG: Add naming of s3c64xx-spi devices

Hein Tibosch (1):
      drivers/dma/dw_dmac: make driver's endianness configurable

Hemant Kumar (1):
      net: usb: Fix memory leak on Tx data path

Hendrik Brueckner (1):
      perf_cpum_cf: Add support for counters available with IBM zEC12

Hiro Sugawara (1):
      iommu/tegra: smmu: Fix deadly typo

Huang Shijie (1):
      ARM: dts: mxs: add the "clock-names" for gpmi-nand

Ian Abbott (7):
      staging: comedi: 8255_pci: fix possible NULL deref during detach
      staging: comedi: amplc_dio200: fix possible NULL deref during detach
      staging: comedi: amplc_pc236: fix invalid register access during detach
      staging: comedi: amplc_pc236: fix possible NULL deref during detach
      staging: comedi: amplc_pc263: fix possible NULL deref during detach
      staging: comedi: das08: fix possible NULL deref during detach
      staging: comedi: ni_labpc: fix possible NULL deref during detach

Ian Campbell (11):
      xen: xenbus: quirk uses x86 specific cpuid
      xen: sysfs: include err.h for PTR_ERR etc
      xen: sysfs: fix build warning.
      xen: XENMEM_translate_gpfn_list was remove ages ago and is unused.
      xen: events: pirq_check_eoi_map is X86 specific
      xen: grant: use xen_pfn_t type for frame_list.
      xen: balloon: don't include e820.h
      xen: arm: make p2m operations NOPs
      xen: balloon: use correct type for frame_list
      xen: arm: comment on why 64-bit xen_pfn_t is safe even on 32 bit
      xen: dbgp: Fix warning when CONFIG_PCI is not enabled.

Ivan Shugov (1):
      ARM: at91: at91sam9g10: fix SOC type detection

Jack Morgenstein (2):
      IB/mlx4: Fix QP1 P_Key processing in the Primary Physical Function (PPF)
      net/mlx4_en: Fix double-release-range in tx-rings

Jacob Shin (1):
      x86, mm: Find_early_table_space based on ranges that are
actually being mapped

Jan Beulich (1):
      x86-64: Fix page table accounting

Jan Kara (1):
      mm: fix XFS oops due to dirty pages without buffers on s390

Jan Luebbe (1):
      drivers/rtc/rtc-imxdi.c: add missing spin lock initialization

Jan Schmidt (7):
      Btrfs: don't put removals from push_node_left into tree mod log twice
      Btrfs: fix a tree mod logging issue for root replacement operations
      Btrfs: tree mod log's old roots could still be part of the tree
      Btrfs: determine level of old roots
      Btrfs: fix extent buffer reference for tree mod log roots
      Btrfs: comment for loop in tree_mod_log_insert_move
      Btrfs: extended inode refs support for send mechanism

Jason Gerecke (2):
      Input: wacom - handle split-sensor devices with internal hubs
      Input: wacom - add touch sensor support for Cintiq 24HD touch

Jay Purohit (1):
      usb/ipheth: Add iPhone 5 support

Jean Delvare (2):
      Documentation: Reflect the new location of the NMI watchdog info
      MAINTAINERS: NETWORKING DRIVERS matches too much

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: drop duplicated config SOC_AT91SAM9 entry

Jenny TC (1):
      extcon : register for cable interest by cable name

Jerry Chu (1):
      tcp: Reject invalid ack_seq to Fast Open sockets

Jesper Juhl (1):
      ACPI: Fix memory leak in acpi_bind_one()

Jingoo Han (2):
      ARM: dma-mapping: fix build warning in __dma_alloc()
      backlight: ili9320: add missing SPI dependency

Jiri Olsa (1):
      perf test: Fix exclude_guest parse events tests

Jiri Pirko (1):
      vlan: allow to change type when no vlan device is hooked on netdev

Jiri Slaby (1):
      cgroup: fix invalid rcu dereference

Joe Jin (1):
      qla3xxx: Ensure request/response queue addr writes to the registers

Joe Perches (1):
      dynamic_debug: Remove unnecessary __used

Joerg Roedel (1):
      iommu/amd: Work around wrong IOAPIC device-id in IVRS table

Johan Hedberg (1):
      Bluetooth: SMP: Fix setting unknown auth_req bits

Johan Hovold (30):
      USB: metro-usb: fix port-data memory leak
      USB: metro-usb: fix io after disconnect
      USB: whiteheat: fix memory leak in error path
      USB: whiteheat: fix port-data memory leak
      USB: ch341: fix port-data memory leak
      USB: digi_acceleport: fix port-data memory leak
      USB: mos7720: fix port-data memory leak
      USB: omninet: fix port-data memory leak
      USB: quatech2: fix memory leak in error path
      USB: quatech2: fix port-data memory leaks
      USB: quatech2: fix close and disconnect urb handling
      USB: quatech2: fix io after disconnect
      USB: opticon: fix DMA from stack
      USB: opticon: fix memory leak in error path
      USB: mct_u232: fix port-data memory leak
      USB: mct_u232: fix broken close
      USB: keyspan: fix NULL-pointer dereferences and memory leaks
      USB: usb-wwan: fix multiple memory leaks in error paths
      USB: sierra: fix memory leak in attach error path
      USB: sierra: fix memory leak in probe error path
      USB: sierra: fix port-data memory leak
      USB: mos7840: fix urb leak at release
      USB: mos7840: fix port-device leak in error path
      USB: ipw: fix interface-data memory leak in error path
      USB: option: fix interface-data memory leak in error path
      USB: qcserial: fix interface-data memory leak in error path
      USB: mos7840: remove NULL-urb submission
      USB: mos7840: remove invalid disconnect handling
      USB: mos7840: fix port-data memory leak
      USB: mos7840: fix port_probe flow

Johannes Berg (2):
      iwlwifi: fix 6000 series channel switch command
      mac80211: connect with HT20 if HT40 is not permitted

John Johansen (1):
      apparmor: fix IRQ stack overflow during free_profile

Josef Bacik (2):
      Btrfs: Use btrfs_update_inode_fallback when creating a snapshot
      Btrfs: do not bug when we fail to commit the transaction

Josh Wu (1):
      ARM: at91/tc: fix typo in the DT document

Jouni Malinen (1):
      mac80211: Fix FC masking in BIP AAD generation

Julia Lawall (1):
      ALSA: sound/isa/opti9xx/miro.c: eliminate possible double free

K. Y. Srinivasan (1):
      Drivers: hv: Cleanup error handling in vmbus_open()

Kees Cook (2):
      gen_init_cpio: avoid stack overflow when expanding
      fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

Kevin Hilman (2):
      ARM: OMAP2: UART: fix console UART mismatched runtime PM status
      ARM: OMAP3: Beagle: fix OPP customization and initcall ordering

Konrad Rzeszutek Wilk (1):
      xen/xenbus: Fix compile warning.

Kuninori Morimoto (3):
      ARM: shmobile: r8a7779: I/O address abuse cleanup
      usb: renesas_usbhs: fixup: avoid NULL access on error case pipe detach
      usb: renesas_usbhs: fixup dma transfer stall

Lan Tianyu (2):
      usb/xhci: release xhci->lock during turning on/off usb port's
acpi power resource and checking the existence of port's power
resource
      usb/xhci: Remove (__force__ __u16) before assigning
DeviceRemovable and assign directly.

Larry Finger (1):
      b43: Fix oops on unload when firmware not found

Lars-Peter Clausen (11):
      iio: Add some helper macros for unit conversion
      staging:iio: Fix adis16201 channel offsets and scales
      staging:iio: Fix adis16203 channel offsets and scales
      staging:iio: Fix adis16204 channel offsets and scales
      staging:iio: Fix adis16209 channel offsets and scales
      staging:iio: Fix adis16220 channel offsets and scales
      staging:iio: Fix adis16240 channel offsets and scales
      staging:iio: Fix adis16260 channel offsets and scales
      staging:iio: Fix adis16400 channel offsets and scales
      staging:iio:adis16400: Report correct temperature scale and offset
      staging:iio:adis16400: Fixup adis16336 temp channel attributes

Laszlo Ersek (1):
      xen PV passthru: assign SR-IOV virtual functions to separate virtual slots

Laurent Pinchart (4):
      drivers: dma-contiguous: Don't redefine SZ_1M
      drivers: dma-coherent: Fix typo in dma_mmap_from_coherent documentation
      drivers: cma: Fix wrong CMA selected region size default value
      ARM: mm: Remove unused arm_vmregion priv field

Lee Jones (5):
      ASoC: Ux500: Dispose of device nodes correctly
      ASoC: ux500_msp_i2s: Fix devm_* and return code merge error
      ARM: ux500: Fix build error relating to IRQCHIP_SKIP_SET_WAKE
      ARM: ux500: Specify AMBA Primecell IDs for Nomadik I2C in DT
      ARM: ux500: Correct SDI5 address and add some format changes

Lennart Sorensen (1):
      USB: serial: Fix memory leak in sierra_release()

Li RongQing (1):
      ipv6: Set default hoplimit as zero.

Linus Lüssing (2):
      batman-adv: Fix broadcast packet CRC calculation
      batman-adv: Fix potential broadcast BLA-duplicate-check race condition

Linus Torvalds (2):
      VFS: don't do protected {sym,hard}links by default
      Linux 3.7-rc3

Linus Walleij (4):
      ARM: 7560/1: SMP_TWD: use DIV_ROUND_CLOSEST() for periodic mode
      pinctrl/nomadik: use irq_create_mapping()
      pinctrl/nomadik: use zero as default irq_start
      pinctrl/nomadik: pass DT node to the irqdomain

Liu Bo (1):
      Btrfs: fix memory leak when cloning root's node

Luigi Semenzato (1):
      perf tools: do not flush maps on COMM for perf report

Lukas Czerner (4):
      ext4: fix undefined bit shift result in ext4_fill_flex_info
      jfs: Fix FITRIM argument handling
      ext4: Avoid underflow in ext4_trim_fs()
      btrfs: Return EINVAL when length to trim is less than FSB

Marcin Slusarz (5):
      drm/nouveau: handle same-fb page flips
      drm/nouveau: fix nouveau_mm/nouveau_mm_node leak
      drm/nouveau: warn when trying to free mm which is still in use
      drm/nouveau: validate vbios size
      drm/debugfs: remove redundant info from gem_names

Marek Belisko (1):
      ARM: at91/dts: at91sam9g20ek_common: Fix typos in buttons labels.

Marek Szyprowski (1):
      Revert "ARM: dma-mapping: support debug_dma_mapping_error"

Marek Vasut (2):
      spi: mxs: Assign message status after transfer finished
      spi: mxs: Terminate DMA in case of DMA timeout

Mark Brown (1):
      ASoC: wm8994: Only enable extra BCLK cycles when required

Martin Peres (1):
      drm/nouveau/bios: improve error handling when reading the vbios from ACPI

Matt Fleming (2):
      MAINTAINERS: Add EFI git repository location
      x86/efi: Fix oops caused by incorrect set_memory_uc() usage

Matus Ujhelyi (1):
      phy: add AT803x driver

Miao Xie (1):
      Btrfs: fix deadlock caused by the nested chunk allocation

Michael Holzheu (1):
      s390/kdump: Use 64 bit mode for 0x10000 entry point

Michael S. Tsirkin (1):
      vhost: fix mergeable bufs on BE hosts

Michael Shigorin (1):
      usb-storage: add unusual_devs entry for Casio EX-N1 digital camera

Michal Hocko (1):
      nohz: Fix idle ticks in cpu summary line of /proc/stat

Mikulas Patocka (3):
      percpu-rw-semaphores: use light/heavy barriers
      percpu-rw-semaphores: use rcu_read_lock_sched
      Lock splice_read and splice_write functions

Ming Lei (6):
      firmware loader: cancel uncache work before caching firmware
      firmware loader: fix one reqeust_firmware race
      firmware loader: let direct loading back on 'firmware_buf'
      firmware loader: sync firmware cache by async_synchronize_full_domain
      ARM: dma-mapping: support debug_dma_mapping_error
      firmware loader: document kernel direct loading

Mohammed Shafi Shajakhan (1):
      ath9k_htc: Add PID/VID for a Ubiquiti WiFiStation

Moni Shoua (1):
      net/mlx4_en: Don't use vlan tag value as an indication for vlan presence

Namhyung Kim (1):
      perf help: Fix --help for builtins

Nicolas Ferre (2):
      ARM: at91: fix external interrupts in non-DT case
      ARM: at91: fix external interrupt specification in board code

Nitin Gupta (1):
      staging: zram: Fix handling of incompressible pages

Octavian Purdila (2):
      usb hub: send clear_tt_buffer_complete events when canceling TT clear work
      usb hub: use flush_work instead of flush_work_sync

Oleg Nesterov (20):
      uprobes: Do not leak UTASK_BP_HIT if find_active_uprobe() fails
      uprobes: Do not setup ->active_uprobe/state prematurely
      uprobes: Fix UPROBE_SKIP_SSTEP checks in handle_swbp()
      uprobes: Kill UTASK_BP_HIT state
      uprobes: Move clear_thread_flag(TIF_UPROBE) to uprobe_notify_resume()
      uprobes: Change write_opcode() to use FOLL_FORCE
      uprobes: Change valid_vma() to demand VM_MAYEXEC rather than VM_EXEC
      uprobes: Restrict valid_vma(false) to skip VM_SHARED vmas
      uprobes: Kill set_swbp()->is_swbp_at_addr()
      uprobes: Introduce copy_opcode(), kill read_opcode()
      uprobes: Kill set_orig_insn()->is_swbp_at_addr()
      uprobes: Simplify is_swbp_at_addr(), remove stale comments
      uprobes/x86: Only rep+nop can be emulated correctly
      uprobes: Don't return success if alloc_uprobe() fails
      uprobes: Do not delete uprobe if uprobe_unregister() fails
      uprobes: Fix handle_swbp() vs unregister() + register() race
      uprobes: Introduce prepare_uprobe()
      uprobes: Fix prepare_uprobe() race with itself
      uprobes: Fix the racy uprobe->flags manipulation
      freezer: exec should clear PF_NOFREEZE along with PF_KTHREAD

Oliver Neukum (2):
      xhci: endianness xhci_calculate_intel_u2_timeout
      xhci: fix integer overflow

Olof Johansson (1):
      x86: efi: Turn off efi_enabled after setup on mixed fw/kernel

Omar Ramirez Luna (6):
      staging: tidspbridge: request the right irq for mmu
      staging: tidspbridge: drop const from custom mmu implementation
      staging: tidspbridge: change type to __iomem for per and core addresses
      staging: tidspbridge: ioremap dsp sync addr
      staging: tidspbridge: ioremap physical address of the stack segment in shm
      staging: tidspbridge: delete unused mmu functions

Or Gerlitz (1):
      mlx4_core: Remove annoying debug messages from SR-IOV flow

Pablo Neira Ayuso (1):
      netfilter: xt_CT: fix timeout setting with IPv6

Paul Walmsley (1):
      ARM: OMAP3: PM: apply part of the erratum i582 workaround

Pavel Machek (1):
      ARM: socfpga: Fix socfpga compilation with early_printk() enabled

Peter Huewe (2):
      extcon: Unregister compat class at module unload to fix oops
      extcon: unregister compat link on cleanup

Peter Korsgaard (1):
      NET_VENDOR_TI: make available for am33xx as well

Peter Ujfalusi (1):
      ARM/dts: omap3: Fix mcbsp2/3 hwmods to be able to probe the
drivers for audio

Piotr Haber (1):
      bcma: fix unregistration of cores

Pritesh Raithatha (3):
      dt: Document: correct tegra20/30 pinctrl slew-rate name
      pinctrl: tegra: set low power mode bank width to 2
      pinctrl: tegra: correct bank for pingroup and drv pingroup

Randy Dunlap (2):
      module_signing: fix printk format warning
      staging: ramster: depends on NET

Rodrigo Vivi (1):
      drm/i915: Insert i915_preliminary_hw_support variable.

Russell King (1):
      ARM: drop experimental status for hotplug and Thumb2

Sachin Kamat (2):
      extcon: Remove duplicate inclusion of extcon.h header file
      extcon: Fix return value in extcon_register_interest()

Sarah Sharp (4):
      xhci: Fix potential NULL ptr deref in command cancellation.
      xhci: Fix missing break in xhci_evaluate_context_result.
      xhci: trivial: Remove assigned but unused slot_ctx.
      xhci: trivial: Remove assigned but unused ep_ctx.

Sascha Hauer (3):
      ARM i.MX25: Fix lcdc_ipg_per parent clock
      ARM i.MX25 clk: Fix nfc_ipg_per parent
      ARM i.MX25: Fix PWM per clock lookups

Sasha Levin (1):
      KVM guest: exit idleness when handling KVM_PV_REASON_PAGE_NOT_PRESENT

Sebastian Ott (3):
      s390/chpid: make headers usable (again)
      s390/cio: use generic bitmap functions
      s390/css: stop stsch loop after cc 3

Sergei Trofimovich (1):
      staging: ipack: add missing include (implicit declaration of
function 'kfree')

Shimoda, Yoshihiro (1):
      spi: spi-rspi: fix build error for the latest shdma driver

Srivatsa S. Bhat (2):
      perf, cpu hotplug: Run CPU_STARTING notifiers with irqs disabled
      perf, cpu hotplug: Use cached value of smp_processor_id()

Stanislav Yakovlev (1):
      net/wireless: ipw2200: Fix panic occurring in ipw_handle_promiscuous_tx()

Stanislaw Gruszka (3):
      cfg80211/mac80211: avoid state mishmash on deauth
      mac80211: check if key has TKIP type before updating IV
      rt2x00: usb: fix reset resume

Stefan Behrens (1):
      Btrfs: Fix wrong error handling code

Steffen Klassert (1):
      ipv4: Fix flushing of cached routing informations

Stefán Freyr (1):
      ALSA: hda - add dock support for Thinkpad T430

Stephane Grosjean (1):
      can: sja1000: fix/add miniPCIe/cPCI PC/104Plus PCI/104e PEAK-System boards

Stephen Boyd (1):
      MAINTAINERS: Add arm-soc tree entry

Steven Rostedt (1):
      ktest: Fix ktest confusion with CONFIG_MODULES_USE_ELF_RELA

Takashi Iwai (1):
      ALSA: hda - Fix silent headphone output from Toshiba P200

Tao Ma (1):
      ext4: Checksum the block bitmap properly with bigalloc enabled

Tejun Heo (2):
      Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"
      Revert "cgroup: Remove task_lock() from cgroup_post_fork()"

Tekkaman Ninja (3):
      Documentation:Chinese translation of Documentation/IRQ.txt
      Documentation:Chinese translation of Documentation/arm64/booting.txt
      Documentation:Chinese translation of Documentation/arm64/memory.txt

Thadeu Lima de Souza Cascardo (2):
      RDMA/cxgb4: Don't free chunk that we have failed to allocate
      genalloc: stop crashing the system when destroying a pool

Theodore Ts'o (1):
      ext4: fix metadata checksum calculation for the superblock

Thierry Reding (3):
      drm: fb: cma: Fix typo in debug message
      drm: fb: cma: Fail gracefully on allocation failure
      drm: platform: Don't initialize driver-private data

Thomas Hellstrom (2):
      drm/ttm: Fix a theoretical race
      drm/ttm: Fix a theoretical race in ttm_bo_cleanup_refs()

Thomas Petazzoni (1):
      ARM: mvebu: update defconfig with 3.7 changes

Tilman Schmidt (1):
      bas_gigaset: fix pre_reset handling

Tomasz Figa (2):
      ARM: dts: Split memory into 4 sections for exynos4210-trats
      ARM: EXYNOS: Set .smp field of machine descriptor for exynos4-dt

Tony Lindgren (2):
      ARM: OMAP2+: Fix location of select PINCTRL
      ARM: OMAP3: Fix 3430 legacy mux names for ssi1 signals.

Trond Myklebust (12):
      NFSv4.1: Kill nfs4_ds_disconnect()
      NFSv4.1: Do not call pnfs_return_layout() from an rpciod context
      NFSv4.1: Use kcalloc() to allocate zeroed arrays instead of kzalloc()
      NFSv4: fs/nfs/nfs4getroot.c needs to include "internal.h"
      NFSv4.1: Declare osd_pri_2_pnfs_err(), objio_init_read/write to be static
      NFSv4: Fix the return value for nfs_callback_start_svc
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
      SUNRPC: Prevent races in xs_abort_connection()
      SUNRPC: Get rid of the xs_error_report socket callback
      LOCKD: fix races in nsm_client_get
      LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero

Tsutomu Itoh (1):
      Btrfs: fix memory leak in btrfs_quota_enable()

Tu, Xiaobing (1):
      Fix memory leak in cpufreq stats.

Ulf Hansson (1):
      spi/pl022: Revert recent runtime PM changes

Vaibhav Hiremath (1):
      ARM: AM33XX: Fix configuration of dmtimer parent clock by
dmtimer driverDate:Wed, 17 Oct 2012 13:55:55 -0500

Vaibhav Nagarnaik (1):
      ring-buffer: Check for uninitialized cpu buffer before resizing

Veaceslav Falico (4):
      pch_gbe: create functions for MAC_RX {en,dis}able
      pch_gbe: don't re-set RX_FIFO_ERR flag in napi_poll
      pch_gbe: don't reset MAC_RX on FIFO overflow
      pch_gbe: fix error handling in pch_gbe_up()

Vince Weaver (6):
      perf/x86: Fix P6 FP_ASSIST event constraint
      perf/x86: Update/fix generic events on P6 PMU
      perf/x86: Remove P6 cpuc->enabled check
      perf/x86: Make Intel KNC use full 40-bit width of counters
      perf/x86: Remove cpuc->enable check on Intl KNC event enable/disable
      perf/x86: Enable overflow on Intel KNC with a custom knc_pmu_handle_irq()

Vincent Penquerc'h (1):
      staging: omapdrm: fix allocation size for page addresses array

Vipul Pandya (1):
      cxgb4: Remove unnecessary #ifdef condition

Viresh Kumar (1):
      ARM: SPEAr: Remove unused empty files

Wei Yang (1):
      gianfar_ptp: use iomem, not ioports resource tree in probe

Wei Yongjun (7):
      ARM: imx: fix return value check in imx3_init_l2x0()
      ARM: imx: fix the return value check in imx_clk_busy_divider()
      xen/x86: remove duplicated include from enlighten.c
      usb: gadget: net2272: fix missing unlock on error in net2272_irq()
      pinctrl: fix missing unlock on error in pinctrl_groups_show()
      dmaengine: imx-dma: fix missing unlock on error in imxdma_xfer_desc()
      perf/x86: Remove unused variable in nhmex_rbox_alter_er()

Will Deacon (3):
      ARM: 7556/1: perf: fix updated event period in response to
PERF_EVENT_IOC_PERIOD
      ARM: 7559/1: smp: switch away from the idmap before updating
init_mm.mm_count
      rbtree: include linux/compiler.h for definition of __always_inline

Wolfgang Grandegger (1):
      can: flexcan: disable bus error interrupts for the i.MX6q

Xiao Guangrong (1):
      KVM: MMU: fix release noslot pfn

Yan, Zheng (2):
      perf/x86: Disable uncore on virtualized CPUs
      perf/x86/uncore: Handle pci_read_config_dword() errors

Yinghai Lu (3):
      x86, mm: Trim memory in memblock to be page aligned
      x86, mm: Use memblock memory loop instead of e820_RAM
      x86, mm: Undo incorrect revert in arch/x86/mm/init.c

Yuanhan Liu (2):
      brcmfmac: fix potential NULL dereference
      sonypi: suspend/resume callbacks should be conditionally
compiled on CONFIG_PM_SLEEP

Yuchung Cheng (1):
      tcp: add SYN/data info to TCP_INFO

anish kumar (4):
      extcon: standard cable names definition and declaration changed
      extcon: optimising the check_mutually_exclusive function
      extcon: driver model release call not needed
      extcon: trivial: kfree missed from remove path

jhbird.choi@samsung.com (1):
      PM / Domains: Fix memory leak on error path in pm_genpd_attach_cpuidle
