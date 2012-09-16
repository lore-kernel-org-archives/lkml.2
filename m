Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab2IPW7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 18:59:35 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63397 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2IPW7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 18:59:31 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Sep 2012 15:59:09 -0700
X-Google-Sender-Auth: NCCWNmI2mc4zfwac9X58SB08eus
Message-ID: <CA+55aFxMmqG32dJXhUe7N+aS=M1q_5hf7iTfsnPKDU4d610EoQ@mail.gmail.com>
Subject: Linux 3.6-rc6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, another week, another -rc.

And as I suspected, the reason -rc5 was so small was that a lot of
people were still getting ready after the Kernel Summit. So -rc6 is a
bit larger, since people were playing catch-up. That said, it's not
*huge* either, and it's not like it looks scary, but it's definitely
not tiny.

Fairly normal statistics: two thirds drivers, with the remaining third
being a mix of architecture updates, filesystems (gfs2 and nfs) and
random core stuff (scheduler, workqueue, stuff like that).

Please do test things out, I'd really like to be able to do the final
3.6 soonish..

                  Linus

---
Aaro Koskinen (2):
      ARM: OMAP: sram: fix OMAP4 errata handling
      ARM: OMAP: sram: skip the first 16K on OMAP3 HS

Aaron Lu (1):
      ACPI / PM: Use KERN_DEBUG when no power resources are found

Al Viro (1):
      perf_event: Switch to internal refcount, fix race with close()

Alan Cox (4):
      netrom: copy_datagram_iovec can fail
      gma500: Fix regression on Oaktrail devices
      ahci: Add alternate identifier for the 88SE9172
      ahci: Add identifiers for ASM106x devices

Alan Stern (1):
      USB: add device quirk for Joss Optical touchboard

Alex Deucher (1):
      drm/radeon: rework pll selection (v3)

Alexander Shishkin (1):
      drm/i915: initialize dpio_lock spin lock

Alexis R. Cortes (1):
      usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP Hardware

Andre Guedes (1):
      Bluetooth: Fix use-after-free bug in SMP

Andrzej Pietrasiewicz (1):
      usb: gadget: add multiple definition guards

AnilKumar Ch (1):
      mfd: Move tps65217 regulator plat data handling to regulator

Arend van Spriel (1):
      brcmfmac: fix use of dev_kfree_skb() in irq context

Aviad Yehezkel (2):
      net/mlx4_core: Looking for promiscuous entries on the correct port
      net/mlx4_core: Fixing error flow in case of QUERY_FW failure

Axel Lin (1):
      i2c-designware: Fix build error if
CONFIG_I2C_DESIGNWARE_PLATFORM=y && CONFIG_I2C_DESIGNWARE_PCI=y

Ben Collins (1):
      crypto/caam: Export gen_split_key symbol for other modules

Ben Hutchings (1):
      ahci: Add JMicron 362 device IDs

Ben Skeggs (2):
      drm/nvd0/disp: hopefully fix selection of 6/8bpc mode on DP outputs
      drm/nv50-/gpio: initialise to vbios defaults during init

Benjamin Wang (1):
      target: Check idr_get_new return value in iscsi_login_zero_tsih_s1

Benoît Locher (1):
      can: mcp251x: avoid repeated frame bug

Bernhard Froemel (2):
      apple-gmux: Obtain version info from indexed gmux
      apple-gmux: Fix index read functions

Bjørn Mork (6):
      net: usbnet: fix softirq storm on suspend
      kobject: fix oops with "input0: bad kobj_uevent_env content in
show_uevent()"
      USB: ftdi_sio: do not claim CDC ACM function
      USB: cdc-wdm: fix wdm_find_device* return value
      USB: option: replace ZTE K5006-Z entry with vendor class rule
      net: qmi_wwan: call subdriver with control intf only

Bo Shen (1):
      ASoC: wm8904: correct the index

Catalin Iacob (1):
      ALSA: hda_intel: add position_fix quirk for Asus K53E

Chanwoo Choi (2):
      mfd: MAX77693: Fix interrupt handling bug
      mfd: MAX77693: Fix NULL pointer error when initializing irqs

Charles Wang (1):
      sched: Add missing call to calc_load_exit_idle()

Chema Gonzalez (1):
      net: small bug on rxhash calculation

Chris Mason (1):
      Revert "Btrfs: fix some error codes in btrfs_qgroup_inherit()"

Christian König (1):
      drm/radeon: make 64bit fences more robust v3

Corentin Chary (2):
      drivers-platform-x86: remove useless #ifdef CONFIG_ACPI_VIDEO
      asus-laptop: HRWS/HWRS typo

Dae S. Kim (1):
      Staging: Android alarm: IOCTL command encoding fix

Dan Carpenter (4):
      staging:iio: prevent divide by zero bugs
      xhci: Fix a logical vs bitwise AND bug
      ALSA: compress_core: fix open flags test in snd_compr_open()
      thinkpad_acpi: buffer overflow in fan_get_status()

Daniel Drake (1):
      libertas sdio: fix suspend when interface is down

Daniel Mack (1):
      fuse: mark variables uninitialized

Daniel Vetter (2):
      drm/i915: set the right gen3 flip_done mode also at resume
      drm/i915: fix up the IBX transcoder B check

Dave Airlie (6):
      drm/ast: drop debug level on error printk
      drm/i915/edp: get the panel delay before powering up
      drm/vmwgfx: allow a kconfig option to choose if fbcon is enabled
      drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot
      vmwgfx: add dumb ioctl support
      drm/nouveau: fix booting with plymouth + dumb support

David Brown (1):
      ARM: 7513/1: Make sure dtc is built before running it

David Ward (4):
      net_sched: gred: correct comment about qavg calculation in RIO mode
      net_sched: gred: eliminate redundant DP prio comparisons
      net_sched: gred: fix qave reporting via netlink
      net_sched: gred: actually perform idling in WRED mode

Dirk Behme (1):
      tty: serial: imx: don't reinit clock in imx_setup_ufcr()

Dmitry Kasatkin (1):
      digsig: add hash size comparision on signature verification

Dmitry Kravkov (2):
      bnx2x: Avoid sending multiple statistics queries
      bnx2x: fix registers dumped

Dylan Reid (1):
      ASoC: samsung dma - Don't indicate support for pause/resume.

Eliad Peller (1):
      mac80211: clear bssid on auth/assoc failure

Emil Goode (1):
      staging: wlan-ng: Fix problem with wrong arguments

Eric Dumazet (8):
      net: sock_edemux() should take care of timewait sockets
      fq_codel: dont reinit flow state
      l2tp: fix a lockdep splat
      l2tp: fix a typo in l2tp_eth_dev_recv()
      netfilter: take care of timewait sockets
      udp: increment UDP_MIB_INERRORS if copy failed
      staging: r8712u: fix bug in r8712_recv_indicatepkt()
      net-sched: sch_cbq: avoid infinite loop

Eugenia Emantayev (1):
      net/mlx4_core: Return the error value in case of command
initialization failure

Fabio Estevam (3):
      ASoC: mc13783: Remove mono support
      ARM: clk-imx25: Fix SSI clock registration
      ARM: clk-imx35: Fix SSI clock registration

Felix Fietkau (6):
      ath9k_hw: do not enable the MIB interrupt in the interrupt mask register
      ath9k_hw: clear the AM2PM predistortion mask on AR933x
      ath9k_hw: calibrate PA input for PA predistortion
      ath9k_hw: disable PA linearization for AR9462
      ath9k: fix PA linearization calibration related crash
      ath9k_hw: enable PA linearization

Feng Tang (1):
      mfd: lpc_ich: Fix a 3.5 kernel regression for iTCO_wdt driver

Florian Fainelli (1):
      ixp4xx_hss: fix build failure due to missing linux/module.h inclusion

Gertjan van Wingerde (3):
      rt2x00: Identify ASUS USB-N53 device.
      rt2x00: Fix word size of rt2500usb MAC_CSR19 register.
      rt2x00: Fix rfkill polling prior to interface start.

Guenter Roeck (2):
      hwmon: (twl4030-madc-hwmon) Initialize uninitialized structure elements
      hwmon: (ina2xx) Fix word size register read and write operations

Gustavo Padovan (1):
      Bluetooth: Use USB_VENDOR_AND_INTERFACE() for Broadcom devices

Hadar Hen Zion (2):
      net/mlx4_core: Put Firmware flow steering structures in common
header files
      net/mlx4_core: Add security check / enforcement for flow
steering rules set for VMs

Hante Meuleman (3):
      brcmfmac: dont use ZERO flag for usb IN
      brcmfmac: fix race condition for rx and tx data.
      brcmfmac: fix get rssi by clearing getvar struct.

Heather Lomond (1):
      ASoC: arizona: Fix typo in 44.1kHz rates

Henrik Rydberg (1):
      Bluetooth: Add support for Apple vendor-specific devices

Herbert Xu (1):
      crypto: authenc - Fix crash with zero-length assoc data

Horst Schirmeier (1):
      USB: ftdi_sio: PID for NZR SEM 16+ USB

Ian Abbott (8):
      staging: comedi: amplc_pci224: Fix PCI ref count
      staging: comedi: amplc_dio200: Fix PCI ref count
      staging: comedi: amplc_pc236: Fix PCI ref count
      staging: comedi: amplc_pc263: Fix PCI ref count
      staging: comedi: amplc_pci230: Fix PCI ref count
      staging: comedi: das08: Fix PCI ref count
      staging: comedi: das08: Correct AI encoding for das08jr-16-ao
      staging: comedi: das08: Correct AO output for das08jr-16-ao

Igor Grinberg (1):
      ARM: OMAP: timer: obey the !CONFIG_OMAP_32K_TIMER

Inki Dae (2):
      drm/exynos: fixed page align bug.
      drm/exynos: remove DRM_FORMAT_NV12M from plane module

James Bottomley (1):
      [SCSI] Fix 'Device not ready' issue on mpt2sas

James Hogan (1):
      kbuild: add symbol prefix arg to kallsyms

James Ralston (1):
      i2c-i801: Add Device IDs for Intel Lynx Point-LP PCH

Jamie Iles (1):
      KVM: PIC: fix use of uninitialised variable.

Jan Kara (2):
      ext3: Fix fdatasync() for files with only i_size changes
      udf: Fix data corruption for files in ICB

Jani Nikula (2):
      drm/i915: only enable sdvo hotplug irq if needed
      drm/i915: do not expose a dysfunctional backlight interface to userspace

Jean Delvare (2):
      |PATCH] seeq: Add missing spinlock init
      i2c-core: Fix for lockdep validator

Jesse Gross (2):
      openvswitch: Relax set header validation.
      openvswitch: Fix FLOW_BUFSIZE definition.

Jiang Liu (1):
      eeepc-laptop: fix device reference count leakage in eeepc_rfkill_hotplug()

Joachim Eastwood (1):
      ASoC: atmel-ssc: include linux/io.h for raw io

Joe Perches (1):
      netfilter: log: Fix log-level processing

Joe Stringer (1):
      openvswitch: Fix typo

Jonathan Austin (1):
      ARM: 7499/1: mm: Fix vmalloc overlap check for !HIGHMEM

Jozsef Kadlecsik (2):
      netfilter: Mark SYN/ACK packets as invalid from original direction
      netfilter: Validate the sequence number of dataless ACK packets as well

Julia Lawall (5):
      ASoC: imx-sgtl5000: fix error return code
      ASoC: ux500_msp_i2s: better use devm functions and fix error return code
      ASoC: am3517evm: fix error return code
      drivers/iio/adc/at91_adc.c: adjust inconsistent IS_ERR and PTR_ERR
      usb: gadget: s3c-hsotg.c: fix error return code

Julian Anastasov (1):
      tcp: fix possible socket refcount problem for ipv6

K.Prasad (1):
      perf/hwpb: Invoke __perf_event_disable() if interrupts are
already disabled

Karsten Keil (1):
      mISDN: Fix wrong usage of flush_work_sync while holding locks

Kashyap Desai (1):
      [SCSI] megaraid_sas: Move poll_aen_lock initializer

Keith Packard (1):
      drm: use drm_compat_ioctl for 32-bit apps

Keng-Yu Lin (1):
      Intel xhci: Only switch the switchable ports

Kishon Vijay Abraham I (1):
      usb: dwc3: core: fix incorrect usage of resource pointer

Kuninori Morimoto (1):
      usb: renesas_usbhs: fixup DMA transport data alignment

LEO Airwarosu Yoichi Shinoda (1):
      mac80211: Various small fixes for cfg.c: mpath_set_pinfo()

Lai Jiangshan (3):
      workqueue: UNBOUND -> REBIND morphing in rebind_workers() should be atomic
      workqueue: restore POOL_MANAGING_WORKERS
      workqueue: fix possible idle worker depletion across CPU hotplug

Lennart Sorensen (1):
      sierra_net: Endianess bug fix.

Lin Ming (1):
      ACPI / PM: Fix resource_lock dead lock in acpi_power_on_device

Linus Torvalds (3):
      vfs: make O_PATH file descriptors usable for 'fstat()'
      Revert "sched: Improve scalability via 'CPU buddies', which
withstand random perturbations"
      Linux 3.6-rc6

Malcolm Priestley (1):
      staging: vt6656: [BUG] - Failed connection, incorrect endian.

Mandeep Singh Baines (1):
      drm/exynos: fix double call of drm_prime_(init/destroy)_file_private

Manoj Iyer (1):
      xhci: Recognize USB 3.0 devices as superspeed at powerup

Marc Kleine-Budde (3):
      rt2x00: fix voltage setting for RT3572/RT3592
      usb: chipidea: udc: fix error path in udc_start()
      usb: chipidea: cleanup dma_pool if udc_start() fails

Mark Brown (3):
      ASoC: dapm: Make sure we update the bias level for CODECs with no op
      ASoC: dapm: Don't force card bias level to be updated
      mfd: core: Push irqdomain mapping out into devices

Matteo Frigo (1):
      ALSA: ice1724: Use linear scale for AK4396 volume control.

Matthew Garrett (1):
      xhci: Make handover code more robust

Maxim Nikulin (1):
      platform/x86: fix asus_laptop.wled_type description

Michael Grzeschik (3):
      usb: chipidea: udc: fix setup of endpoint maxpacket size
      usb: chipidea: udc: add pullup fuction, needed by the uvc gadget
      usb: chipidea: udc: don't stall endpoint if request list is
empty in isr_tr_complete_low

Mike Snitzer (1):
      [SCSI] scsi_lib: fix scsi_io_completion's SG_IO error propagation

Miklos Szeredi (3):
      cuse: fix fuse_conn_kill()
      cuse: kill connection on initialization error
      fuse: fix retrieve length

Misael Lopez Cruz (1):
      ARM: OMAP: hwmod code: Disable module when hwmod enable fails

Mohammed Shafi Shajakhan (1):
      ath9k: Fix a crash in 2 WIRE btcoex chipsets

Moiz Sonasath (1):
      usb: host: xhci: fix compilation error for non-PCI based stacks

Nicholas Bellinger (1):
      target: Fix ->data_length re-assignment bug with SCSI overflow

Nicolas Ferre (1):
      USB: ohci-at91: fix PIO handling in relation with number of ports

Nishank Trivedi (1):
      pktgen: fix crash with vlan and packet size less than 46

Paolo Bonzini (9):
      target: move transport_get_sense_data
      target: simplify code around transport_get_sense_data
      target: fix use-after-free with PSCSI sense data
      target: go through normal processing for zero-length PSCSI commands
      target: report too-small parameter lists everywhere
      target: fail REPORT LUNS with less than 16 bytes of payload
      target: support zero-size allocation lengths in transport_kmap_data_sg
      target: support zero allocation length in REQUEST SENSE
      target: go through normal processing for zero-length REQUEST_SENSE

Paul Walmsley (1):
      ARM: OMAP3xxx: clockdomain: fix software supervised wakeup/sleep

Pavankumar Kondeti (1):
      EHCI: Update qTD next pointer in QH overlay region during unlink

Pavel Shilovsky (2):
      CIFS: Fix error handling in cifs_push_mandatory_locks
      CIFS: Fix endianness conversion

Peter Boonstoppel (1):
      sched: Unthrottle rt runqueues in __disable_runtime()

Peter Meerwald (1):
      staging iio: fix potential memory leak in lis3l02dq_ring.c

Peter Zijlstra (1):
      sched: Fix load avg vs cpu-hotplug

Philip, Avinash (2):
      pwm: pwm-tiecap: Disable APWM mode after configure
      pwm: pwm-tiehrpwm: Fix conflicting channel period setting

Pierre Sauter (1):
      net: qmi_wwan: fix Gobi device probing for un2430

Prasad Joshi (1):
      ASoC: spear: correct the check for NULL dma_buffer pointer

Pratyush Anand (2):
      usb: dwc3: ep0: correct cache sync issue in case of ep0_bounced
      usb: dwc3: gadget: fix pending isoc handling

Radek Pilar (1):
      ARM: OMAP: Config fix for omap3-touchbook board

Rafael J. Wysocki (1):
      ACPI / PM: Infer parent power state from child if unknown, v2

Randy Dunlap (2):
      sched: Fix kernel-doc warnings in kernel/sched/fair.c
      net: fix net/core/sock.c build error

Ren, Yongjie (1):
      KVM: x86: Check INVPCID feature bit in EBX of leaf 7

Rob Clark (2):
      drm/omap: update for interlaced
      drm/omap: add more new timings fields

Robert Richter (1):
      oprofile, s390: Fix uninitialized memory access when writing to oprofilefs

Roland Stigge (2):
      i2c: pnx: Fix bit definitions
      i2c: pnx: Fix read transactions of >= 2 bytes

Ruchika Kharwar (1):
      usb: host: xhci-plat: use ioremap_nocache

Russell King (2):
      ARM: Fix ioremap() of address zero
      ARM: 7527/1: uaccess: explicitly check __user pointer when
!CPU_USE_DOMAINS

Sachin Kamat (10):
      mm/memblock: Use NULL instead of 0 for pointers
      drm/exynos: Remove redundant check in exynos_hdmi.c file
      drm/exynos: Remove redundant check in exynos_drm_fimd.c file
      drm/exynos: Use devm_kzalloc in exynos_drm_vidi.c file
      drm/exynos: Use devm_kzalloc in exynos_drm_hdmi.c file
      drm/exynos: Use devm_* functions in exynos_drm_g2d.c file
      drm/exynos: Add dependency for G2D in Kconfig
      drm/exynos: Make g2d_pm_ops static
      drm/exynos: Add missing braces around sizeof in exynos_hdmi.c
      drm/exynos: Add missing braces around sizeof in exynos_mixer.c

Santiago Leon (1):
      ibmveth: Fix alignment of rx queue bug

Sebastian Andrzej Siewior (4):
      usb: gadget: dummy_hcd: fixup error probe path
      usb: gadget: dummy_hcd: add support for USB_DT_BOS on rh
      usb: gadget: at91udc: don't overwrite driver data
      usb: gadget: at91udc: Don't check for ep->ep.desc

Sergei Poselenov (1):
      rt2800usb: Added rx packet length validity check

Sergei Shtylyov (2):
      usb: musb: tusb6010: fix error path in tusb_probe()
      usb: musb: musbhsdma: fix IRQ check

Seth Forshee (1):
      apple-gmux: Fix port address calculation in gmux_pio_write32()

Seth Jennings (1):
      staging: zcache: fix cleancache race condition with shrinker

Steffen Klassert (1):
      xfrm: Workaround incompatibility of ESN and async crypto

Stephane Eranian (2):
      perf/x86: Fix microcode revision check for SNB-PEBS
      perf/x86: Enable Intel Cedarview Atom suppport

Stephen Boyd (2):
      ARM: 7512/1: Fix XIP build due to PHYS_OFFSET definition moving
      ARM: 7521/1: Fix semihosting Kconfig text

Stephen Warren (2):
      sound: tegra_alc5632: remove HP detect GPIO inversion
      ASoC: tegra: fix maxburst settings in dmaengine code

Steven Miao (1):
      blackfin: smp: adapt to generic smp helpers

Steven Whitehouse (3):
      GFS2: Make write size hinting code common
      GFS2: Fix missing allocation data for set/remove xattr
      GFS2: Take account of blockages when using reserved blocks

Stone Piao (1):
      mwifiex: fix skb length issue when send a command to firmware

Takashi Iwai (4):
      ALSA: hda - Fix missing Master volume for STAC9200/925x
      ALSA: usb-audio: Fix bogus error messages for delay accounting
      ALSA: hda - Fix Oops at codec reset/reconfig
      ALSA: hda - Yet another position_fix quirk for ASUS machines

Tejun Heo (2):
      workqueue: move WORKER_REBIND clearing in rebind_workers() to
the end of the function
      workqueue: fix possible deadlock in idle worker rebinding

Tero Kristo (2):
      ARM: OMAP3: hwmod data: fix iva2 reset info
      ARM: OMAP4: hwmod data: temporarily comment out data for the
sl2if IP block

Thomas Graf (1):
      sctp: Don't charge for data in sndbuf again when transmitting packet

Thomas Kavanagh (1):
      i2c: algo: pca: Fix mode selection for PCA9665

Thomas Meyer (1):
      drm/exynos: Use ERR_CAST inlined function instead of
ERR_PTR(PTR_ERR(.. [1]

Thomas Petazzoni (1):
      arm: mm: fix DMA pool affiliation check

Tomas Winkler (1):
      staging: ozwpan: fix memcmp() test in oz_set_active_pd()

Tomasz Stanislawski (1):
      drm/exynos: add dummy support for dmabuf-mmap

Tony Lindgren (1):
      ARM: OMAP4: Fix array size for irq_target_cpu

Trond Myklebust (6):
      NFS: Fix the initialisation of the readdir 'cookieverf' array
      NFS: Fix a problem with the legacy binary mount code
      NFSv4: Fix range checking in __nfs4_get_acl_uncached and
__nfs4_proc_set_acl
      NFSv4: Fix buffer overflow checking in __nfs4_get_acl_uncached
      SUNRPC: Fix a UDP transport regression
      NFS: fsync() must exit with an error if page writeback failed

Tyler Hicks (3):
      eCryptfs: Write out all dirty pages just before releasing the lower file
      eCryptfs: Call lower ->flush() from ecryptfs_flush()
      eCryptfs: Copy up attributes of the lower target inode after rename

Vaibhav Hiremath (1):
      ARM: OMAP2+: am33xx: Fix the timer fck clock naming convention

Ville Syrjälä (1):
      drm: Drop the NV12M and YUV420M formats

Vinicius Costa Gomes (2):
      Bluetooth: Change signature of smp_conn_security()
      Bluetooth: Fix sending a HCI Authorization Request over LE links

Wei Yongjun (3):
      mISDN: fix possible memory leak in hfcmulti_init()
      nl80211: fix possible memory leak nl80211_connect()
      caif: move the dereference below the NULL test

Weston Andros Adamson (1):
      NFS: return error from decode_getfh in decode open

Will Deacon (8):
      ARM: 7496/1: hw_breakpoint: don't rely on dfsr to show
watchpoint access type
      ARM: 7497/1: hw_breakpoint: allow single-byte watchpoints on all addresses
      ARM: 7501/1: decompressor: reset ttbcr for VMSA ARMv7 cores
      ARM: 7502/1: contextidr: avoid using bfi instruction during notifier
      ARM: 7503/1: mm: only flush both pmd entries for classic MMU
      ARM: 7526/1: traps: send SIGILL if get_user fails on undef handling path
      ARM: 7528/1: uaccess: annotate [__]{get,put}_user functions with
might_fault()
      ARM: 7529/1: delay: set loops_per_jiffy when moving to timer-based loop

Wolfram Sang (2):
      i2c: mxs: correctly setup speed for non devicetree
      MAINTAINERS: fix tree for current i2c-embedded development

Wu Fengguang (1):
      i825xx: fix paging fault on znet_probe()

Xiao Guangrong (1):
      KVM: fix error paths for failed gfn_to_page() calls

Xinyu Chen (1):
      tty: serial: imx: console write routing is unsafe on SMP

Yaniv Rosner (3):
      bnx2x: prevent timeouts when using PFC
      bnx2x: display the correct duplex value
      bnx2x: correct advertisement of pause capabilities

Yevgeniy Melnichuk (1):
      Bluetooth: Add support for Sony Vaio T-Series

Yuval Mintz (2):
      bnx2x: fix stats copying logic
      bnx2x: Add missing afex code

sreekanth.reddy@lsi.com (1):
      [SCSI] mpt2sas: Fix for Driver oops, when loading driver with
max_queue_depth command line option to a very small value

yuzheng ma (1):
      usb: musb: host: fix for musb_start_urb Oops

Éric Piel (1):
      USB: ftdi-sio: add support for more Physik Instrumente devices
