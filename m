Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2BSGuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 01:50:55 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62211 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2BSGux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 01:50:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gcoady.lk@gmail.com designates 10.68.222.194 as permitted sender) smtp.mail=gcoady.lk@gmail.com; dkim=pass header.i=gcoady.lk@gmail.com
From: Grant Coady <gcoady.lk@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: compile warnings, linux-3.2.6a/arch/x86/include/asm/uaccess_32.h, was Re: Linux 3.2.6
Date: Sun, 19 Feb 2012 17:50:45 +1100
Organization: scattered
Message-ID: <h561k71mg76rebd4m46l25791ilkcr8n0r@4ax.com>
References: <20120213192545.GA28291@kroah.com>
In-Reply-To: <20120213192545.GA28291@kroah.com>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 11:25:45 -0800, you wrote:

>I'm announcing the release of the 3.2.6 kernel.
>
>All users of the 3.2 kernel series must upgrade.

I'm getting:
...
  CC      drivers/net/Space.o
In file included from /home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess.h:573:0,
                 from /home/grant/linux/linux-3.2.6a/arch/x86/include/asm/sections.h:5,
                 from /home/grant/linux/linux-3.2.6a/arch/x86/include/asm/hw_irq.h:26,
                 from include/linux/irq.h:357,
                 from /home/grant/linux/linux-3.2.6a/arch/x86/include/asm/hardirq.h:5,
                 from include/linux/hardirq.h:7,
                 from include/linux/interrupt.h:12,
                 from net/core/pktgen.c:135:
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:877:20:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1147:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1254:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1276:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1300:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1323:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1346:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1367:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1388:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1409:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1431:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:1448:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
  CC      drivers/net/loopback.o
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1771:20:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
In function 'copy_from_user',
    inlined from 'pktgen_thread_write' at net/core/pktgen.c:1802:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
  CC [M]  drivers/net/ethernet/broadcom/bnx2.o
...

Is this bad? Turning off the pktgen option reduced the compile 
warnings to a single:

In file included from /home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess.h:573:0,
                 from include/net/checksum.h:25,
                 from include/linux/skbuff.h:28,
                 from include/linux/if_ether.h:133,
                 from include/linux/netdevice.h:29,
                 from net/packet/af_packet.c:62:
In function 'copy_from_user',
    inlined from 'packet_getsockopt' at net/packet/af_packet.c:3269:21:
/home/grant/linux/linux-3.2.6a/arch/x86/include/asm/uaccess_32.h:211:26: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct

Cheers,
Grant.
>
>The updated 3.2.y git tree can be found at:
>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
>and can be browsed at the normal kernel.org git web browser:
>        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>
>thanks,
>
>greg k-h
>
>------------
>
> Makefile                                  |    2 
> arch/arm/kernel/ptrace.c                  |    8 +
> arch/arm/kernel/signal.c                  |    5 -
> arch/arm/mach-omap2/gpmc.c                |    6 +
> drivers/cpufreq/powernow-k8.c             |   30 ++++--
> drivers/dma/at_hdmac.c                    |    4 
> drivers/dma/at_hdmac_regs.h               |   17 +--
> drivers/firewire/ohci.c                   |    6 +
> drivers/gpu/drm/i915/i915_debugfs.c       |    8 +
> drivers/gpu/drm/i915/i915_dma.c           |    1 
> drivers/gpu/drm/i915/i915_drv.c           |   20 +++-
> drivers/gpu/drm/i915/i915_drv.h           |   12 ++
> drivers/gpu/drm/i915/i915_irq.c           |   13 ++-
> drivers/gpu/drm/i915/i915_suspend.c       |    4 
> drivers/gpu/drm/i915/intel_dp.c           |    1 
> drivers/gpu/drm/i915/intel_hdmi.c         |    8 +
> drivers/gpu/drm/i915/intel_tv.c           |   16 +--
> drivers/gpu/drm/nouveau/nouveau_gem.c     |   23 ++++-
> drivers/gpu/drm/radeon/atombios_crtc.c    |    4 
> drivers/gpu/drm/radeon/atombios_dp.c      |   18 +++-
> drivers/gpu/drm/radeon/radeon_device.c    |    4 
> drivers/hwmon/w83627ehf.c                 |   23 ++++-
> drivers/infiniband/core/uverbs_cmd.c      |    1 
> drivers/infiniband/core/verbs.c           |    2 
> drivers/infiniband/hw/mlx4/mad.c          |    7 -
> drivers/iommu/amd_iommu.c                 |    3 
> drivers/iommu/msm_iommu.c                 |    7 -
> drivers/misc/cb710/core.c                 |    1 
> drivers/mtd/nand/atmel_nand.c             |   45 +++++++++-
> drivers/mtd/nand/gpmi-nand/gpmi-lib.c     |   18 +++-
> drivers/net/ethernet/realtek/8139cp.c     |    1 
> drivers/pcmcia/ds.c                       |    4 
> drivers/staging/asus_oled/asus_oled.c     |   13 ++-
> drivers/staging/rtl8712/drv_types.h       |    7 +
> drivers/staging/rtl8712/hal_init.c        |   62 ++++++++++----
> drivers/staging/rtl8712/os_intfs.c        |   14 ++-
> drivers/staging/rtl8712/rtl8712_hal.h     |    1 
> drivers/staging/rtl8712/usb_intf.c        |   10 +-
> drivers/staging/zcache/zcache-main.c      |   11 +-
> drivers/target/iscsi/iscsi_target.c       |   39 +++++++--
> drivers/target/iscsi/iscsi_target_core.h  |    2 
> drivers/target/iscsi/iscsi_target_login.c |   31 ++++++-
> drivers/target/iscsi/iscsi_target_util.c  |   11 ++
> drivers/target/target_core_cdb.c          |    9 +-
> drivers/target/target_core_pr.c           |    5 -
> drivers/target/target_core_transport.c    |   21 +++-
> drivers/tty/vt/vt_ioctl.c                 |    1 
> drivers/usb/gadget/f_loopback.c           |    2 
> drivers/usb/host/pci-quirks.c             |    6 +
> drivers/usb/serial/ftdi_sio.c             |    1 
> drivers/usb/serial/ftdi_sio_ids.h         |    7 +
> drivers/usb/serial/option.c               |  129 +++++++++++++++++++++++++++++-
> drivers/video/atmel_lcdfb.c               |    2 
> fs/cifs/sess.c                            |    7 -
> fs/ecryptfs/read_write.c                  |    4 
> fs/proc/base.c                            |  106 ++++++++++--------------
> fs/udf/super.c                            |    6 +
> include/linux/freezer.h                   |    2 
> include/linux/pm_qos.h                    |   14 +++
> include/linux/usb/ch9.h                   |    2 
> kernel/kprobes.c                          |    6 +
> kernel/panic.c                            |   17 +++
> kernel/power/hibernate.c                  |    2 
> kernel/power/power.h                      |    2 
> kernel/power/process.c                    |    9 ++
> kernel/power/user.c                       |   22 ++++-
> kernel/sched_rt.c                         |    5 +
> mm/compaction.c                           |   24 +++++
> mm/filemap.c                              |    8 -
> mm/filemap_xip.c                          |    7 +
> mm/huge_memory.c                          |    4 
> mm/swap.c                                 |    2 
> sound/pci/hda/hda_codec.c                 |    2 
> sound/pci/hda/patch_cirrus.c              |    6 -
> sound/pci/hda/patch_realtek.c             |   44 ++++++++--
> sound/pci/hda/patch_via.c                 |   28 +++++-
> sound/pci/oxygen/oxygen_mixer.c           |   25 +++--
> sound/soc/codecs/wm8962.c                 |    6 -
> sound/soc/codecs/wm8994.c                 |    6 +
> sound/soc/codecs/wm_hubs.c                |   18 ++--
> 80 files changed, 822 insertions(+), 268 deletions(-)
>
>Alex Deucher (1):
>      drm/radeon/kms: fix TRAVIS panel setup
>
>Andreas Herrmann (2):
>      powernow-k8: Avoid Pstate MSR accesses on systems supporting CPB
>      powernow-k8: Fix indexing issue
>
>Artem Bityutskiy (1):
>      Revert "mtd: atmel_nand: optimize read/write buffer functions"
>
>Axel Lin (1):
>      mmc: cb710 core: Add missing spin_lock_init for irq_lock of struct cb710_chip
>
>Ben Hutchings (1):
>      lockdep, bug: Exclude TAINT_OOT_MODULE from disabling lock debugging
>
>Ben Skeggs (1):
>      drm/nouveau/gem: fix fence_sync race / oops
>
>Bernd Schubert (1):
>      RDMA/core: Fix kernel panic by always initializing qp->usecnt
>
>Carsten Otte (1):
>      mm/filemap_xip.c: fix race condition in xip_file_fault()
>
>Chanho Min (1):
>      sched/rt: Fix task stack corruption under __ARCH_WANT_INTERRUPTS_ON_CTXSW
>
>Clemens Ladisch (2):
>      firewire: ohci: add reset packet quirk for SB Audigy
>      ALSA: oxygen, virtuoso: fix exchanged L/R volumes of aux and CD inputs
>
>Dan Magenheimer (2):
>      zcache: Set SWIZ_BITS to 8 to reduce tmem bucket lock contention.
>      zcache: fix deadlock condition
>
>Daniel Vetter (3):
>      drm/i915: check ACTHD of all rings
>      drm/i915: convert force_wake_get to func pointer in the gpu reset code
>      drm/i915: protect force_wake_(get|put) with the gt_lock
>
>Dave Martin (1):
>      ARM: 7307/1: vfp: fix ptrace regset modification race
>
>David Henningsson (2):
>      ALSA: HDA: Remove quirk for Asus N53Jq
>      ALSA: HDA: Fix duplicated output to more than one codec
>
>Dylan Reid (1):
>      ALSA: hda - Fix calling cs_automic twice for Cirrus codecs.
>
>Eugeni Dodonov (1):
>      drm/i915: handle 3rd pipe
>
>Francois Romieu (1):
>      8139cp: fix missing napi_gro_flush.
>
>Greg Kroah-Hartman (1):
>      Linux 3.2.6
>
>Guenter Roeck (1):
>      hwmon: (w83627ehf) Fix number of fans for NCT6776F
>
>Huang Shijie (1):
>      mtd: gpmi-nand bugfix: reset the BCH module when it is not MX23
>
>Hubert Feurstein (1):
>      atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume
>
>Hugh Dickins (1):
>      mm: fix UP THP spin_is_locked BUGs
>
>Jack Morgenstein (1):
>      IB/mlx4: pass SMP vendor-specific attribute MADs to firmware
>
>Jan Kara (1):
>      udf: Mark LVID buffer as uptodate before marking it dirty
>
>Jayachandran C (1):
>      usb: Skip PCI USB quirk handling for Netlogic XLP
>
>Jiang Liu (1):
>      kprobes: fix a memory leak in function pre_handler_kretprobe()
>
>Joerg Roedel (2):
>      iommu/amd: Work around broken IVRS tables
>      iommu/msm: Fix error handling in msm_iommu_unmap()
>
>Kuninori Morimoto (1):
>      usb: ch9.h: usb_endpoint_maxp() uses __le16_to_cpu()
>
>Larry Finger (2):
>      staging: r8712u: Add new Sitecom UsB ID
>      staging: r8712u: Use asynchronous firmware loading
>
>Li Wang (1):
>      eCryptfs: Infinite loop due to overflow in ecryptfs_write()
>
>Marco Sanvido (2):
>      target: Use correct preempted registration sense code
>      target: Allow PERSISTENT RESERVE IN for non-reservation holder
>
>Mark Brown (5):
>      ASoC: wm_hubs: Enable line out VMID buffer for single ended line outputs
>      ASoC: wm_hubs: Fix routing of input PGAs to line output mixer
>      ASoC: wm_hubs: Correct line input to line output 2 paths
>      ASoC: wm8994: Enabling VMID should take a runtime PM reference
>      ASoC: wm8994: Fix typo in VMID ramp setting
>
>Mel Gorman (2):
>      mm: compaction: check pfn_valid when entering a new MAX_ORDER_NR_PAGES block during isolation for migration
>      mm: compaction: check for overlapping nodes during isolation for migration
>
>Michel Dänzer (1):
>      drm/radeon: Set DESKTOP_HEIGHT register to the framebuffer (not mode) height.
>
>Milan Kocian (1):
>      USB: usbserial: add new PID number (0xa951) to the ftdi driver
>
>Nicholas Bellinger (4):
>      iscsi-target: Fix reject release handling in iscsit_free_cmd()
>      iscsi-target: Fix double list_add with iscsit_alloc_buffs reject
>      iscsi-target: Fix discovery with INADDR_ANY and IN6ADDR_ANY_INIT
>      target: Add workaround for zero-length control CDB handling
>
>Nikolaus Voss (1):
>      at_hdmac: bugfix for enabling channel irq
>
>Oleg Nesterov (3):
>      proc: mem_release() should check mm != NULL
>      proc: unify mem_read() and mem_write()
>      proc: make sure mem_open() doesn't pin the target's memory
>
>Pekka Paalanen (2):
>      Staging: asus_oled: fix image processing
>      Staging: asus_oled: fix NULL-ptr crash on unloading
>
>Peter Zijlstra (1):
>      lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
>
>Rafael J. Wysocki (1):
>      PM / Hibernate: Fix s2disk regression related to freezing workqueues
>
>Rodrigo Vivi (1):
>      drm/i915: Fix TV Out refresh rate.
>
>Roland Dreier (3):
>      target: Correct sense key for INVALID FIELD IN {PARAMETER LIST,CDB}
>      target: Return correct ASC for unimplemented VPD pages
>      target: Fail INQUIRY commands with EVPD==0 but PAGE CODE!=0
>
>Rui li (1):
>      USB: add new zte 3g-dongle's pid to option.c
>
>Russell King (1):
>      pcmcia: fix socket refcount decrementing on each resume
>
>Samuel Thibault (1):
>      drivers/tty/vt/vt_ioctl.c: fix KDFONTOP 32bit compatibility layer
>
>Seth Forshee (1):
>      drm/radeon/kms: disable output polling when suspended
>
>Shaohua Li (1):
>      readahead: fix pipeline break caused by block plug
>
>Shirish Pargaonkar (1):
>      cifs: Fix oops in session setup code for null user mounts
>
>Srivatsa S. Bhat (2):
>      PM / Hibernate: Thaw processes in SNAPSHOT_CREATE_IMAGE ioctl test path
>      PM / Hibernate: Thaw kernel threads in SNAPSHOT_CREATE_IMAGE ioctl path
>
>Stefan Richter (1):
>      firewire: ohci: disable MSI on Ricoh controllers
>
>Susan Gao (1):
>      ASoC: wm8962: Fix word length configuration
>
>Takashi Iwai (4):
>      ALSA: hda - Fix the logic to detect VIA analog low-current mode
>      ALSA: hda - Apply 0x0f-VREF fix to all ASUS laptops with ALC861/660
>      ALSA: hda - Allow analog low-current mode when dynamic power-control is on
>      ALSA: hda - Disable dynamic-power control for VIA as default
>
>Timo Juhani Lindfors (1):
>      usb: gadget: zero: fix bug in loopback autoresume handling
>
>UK KIM (1):
>      ASoC: wm_hubs: fix wrong bits for LINEOUT2 N/P mixer
>
>Venkatesh Pallipadi (1):
>      PM / QoS: CPU C-state breakage with PM Qos change
>
>Will Deacon (2):
>      ARM: 7306/1: vfp: flush thread hwstate before restoring context from sigframe
>      ARM: 7308/1: vfp: flush thread hwstate before copying ptrace registers
>
>Wu Fengguang (2):
>      drm/i915: HDMI hot remove notification to audio driver
>      drm/i915: DisplayPort hot remove notification to audio driver
>
>Yegor Yefremov (1):
>      ARM: OMAP2+: GPMC: fix device size setup
