Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031009Ab2I1URh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:17:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58061 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030339Ab2I1UR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:17:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk
Subject: =?UTF-8?q?=5B=20000/218=5D=203=2E4=2E12-stable=20review?=
Date: Fri, 28 Sep 2012 13:13:37 -0700
Message-Id: <20120928201501.208384923@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.12 release.
There are 218 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun Sep 30 20:13:59 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.12-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert: drm/i915: correctly order the ring init sequence

Dan Carpenter <dan.carpenter@oracle.com>
    vmwgfx: corruption in vmw_event_fence_action_create()

Jani Nikula <jani.nikula@intel.com>
    drm/i915: fall back to bit-banging if GMBUS fails in CRT EDID reads

Dave Airlie <airlied@redhat.com>
    drm/udl: limit modes to the sku pixel limits.

Roland Stigge <stigge@antcom.de>
    gpio-lpc32xx: Fix value handling of gpio_direction_output()

Mark Brown <broonie@opensource.wolfsonmicro.com>
    ASoC: wm2000: Correct register size

Alan Stern <stern@rowland.harvard.edu>
    USB: Fix race condition when removing host controllers

Joachim Eastwood <manabian@gmail.com>
    USB: ohci-at91: fix null pointer in ohci_hcd_at91_overcurrent_irq

Stanislav Kinsbursky <skinsbursky@parallels.com>
    LockD: pass service to per-net up and down functions

Tejun Heo <tj@kernel.org>
    kthread_worker: reimplement flush_kthread_work() to allow freeing the work item being executed

Tejun Heo <tj@kernel.org>
    kthread_worker: reorganize to prepare for flush_kthread_work() reimplementation

Stanislav Kinsbursky <skinsbursky@parallels.com>
    NFSd: set nfsd_serv to NULL after service destruction

Stanislav Kinsbursky <skinsbursky@parallels.com>
    NFSd: introduce nfsd_destroy() helper

Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    UBI: fix a horrible memory deallocation bug

Seth Forshee <seth.forshee@canonical.com>
    irq_remap: disable IRQ remapping if any IOAPIC lacks an IOMMU

Satoru Moriya <satoru.moriya@hds.com>
    mm: avoid swapping out with swappiness==0

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: new devices: UML290 and K5006-Z

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add Sierra Wireless devices

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add ZTE MF821D

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: add ZTE MF60

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: Add Sierra Wireless device IDs

Andrew Bird (Sphere Systems) <ajb@spheresystems.co.uk>
    USB: qmi_wwan: Add ZTE (Vodafone) K3765-Z

Bjørn Mork <bjorn@mork.no>
    net: qmi_wwan: Add Vodafone/Huawei K5005 support

Darren Hart <dvhart@linux.intel.com>
    pch_uart: Add eg20t_port lock field, avoid recursive spinlocks

Timur Tabi <timur@freescale.com>
    powerpc/85xx: p1022ds: fix DIU/LBC switching with NAND enabled

Timur Tabi <timur@freescale.com>
    powerpc/85xx: p1022ds: disable the NAND flash node if video is enabled

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

Jarod Wilson <jarod@redhat.com>
    media: lirc_sir: make device registration work

Yinghai Lu <yinghai@kernel.org>
    mm: sparse: fix usemap allocation above node descriptor section

Peter Zijlstra <peterz@infradead.org>
    sched: Fix race in task_group()

Francois Romieu <romieu@fr.zoreil.com>
    r8169: RxConfig hack for the 8168evl.

Daniel J Blueman <daniel@quora.org>
    libata: Prevent interface errors with Seagate FreeAgent GoFlex

Weiping Pan <wpan@redhat.com>
    rds: set correct msg_namelen

Li Zhong <zhong@linux.vnet.ibm.com>
    Fix a dead loop in async_synchronize_full()

Ezequiel Garcia <elezegarcia@gmail.com>
    media: cx25821: Remove bad strcpy to read-only char*

Rustad, Mark D <mark.d.rustad@intel.com>
    net: Statically initialize init_net.dev_base_head

Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Bluetooth: Fix sending a HCI Authorization Request over LE links

Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Bluetooth: Change signature of smp_conn_security()

Andre Guedes <andre.guedes@openbossa.org>
    Bluetooth: Fix use-after-free bug in SMP

Henrik Rydberg <rydberg@euromail.se>
    Bluetooth: Add support for Apple vendor-specific devices

Gustavo Padovan <gustavo.padovan@collabora.co.uk>
    Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices

Manoj Iyer <manoj.iyer@canonical.com>
    Bluetooth: btusb: Add vendor specific ID (0a5c:21f4) BCM20702A0

Jason Wang <jasowang@redhat.com>
    macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when skb is built successfully

Jason Wang <jasowang@redhat.com>
    macvtap: zerocopy: put page when fail to get all requested user pages

Jason Wang <jasowang@redhat.com>
    macvtap: zerocopy: fix truesize underestimation

Jason Wang <jasowang@redhat.com>
    macvtap: zerocopy: fix offset calculation when building skb

Alan Cox <alan@linux.intel.com>
    x86: Fix boot on Twinhead H12Y

Lai Jiangshan <laijs@cn.fujitsu.com>
    workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be atomic

NeilBrown <neilb@suse.de>
    md/raid10: fix problem with on-stack allocation of r10bio structure.

Wang Xingchao <xingchao.wang@intel.com>
    drm/i915: HDMI - Clear Audio Enable bit for Hot Plug

Dave Airlie <airlied@redhat.com>
    drm/nouveau: fix booting with plymouth + dumb support

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: fix dig encoder selection on DCE61

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: force dma32 to fix regression rs4xx,rs6xx,rs740

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: don't disable plls that are in use by other crtcs

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: convert radeon vfct code to use acpi_get_table_with_size

Xu, Anhua <anhua.xu@intel.com>
    drm/i915: fix wrong order of parameters in port checking functions

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: powergating fixes for DCE6

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/atom: rework DIG modesetting on DCE3+

Jakob Bornecrantz <jakob@vmware.com>
    drm: Check for invalid cursor flags

AceLan Kao <acelan.kao@canonical.com>
    asus-nb-wmi: add some video toggle keys

Corentin Chary <corentin.chary@gmail.com>
    asus-laptop: HRWS/HWRS typo

Jani Nikula <jani.nikula@intel.com>
    drm/i915: extract connector update from intel_ddc_get_modes() for reuse

Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
    drm/radeon/kms: extend the Fujitsu D3003-S2 board connector quirk to cover later silicon stepping

David Lamparter <equinox@diac24.net>
    drm/radeon: implement ACPI VFCT vbios fetch (v3)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon: split ATRM support out from the ATPX handler (v3)

Alex Deucher <alexander.deucher@amd.com>
    drm/radeon/ss: use num_crtc rather than hardcoded 6

Jerome Glisse <jglisse@redhat.com>
    drm/radeon: avoid turning off spread spectrum for used pll

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

Xinyu Chen <xinyu.chen@freescale.com>
    tty: serial: imx: console write routing is unsafe on SMP

Moiz Sonasath <m-sonasath@ti.com>
    usb: host: xhci: fix compilation error for non-PCI based stacks

Manoj Iyer <manoj.iyer@canonical.com>
    xhci: Recognize USB 3.0 devices as superspeed at powerup

Matthew Garrett <mjg@redhat.com>
    xhci: Make handover code more robust

Dan Carpenter <dan.carpenter@oracle.com>
    xhci: Fix a logical vs bitwise AND bug

Ruchika Kharwar <ruchika@ti.com>
    usb: host: xhci-plat: use ioremap_nocache

Keng-Yu Lin <kengyu@canonical.com>
    Intel xhci: Only switch the switchable ports

Alexis R. Cortes <alexis.cortes@ti.com>
    usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP Hardware

Sergei Poselenov <sposelenov@emcraft.com>
    rt2800usb: Added rx packet length validity check

Alan Stern <stern@rowland.harvard.edu>
    USB: add device quirk for Joss Optical touchboard

Nicolas Ferre <nicolas.ferre@atmel.com>
    USB: ohci-at91: fix PIO handling in relation with number of ports

Bjørn Mork <bjorn@mork.no>
    USB: cdc-wdm: fix wdm_find_device* return value

Pratyush Anand <pratyush.anand@st.com>
    usb: dwc3: ep0: correct cache sync issue in case of ep0_bounced

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

Gertjan van Wingerde <gwingerde@gmail.com>
    rt2x00: Identify ASUS USB-N53 device.

Nicolas Ferre <nicolas.ferre@atmel.com>
    dmaengine: at_hdmac: check that each sg data length is non-null

Nicolas Ferre <nicolas.ferre@atmel.com>
    dmaengine: at_hdmac: fix comment in atc_prep_slave_sg()

Sachin Kamat <sachin.kamat@linaro.org>
    DMA: PL330: Check the pointer returned by kzalloc

Sachin Kamat <sachin.kamat@linaro.org>
    DMA: PL330: Fix potential NULL pointer dereference in pl330_submit_req()

Luis R. Rodriguez <mcgrof@do-not-panic.com>
    cfg80211: fix possible circular lock on reg_regdb_search()

Ira W. Snyder <iws@ovro.caltech.edu>
    can: janz-ican3: fix support for older hardware revisions

Marc Kleine-Budde <mkl@pengutronix.de>
    can: ti_hecc: fix oops during rmmod

Søren Holm <sgh@sgh.dk>
    asix: Support DLink DUB-E100 H/W Ver C1

Larry Finger <Larry.Finger@lwfinger.net>
    rtlwifi: rtl8192ce: Log message that B_CUT device may not work

Jovi Zhang <bookjovi@gmail.com>
    MIPS: mm: Add compound tail page _mapcount when mapped

Anisse Astier <anisse@astier.eu>
    Input: i8042 - disable mux on Toshiba C850D

Wen Congyang <wency@cn.fujitsu.com>
    tracing: Don't call page_to_pfn() if page is NULL

Matthew Leach <matthew.leach@arm.com>
    ARM: 7532/1: decompressor: reset SCTLR.TRE for VMSA ARMv7 cores

Toshi Kani <toshi.kani@hp.com>
    hpwdt: Fix kdump issue in hpwdt

Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
    Bluetooth: mgmt: Fix enabling LE while powered off

Vinicius Costa Gomes <vinicius.gomes@openbossa.org>
    Bluetooth: Fix not removing power_off delayed work

Andrzej Kaczmarek <andrzej.kaczmarek@tieto.com>
    Bluetooth: mgmt: Fix enabling SSP while powered off

Wang Sen <senwang@linux.vnet.ibm.com>
    SCSI: scsi: virtio-scsi: Fix address translation failure of HighMem pages used by sg list

Stephen M. Cameron <scameron@beardog.cce.hp.com>
    SCSI: hpsa: fix handling of protocol error

Eddie Wai <eddie.wai@broadcom.com>
    SCSI: bnx2i: Fixed NULL ptr deference for 1G bnx2 Linux iSCSI offload

sreekanth.reddy@lsi.com <sreekanth.reddy@lsi.com>
    SCSI: mpt2sas: Fix for issue - Unable to boot from the drive connected to HBA

James Bottomley <jbottomley@parallels.com>
    SCSI: lpfc: fix problems with -Werror

Hante Meuleman <meuleman@broadcom.com>
    brcmfmac: Fix big endian host configuration data.

Hante Meuleman <meuleman@broadcom.com>
    brcmfmac: fix big endian bug in i-scan.

Eliad Peller <eliad@wizery.com>
    mac80211: clear bssid on auth/assoc failure

Santiago Leon <santil@linux.vnet.ibm.com>
    ibmveth: Fix alignment of rx queue bug

Dave Airlie <airlied@redhat.com>
    vmwgfx: add dumb ioctl support

Jeff Layton <jlayton@redhat.com>
    cifs: fix return value in cifsConvertToUTF16

Nestor Lopez Casado <nlopezcasad@logitech.com>
    HID: Fix logitech-dj: missing Unifying device issue

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ad7314) Add 'name' sysfs attribute

Guenter Roeck <linux@roeck-us.net>
    hwmon: (ads7871) Add 'name' sysfs attribute

Andreas Herrmann <andreas.herrmann3@amd.com>
    hwmon: (fam15h_power) Tweak runavg_range on resume

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    xen/boot: Disable NUMA for PV guests.

Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    xen/m2p: do not reuse kmap_op->dev_bus_addr

qiuxishi <qiuxishi@gmail.com>
    memory hotplug: fix section info double registration bug

Jianguo Wu <wujianguo@huawei.com>
    mm/ia64: fix a memory block size bug

Benoît Locher <Benoit.Locher@skf.com>
    can: mcp251x: avoid repeated frame bug

Charles Wang <muming.wq@taobao.com>
    sched: Add missing call to calc_load_exit_idle()

Guenter Roeck <linux@roeck-us.net>
    hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elements

Kevin Hilman <khilman@ti.com>
    drivers/rtc/rtc-twl.c: ensure all interrupts are disabled during probe

Li Haifeng <omycle@gmail.com>
    mm/page_alloc: fix the page address of higher page's buddy calculation

Dylan Reid <dgreid@chromium.org>
    ASoC: samsung dma - Don't indicate support for pause/resume.

Paul Clements <paul.clements@steeleye.com>
    nbd: clear waiting_queue on shutdown

NeilBrown <neilb@suse.de>
    md/raid5: fix calculate of 'degraded' when a replacement becomes active.

NeilBrown <neilb@suse.de>
    md: make sure metadata is updated when spares are activated or removed.

NeilBrown <neilb@suse.de>
    md: Don't truncate size at 4TB for RAID0 and Linear

Trond Myklebust <Trond.Myklebust@netapp.com>
    SUNRPC: Fix a UDP transport regression

Dmitry Kasatkin <dmitry.kasatkin@intel.com>
    digsig: add hash size comparision on signature verification

Mel Gorman <mgorman@suse.de>
    Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

Bjørn Mork <bjorn@mork.no>
    kobject: fix oops with "input0: bad kobj_uevent_env content in show_uevent()"

Alan Cox <alan@linux.intel.com>
    ahci: Add alternate identifier for the 88SE9172

Robert Richter <robert.richter@amd.com>
    oprofile, s390: Fix uninitialized memory access when writing to oprofilefs

Ian Chen <ian.cy.chen@samsung.com>
    mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corruption.

Shawn Guo <shawn.guo@linaro.org>
    mmc: sdhci-esdhc: break out early if clock is 0

Lauri Hintsala <lauri.hintsala@bluegiga.com>
    mmc: mxs-mmc: fix deadlock in SDIO IRQ case

Aaron Lu <aaron.lu@intel.com>
    ACPI / PM: Use KERN_DEBUG when no power resources are found

Lin Ming <ming.m.lin@intel.com>
    ACPI / PM: Fix resource_lock dead lock in acpi_power_on_device

Al Viro <viro@ZenIV.linux.org.uk>
    perf_event: Switch to internal refcount, fix race with close()

Stephen Warren <swarren@nvidia.com>
    sound: tegra_alc5632: remove HP detect GPIO inversion

Francesco Ruggeri <fruggeri@aristanetworks.com>
    fs/proc: fix potential unregister_sysctl_table hang

Bjørn Mork <bjorn@mork.no>
    USB: option: replace ZTE K5006-Z entry with vendor class rule

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: das08: Correct AO output for das08jr-16-ao

Eric Dumazet <edumazet@google.com>
    staging: r8712u: fix bug in r8712_recv_indicatepkt()

Malcolm Priestley <tvboxspy@gmail.com>
    staging: vt6656: [BUG] - Failed connection, incorrect endian.

Seth Jennings <sjenning@linux.vnet.ibm.com>
    staging: zcache: fix cleancache race condition with shrinker

Christopher Brannon <chris@the-brannons.com>
    Staging: speakup: fix an improperly-declared variable.

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Workaround for silent output on VAIO Z with ALC889

Matteo Frigo <athena@fftw.org>
    ALSA: ice1724: Use linear scale for AK4396 volume control.

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix Oops at codec reset/reconfig

Takashi Iwai <tiwai@suse.de>
    ALSA: hda - Fix missing Master volume for STAC9200/925x

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: Fix ioremap() of address zero

Igor Grinberg <grinberg@compulab.co.il>
    ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER

Dae S. Kim <dae@velatum.com>
    Staging: Android alarm: IOCTL command encoding fix

Russell King <rmk+kernel@arm.linux.org.uk>
    ARM: 7527/1: uaccess: explicitly check __user pointer when !CPU_USE_DOMAINS

Will Deacon <will.deacon@arm.com>
    ARM: 7526/1: traps: send SIGILL if get_user fails on undef handling path

David Brown <davidb@codeaurora.org>
    ARM: 7513/1: Make sure dtc is built before running it

Will Deacon <will.deacon@arm.com>
    ARM: 7496/1: hw_breakpoint: don't rely on dfsr to show watchpoint access type

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

Jesse Gross <jesse@nicira.com>
    openvswitch: Reset upper layer protocol info on internal devices.

Yuval Mintz <yuvalmin@broadcom.com>
    bnx2x: fix 57840_MF pci id

Francesco Ruggeri <fruggeri@aristanetworks.com>
    net: ipv4: ipmr_expire_timer causes crash when removing net namespace

xeb@mail.ru <xeb@mail.ru>
    l2tp: avoid to use synchronize_rcu in tunnel free function

Claudiu Manoil <claudiu.manoil@freescale.com>
    gianfar: fix default tx vlan offload feature flag

Ben Hutchings <bhutchings@solarflare.com>
    sfc: Fix reporting of IPv4 full filters through ethtool

Yuchung Cheng <ycheng@google.com>
    tcp: fix cwnd reduction for non-sack recovery

Pablo Neira Ayuso <pablo@netfilter.org>
    netlink: fix possible spoofing from non-root processes

Eric Dumazet <edumazet@google.com>
    af_netlink: force credentials passing [CVE-2012-3520]

Eric Leblond <eric@regit.org>
    af_packet: don't emit packet on orig fanout group

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
    Bluetooth: RFCOMM - Fix info leak in getsockopt(BT_SECURITY)

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

Gao feng <gaofeng@cn.fujitsu.com>
    pptp: lookup route with the proper net namespace

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

 Documentation/sound/alsa/HD-Audio-Models.txt          |    1 +
 Makefile                                              |    4 +-
 arch/alpha/include/asm/atomic.h                       |    4 +-
 arch/arm/Makefile                                     |    4 +-
 arch/arm/boot/compressed/head.S                       |    1 +
 arch/arm/include/asm/assembler.h                      |    8 +++
 arch/arm/include/asm/uaccess.h                        |   40 +++++++++----
 arch/arm/kernel/hw_breakpoint.c                       |   55 ++++++++++++-----
 arch/arm/kernel/traps.c                               |   11 ++--
 arch/arm/lib/getuser.S                                |   23 +++++---
 arch/arm/lib/putuser.S                                |    6 ++
 arch/arm/mach-omap2/timer.c                           |    7 +++
 arch/arm/mm/mm.h                                      |    3 +
 arch/arm/mm/mmu.c                                     |    4 +-
 arch/mips/mm/gup.c                                    |    2 +
 arch/powerpc/platforms/85xx/p1022_ds.c                |  102 ++++++++++++++++++++++++++++----
 arch/s390/oprofile/init.c                             |   10 ++--
 arch/x86/include/asm/xen/page.h                       |    3 +-
 arch/x86/pci/fixup.c                                  |   17 ++++++
 arch/x86/xen/p2m.c                                    |   27 ++++-----
 arch/x86/xen/setup.c                                  |    4 ++
 drivers/acpi/power.c                                  |   36 ++++++++----
 drivers/ata/ahci.c                                    |    2 +
 drivers/ata/libata-core.c                             |    1 +
 drivers/base/power/runtime.c                          |    5 +-
 drivers/block/cciss_scsi.c                            |    1 +
 drivers/block/nbd.c                                   |    9 +++
 drivers/block/xen-blkback/blkback.c                   |    2 +-
 drivers/bluetooth/btusb.c                             |   10 ++--
 drivers/cpufreq/powernow-k8.c                         |   63 +++++++++++---------
 drivers/dma/at_hdmac.c                                |   13 +++-
 drivers/dma/pl330.c                                   |   21 ++++---
 drivers/gpio/gpio-lpc32xx.c                           |    5 ++
 drivers/gpu/drm/drm_crtc.c                            |    2 +-
 drivers/gpu/drm/i915/intel_crt.c                      |   36 +++++++++++-
 drivers/gpu/drm/i915/intel_display.c                  |   12 ++--
 drivers/gpu/drm/i915/intel_drv.h                      |    2 +
 drivers/gpu/drm/i915/intel_hdmi.c                     |    2 +-
 drivers/gpu/drm/i915/intel_modes.c                    |   31 +++++++---
 drivers/gpu/drm/i915/intel_ringbuffer.c               |    7 +--
 drivers/gpu/drm/nouveau/nouveau_display.c             |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c                |   61 +++++++++++--------
 drivers/gpu/drm/radeon/atombios_encoders.c            |  140 +++++++++++++++++++++++---------------------
 drivers/gpu/drm/radeon/radeon.h                       |   15 -----
 drivers/gpu/drm/radeon/radeon_atombios.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c          |   56 +-----------------
 drivers/gpu/drm/radeon/radeon_bios.c                  |  138 +++++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/radeon/radeon_device.c                |    2 +-
 drivers/gpu/drm/udl/udl_connector.c                   |    7 +++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                   |    5 ++
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h                   |   10 ++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c                 |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c              |   73 +++++++++++++++++++++++
 drivers/hid/hid-logitech-dj.c                         |   41 +++++++++++++
 drivers/hid/hid-logitech-dj.h                         |    1 +
 drivers/hwmon/ad7314.c                                |    8 +++
 drivers/hwmon/ads7871.c                               |    9 +++
 drivers/hwmon/fam15h_power.c                          |   15 ++++-
 drivers/hwmon/twl4030-madc-hwmon.c                    |    9 +--
 drivers/input/serio/i8042-x86ia64io.h                 |    6 ++
 drivers/iommu/intr_remapping.c                        |   18 ++++--
 drivers/isdn/isdnloop/isdnloop.c                      |   12 ----
 drivers/md/md.c                                       |   15 +++--
 drivers/md/raid10.c                                   |   16 +++--
 drivers/md/raid10.h                                   |    2 +-
 drivers/md/raid5.c                                    |    4 ++
 drivers/media/rc/rc-main.c                            |    5 +-
 drivers/media/video/cx25821/cx25821-core.c            |    3 -
 drivers/media/video/cx25821/cx25821.h                 |    2 +-
 drivers/misc/sgi-xp/xpc_uv.c                          |   84 ++++++++++++++++++++------
 drivers/mmc/card/block.c                              |   26 +++++++-
 drivers/mmc/host/mxs-mmc.c                            |    4 +-
 drivers/mmc/host/sdhci-esdhc.h                        |    6 +-
 drivers/mtd/ubi/vtbl.c                                |    4 +-
 drivers/net/can/janz-ican3.c                          |    4 +-
 drivers/net/can/mcp251x.c                             |   11 +++-
 drivers/net/can/ti_hecc.c                             |    2 +-
 drivers/net/ethernet/freescale/gianfar.c              |    2 +-
 drivers/net/ethernet/ibm/ibmveth.c                    |   26 +++-----
 drivers/net/ethernet/realtek/r8169.c                  |    1 +
 drivers/net/ethernet/sfc/efx.c                        |    6 ++
 drivers/net/ethernet/sfc/efx.h                        |   14 +++--
 drivers/net/ethernet/sfc/ethtool.c                    |   20 ++++---
 drivers/net/ethernet/sfc/tx.c                         |   19 ++++++
 drivers/net/macvtap.c                                 |   35 ++++++-----
 drivers/net/netconsole.c                              |    1 -
 drivers/net/ppp/pptp.c                                |    4 +-
 drivers/net/usb/asix.c                                |    4 ++
 drivers/net/usb/qmi_wwan.c                            |   95 ++++++++++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c  |   26 ++++----
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    6 +-
 drivers/net/wireless/rt2x00/rt2400pci.c               |    9 +++
 drivers/net/wireless/rt2x00/rt2400pci.h               |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c               |    9 +++
 drivers/net/wireless/rt2x00/rt2500usb.c               |   11 +++-
 drivers/net/wireless/rt2x00/rt2500usb.h               |   17 +++---
 drivers/net/wireless/rt2x00/rt2800pci.c               |    9 +++
 drivers/net/wireless/rt2x00/rt2800usb.c               |   22 ++++++-
 drivers/net/wireless/rt2x00/rt2x00dev.c               |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c                 |    9 +++
 drivers/net/wireless/rt2x00/rt61pci.h                 |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c                 |    9 +++
 drivers/net/wireless/rt2x00/rt73usb.h                 |    3 +
 drivers/net/wireless/rtlwifi/rtl8192ce/def.h          |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c           |   12 +++-
 drivers/net/wireless/rtlwifi/rtl8192ce/sw.c           |    6 +-
 drivers/platform/x86/asus-laptop.c                    |    8 +--
 drivers/platform/x86/asus-nb-wmi.c                    |    4 ++
 drivers/rtc/rtc-rs5c348.c                             |    7 ++-
 drivers/rtc/rtc-twl.c                                 |    5 ++
 drivers/scsi/bnx2i/bnx2i_hwi.c                        |    3 +
 drivers/scsi/hpsa.c                                   |    3 +-
 drivers/scsi/lpfc/Makefile                            |    2 +
 drivers/scsi/mpt2sas/mpt2sas_base.c                   |    7 +++
 drivers/scsi/virtio_scsi.c                            |    2 +-
 drivers/staging/android/android_alarm.h               |    4 +-
 drivers/staging/comedi/drivers/das08.c                |    2 +-
 drivers/staging/media/lirc/lirc_sir.c                 |   60 ++++++++++++++++++-
 drivers/staging/rtl8712/recv_linux.c                  |    7 +--
 drivers/staging/speakup/main.c                        |    2 +-
 drivers/staging/vt6656/dpc.c                          |    2 +-
 drivers/staging/vt6656/rxtx.c                         |   38 ++++++------
 drivers/staging/zcache/zcache-main.c                  |    7 +--
 drivers/target/target_core_transport.c                |    9 ++-
 drivers/tty/serial/imx.c                              |   12 +++-
 drivers/tty/serial/pch_uart.c                         |   59 +++++++++++++------
 drivers/usb/class/cdc-wdm.c                           |   12 ++--
 drivers/usb/core/devices.c                            |    2 +-
 drivers/usb/core/hcd.c                                |    6 +-
 drivers/usb/core/quirks.c                             |    4 ++
 drivers/usb/dwc3/ep0.c                                |    1 -
 drivers/usb/dwc3/gadget.c                             |    7 ++-
 drivers/usb/host/ehci-q.c                             |   12 +++-
 drivers/usb/host/ohci-at91.c                          |   13 +++-
 drivers/usb/host/pci-quirks.c                         |   42 ++++++++++---
 drivers/usb/host/pci-quirks.h                         |    1 +
 drivers/usb/host/xhci-hub.c                           |   42 +++++++++++++
 drivers/usb/host/xhci-plat.c                          |    2 +-
 drivers/usb/host/xhci.c                               |  123 +++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h                               |    6 ++
 drivers/usb/serial/ftdi_sio.c                         |   22 ++++++-
 drivers/usb/serial/ftdi_sio_ids.h                     |   29 ++++++++-
 drivers/usb/serial/option.c                           |    6 +-
 drivers/video/console/fbcon.c                         |    9 ++-
 drivers/watchdog/hpwdt.c                              |    3 +
 drivers/xen/gntdev.c                                  |    5 +-
 drivers/xen/grant-table.c                             |    6 +-
 fs/cifs/cifs_unicode.c                                |    2 +-
 fs/dcache.c                                           |    4 +-
 fs/ecryptfs/inode.c                                   |    5 ++
 fs/lockd/svc.c                                        |   12 ++--
 fs/nfs/inode.c                                        |    2 +-
 fs/nfs/nfs3proc.c                                     |    2 +-
 fs/nfs/nfs4proc.c                                     |    4 +-
 fs/nfs/nfs4xdr.c                                      |    3 +-
 fs/nfs/super.c                                        |    2 +
 fs/nfsd/nfsctl.c                                      |    8 +--
 fs/nfsd/nfsd.h                                        |   11 ++++
 fs/nfsd/nfssvc.c                                      |   24 +++-----
 fs/proc/proc_sysctl.c                                 |    5 +-
 fs/stat.c                                             |    2 +-
 include/asm-generic/mutex-xchg.h                      |   11 +++-
 include/drm/drm_mode.h                                |    5 +-
 include/linux/dcache.h                                |    2 +
 include/linux/init_task.h                             |   12 +++-
 include/linux/kobject.h                               |    2 +-
 include/linux/kthread.h                               |    8 +--
 include/linux/ktime.h                                 |    7 ---
 include/linux/memory.h                                |    2 +-
 include/linux/mmc/card.h                              |    1 +
 include/linux/netdevice.h                             |    4 ++
 include/linux/nfs_fs.h                                |    5 --
 include/linux/pci_ids.h                               |    2 +-
 include/linux/perf_event.h                            |    2 +-
 include/linux/sched.h                                 |    5 +-
 include/linux/sunrpc/xprt.h                           |    3 +
 include/linux/time.h                                  |   29 ++++++++-
 include/net/bluetooth/smp.h                           |    2 +-
 include/net/scm.h                                     |    4 +-
 include/net/sock.h                                    |    2 +
 include/trace/events/kmem.h                           |    4 +-
 include/xen/grant_table.h                             |    3 +-
 kernel/async.c                                        |   13 ++--
 kernel/events/core.c                                  |   62 +++++++++++---------
 kernel/kthread.c                                      |   88 ++++++++++++++++------------
 kernel/sched/core.c                                   |    9 ++-
 kernel/sched/sched.h                                  |   23 ++++----
 kernel/time/tick-sched.c                              |    1 +
 kernel/time/timekeeping.c                             |   33 +++++++++--
 kernel/workqueue.c                                    |   34 +++++------
 lib/digsig.c                                          |    6 +-
 mm/bootmem.c                                          |    8 ++-
 mm/memory_hotplug.c                                   |   16 +++--
 mm/page_alloc.c                                       |    2 +-
 mm/vmscan.c                                           |    6 +-
 net/atm/common.c                                      |    1 +
 net/atm/pvc.c                                         |    1 +
 net/bluetooth/hci_conn.c                              |    4 ++
 net/bluetooth/hci_core.c                              |    2 +
 net/bluetooth/hci_sock.c                              |    2 +
 net/bluetooth/l2cap_core.c                            |   11 ++--
 net/bluetooth/l2cap_sock.c                            |    3 +-
 net/bluetooth/mgmt.c                                  |   16 +++++
 net/bluetooth/rfcomm/sock.c                           |    2 +
 net/bluetooth/rfcomm/tty.c                            |    2 +-
 net/bluetooth/smp.c                                   |   10 ++--
 net/core/dev.c                                        |   30 ++++++++--
 net/core/net_namespace.c                              |    4 +-
 net/core/sock.c                                       |    1 +
 net/dccp/ccids/ccid3.c                                |    1 +
 net/ipv4/ipmr.c                                       |   14 ++++-
 net/ipv4/tcp.c                                        |    4 +-
 net/ipv4/tcp_cong.c                                   |    3 +-
 net/ipv4/tcp_input.c                                  |   15 +++--
 net/ipv4/tcp_output.c                                 |   21 ++++---
 net/ipv6/addrconf.c                                   |    4 +-
 net/l2tp/l2tp_core.c                                  |    3 +-
 net/l2tp/l2tp_core.h                                  |    1 +
 net/llc/af_llc.c                                      |    3 +-
 net/mac80211/mlme.c                                   |    4 ++
 net/netfilter/ipvs/ip_vs_ctl.c                        |    1 +
 net/netlink/af_netlink.c                              |    6 +-
 net/openvswitch/vport-internal_dev.c                  |    8 +++
 net/packet/af_packet.c                                |   10 +++-
 net/rds/recv.c                                        |    3 +
 net/sched/act_gact.c                                  |   14 ++++-
 net/socket.c                                          |    1 +
 net/sunrpc/xprt.c                                     |   34 ++++++-----
 net/sunrpc/xprtrdma/transport.c                       |    1 +
 net/sunrpc/xprtsock.c                                 |    3 +
 net/unix/af_unix.c                                    |    4 +-
 net/wireless/reg.c                                    |   12 +++-
 sound/pci/hda/hda_codec.c                             |    2 +-
 sound/pci/hda/patch_realtek.c                         |   22 ++++++-
 sound/pci/hda/patch_sigmatel.c                        |    2 +-
 sound/pci/ice1712/prodigy_hifi.c                      |    3 +-
 sound/soc/codecs/wm2000.c                             |    2 +-
 sound/soc/samsung/dma.c                               |    8 +--
 sound/soc/tegra/tegra_alc5632.c                       |    1 -
 239 files changed, 2335 insertions(+), 858 deletions(-)


