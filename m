Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2CDC5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 21:57:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42254 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab2CDC5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 21:57:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.133.151 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 3 Mar 2012 18:57:31 -0800
X-Google-Sender-Auth: IKFBRtGKtkB3OqNBOxPOz1GZ5Vo
Message-ID: <CA+55aFxHj-7fQ0+yJv4WaeKCGha5+a+J=gtHi6m6EWg58q7Ljw@mail.gmail.com>
Subject: Linux 3.3-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Nothing much to say about this -rc: it really is all small fixes
and cleanups.

In fact, it's been calm enough that this *might* be the last -rc, but
we'll see how the upcoming week goes. If it stays calm (and hopefully
even calms down some more), there doesn't seem to be any major reason
to drag out the release cycle any more.

But hey, that does imply that people who have seen regressions should
re-check them and holler loudly if they are still seeing problems.

So please test,

                   Linus

---
Alban Bedel (1):
      ALSA: azt3328 - Fix NULL ptr dereference on cards without OPL3

Alban Browaeys (1):
      drm/i915: Prevent a machine hang by checking crtc->active before
loading lut

Alex Deucher (1):
      drm/radeon/kms: fix radeon_dp_get_modes for LVDS bridges (v2)

Amit Shah (1):
      virtio: balloon: leak / fill balloon across S4

Amitkumar Karwar (1):
      mwifiex: clear previous security setting during association

Andre Guedes (1):
      Bluetooth: Fix potential deadlock

Andreas Bießmann (1):
      mod/file2alias: make modpost compile on darwin again

Andreas Herrmann (1):
      x86/amd: Fix L1i and L2 cache sharing information for AMD family
15h processors

Andrzej Kaczmarek (2):
      Bluetooth: Fix sk_sndtimeo initialization for L2CAP socket
      Bluetooth: l2cap_set_timer needs jiffies as timeout value

Anton Altaparmakov (5):
      NTFS: Remove unused variable.
      NTFS: Do not dereference pointer before checking for NULL.
      NTFS: Correct two spelling errors "dealocate" to "deallocate" in mft.c.
      LDM: Fix reassembly of extended VBLKs.
      NTFS: Update git repo path in MAINTAINERS file.

Archit Taneja (1):
      OMAPDSS: HACK: Ensure DSS clock domain gets out of idle when
HDMI is enabled

Arnout Vandecappelle (Essensium/Mind) (1):
      OMAP3 EVM: remove out-of-bounds array access of gpio_leds

Axel Lin (2):
      ARM: pxa: fix error handling in pxa2xx_drv_pcmcia_probe
      pxa/hx4700: add platform device and I2C info for AK4641 codec

Ben Hutchings (1):
      sfc: Fix assignment of ip_summed for pre-allocated skbs

Ben McKeegan (1):
      ppp: fix 'ppp_mp_reconstruct bad seq' errors

Boaz Harrosh (1):
      [SCSI] osd_uld: Bump MAX_OSD_DEVICES from 64 to 1,048,576

Bob Peterson (2):
      GFS2: Read in rindex if necessary during unlink
      GFS2: Ensure rindex is uptodate for fallocate

Borislav Petkov (1):
      x86/mce/AMD: Fix UP build error

Chris Wilson (1):
      drm/i915: Remove use of the autoreported ringbuffer HEAD position

Christian König (1):
      drm/radeon: fix uninitialized variable

Christian Riesch (1):
      davinci_emac: Do not free all rx dma descriptors during init

Cong Wang (1):
      [PARISC] include <linux/prefetch.h> in drivers/parisc/iommu-helpers.h

Dan Carpenter (2):
      net/ethernet: ks8851_mll: signedness bug in ks8851_probe()
      hso: memsetting wrong data in hso_get_count()

Daniel Wagner (1):
      Bluetooth: Don't mark non xfer isoc endpoint URBs with URB_ISO_ASAP

Danny Kukawka (4):
      ARM: pxa: fix including linux/gpio.h twice
      arch/arm/mach-mmp/: some files include some headers twice
      arch/arm/mach-pxa/: included linux/gpio.h twice
      [S390] crash_dump: remove duplicate include

Dave Airlie (1):
      drm/i915: fix mode set on load pipe. (v2)

Dave Jones (1):
      zaurus: Add ID for C-750/C-760/C-860/SL-C3000 PDA in MDLM mode

David Ahern (1):
      perf tools: Ensure comm string is properly terminated

David Howells (1):
      [S390] KEYS: Enable the compat keyctl wrapper on s390x

David McKay (1):
      netdev/phy/icplus: Correct broken phy_init code

David S. Miller (1):
      ipv4: ping: Fix recvmsg MSG_OOB error handling.

Dmitry Artamonow (1):
      watchdog: fix GETTIMEOUT ioctl in booke_wdt

Eric Dumazet (4):
      netem: fix dequeue
      atl1c: dont use highprio tx queue
      atm: clip: remove clip_tbl
      ipsec: be careful of non existing mac headers

Eugeni Dodonov (1):
      drm/i915: fix operator precedence when enabling RC6p

Eun-Chul Kim (1):
      drm/exynos: added panel physical size.

Felipe Balbi (1):
      ARM: OMAP2+: usb-host: fix compile warning

Felix Fietkau (1):
      mac80211: do not call rate control .tx_status before .rate_init

Florian Tobias Schandinat (2):
      viafb: select HW scaling on VX900 for IGA2
      viafb: fix IGA1 modesetting on VX900

Florian Westphal (1):
      netfilter: nf_queue: fix queueing of bridged gro skbs

Gerald Schaefer (1):
      [S390] memory hotplug: prevent memory zone interleave

Giuseppe CAVALLARO (1):
      phy: IC+101G and PHY_HAS_INTERRUPT flag

Greg Rose (1):
      rtnetlink: Fix problem with buffer allocation

Guo-Fu Tseng (1):
      jme: Fix FIFO flush issue

H. Peter Anvin (2):
      regset: Prevent null pointer reference on readonly regsets
      regset: Return -EFAULT, not -EIO, on host-side memory fault

Hai Lan (1):
      drm/i915: fix a sprite watermark computation to avoid divide by
zero if xpos<0

Haojian Zhuang (2):
      ARM: pxa: fix wrong parsing gpio event on spitz
      ARM: pxa: fix mixed declarations and code in sharpsl_pm

Heiko Carstens (1):
      compat: fix compile breakage on s390

Ian Kent (1):
      autofs4 - update MAINTAINERS mailing list entry

Inki Dae (4):
      drm/exynos: added possible_clones setup function.
      drm/exynos: fixed page flip issue.
      drm/exynos: removed exynos_drm_fbdev_recreate function.
      drm/exynos: added postclose to release resource.

Jack Morgenstein (1):
      mlx4_core: Do not map BF area if capability is 0

James Bottomley (2):
      [PARISC] fix compile break caused by iomap: make IOPORT/PCI
mapping functions conditional
      [PARISC] don't unconditionally override CROSS_COMPILE for 64 bit.

Javier Martin (1):
      ASoC: i.MX SSI: Fix DSP_A format.

Jett.Zhou (1):
      regulator: fix the ldo configure according to 88pm860x spec

Joerg Roedel (1):
      perf/x86/kvm: Fix Host-Only/Guest-Only counting with SVM disabled

Joerg Willmann (1):
      netfilter: ebtables: fix alignment problem in ppc

Johan Hedberg (2):
      Bluetooth: Remove bogus inline declaration from l2cap_chan_connect
      Bluetooth: Add missing QUIRK_NO_RESET test to hci_dev_do_close

Johannes Berg (1):
      mac80211: call rate control only after init

Jonas Bonn (2):
      openrisc: include export.h for EXPORT_SYMBOL
      openrisc: Fix up audit_syscall_[entry|exit]() usage

Joonyoung Shim (2):
      drm/exynos: changed priority of mixer layers.
      drm/exynos: removed pageflip_event_list init code when closed.

Jozsef Kadlecsik (2):
      netfilter: ctnetlink: fix soft lockup when netlink adds new entries
      netfilter: ctnetlink: fix soft lockup when netlink adds new entries (v2)

Julia Lawall (1):
      drivers/atm/solos-pci.c: exchange pci_iounmaps

Kamil Debski (1):
      drm/exynos: exynos_drm.h header file fixes

Konrad Rzeszutek Wilk (2):
      xen/setup: Remove redundant filtering of PTE masks.
      xen/pat: Disable PAT support for now.

Linus Torvalds (7):
      Fix autofs compile without CONFIG_COMPAT
      vfs: trivial __d_lookup_rcu() cleanups
      vfs: uninline full_name_hash()
      vfs: clarify and clean up dentry_cmp()
      vfs: split up name hashing in link_path_walk() into helper function
      vfs: export full_name_hash() function to modules
      Linux 3.3-rc6

Manoj Iyer (1):
      Bluetooth: btusb: Add vendor specific ID (0a5c 21f3) for BCM20702A0

Mark Brown (1):
      ASoC: dapm: Check for bias level when powering down

Masanari Iida (3):
      drm/exynos: Fix typo in exynos_mixer.c
      watchdog: Fix typo in Kconfig
      watchdog: Fix typo in pnx4008_wdt.c

Matt Porter (1):
      ARM: OMAP2+: gpmc-smsc911x: add required smsc911x regulators

Maxim Uvarov (1):
      watchdog: hpwdt: clean up set_memory_x call for 32 bit

Michel Machado (1):
      neighbour: Fixed race condition at tbl->nht

MyungJoo Ham (1):
      watchdog: fix error in probe() of s3c2410_wdt (reset at booting)

Namhyung Kim (2):
      perf/hwbp: Fix a possible memory leak
      perf evlist: Return first evsel for non-sample event on old kernel

Neil Horman (1):
      vmxnet3: cap copy length at size of skb to prevent dropped frames on tx

NeilBrown (1):
      ARM: OMAP: add RCU locking to omap2_set_init_voltage.

Nikola Pajkovsky (1):
      b44: remove __exit from b44_pci_exit()

Nikolaus Schulz (4):
      hwmon: (f75375s) Fix writes to the pwm* attribute for the F75387
      hwmon: (f75375s) Make pwm*_mode writable for the F75387
      hwmon: (f75375s) Properly map the F75387 automatic modes to pwm_enable
      hwmon: (f75375s) Catch some attempts to write to r/o registers

Octavian Purdila (2):
      Bluetooth: silence lockdep warning
      Bluetooth: Fix RFCOMM session reference counting issue

Ohad Ben-Cohen (4):
      ARM: OMAP2: fix mailbox init code
      iommu/omap: fix erroneous omap-iommu-debug API calls
      iommu/omap: fix NULL pointer dereference
      ARM: OMAP: make iommu subsys_initcall to fix builtin omap3isp

Oliver Hartkopp (1):
      can: sja1000: fix isr hang when hw is unplugged under load

Pablo Neira Ayuso (1):
      Revert "netfilter: ctnetlink: fix soft lockup when netlink adds
new entries"

Pavel Roskin (1):
      ath9k: stop on rates with idx -1 in ath9k rate control's .tx_status

Peter Hurley (1):
      Bluetooth: Fix l2cap conn failures for ssp devices

Peter Zijlstra (1):
      sched/events: Revert trace_sched_stat_sleeptime()

Phil Sutter (1):
      crypto: mv_cesa - fix final callback not ignoring input data

Prarit Bhargava (1):
      x86/microcode: Remove noisy AMD microcode warning

Prashanth Nageshappa (2):
      perf probe: Ensure offset provided is not greater than function length
      perf probe: Ensure offset provided is not greater than function
length without DWARF info too

Randy Dunlap (1):
      ecryptfs: fix printk format warning for size_t

Rob Clark (1):
      OMAPDSS: HDMI: hot plug detect fix

Roland Stigge (5):
      ARM: LPC32xx: Fix irq on GPI_28
      ARM: LPC32xx: Fix interrupt controller init
      ARM: LPC32xx: irq.c: Clear latched event
      ARM: LPC32xx: serial.c: HW bug workaround
      ARM: LPC32xx: serial.c: Fixed loop limit

RongQing.Li (3):
      ipv6: ip6_route_output() never returns NULL.
      ethernet/broadcom: ip6_route_output() never returns NULL.
      netfilter: ip6_route_output() never returns NULL.

Santosh Nayak (1):
      enic: Fix endianness bug.

Santosh Shilimkar (2):
      ARM: OMAP4: cpuidle: Fix the C-state reporting to cpuidle governor.
      ARM: OMAP4: Move the barrier memboclk_steal() as part of reserve callback

Scott Talbert (1):
      Move Logitech Harmony 900 from cdc_ether to zaurus

Sebastian Biemueller (1):
      drm/radeon/kms/vm: fix possible bug in radeon_vm_bo_rmv()

Simon Horman (1):
      ipvs: fix matching of fwmark templates during scheduling

Srivatsa S. Bhat (1):
      CPU hotplug, cpusets, suspend: Don't touch cpusets during suspend/resume

Steven Rostedt (3):
      x86/nmi: Test saved %cs in NMI to determine nested NMI case
      x86: Specify a size for the cmp in the NMI handler
      ktest: Fix make_min_config test when build fails

Steven Whitehouse (2):
      GFS2: Fix race between lru_list and glock ref count
      GFS2: Read resource groups on mount

Takashi Iwai (4):
      ALSA: hda/realtek - Fix resume of multiple input sources
      ALSA: hda - Always set HP pin in unsol handler for STAC/IDT codecs
      ALSA: hda - Add a fake mute feature
      ALSA: hda - Kill hyphenated names

Tejun Heo (1):
      memblock: Fix size aligning of memblock_alloc_base_nid()

Thomas Gleixner (2):
      genirq: Unmask oneshot irqs when thread was not woken
      genirq: Handle pending irqs in irq_startup()

Tomi Valkeinen (2):
      OMAPDSS: panel-dvi: Add Kconfig dependency on I2C
      OMAPDSS: APPLY: make ovl_enable/disable synchronous

Tony Lindgren (3):
      ARM: OMAP: Fix kernel panic with HSMMC when twl4030_gpio is a module
      ARM: OMAP: Fix build error when mmc_omap is built as module
      ARM: OMAP1: Fix out-of-bounds array access for Innovator

Ulisses Furquim (2):
      Bluetooth: Remove usage of __cancel_delayed_work()
      Bluetooth: Fix possible use after free in delete path

Vinicius Costa Gomes (1):
      Bluetooth: Fix using an absolute timeout on hci_conn_put()

Wim Van Sebroeck (1):
      watchdog: update maintainers git entry

Wolfram Sang (1):
      i2c: mxs: only flag completion when queue is completely done

Yevgeny Petrilin (3):
      mlx4: Replacing pool_lock with mutex
      mlx4: Setting new port types after all interfaces unregistered
      mlx4_core: Fixing array indexes when setting port types

stephen hemminger (1):
      gre: fix spelling in comments
