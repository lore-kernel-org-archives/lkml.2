Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0L2BTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 20:19:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752925Ab0L2BTB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 20:19:01 -0500
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Dec 2010 17:18:12 -0800
Message-ID: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com>
Subject: Linux 2.6.37-rc8
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another week, another -rc. This should be the last for the 37 series,
so I still expect the merge window to open early January when people
are hopefully back to working order after having eaten (and drunk) too
much.

The -rc8 release shouldn't be all that exciting. The most noticeable
is probably the fact that hopefully the "blank screen" problem with
intel graphics is fixed. But on the whole, it's all just a collection
of random fixes all over.

The diffstat doesn't look very interesting, and the appended shortlog
probably does give about as much information as you'd want.

Go wild, and ring in the new year with a new kernel.

                      Linus

---
Aaro Koskinen (1):
      gpiolib: gpio_request_one(): add missing gpio_free()

Ahmed S. Darwish (1):
      RAMOOPS: Don't overflow over non-allocated regions

Alex Deucher (7):
      drm/radeon/kms: disable ss fixed ref divide
      drm/radeon/kms: disable the r600 cb offset checker for linear surfaces
      drm/radeon/kms/evergreen: flush hdp cache when flushing gart tlb
      drm/radeon/kms: fix evergreen asic reset
      drm/radeon/kms/evergreen: reset the grbm blocks at resume and init
      drm/radeon/kms: reorder display resume to avoid problems
      drm/radeon/kms: fix bug in r600_gpu_is_lockup

Andreas Mohr (1):
      net: Add USB PID for new MOSCHIP USB ethernet controller MCS7832 variant

Andres Salomon (3):
      MAINTAINERS: update geode entry
      cs5535-gpio: don't apply errata #36 to edge detect GPIOs
      cs5535-gpio: handle GPIO regs where higher (clear) bits are set

Andrey Vagin (1):
      ipv6: delete expired route in ip6_pmtu_deliver

Arnaldo Carvalho de Melo (1):
      perf buildid-list: Fix error return for success

Arnaud Ebalard (1):
      asix: add USB ID for Logitec LAN-GTJ U2A

Axel Lin (1):
      backlight: cr_bllcd.c: fix a memory leak

Baruch Siach (1):
      [media] mx2_camera: fix pixel clock polarity configuration

Ben Hutchings (4):
      bonding/vlan: Remove redundant VLAN tag insertion logic
      bonding: Change active slave quietly when bond is down
      bonding/vlan: Fix mangled NAs on slaves without VLAN tag insertion
      tehuti: Firmware filename is tehuti/bdx.bin

Benjamin Herrenschmidt (1):
      drm/radeon: Add early unregister of firmware fb's

Changli Gao (1):
      net_sched: always clone skbs

Chris Wilson (5):
      drm/i915/ringbuffer: Handle wrapping of the autoreported HEAD
      drm/i915/sdvo: Only use the SDVO pin if it is in the valid range
      agp/intel: Fix missed cached memory flags setting in i965_write_entry()
      drm/i915/bios: Reverse order of 100/120 Mhz SSC clocks
      drm: Include the connector name in the output_poll_execute() debug message

Christian Lamparter (1):
      p54usb: add 5 more USBIDs

Dan Carpenter (4):
      [media] lirc_dev: stray unlock in lirc_dev_fop_poll()
      [media] lirc_dev: fixes in lirc_dev_fop_read()
      typhoon: memory corruption in typhoon_get_drvinfo()
      USB: mcs7830: return negative if auto negotiate fails

Dan Rosenberg (1):
      irda: prevent integer underflow in IRLMP_ENUMDEVICES

Dave Airlie (3):
      drm/radeon: use aperture size not vram size for overlap tests
      Revert "drm: Don't try and disable an encoder that was never enabled"
      fb: fix overlapping test off-by-one.

David Daney (1):
      of/i2c: Fix request module by alias

David Flynn (1):
      drm/i915/dp: Fix I2C/EDID handling with active DisplayPort to
DVI converter

David Henningsson (1):
      ALSA: HDA: Add auto-mute for Thinkpad SL410/SL510

David Howells (1):
      KEYS: Don't call up_write() if __key_link_begin() returns an error

David S. Miller (2):
      net: Fix range checks in tcf_valid_offset().
      Revert "ipv4: Allow configuring subnets as local addresses"

David Sharp (1):
      ring_buffer: Off-by-one and duplicate events in ring_buffer_read_page

David Stevens (2):
      bridge: fix IPv6 queries for bridge multicast snooping
      ipv6: Fragment locally generated tunnel-mode IPSec6 packets as needed.

Dmitry V. Levin (1):
      netlink: fix gcc -Wconversion compilation warning

Don Fry (1):
      MAINTAINERS: email address change

Eduardo Costa (1):
      p54usb: New USB ID for Gemtek WUBI-100GW

Eric Dumazet (3):
      net_sched: sch_sfq: fix allot handling
      tcp: fix listening_get_next()
      ipv4: dont create routes on down devices

Fabio Estevam (1):
      video: imxfb: Fix the maximum value for yres

Florian Fainelli (2):
      gpio: Fix null pointer dereference while accessing rdc321x platform_data
      watchdog: Fix null pointer dereference while accessing rdc321x
platform_data

Franck Bui-Huu (3):
      perf probe: Fix use of kernel image path given by 'k' option
      perf symbols: Stop using vmlinux files with no symbols
      perf buildid-cache: Fix symbolic link handling

Guennadi Liakhovetski (5):
      [media] soc-camera: fix static build of the sh_mobile_csi2.c driver
      fbdev: sh-mobile: restore display size configuration
      fbdev: sh-mobile: retrieve and propagate display sizes from EDID
      [media] v4l: soc-camera: fix multiple simultaneous user case
      fbdev: sh_mobile_lcdc: increase maximum framebuffer size to support 1080p

H. Peter Anvin (1):
      x86, kexec: Limit the crashkernel address appropriately

Herton Ronaldo Krzesinski (1):
      mac80211: avoid calling ieee80211_work_work unconditionally

Hillf Danton (1):
      bonding: Fix slave selection bug.

Imre Kaloz (1):
      ARM: fix IXP4xx build failure

Ivan Vecera (1):
      be2net: use mutex instead of spin lock for mbox_lock

James Bottomley (1):
      [SCSI] fix up documentation for change in ->queuecommand to
lockless calling

Jarek Poplawski (2):
      sundance: Fix oopses with corrupted skb_shared_info
      epic100: hamachi: yellowfin: Fix skb allocation size

Jarod Wilson (10):
      [media] mceusb: add support for Conexant Hybrid TV RDU253S
      [media] nuvoton-cir: improve buffer parsing responsiveness
      [media] mceusb: fix up reporting of trailing space
      [media] mceusb: buffer parsing fixups for 1st-gen device
      [media] IR: add tv power scancode to rc6 mce keymap
      [media] mceusb: fix keybouce issue after parser simplification
      [media] streamzap: merge timeout space with trailing space
      [media] mceusb: add another Fintek device ID
      [media] mceusb: fix inverted mask inversion logic
      [media] mceusb: set a default rx timeout

Jeff Garzik (1):
      pata_cs5536: avoid implicit MSR API inclusion on x86-64

Jeff Mahoney (1):
      taskstats: pad taskstats netlink response for aligment issues on ia64

Jesper Juhl (2):
      ALSA: pcm: remember to always call va_end() on stuff that we va_start()
      x86/microcode: Fix double vfree() and remove redundant pointer
checks before vfree()

Jing Huang (1):
      [SCSI] bfa: rename log_level to bfa_log_level

Johan Hedberg (1):
      Bluetooth: Fix initial RFCOMM DLC security level

Johannes Berg (3):
      iwlagn: rename enhanced txpower fields
      mac80211: fix mesh forwarding
      led_class: fix typo in blink API

Johannes Stezenbach (1):
      mac80211/rt2x00: add ieee80211_tx_status_ni()

Jun Nie (1):
      Bluetooth: add NULL pointer check in HCI

Kailang Yang (2):
      ALSA: hda - Add fix-up for Sony VAIO with ALC275 codecs
      ALSA: hda - Don't apply ALC269-specific initialization to ALC275

Ken Kawasaki (1):
      axnet_cs: move id (0x1bf, 0x2328) to axnet_cs

Len Brown (1):
      Revert "ACPI battery: update status upon sysfs query"

Linus Torvalds (1):
      Linux 2.6.37-rc8

Mark Brown (2):
      mfd: Supply IRQ base for WM832x devices
      mfd: Support additional parent IDs for wm831x

Masami Hiramatsu (2):
      perf tools: Fix lazy wildcard matching
      perf probe: Fix to support libdwfl older than 0.148

Mattias Wallin (1):
      mfd: Fix ab8500-core interrupt ffs bit bug

Meelis Roos (1):
      hostap: remove netif_stop_queue from init

Mel Gorman (1):
      mm: vmscan: tracepoint: account for scanned pages similarly for
both ftrace and vmstat

Michal Nazarewicz (1):
      mm/migrate.c: fix compilation error

Michał Mirosław (1):
      net/veth: Fix packet checksumming

Minchan Kim (1):
      mm/compaction.c: avoid double mem_cgroup_del_lru()

Mingkai Hu (2):
      spi/fsl_espi: change the read behaviour of the SPIRF
      spi/fsl_espi: fix wrong setting of the address in the command buffer

Nicolas Ferre (1):
      mmc: atmel-mci: fix multiblock SDIO transfers

Octavian Purdila (1):
      net: fix nulls list corruptions in sk_prot_alloc

Paul Bender (1):
      [media] rc: fix sysfs entry for mceusb and streamzap

Paul Mundt (6):
      sh: Fix up SH4-202 clkfwk build.
      sh: mach-se: Fix up SE7206 build.
      nommu: Fix up vmalloc_node() symbol export regression.
      nommu: Provide stubbed alloc/free_vm_area() implementation.
      sh: Fix up SH7201 clkfwk build.
      sh: intc: Initialize radix tree gfp mask explicitly.

Prasad Joshi (2):
      logfs: fix deadlock in logfs_get_wblocks, hold and wait on
super->s_write_mutex
      logfs: fix "Kernel BUG at readwrite.c:1193"

Rafael J. Wysocki (4):
      ACPI: Execute _PRW for devices reported as inactive or not present
      atl1c: Do not use legacy PCI power management
      PCI hotplug: Fix unexpected driver unregister in pciehp_acpi.c
      ACPI / ACPICA: Disable GPEs during initialization

Sebastian Andrzej Siewior (1):
      drivers/spi/spi.c: don't release the spi device twice

Sunil Mushran (2):
      ocfs2/dlm: Migrate lockres with no locks if it has a reference
      ocfs2: Adjust masklog flag values

Sven Neumann (1):
      libertas: fix potential NULL-pointer dereference

Sylwester Nawrocki (6):
      [media] s5p-fimc: BKL lock removal - compilation fix
      [media] s5p-fimc: Fix vidioc_g_crop/cropcap on camera sensor
      [media] s5p-fimc: Explicitly add required header file
      [media] s5p-fimc: Convert m2m driver to unlocked_ioctl
      [media] s5p-fimc: Use correct fourcc code for 32-bit RGB format
      [media] s5p-fimc: Fix output DMA handling in S5PV310 IP revisions

Takashi Iwai (4):
      mmc: Fix re-probing with PM_POST_RESTORE notification
      ALSA: hda - Fix conflict of d-mic capture volume controls
      ALSA: hda - Try to find an empty control index when it's occupied
      ALSA: hda - Fix GPIO2-fixup for Sony laptops

Tao Ma (2):
      ocfs2: Hold ip_lock when set/clear flags for indexed dir.
      ocfs2: Fix system inodes cache overflow.

Tejun Heo (4):
      percpu: print out alloc information with KERN_DEBUG instead of KERN_INFO
      libata-sff: fix HSM_ST_ERR handling in __ata_sff_port_intr()
      libata: no special completion processing for EH commands
      libata: issue DIPM enable commands with LPM state updated

Theodore Ts'o (1):
      ext4: fix on-line resizing regression

Tim Harvey (1):
      mac80211: Fix NULL-pointer deference on ibss merge when not ready

Tristan Ye (1):
      Ocfs2: Teach 'coherency=full' O_DIRECT writes to correctly
up_read i_alloc_sem.

Wei Yongjun (1):
      sctp: fix the return value of getting the sctp partial delivery point

Wey-Yi Guy (1):
      iwlagn: implement layout-agnostic EEPROM reading

Will Newton (1):
      include/linux/unaligned: pack the whole struct rather than just the field

Wolfram Sang (4):
      rtc: rs5c372: fix buffer size
      powerpc/mpc5200: include fs.h in mpc52xx_gpt.c
      spi/mpc52xx-spi: fix annotation for remove()-pointer
      pata_mpc52xx: driver needs BMDMA

Wu Fengguang (1):
      writeback: do uninterruptible sleep in balance_dirty_pages()

Wu Zhangjin (1):
      pata_cs5536: Add support for non-X86_32 platforms

Yauhen Kharuzhy (1):
      mmc: at91_mci: fix multiblock SDIO transfers

Yong Zhang (1):
      kthread_work: make lockdep happy

stephen hemminger (1):
      ipv6: don't flush routes when setting loopback down
