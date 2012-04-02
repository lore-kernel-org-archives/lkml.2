Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2DBRgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:36:04 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:36410 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab2DBRf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:35:58 -0400
Date: Mon, 2 Apr 2012 10:35:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.14
Message-ID: <20120402173554.GA32204@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.14 kernel.

All users of the 3.2 kernel series must upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/mach-tegra/Kconfig                       |   12 +
 arch/x86/include/asm/kvm_emulate.h                |   16 ++
 arch/x86/kernel/apic/io_apic.c                    |   40 ++++-
 arch/x86/kernel/entry_32.S                        |   17 +-
 arch/x86/kernel/tls.c                             |    4=20
 arch/x86/kernel/tsc.c                             |   10 +
 arch/x86/kernel/vm86_32.c                         |    2=20
 arch/x86/kvm/emulate.c                            |   51 ++++++
 arch/x86/kvm/x86.c                                |   23 ++
 arch/x86/net/bpf_jit_comp.c                       |   14 -
 drivers/ata/pata_legacy.c                         |    3=20
 drivers/base/power/domain.c                       |    3=20
 drivers/bluetooth/ath3k.c                         |    1=20
 drivers/bluetooth/btusb.c                         |   10 -
 drivers/char/tpm/Kconfig                          |    1=20
 drivers/char/tpm/tpm.c                            |    3=20
 drivers/firewire/ohci.c                           |    5=20
 drivers/gpio/gpio-davinci.c                       |   26 ++-
 drivers/gpio/gpio-omap.c                          |    5=20
 drivers/gpu/drm/i915/i915_drv.c                   |    7=20
 drivers/gpu/drm/i915/i915_gem.c                   |    7=20
 drivers/gpu/drm/i915/intel_drv.h                  |    2=20
 drivers/gpu/drm/i915/intel_fb.c                   |   10 +
 drivers/gpu/drm/radeon/radeon_atombios.c          |   14 +
 drivers/gpu/drm/radeon/radeon_connectors.c        |    4=20
 drivers/gpu/drm/radeon/radeon_cursor.c            |   13 +
 drivers/gpu/drm/radeon/radeon_object.c            |   18 ++
 drivers/gpu/drm/radeon/radeon_object.h            |    2=20
 drivers/hid/hid-chicony.c                         |    7=20
 drivers/hid/hid-core.c                            |    1=20
 drivers/hid/hid-ids.h                             |    1=20
 drivers/hwmon/fam15h_power.c                      |    2=20
 drivers/infiniband/ulp/iser/iscsi_iser.c          |   18 --
 drivers/infiniband/ulp/iser/iscsi_iser.h          |    1=20
 drivers/infiniband/ulp/iser/iser_initiator.c      |   30 ++-
 drivers/iommu/amd_iommu.c                         |    2=20
 drivers/md/bitmap.c                               |    2=20
 drivers/md/dm-crypt.c                             |   38 ++--
 drivers/md/dm-exception-store.c                   |    2=20
 drivers/md/dm-thin.c                              |  124 +++++++++------
 drivers/md/md.c                                   |   40 ++---
 drivers/md/persistent-data/dm-btree-remove.c      |  174 ++++++++++++-----=
-----
 drivers/md/raid1.c                                |   17 +-
 drivers/md/raid10.c                               |   17 +-
 drivers/media/dvb/dvb-usb/mxl111sf.c              |    6=20
 drivers/media/dvb/frontends/lgdt330x.c            |    6=20
 drivers/media/video/pvrusb2/pvrusb2-devattr.c     |   10 +
 drivers/mtd/ubi/scan.c                            |    8 -
 drivers/mtd/ubi/wl.c                              |   10 -
 drivers/net/ethernet/intel/e1000e/e1000.h         |    1=20
 drivers/net/ethernet/intel/e1000e/netdev.c        |   23 ++
 drivers/net/ethernet/marvell/sky2.c               |   11 +
 drivers/net/usb/usbnet.c                          |   10 +
 drivers/net/wireless/iwlwifi/iwl-core.c           |   18 --
 drivers/net/wireless/p54/p54spi.c                 |   14 +
 drivers/net/wireless/rt2x00/rt2800usb.c           |    1=20
 drivers/net/wireless/rtlwifi/pci.c                |   18 +-
 drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c |   15 +
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |    2=20
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c       |   14 +
 drivers/net/wireless/rtlwifi/usb.c                |   12 -
 drivers/pci/pcie/aspm.c                           |   13 +
 drivers/rtc/interface.c                           |   20 ++
 drivers/rtc/rtc-mpc5121.c                         |    2=20
 drivers/staging/rtl8712/Kconfig                   |    7=20
 drivers/staging/rtl8712/os_intfs.c                |    2=20
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c     |    8 -
 drivers/staging/rtl8712/rtl871x_sta_mgt.c         |    5=20
 drivers/staging/rtl8712/sta_info.h                |    4=20
 drivers/staging/zcache/zcache-main.c              |    4=20
 drivers/target/iscsi/iscsi_target.c               |   14 -
 drivers/target/iscsi/iscsi_target_configfs.c      |    6=20
 drivers/target/loopback/tcm_loop.c                |    6=20
 drivers/target/target_core_alua.c                 |    7=20
 drivers/target/target_core_cdb.c                  |    2=20
 drivers/target/target_core_device.c               |    6=20
 drivers/target/tcm_fc/tfc_cmd.c                   |    6=20
 drivers/tty/moxa.c                                |    2=20
 drivers/tty/serial/sh-sci.c                       |   15 +
 drivers/tty/vt/consolemap.c                       |   51 +++++-
 drivers/usb/class/cdc-wdm.c                       |   17 +-
 drivers/usb/dwc3/gadget.c                         |   24 +--
 drivers/usb/gadget/f_subset.c                     |   34 ++--
 drivers/usb/gadget/fsl_udc_core.c                 |   18 +-
 drivers/usb/gadget/hid.c                          |    6=20
 drivers/usb/gadget/inode.c                        |    2=20
 drivers/usb/host/ehci-fsl.c                       |    4=20
 drivers/usb/host/ehci-fsl.h                       |    1=20
 drivers/usb/host/fsl-mph-dr-of.c                  |    1=20
 drivers/usb/musb/musb_gadget.c                    |   18 ++
 drivers/usb/renesas_usbhs/mod_gadget.c            |    6=20
 drivers/usb/serial/cp210x.c                       |   44 +++++
 drivers/usb/serial/ftdi_sio.c                     |   32 +++-
 drivers/usb/serial/ftdi_sio.h                     |    3=20
 drivers/usb/serial/ftdi_sio_ids.h                 |   19 ++
 drivers/usb/serial/generic.c                      |    4=20
 drivers/usb/serial/mos7840.c                      |   83 +++++++---
 drivers/usb/serial/option.c                       |   16 ++
 drivers/usb/serial/qcserial.c                     |  109 ++++++++-----
 drivers/usb/storage/realtek_cr.c                  |    8 -
 drivers/video/backlight/tosa_lcd.c                |    2=20
 drivers/video/fbmem.c                             |   18 ++
 drivers/video/udlfb.c                             |    2=20
 fs/cifs/cifsfs.c                                  |    8 -
 fs/cifs/cifsglob.h                                |   10 -
 fs/cifs/cifssmb.c                                 |    9 -
 fs/cifs/connect.c                                 |   14 -
 fs/cifs/dir.c                                     |    6=20
 fs/cifs/file.c                                    |   23 +-
 fs/cifs/transport.c                               |    4=20
 fs/dcache.c                                       |    3=20
 fs/ext4/ext4.h                                    |    2=20
 fs/ext4/ext4_jbd2.h                               |   56 +++----
 fs/ext4/extents.c                                 |    2=20
 fs/ext4/fsync.c                                   |    2=20
 fs/ext4/inode.c                                   |   46 +++--
 fs/ext4/page-io.c                                 |   11 +
 fs/hugetlbfs/inode.c                              |   25 +--
 fs/jbd2/transaction.c                             |    2=20
 fs/lockd/svc.c                                    |    2=20
 fs/nfs/callback_xdr.c                             |    4=20
 fs/nfs/delegation.c                               |   11 +
 fs/nfs/delegation.h                               |    1=20
 fs/nfs/nfs4_fs.h                                  |    3=20
 fs/nfs/nfs4proc.c                                 |   64 +++++---
 fs/nfs/nfs4state.c                                |   33 +++-
 fs/proc/namespaces.c                              |    2=20
 fs/proc/proc_sysctl.c                             |   17 ++
 fs/proc/task_mmu.c                                |    9 +
 fs/sysfs/inode.c                                  |   11 -
 fs/udf/file.c                                     |    2=20
 fs/xfs/xfs_iget.c                                 |   18 +-
 fs/xfs/xfs_log_recover.c                          |   33 +---
 include/asm-generic/pgtable.h                     |   61 +++++++
 include/asm-generic/unistd.h                      |    2=20
 include/linux/fb.h                                |    1=20
 include/linux/math64.h                            |    4=20
 include/linux/rtc.h                               |    3=20
 kernel/futex.c                                    |   19 +-
 kernel/irq/chip.c                                 |    3=20
 kernel/irq/manage.c                               |    2=20
 kernel/module.c                                   |    3=20
 kernel/power/hibernate.c                          |    7=20
 kernel/time/ntp.c                                 |    2=20
 lib/kobject_uevent.c                              |   19 +-
 mm/bootmem.c                                      |    5=20
 mm/memcontrol.c                                   |    4=20
 mm/memory.c                                       |   16 +-
 mm/mempolicy.c                                    |    2=20
 mm/mincore.c                                      |    2=20
 mm/pagewalk.c                                     |    2=20
 mm/slub.c                                         |    3=20
 mm/sparse.c                                       |   30 +--
 mm/swapfile.c                                     |    4=20
 net/core/dev.c                                    |    3=20
 net/core/rtnetlink.c                              |    2=20
 net/ipv6/ip6_output.c                             |   11 -
 net/ipv6/route.c                                  |    8 -
 net/l2tp/l2tp_ppp.c                               |    2=20
 net/rds/send.c                                    |    1=20
 net/sunrpc/cache.c                                |    2=20
 net/sunrpc/sched.c                                |   15 +
 net/xfrm/xfrm_replay.c                            |    6=20
 security/integrity/ima/Kconfig                    |    2=20
 sound/pci/hda/hda_eld.c                           |    4=20
 sound/soc/fsl/p1022_ds.c                          |   24 ++-
 sound/soc/pxa/pxa-ssp.c                           |   61 ++++---
 168 files changed, 1606 insertions(+), 793 deletions(-)

Alex Deucher (2):
      drm/radeon/kms: fix analog load detection on DVI-I connectors
      drm/radeon/kms: add connector quirk for Fujitsu D3003-S2 board

Alexander Gordeev (1):
      genirq: Fix incorrect check for forced IRQ thread handler

Alok Kataria (1):
      x86, tsc: Skip refined tsc calibration on systems with reliable TSC

Andrea Arcangeli (1):
      mm: thp: fix pmd_bad() triggering in code paths holding mmap_sem read=
 mode

Andrea Righi (1):
      staging: zcache: avoid AB-BA deadlock condition

Andreas Herrmann (1):
      hwmon: (fam15h_power) Correct sign extension of running_avg_capture

Andrei Warkentin (1):
      dm exception store: fix init error path

Andrew Vagin (1):
      uevent: send events in correct order according to seqnum (v3)

Aneesh Kumar K.V (1):
      hugetlbfs: avoid taking i_mutex from hugetlbfs_read()

Anssi Hannula (1):
      ALSA: hda - fix printing of high HDMI sample rates

Anton Tikhomirov (1):
      usb: dwc3: use proper function for setting endpoint name

Artem Bityutskiy (1):
      UBI: fix eraseblock picking criteria

Ben Hutchings (2):
      cdc-wdm: Fix more races on the read path
      cdc-wdm: Don't clear WDM_READ unless entire read buffer is emptied

Benjamin LaHaise (1):
      Fix pppol2tp getsockname()

Bing Zhao (1):
      Bluetooth: btusb: fix bInterval for high/super speed isochronous endp=
oints

Bj=C3=B8rn Mork (2):
      USB: option: make interface blacklist work again
      USB: option: add ZTE MF820D

Bruno Thomsen (1):
      USB: Microchip VID mislabeled as Hornby VID in ftdi_sio.

Chris Metcalf (1):
      compat: use sys_sendfile64() implementation for sendfile syscall

Chris Wilson (1):
      drm/i915: Only clear the GPU domains upon a successful finish

Christoph Lameter (1):
      slub: Do not hold slub_lock when calling sysfs_slab_add()

Clemens Ladisch (1):
      firewire: ohci: fix too-early completion of IR multichannel buffers

Dan Carpenter (3):
      tty: moxa: fix bit test in moxa_start()
      x86, tls: Off by one limit check
      nfsd: don't allow zero length strings in cache_parse()

Dan Williams (1):
      USB: qcserial: don't grab QMI port on Gobi 1000 devices

Daniel Mack (1):
      ASoC: pxa-ssp: atomically set stream active masks

Daniele Palmas (1):
      USB: option driver: adding support for Telit CC864-SINGLE, CC864-DUAL=
 and DE910-DUAL modems

Dave Airlie (1):
      drm/i915: suspend fbdev device around suspend/hibernate

Dave Chinner (1):
      xfs: fix inode lookup race

Dave Jones (1):
      Remove printk from rds_sendmsg

Dmitry Adamushko (1):
      x86-32: Fix endless loop when processing signals for kernel tasks

Donald Lee (1):
      USB: serial: mos7840: Fixed MCS7820 device attach problem

Eric Dumazet (3):
      net: bpf_jit: fix BPF_S_LDX_B_MSH compilation
      net: fix a potential rcu_read_lock() imbalance in rt6_fill_node()
      net: fix napi_reuse_skb() skb reserve

Eric Sandeen (1):
      jbd2: clear BH_Delay & BH_Unwritten in journal_unmap_buffer

Fabio Estevam (1):
      ima: fix Kconfig dependencies

Gao feng (1):
      ipv6: fix incorrent ipv6 ipsec packet fragment

Gertjan van Wingerde (1):
      rt2x00: Add support for D-Link DWA-127 to rt2800usb.

Greg Kroah-Hartman (2):
      USB: ftdi_sio: fix problem when the manufacture is a NULL string
      Linux 3.2.14

Greg Rose (1):
      rtnetlink: Fix VF IFLA policy

Jan Kara (2):
      udf: Fix deadlock in udf_release_file()
      xfs: Fix oops on IO error during xlog_recover_process_iunlinks()

Jeff Kirsher (1):
      e1000e: Avoid wrong check on TX hang

Jeff Layton (1):
      cifs: fix issue mounting of DFS ROOT when redirecting from one domain=
 controller to the next

Jeff Moyer (2):
      ext4: fix race between unwritten extent conversion and truncate
      ext4: fix race between sync and completed io work

Jim Paris (1):
      USB: ftdi_sio: add support for FT-X series devices

Jingjun Wu (1):
      rtlwifi: rtl8192ce: Fix loss of receive performance

Joe Thornber (2):
      dm persistent data: fix btree rebalancing after remove
      dm thin: fix stacked bi_next usage

Johan Hovold (1):
      USB: serial: fix console error reporting

Johannes Berg (1):
      iwlwifi: always monitor for stuck queues

John Stultz (1):
      rtc: Provide flag for rtc devices that don't support UIE

Josh Boyer (1):
      USB: ums_realtek: do not use stack memory for DMA in __do_config_auto=
delink

J=C3=B6rn Engel (2):
      target: fix use after free in target_report_luns
      target: prevent NULL pointer dereference in target_report_luns

Kay Sievers (1):
      udlfb: remove sysfs framebuffer device with USB .disconnect()

Keng-Yu Lin (3):
      Bluetooth: Add AR30XX device ID on Asus laptops
      HID: add extra hotkeys in Asus AIO keyboards
      HID: add more hotkeys in Asus AIO keyboards

Kuninori Morimoto (1):
      usb: renesas_usbhs: bugfix: add .release function to gpriv->gadget.dev

Larry Finger (5):
      staging: r8712u: Add missing initialization and remove configuration =
parameter CONFIG_R8712_AP
      staging: r8712u: Fix regression introduced by commit a5ee652
      staging: r8712u: Fix regression in signal level after commit c6dc001
      rtlwifi: rtl8192c_common: rtl8192de: Check for allocation failures
      rtlwifi: rtl8192c: Prevent sleeping from invalid context in rtl8192cu

Liz Clark (1):
      TTY: Wrong unicode value copied in con_set_unimap()

Lothar Wa=C3=9Fmann (1):
      usb gadget: fix a section mismatch when compiling g_ffs with CONFIG_U=
SB_FUNCTIONFS_ETH

Lucas De Marchi (1):
      sysctl: protect poll() in entries that may go away

Lukas Czerner (1):
      ext4: ignore EXT4_INODE_JOURNAL_DATA flag with delalloc

Masami Ichikawa (1):
      sysfs: Fix memory leak in sysfs_sd_setsecdata().

Masanari Iida (1):
      backlight: fix typo in tosa_lcd.c

Matthew Garrett (1):
      ASPM: Fix pcie devices with non-pcie children

Max Filippov (1):
      p54spi: Release GPIO lines and IRQ on error in p54spi_probe

Meng Zhang (1):
      USB: option: Add MediaTek MT6276M modem&app interfaces

Michael Krufky (2):
      pvrusb2: fix 7MHz & 8MHz DVB-T tuner support for HVR1900 rev D1F5
      mxl111sf: fix error on stream stop in mxl111sf_ep6_streaming_ctrl()

Micha=C5=82 Wr=C3=B3bel (2):
      USB: ftdi_sio: new PID: Distortec JTAG-lock-pick
      USB: ftdi_sio: new PID: LUMEL PD12

Michel D=C3=A4nzer (1):
      drm/radeon: Restrict offset for legacy hardware cursor.

Michel Lespinasse (1):
      vfs: fix d_ancestor() case in d_materialize_unique

Mikulas Patocka (2):
      dm crypt: fix mempool deadlock
      dm crypt: add missing error handling

NeilBrown (5):
      md/bitmap: ensure to load bitmap when creating via sysfs.
      md: don't set md arrays to readonly on shutdown.
      md/raid1,raid10: avoid deadlock during resync/recovery.
      md: fix clearing of the 'changed' flags for the bad blocks list.
      lockd: fix arg parsing for grace_period and timeout.

Nicholas Bellinger (3):
      iscsi-target: Fix iscsit_alloc_buffs() failure cases
      iscsi-target: Fix dynamic -> explict NodeACL pointer reference
      tcm_fc: Fix fc_exch memory leak in ft_send_resp_status

Nishanth Aravamudan (1):
      bootmem/sparsemem: remove limit constraint in alloc_bootmem_section

Or Gerlitz (1):
      IB/iser: Post initial receive buffers before sending the final login =
request

Orjan Friberg (1):
      USB: gadget: Make g_hid device class conform to spec.

Paul Zimmerman (1):
      usb: dwc3: fix bogus test in dwc3_gadget_start_isoc

Pavel Shilovsky (2):
      CIFS: Respect negotiated MaxMpxCount
      CIFS: Fix a spurious error in cifs_push_posix_locks

Peter Chen (2):
      usb: fsl_udc_core: Fix scheduling while atomic dump message
      usb: Fix build error due to dma_mask is not at pdev_archdata at ARM

Peter Korsgaard (1):
      USB: ftdi_sio: add support for BeagleBone rev A5+

Pravin B Shelar (1):
      proc-ns: use d_set_d_op() API to set dentry ops in proc_ns_instantiat=
e().

Preston Fick (1):
      usb: cp210x: Update to support CP2105 and multiple interface devices

Rabin Vincent (1):
      rtc: Disable the alarm in the hardware (v2)

Rafael J. Wysocki (1):
      PM / Domains: Fix handling of wakeup devices during system resume

Richard Weinberger (1):
      UBI: fix error handling in ubi_scan()

Roland Dreier (3):
      tcm_loop: Set residual field for SCSI commands
      target: Don't set WBUS16 or SYNC bits in INQUIRY response
      target: Fix 16-bit target ports for SET TARGET PORT GROUPS emulation

Russell King (1):
      genirq: Fix long-term regression in genirq irq_set_irq_type() handling

Sasha Levin (3):
      math: Introduce div64_long
      ntp: Fix integer overflow when setting time
      module: Remove module size limit

Scott Dial (1):
      usb-serial: Add support for the Sealevel SeaLINK+8 2038-ROHS device

Sekhar Nori (2):
      gpio/davinci: fix oops on unbanked gpio irq request
      gpio/davinci: fix enabling unbanked GPIO IRQs

Sergei Shtylyov (1):
      pata_legacy: correctly mask recovery field for HT6560B

Shengzhou Liu (1):
      powerpc/usb: fix bug of kernel hang when initializing usb

Simon Graham (1):
      rtlwifi: Handle previous allocation failures when freeing device memo=
ry

Srivatsa S. Bhat (1):
      PM / Hibernate: Enable usermodehelpers in hibernate() error path

Steffen Klassert (1):
      xfrm: Access the replay notify functions via the registered callbacks

Steffen Persvold (1):
      iommu/amd: Fix section warning for prealloc_protection_domains

Stephan B=C3=A4rwolf (2):
      KVM: x86: extend "struct x86_emulate_ops" with "get_cpuid"
      KVM: x86: fix missing checks in syscall emulation

Stephen Warren (1):
      ARM: tegra: select required CPU and L2 errata options

Supriya Karanth (1):
      usb: musb: Reselect index reg in interrupt context

Suresh Siddha (1):
      x86/ioapic: Add register level checks to detect bogus io-apic entries

Takashi YOSHII (1):
      serial: sh-sci: fix a race of DMA submit_tx on transfer

Tarun Kanti DebBarma (1):
      gpio/omap: fix _set_gpio_irqenable implementation

Theodore Ts'o (1):
      ext4: check for zero length extent

Thomas Faber (1):
      usb: gadgetfs: return number of bytes on ep0 read request

Thomas Gleixner (1):
      futex: Cover all PI opcodes with cmpxchg enabled check

Thomas Tuttle (1):
      USB: qcserial: add several new serial devices

Tim Gardner (1):
      TPM: Zero buffer whole after copying to userspace

Timur Tabi (1):
      ASoC: fsl: p1022ds: tell the WM8776 codec driver that it's the master

Trond Myklebust (6):
      NFS: Properly handle the case where the delegation is revoked
      NFSv4: Return the delegation if the server returns NFS4ERR_OPENMODE
      SUNRPC: We must not use list_for_each_entry_safe() in rpc_wake_up()
      NFSv4: Rate limit the state manager warning messages
      NFSv4: Fix two infinite loops in the mount code
      NFSv4.1: Fix layoutcommit error handling

Xi Wang (1):
      lgdt330x: fix signedness error in i2c_read_demod_bytes()

stephen hemminger (1):
      sky2: override for PCI legacy power management

tom.leiming@gmail.com (2):
      usbnet: increase URB reference count before usb_unlink_urb
      usbnet: don't clear urb->dev in tx_complete


--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPeeN6AAoJEDjbvchgkmk+1yEP/0HMtvNvShJoqH6wAXQWVuJA
nGRngZmVxj1VgaYCMI7uDSmsi58uomc03iTfQRvwoZXaMczoKzoXnRHTet5A4oA9
300JnTHfabizPtht1R6UynL2t0O55di4b+JNMoIT7aZ7M3ChfOAXiNkKb+oQELBq
ezyJ57WpWQV/l6CPvI4nDavQVRW1yLi2P62flT0AhmOEyPeNbPXNfUpi/cKajdvW
sDct0pgkQuH0qxrOozSj17nOV/wFH9kdNFpEWM7jjc+BvMVi2uZkghM1v2RuY+Wk
v+K8tAEjhBgz+EiHLLh7xVN+3m7vZDmrCvnug8h1EpgBvQObBm2vKFePUXX2E8NG
5sZyS64cXDeRcQDWcNJV3kit0Z13WcWgyHq5U6NxendP903akKtlpAiuOSp3Mcez
BVvFm/xvpALc9kbTl7kHsRHnb8W9QRB9jrqOE82cQAV68iRRlVF1h3MVrRzFcx7x
y2vUI641OTPxFytsBIgS/ES5XZ2AAoKy5MJxnxF+h3enpojmSxh7pSqk91YF1D2e
5AcEDtrsaVMflRfV8KscPlqDHAZixZPQE39PckNjXAtC8PNuK63nY0Cdh+xgBjJ2
9iBVWXPVhhs2vzsP6/m+zF3J/c/e4SCZZT7fYlvicx85l5Kn/eX2GNGieCce26Pu
T7KbN+cKrN4jB9KGeZVu
=xY29
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
