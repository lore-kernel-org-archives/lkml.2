Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1INHZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:25:26 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:57751 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab1INHZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFztt7L54sMxguO45MMpdzERmNi+i2a5cbi_MUKdhC-=jg@mail.gmail.com>
References: <CA+55aFztt7L54sMxguO45MMpdzERmNi+i2a5cbi_MUKdhC-=jg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Sep 2011 00:25:02 -0700
X-Google-Sender-Auth: 84Sm5jdOzfctycARE3yjTQcJWMw
Message-ID: <CA+55aFx4aS-2XiYqAkZJPAVSOzNjO2vT3ojArpnivPVa7oDAHA@mail.gmail.com>
Subject: Linux 3.1-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Heh. Somewhat delayed, but I literally didn't notice that all my
outgoing email bounced for the last couple of days, so here it is
again. Originally *meant* to be sent on Monday, just apparently never
got anywhere. So when it says "I should have done this yesterday", it
actually *means* Sunday ;^]

So I should have done this yesterday, but I was distracted. So here it
is, a day late:

   git://github.com/torvalds/linux.git

with just over a hundred commits. It's been fairly quiet.

Some arm and openrisc updates, various small driver fixes (the drm
nvidia fixes might be the ones most noticeable to people), and some
fuse, 9p and btrfs updates for filesystems.

Nothing really stands out. Have at it, and let us know of any
outstanding regressions,

                   Linus

---
Alex Deucher (1):
     drm/radeon/kms: fix DP detect and EDID fetch for DP bridges

Andrey Vagin (1):
     x86, perf: Check that current->mm is alive before getting user callchain

Aneesh Kumar K.V (5):
     fs/9p: Add fid before dentry instantiation
     fs/9p: Don't update file type when updating file attributes
     net/9p: Fix kernel crash with msize 512K
     fs/9p: Add OS dependent open flags in 9p protocol
     fs/9p: Always ask new inode in lookup for cache mode disabled

Anton Vorontsov (1):
     ARM: cns3xxx: Fix newly introduced warnings in the PCIe code

Artem Bityutskiy (1):
     UBI: do not link debug messages when debugging is disabled

Axel Lin (2):
     rtc: ep93xx: Fix 'rtc' may be used uninitialized warning
     i2c-pxa2xx: return proper error code in ce4100_i2c_probe error paths

Bart Van Assche (1):
     backlight: Declare backlight_types[] const

Ben Skeggs (1):
     drm/nouveau: fix oops on pre-semaphore hardware

Chase Douglas (1):
     HID: magicmouse: Set resolution of touch surfaces

Clemens Werther (1):
     HID: add support for HuiJia USB Gamepad connector

Dan Carpenter (1):
     [media] pwc: precedence bug in pwc_init_controls()

David Herrmann (2):
     HID: wacom: Fix error path of power-supply initialization
     HID: wacom: Unregister sysfs attributes on remove

David Sterba (1):
     btrfs: xattr: fix attribute removal

David Vrabel (1):
     xen: use maximum reservation to limit amount of usable RAM

Doug Anderson (1):
     i2c-tegra: fix possible race condition after tx

Duncan Sands (1):
     KVM: Fix instruction size issue in pvclock scaling

Emil Velikov (2):
     drm/nv50/crtc: Bail out if FB is not bound to crtc
     drm/nv04/crtc: Bail out if FB is not bound to crtc

Eric B Munson (1):
     perf_event: Fix broken calc_timer_values()

Florian Mickler (1):
     [media] vp7045: fix buffer setup

Girish K S (1):
     mmc: sdhci-s3c: Fix mmc card I/O problem

Guenter Roeck (2):
     hwmon: (max16065) Fix current calculation
     hwmon: (max16065) Add chip access warning to documentation

Igor Mammedov (1):
     xen: x86_32: do not enable iterrupts when returning from
exception in interrupt context

Ilkka Koskinen (1):
     rtc: rtc-twl: Switch to using threaded irq

Jamie Iles (1):
     ARM: CSR: add missing sentinels to of_device_id tables

Janusz Krzysztofik (1):
     ARM: 7088/1: entry: fix wrong parameter name used in do_thumb_abort

Jarod Wilson (1):
     [media] nuvoton-cir: simplify raw IR sample handling

Jean Delvare (1):
     hwmon: (ucd9000/ucd9200) Optimize array walk

Jean-François Moine (2):
     [media] gspca - ov519: Fix LED inversion of some ov519 webcams
     [media] gspca - sonixj: Fix the darkness of sensor om6802 in 320x240

Jesper Juhl (1):
     [media] [Resend] viacam: Don't explode if pci_find_bus() returns NULL

Jim Garlick (1):
     fs/9p: Use protocol-defined value for lock/getlock 'type' field.

Jiri Kosina (1):
     HID: magicmouse: ignore 'ivalid report id' while switching modes, v2

Joerg Roedel (2):
     iommu/amd: Make sure iommu->need_sync contains correct value
     iommu/amd: Don't take domain->lock recursivly

John Bonesio (1):
     i2c-tegra: Add of_match_table

John Stultz (4):
     alarmtimers: Avoid possible null pointer traversal
     alarmtimers: Memset itimerspec passed into alarm_timer_get
     alarmtimers: Avoid possible denial of service with high freq
periodic timers
     rtc: Fix RTC PIE frequency limit

Jon Mason (1):
     PCI: Remove MRRS modification from MPS setting code

Jonas Bonn (2):
     openrisc: don't use pt_regs in struct sigcontext
     Add missing DMA ops

Josef Bacik (1):
     Btrfs: skip locking if searching the commit root in csum lookup

Kamil Debski (1):
     [media] v4l2: Fix documentation of the codec device controls

Kevin Hilman (1):
     OMAP: omap_device: fix !CONFIG_SUSPEND case in _noirq handlers

Konrad Rzeszutek Wilk (1):
     xen/smp: Warn user why they keel over - nosmp or noapic and what
to use instead.

Li Zefan (2):
     Btrfs: calc file extent num_bytes correctly in file clone
     Btrfs: add dummy extent if dst offset excceeds file end in

Lin Ming (1):
     drm: Remove duplicate "return" statement

Linus Torvalds (1):
     Linux 3.1-rc6

Linus Walleij (3):
     ARM: 7081/1: mach-integrator: fix the clocksource
     ARM: 7080/1: l2x0: make sure I&D are not locked down on init
     ARM: davinci: fix cache flush build error

Liu Bo (3):
     Btrfs: fix an oops when deleting snapshots
     Btrfs: reset to appropriate block rsv after orphan operations
     Btrfs: fix misuse of trans block rsv

Luiz Carlos Ramos (1):
     [media] gspca - sonixj: Fix wrong register mask for sensor om6802

Marcin Slusarz (2):
     drm/nouveau: properly handle allocation failure in nouveau_sgdma_populate
     drm/nouveau: fix nv04_sgdma_bind on non-"4kB pages" archs

Mark Brown (1):
     regmap: Remove bitrotted module_put()s

Mark Rutland (1):
     ARM: 7067/1: mm: keep significant bits in pfn_valid

Mathieu Desnoyers (1):
     ioctl: register LTTng ioctl

Miao Xie (3):
     Btrfs: fix unclosed transaction handle in btrfs_cont_expand
     Btrfs: fix the file extent gap when doing direct IO
     Btrfs: fix wrong nbytes information of the inode

Michal Marek (1):
     UBIFS: not build debug messages with CONFIG_UBIFS_FS_DEBUG disabled

Mika Westerberg (3):
     mmc: rename mmc_host_clk_{ungate|gate} to mmc_host_clk_{hold|release}
     mmc: core: prevent aggressive clock gating racing with ios updates
     mmc: core: use non-reentrant workqueue for clock gating

Mike Rapoport (1):
     i2c-tegra: add I2C_FUNC_SMBUS_EMUL

Mike Waychison (1):
     rtc: Initialized rtc_time->tm_isdst

Miklos Szeredi (3):
     vfs: automount should ignore LOOKUP_FOLLOW
     fuse: fix flock breakage
     fuse: fix memory leak

NeilBrown (4):
     Avoid dereferencing a 'request_queue' after last close.
     md/raid10: unify handling of write completion.
     md/raid1,10: Remove use-after-free bug in make_request.
     md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.

Noah Watkins (1):
     ceph: fix memory leak

Paul Walmsley (4):
     OMAP4: clock: re-enable previous clockdomain enable/disable sequence
     OMAP4: clock: fix compile warning
     OMAP3: clock: indicate that gpt12_fck and wdt1_fck are in the
WKUP clockdomain
     OMAP2430: hwmod: musb: add missing terminator to omap2430_usbhsotg_addrs[]

Per Forlin (4):
     dmaengine/ste_dma40: add missing kernel doc for pending_queue
     dmaengine/ste_dma40: remove duplicate call to d40_pool_lli_free().
     dmaengine/ste_dma40: fix Oops due to double free of client descriptor
     dmaengine/ste_dma40: fix memory leak due to prepared descriptors

Rajashekhara, Sudhakar (1):
     ARM: davinci: da850 EVM: read mac address from SPI flash

Rajendra Nayak (1):
     OMAP: powerdomains: Make all powerdomain target states as ON at init

Randy Dunlap (3):
     wireless: fix kernel-doc warning in net/cfg80211.h
     regulator: fix kernel-doc warning in consumer.h
     scsi: qla4xxx driver depends on NET

Russell King (1):
     NET: am79c961: fix race in link status code

Sage Weil (3):
     libceph: fix msgpool
     ceph: fix encoding of ino only (not relative) paths
     libceph: fix leak of osd structs during shutdown

Santosh Shilimkar (1):
     OMAP: clockdomain: Wait for powerdomain to be ON when using
clockdomain force wakeup

Sebastian Reichel (1):
     rtc: rtc-twl: Remove lockdep related local_irq_enable()

Sergei Shtylyov (1):
     ARM: davinci: correct MDSTAT_STATE_MASK

Sergei Trofimovich (1):
     btrfs: fix warning in iput for bad-inode

Shawn Guo (1):
     mmc: sdhci-esdhc-imx: add missing inclusion of linux/module.h

Shyam Iyer (1):
     Fix pointer dereference before call to pcie_bus_configure_settings

Simon Horman (1):
     mmc: sdhi: initialise mmc_data->flags before use

Stephane Eranian (1):
     perf events: Fix slow and broken cgroup context switch code

Subhash Jadavani (1):
     mmc: sd: UHS-I bus speed should be set last in UHS initialization

Thomas Gleixner (2):
     sched: Separate the scheduler entry for preemption
     sched: Move blk_schedule_flush_plug() out of __schedule()

Todd Poynor (1):
     rtc: twl: Fix registration vs. init order

Tommy Lin (1):
     ARM: cns3xxx: Fix compile error caused by hardware.h removed

WANG Cong (1):
     sched: Fix a memory leak in __sdt_free()
