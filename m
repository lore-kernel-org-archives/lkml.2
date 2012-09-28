Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2I1UjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:39:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47338 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759309Ab2I1UjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:39:02 -0400
X-Sasl-enc: 1kQ6wu6TacigBpoUpT8R5+YcGTH97K9pGPX4U0KLJ8AG 1348864741
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk
Subject: =?UTF-8?q?=5B=20000/127=5D=203=2E0=2E44-stable=20review?=
Date: Fri, 28 Sep 2012 13:32:53 -0700
Message-Id: <20120928203045.835238916@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.44 release.
There are 127 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Sep 30 20:29:56 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.44-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix race condition when removing host controllers

Andi Kleen <andi@firstfloor.org>
    MCE: Fix vm86 handling for 32bit mce handler

Yasunori Goto <y-goto@jp.fujitsu.com>
    sched: Fix ancient race in do_exit()

Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    spi/spi-fsl-spi: reference correct pdata in fsl_spi_cs_control

Kenth Eriksson <kenth.eriksson@transmode.com>
    spi/mpc83xx: fix NULL pdata dereference bug

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBI: fix a horrible memory deallocation bug

Chris Boot <bootc@bootc.net>
    e1000e: Disable ASPM L1 on 82574

Al Cooper <acooper@gmail.com>
    mmc: Prevent 1.8V switch for SD hosts that don't support UHS modes.

Subhash Jadavani <subhashj@codeaurora.org>
    mmc: sd: Handle SD3.0 cards not supporting UHS-I bus speed mode

Phillip Lougher <phillip@squashfs.org.uk>
    Squashfs: fix mount time sanity check for corrupted superblock

Tomoya MORINAGA <tomoya.rohm@gmail.com>
    pch_uart: Fix parity setting issue

Tomoya MORINAGA <tomoya.rohm@gmail.com>
    pch_uart: Fix rx error interrupt setting issue

Alan Cox <alan@linux.intel.com>
    pch_uart: Fix missing break for 16 byte fifo

Douglas Bagnall <douglas@paradise.net.nz>
    media: Avoid sysfs oops when an rc_dev's raw device is absent

John Stultz <john.stultz@linaro.org>
    time: Move ktime_t overflow checking into timespec_valid_strict

John Stultz <john.stultz@linaro.org>
    time: Avoid making adjustments if we haven't accumulated anything

John Stultz <john.stultz@linaro.org>
    time: Improve sanity checking of timekeeping inputs

Eric Dumazet <edumazet@google.com>
    drop_monitor: dont sleep in atomic context

Neil Horman <nhorman@tuxdriver.com>
    drop_monitor: prevent init path from scheduling on the wrong cpu

Neil Horman <nhorman@tuxdriver.com>
    drop_monitor: Make updating data->skb smp safe

Neil Horman <nhorman@tuxdriver.com>
    drop_monitor: fix sleeping in invalid context warning

Jarod Wilson <jarod@redhat.com>
    media: lirc_sir: make device registration work

Peter Zijlstra <peterz@infradead.org>
    sched: Fix race in task_group()

Thomas Renninger <trenn@suse.de>
    cpufreq / ACPI: Fix not loading acpi-cpufreq driver regression

Daniel J Blueman <daniel@quora.org>
    libata: Prevent interface errors with Seagate FreeAgent GoFlex

Weiping Pan <wpan@redhat.com>
    rds: set correct msg_namelen

Li Zhong <zhong@linux.vnet.ibm.com>
    Fix a dead loop in async_synchronize_full()

Rustad, Mark D <mark.d.rustad@intel.com>
    net: Statically initialize init_net.dev_base_head

Henrik Rydberg <rydberg@euromail.se>
    Bluetooth: Add support for Apple vendor-specific devices

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices

Manoj Iyer <manoj.iyer@canonical.com>
    Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0

Alan Cox <alan@linux.intel.com>
    x86: Fix boot on Twinhead H12Y

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be atomic

NeilBrown <neilb@suse.de>
    md: make sure metadata is updated when spares are activated or removed.

Wang Xingchao <xingchao.wang@intel.com>
    drm/i915: HDMI - Clear Audio Enable bit for Hot Plug

AceLan Kao <acelan.kao@canonical.com>
    asus-nb-wmi: add some video toggle keys

Corentin Chary <corentin.chary@gmail.com>
    asus-laptop: HRWS/HWRS typo

Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
    drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to cover later silicon stepping

Dave Airlie <airlied@redhat.com>
    fbcon: fix race condition between console lock and cursor timer (v1.1)

Robin Holt <holt@sgi.com>
    drivers/misc/sgi-xp/xpc_uv.c: SGI XPC fails to load when cpu 0 is out of IRQ resources

Rafael J. Wysocki <rjw@sisk.pl>
    PM / Runtime: Clear power.deferred_resume on success in rpm_suspend()

Rafael J. Wysocki <rjw@sisk.pl>
    PM / Runtime: Fix rpm_resume() return value for power.no_callbacks set

Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode

Will Deacon <will.deacon@arm.com>
    mutex: Place lock in contended state after fastpath_lock failure

Sarah Sharp <sarah.a.sharp@linux.intel.com>
    xhci: Fix bug after deq ptr set to link TRB.

Moiz Sonasath <m-sonasath@ti.com>
    usb: host: xhci: fix compilation error for non-PCI based stacks

Manoj Iyer <manoj.iyer@canonical.com>
    xhci: Recognize USB 3.0 devices as superspeed at powerup

Matthew Garrett <mjg@redhat.com>
    xhci: Make handover code more robust

Dan Carpenter <dan.carpenter@oracle.com>
    xhci: Fix a logical vs bitwise AND bug

Keng-Yu Lin <kengyu@canonical.com>
    Intel xhci: Only switch the switchable ports

Alan Stern <stern@rowland.harvard.edu>
    USB: add device quirk for Joss Optical touchboard

Éric Piel <piel@delmic.com>
    USB: ftdi-sio: add support for more Physik Instrumente devices

Bjørn Mork <bjorn@mork.no>
    USB: ftdi_sio: do not claim CDC ACM function

Horst Schirmeier <horst@schirmeier.com>
    USB: ftdi_sio: PID for NZR SEM 16+ USB

Pavankumar Kondeti <pkondeti@codeaurora.org>
    EHCI: Update qTD next pointer in QH overlay region during unlink

Weston Andros Adamson <dros@netapp.com>
    NFS: return error from decode_getfh in decode open

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix a problem with the legacy binary mount code

Trond Myklebust <Trond.Myklebust@netapp.com>
    NFS: Fix the initialisation of the readdir 'cookieverf' array

Gertjan van Wingerde <gwingerde@gmail.com>
    rt2x00: Fix rfkill polling prior to interface start.

Gertjan van Wingerde <gwingerde@gmail.com>
    rt2x00: Fix word size of rt2500usb MAC_CSR19 register.

Nicolas Ferre <nicolas.ferre@atmel.com>
    dmaengine: at_hdmac: check that each sg data length is non-null

Nicolas Ferre <nicolas.ferre@atmel.com>
    dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()

Luis R. Rodriguez <mcgrof@do-not-panic.com>
    cfg80211: fix possible circular lock on reg_regdb_search()

Ira W. Snyder <iws@ovro.caltech.edu>
    can: janz-ican3: fix support for older hardware revisions

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ti_hecc: fix oops during rmmod

Søren Holm <sgh@sgh.dk>
    asix: Support DLink DUB-E100 H/W Ver C1

Anisse Astier <anisse@astier.eu>
    Input: i8042 - disable mux on Toshiba C850D

Wen Congyang <wency@cn.fujitsu.com>
    tracing: Don't call page_to_pfn() if page is NULL

Matthew Leach <matthew.leach@arm.com>
    ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores

Tetsuyuki Kobayashi <koba@kmckk.co.jp>
    ARM: fix bad applied patch for arch/arm/Kconfig of stable 3.0.y tree.

Toshi Kani <toshi.kani@hp.com>
    hpwdt: Fix kdump issue in hpwdt

Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Bluetooth: Fix not removing power_off delayed work

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: fix handling of protocol error

Eddie Wai <eddie.wai@broadcom.com>
    SCSI: bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

sreekanth.reddy@lsi.com <sreekanth.reddy@lsi.com>
    SCSI: mpt2sas: Fix for issue - Unable to boot from the drive connected to HBA

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ads7871) Add 'name' sysfs attribute

Andreas Herrmann <andreas.herrmann3@amd.com>
    hwmon: (fam15h_power) Tweak runavg_range on resume

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/boot: Disable NUMA for PV guests.

qiuxishi <qiuxishi@gmail.com>
    memory hotplug: fix section info double registration bug

Jianguo Wu <wujianguo@huawei.com>
    mm/ia64: fix a memory block size bug

Benoît Locher <Benoit.Locher@skf.com>
    can: mcp251x: avoid repeated frame bug

Guenter Roeck <linux@roeck-us.net>
    hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elements

Kevin Hilman <khilman@ti.com>
    drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe

Li Haifeng <omycle@gmail.com>
    mm/page_alloc: fix the page address of higher page's buddy calculation

NeilBrown <neilb@suse.de>
    md: Don't truncate size at 4TB for RAID0 and Linear

Mel Gorman <mgorman@suse.de>
    Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Bjørn Mork <bjorn@mork.no>
    kobject: fix oops with "input0: bad kobj_uevent_env content in show_uevent()"

Alan Cox <alan@linux.intel.com>
    ahci: Add alternate identifier for the 88SE9172

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci-esdhc: break out early if clock is 0

Lauri Hintsala <lauri.hintsala@bluegiga.com>
    mmc: mxs-mmc: fix deadlock in SDIO IRQ case

Al Viro <viro@ZenIV.linux.org.uk>
    perf_event: Switch to internal refcount, fix race with close()

Bjørn Mork <bjorn@mork.no>
    USB: option: replace ZTE K5006-Z entry with vendor class rule

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das08: Correct AO output for das08jr-16-ao

Eric Dumazet <edumazet@google.com>
    staging: r8712u: fix bug in r8712_recv_indicatepkt()

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] - Failed connection, incorrect endian.

Christopher Brannon <chris@the-brannons.com>
    Staging: speakup: fix an improperly-declared variable.

Matteo Frigo <athena@fftw.org>
    ALSA: ice1724: Use linear scale for AK4396 volume control.

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Fix ->data_length re-assignment bug with SCSI overflow

Tyler Hicks <tyhicks@canonical.com>
    eCryptfs: Copy up attributes of the lower target inode after rename

Amerigo Wang <amwang@redhat.com>
    netconsole: remove a redundant netconsole_target_put()

Miklos Szeredi <mszeredi@suse.cz>
    vfs: dcache: use DCACHE_DENTRY_KILLED instead of DCACHE_DISCONNECTED in d_kill()

Linus Torvalds <torvalds@linux-foundation.org>
    vfs: make O_PATH file descriptors usable for 'fstat()'

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    cciss: fix handling of protocol error

Tejun Heo <tj@kernel.org>
    cpufreq/powernow-k8: workqueue user shouldn't migrate the kworker to another CPU

Tejun Heo <tj@kernel.org>
    workqueue: reimplement work_on_cpu() using system_wq

Francesco Ruggeri <fruggeri@aristanetworks.com>
    net: ipv4: ipmr_expire_timer causes crash when removing net namespace

xeb@mail.ru <xeb@mail.ru>
    l2tp: avoid to use synchronize_rcu in tunnel free function

Pablo Neira Ayuso <pablo@netfilter.org>
    netlink: fix possible spoofing from non-root processes

Mathias Krause <minipli@googlemail.com>
    net: fix info leak in compat dev_ifconf()

Mathias Krause <minipli@googlemail.com>
    ipvs: fix info leak in getsockopt(IP_VS_SO_GET_TIMEOUT)

Mathias Krause <minipli@googlemail.com>
    dccp: fix info leak via getsockopt(DCCP_SOCKOPT_CCID_TX_INFO)

Mathias Krause <minipli@googlemail.com>
    llc: fix info leak via getsockname()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: L2CAP - Fix info leak via getsockname()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: RFCOMM - Fix info leak via getsockname()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: RFCOMM - Fix info leak in ioctl(RFCOMMGETDEVLIST)

Mathias Krause <minipli@googlemail.com>
    Bluetooth: HCI - Fix info leak via getsockname()

Mathias Krause <minipli@googlemail.com>
    Bluetooth: HCI - Fix info leak in getsockopt(HCI_FILTER)

Mathias Krause <minipli@googlemail.com>
    atm: fix info leak via getsockname()

Mathias Krause <minipli@googlemail.com>
    atm: fix info leak in getsockopt(SO_ATMPVC)

Ben Hutchings <bhutchings@solarflare.com>
    ipv6: addrconf: Avoid calling netdevice notifiers with RCU read-side lock

danborkmann@iogearbox.net <danborkmann@iogearbox.net>
    af_packet: remove BUG statement in tpacket_destruct_skb

Alexey Khoroshilov <khoroshilov@ispras.ru>
    net/core: Fix potential memory leak in dev_set_alias()

Wu Fengguang <fengguang.wu@intel.com>
    isdnloop: fix and simplify isdnloop_init()

Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
    net_sched: gact: Fix potential panic in tcf_gact().

Ben Hutchings <bhutchings@solarflare.com>
    tcp: Apply device TSO segment limit earlier

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix maximum number of TSO segments and minimum TX queue size

Ben Hutchings <bhutchings@solarflare.com>
    net: Allow driver to limit number of GSO segments per skb


-------------

Diffstat:

 Makefile                                 |    4 +-
 arch/alpha/include/asm/atomic.h          |    4 +-
 arch/arm/Kconfig                         |   52 +++++++++++++-------------
 arch/arm/boot/compressed/head.S          |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c         |    9 ++++-
 arch/x86/pci/fixup.c                     |   17 +++++++++
 arch/x86/xen/setup.c                     |    4 ++
 drivers/acpi/processor_core.c            |    6 ++-
 drivers/ata/ahci.c                       |    2 +
 drivers/ata/libata-core.c                |    1 +
 drivers/base/power/runtime.c             |    5 ++-
 drivers/block/cciss_scsi.c               |    1 +
 drivers/bluetooth/btusb.c                |   10 +++--
 drivers/cpufreq/powernow-k8.c            |   63 +++++++++++++++++---------------
 drivers/dma/at_hdmac.c                   |   13 ++++++-
 drivers/gpu/drm/i915/intel_hdmi.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_atombios.c |    2 +-
 drivers/hwmon/ads7871.c                  |    9 +++++
 drivers/hwmon/fam15h_power.c             |   15 +++++++-
 drivers/hwmon/twl4030-madc-hwmon.c       |    9 +++--
 drivers/input/serio/i8042-x86ia64io.h    |    6 +++
 drivers/isdn/isdnloop/isdnloop.c         |   12 ------
 drivers/md/md.c                          |   17 +++++++--
 drivers/media/rc/rc-main.c               |    5 ++-
 drivers/misc/sgi-xp/xpc_uv.c             |   84 ++++++++++++++++++++++++++++++++----------
 drivers/mmc/core/sd.c                    |    6 +--
 drivers/mmc/host/mxs-mmc.c               |    4 +-
 drivers/mmc/host/sdhci-esdhc.h           |    6 +--
 drivers/mmc/host/sdhci.c                 |    5 ++-
 drivers/mtd/ubi/vtbl.c                   |    4 +-
 drivers/net/can/janz-ican3.c             |    4 +-
 drivers/net/can/mcp251x.c                |   11 +++++-
 drivers/net/can/ti_hecc.c                |    2 +-
 drivers/net/e1000e/82571.c               |    3 +-
 drivers/net/netconsole.c                 |    1 -
 drivers/net/sfc/efx.c                    |    6 +++
 drivers/net/sfc/efx.h                    |   14 +++++--
 drivers/net/sfc/ethtool.c                |   16 +++++---
 drivers/net/sfc/nic.h                    |    5 +++
 drivers/net/sfc/tx.c                     |   19 ++++++++++
 drivers/net/usb/asix.c                   |    4 ++
 drivers/net/wireless/rt2x00/rt2400pci.c  |    9 +++++
 drivers/net/wireless/rt2x00/rt2400pci.h  |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c  |    9 +++++
 drivers/net/wireless/rt2x00/rt2500usb.c  |   11 +++++-
 drivers/net/wireless/rt2x00/rt2500usb.h  |   17 +++++----
 drivers/net/wireless/rt2x00/rt2800pci.c  |    9 +++++
 drivers/net/wireless/rt2x00/rt2800usb.c  |    9 +++++
 drivers/net/wireless/rt2x00/rt61pci.c    |    9 +++++
 drivers/net/wireless/rt2x00/rt61pci.h    |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c    |    9 +++++
 drivers/net/wireless/rt2x00/rt73usb.h    |    3 ++
 drivers/platform/x86/asus-laptop.c       |    8 ++--
 drivers/platform/x86/asus-nb-wmi.c       |    4 ++
 drivers/rtc/rtc-rs5c348.c                |    7 +++-
 drivers/rtc/rtc-twl.c                    |    5 +++
 drivers/scsi/bnx2i/bnx2i_hwi.c           |    3 ++
 drivers/scsi/hpsa.c                      |    3 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c      |    7 ++++
 drivers/spi/spi_fsl_spi.c                |    6 ++-
 drivers/staging/comedi/drivers/das08.c   |    2 +-
 drivers/staging/lirc/lirc_sir.c          |   60 +++++++++++++++++++++++++++++-
 drivers/staging/rtl8712/recv_linux.c     |    7 +---
 drivers/staging/speakup/main.c           |    2 +-
 drivers/staging/vt6656/dpc.c             |    2 +-
 drivers/staging/vt6656/rxtx.c            |   38 +++++++++----------
 drivers/target/target_core_transport.c   |    9 ++++-
 drivers/tty/serial/pch_uart.c            |   21 +++++++----
 drivers/usb/core/devices.c               |    2 +-
 drivers/usb/core/hcd.c                   |    6 +--
 drivers/usb/core/quirks.c                |    4 ++
 drivers/usb/host/ehci-q.c                |   12 +++++-
 drivers/usb/host/pci-quirks.c            |   42 +++++++++++++++++----
 drivers/usb/host/pci-quirks.h            |    1 +
 drivers/usb/host/xhci-ring.c             |   39 ++++++++++++--------
 drivers/usb/host/xhci.c                  |    2 +-
 drivers/usb/serial/ftdi_sio.c            |   22 ++++++++++-
 drivers/usb/serial/ftdi_sio_ids.h        |   29 ++++++++++++++-
 drivers/usb/serial/option.c              |    6 ++-
 drivers/video/console/fbcon.c            |    9 ++++-
 drivers/watchdog/hpwdt.c                 |    3 ++
 fs/dcache.c                              |    4 +-
 fs/ecryptfs/inode.c                      |    5 +++
 fs/nfs/inode.c                           |    2 +-
 fs/nfs/nfs3proc.c                        |    2 +-
 fs/nfs/nfs4proc.c                        |    4 +-
 fs/nfs/nfs4xdr.c                         |    3 +-
 fs/nfs/super.c                           |    2 +
 fs/squashfs/super.c                      |    2 +-
 fs/stat.c                                |    2 +-
 include/asm-generic/mutex-xchg.h         |   11 +++++-
 include/linux/dcache.h                   |    2 +
 include/linux/init_task.h                |   12 +++++-
 include/linux/kobject.h                  |    2 +-
 include/linux/ktime.h                    |    7 ----
 include/linux/memory.h                   |    2 +-
 include/linux/netdevice.h                |    2 +
 include/linux/nfs_fs.h                   |    5 ---
 include/linux/perf_event.h               |    2 +-
 include/linux/sched.h                    |    5 ++-
 include/linux/time.h                     |   29 ++++++++++++++-
 include/net/sock.h                       |    2 +
 include/trace/events/kmem.h              |    4 +-
 kernel/async.c                           |   13 +++++--
 kernel/events/core.c                     |   62 ++++++++++++++++---------------
 kernel/exit.c                            |   16 ++++++++
 kernel/sched.c                           |   32 +++++++++-------
 kernel/time/timekeeping.c                |   36 +++++++++++++++++-
 kernel/workqueue.c                       |   34 +++++++----------
 mm/memory_hotplug.c                      |   16 +++++---
 mm/page_alloc.c                          |    2 +-
 net/atm/common.c                         |    1 +
 net/atm/pvc.c                            |    1 +
 net/bluetooth/hci_core.c                 |    2 +
 net/bluetooth/hci_sock.c                 |    2 +
 net/bluetooth/l2cap_sock.c               |    1 +
 net/bluetooth/rfcomm/sock.c              |    1 +
 net/bluetooth/rfcomm/tty.c               |    2 +-
 net/core/dev.c                           |   14 +++++--
 net/core/drop_monitor.c                  |  113 ++++++++++++++++++++++++++++++---------------------------
 net/core/net_namespace.c                 |    4 +-
 net/core/sock.c                          |    1 +
 net/dccp/ccids/ccid3.c                   |    1 +
 net/ipv4/ipmr.c                          |   14 ++++++-
 net/ipv4/tcp.c                           |    4 +-
 net/ipv4/tcp_cong.c                      |    3 +-
 net/ipv4/tcp_output.c                    |   21 ++++++-----
 net/ipv6/addrconf.c                      |    4 +-
 net/l2tp/l2tp_core.c                     |    3 +-
 net/l2tp/l2tp_core.h                     |    1 +
 net/llc/af_llc.c                         |    3 +-
 net/netfilter/ipvs/ip_vs_ctl.c           |    1 +
 net/netlink/af_netlink.c                 |    4 +-
 net/packet/af_packet.c                   |    1 -
 net/rds/recv.c                           |    3 ++
 net/sched/act_gact.c                     |   14 +++++--
 net/socket.c                             |    1 +
 net/wireless/reg.c                       |   12 ++++--
 sound/pci/ice1712/prodigy_hifi.c         |    3 +-
 139 files changed, 1037 insertions(+), 431 deletions(-)


