Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412Ab2FVTZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 15:25:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2FVTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 15:25:16 -0400
Date: Fri, 22 Jun 2012 12:25:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.4.4
Message-ID: <20120622192512.GA23071@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.4 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                          |    2=20
 arch/arm/mach-imx/crm-regs-imx5.h                 |    2=20
 arch/arm/mach-imx/hotplug.c                       |   42 +++++++++
 arch/arm/mach-imx/mach-mx21ads.c                  |    2=20
 arch/powerpc/include/asm/hw_irq.h                 |    3=20
 arch/x86/xen/enlighten.c                          |    8 +
 drivers/char/hw_random/atmel-rng.c                |    2=20
 drivers/edac/i7core_edac.c                        |   15 ---
 drivers/edac/sb_edac.c                            |   10 +-
 drivers/gpu/drm/i915/intel_dp.c                   |    7 +
 drivers/gpu/drm/radeon/evergreen.c                |    3=20
 drivers/gpu/drm/radeon/evergreend.h               |    1=20
 drivers/gpu/drm/radeon/r600.c                     |    1=20
 drivers/gpu/drm/radeon/r600d.h                    |    1=20
 drivers/gpu/drm/radeon/rv770.c                    |    5 -
 drivers/gpu/drm/radeon/rv770d.h                   |    3=20
 drivers/gpu/drm/sis/sis_drv.c                     |    2=20
 drivers/gpu/drm/udl/udl_drv.c                     |   15 +++
 drivers/gpu/drm/via/via_map.c                     |    3=20
 drivers/net/ethernet/intel/e1000e/82571.c         |    3=20
 drivers/net/ethernet/intel/e1000e/netdev.c        |    8 -
 drivers/net/wireless/iwlwifi/iwl-6000.c           |   23 ++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom.c         |   18 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    2=20
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   20 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |    4=20
 drivers/pci/pci.c                                 |    5 +
 drivers/pci/quirks.c                              |   26 +++++
 drivers/remoteproc/omap_remoteproc.c              |    2=20
 drivers/remoteproc/remoteproc_core.c              |   10 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c               |    2=20
 drivers/target/target_core_alua.c                 |    8 +
 drivers/tty/hvc/hvc_xen.c                         |   31 +++----
 drivers/usb/class/cdc-acm.c                       |    8 +
 drivers/usb/class/cdc-wdm.c                       |    9 ++
 drivers/usb/core/hcd-pci.c                        |    9 --
 drivers/usb/core/message.c                        |    3=20
 drivers/usb/host/ehci-hcd.c                       |    2=20
 drivers/usb/host/ehci-pci.c                       |    8 -
 drivers/usb/host/xhci-mem.c                       |   74 +++++-----------
 drivers/usb/host/xhci.c                           |    8 -
 drivers/usb/musb/davinci.c                        |    1=20
 drivers/usb/musb/davinci.h                        |    4=20
 drivers/usb/musb/musb_gadget.c                    |    1=20
 drivers/usb/serial/cp210x.c                       |    1=20
 drivers/usb/serial/ftdi_sio.c                     |    1=20
 drivers/usb/serial/ftdi_sio_ids.h                 |    1=20
 drivers/usb/serial/mct_u232.c                     |   13 +-
 drivers/usb/serial/mos7840.c                      |    2=20
 drivers/usb/serial/option.c                       |   96 ++++++++++-------=
-----
 drivers/usb/serial/qcserial.c                     |    6 +
 drivers/usb/serial/sierra.c                       |    4=20
 drivers/usb/serial/usb-serial.c                   |    6 -
 drivers/usb/storage/unusual_devs.h                |    7 +
 fs/hfsplus/ioctl.c                                |    9 +-
 fs/hfsplus/wrapper.c                              |    2=20
 fs/nfs/nfs4proc.c                                 |    1=20
 fs/nfsd/nfs4state.c                               |    4=20
 include/linux/pci.h                               |    2=20
 include/linux/swapops.h                           |    8 +
 include/linux/usb/hcd.h                           |    2=20
 kernel/panic.c                                    |    4=20
 kernel/time/ntp.c                                 |    2=20
 kernel/trace/trace.c                              |    2=20
 mm/swapfile.c                                     |   12 --
 net/9p/trans_virtio.c                             |    2=20
 net/sunrpc/rpc_pipe.c                             |   12 +-
 net/sunrpc/svc.c                                  |    3=20
 sound/soc/codecs/wm8904.c                         |   13 +-
 69 files changed, 384 insertions(+), 247 deletions(-)

Alan Cox (1):
      USB: mct_u232: Fix incorrect TIOCMSET return

Alan Stern (1):
      USB: add NO_D3_DURING_SLEEP flag and revert 151b61284776be2

Alex Deucher (1):
      drm/radeon: add some additional 6xx/7xx/EG register init

Andiry Xu (1):
      xHCI: Increase the timeout for controller save/restore state operation

Andre Przywara (1):
      xen/setup: filter APERFMPERF cpuid feature out

Andrew Bird (1):
      USB: option: Updated Huawei K4605 has better id

Bj=C3=B8rn Mork (4):
      USB: option: Add Vodafone/Huawei K5005 support
      USB: qcserial: Add Sierra Wireless device IDs
      USB: cdc-wdm: Add Vodafone/Huawei K5005 support
      USB: serial: Enforce USB driver and USB serial driver match

Chen Gong (2):
      edac: avoid mce decoding crash after edac driver unloaded
      edac: fix the error about memory type detection on SandyBridge

Chris Boot (2):
      e1000e: Disable ASPM L1 on 82574
      e1000e: Remove special case for 82573/82574 ASPM L1 disablement

Daniel Mack (1):
      USB: fix gathering of interface associations

Daniel Vetter (1):
      Revert "drm/i915/dp: Use auxch precharge value of 5 everywhere"

Dave Airlie (1):
      drm/udl: only bind to the video devices on the hub.

Emmanuel Grumbach (1):
      iwlwifi: fix the Transmit Frame Descriptor rings

Evan McNabb (1):
      USB: ftdi-sio: Add support for RT Systems USB-RTS01 serial adapter

Grazvydas Ignotas (1):
      usb: musb_gadget: fix crash caused by dangling pointer

Greg Kroah-Hartman (1):
      Linux 3.4.4

Hans de Goede (1):
      usb-storage: Add 090c:1000 to unusal-devs

Hugh Dickins (1):
      swap: fix shmem swapping when more than 8 areas

J. Bruce Fields (1):
      nfsd4: BUG_ON(!is_spin_locked()) no good on UP kernels

Jaccon Bastiaansen (1):
      ARM i.MX imx21ads: Fix overlapping static i/o mappings

Janne Kalliom=C3=A4ki (1):
      hfsplus: fix overflow in sector calculations in hfsplus_submit_bio

Jeff Layton (1):
      rpc_pipefs: allow rpc_purge_list to take a NULL waitq pointer

Johan Hovold (2):
      USB: option: fix memory leak
      USB: option: fix port-data abuse

Johannes Berg (1):
      iwlwifi: fix TX power antenna access

Jon Povey (1):
      usb: musb: davinci: Fix build breakage

Konrad Rzeszutek Wilk (3):
      xen/hvc: Collapse error logic.
      xen/hvc: Fix error cases around HVM_PARAM_CONSOLE_PFN
      xen/hvc: Check HVM_PARAM_CONSOLE_[EVTCHN|PFN] for correctness.

Mark Brown (1):
      ASoC: wm8904: Fix GPIO and MICBIAS initialisation for regmap conversi=
on

Matthew Garrett (1):
      hfsplus: fix bless ioctl when used with hardlinks

Meenakshi Venkataraman (1):
      iwlwifi: use correct supported firmware for 6035 and 6000g2

Mikko Tuumanen (1):
      USB: serial: cp210x: add Optris MS Pro usb id

M=C3=A1rton N=C3=A9meth (2):
      drm via: initialize object_idr
      drm sis: initialize object_idr

Ohad Ben-Cohen (1):
      remoteproc/omap: fix dev_err typo

Otto Meta (1):
      usb: cdc-acm: fix devices not unthrottled on open

Paul Mackerras (1):
      Make hard_irq_disable() actually hard-disable interrupts

Peter Korsgaard (1):
      hwrng: atmel-rng - fix data valid check

Ricardo Martins (1):
      USB: fix PS3 EHCI systems

Richard Cochran (1):
      ntp: Correct TAI offset during leap second

Roland Dreier (1):
      target: Return error to initiator if SET TARGET PORT GROUPS emulation=
 fails

Sascha Hauer (1):
      ARM i.MX53: Fix PLL4 base address

Sasha Levin (1):
      9p: BUG before corrupting memory

Seiji Aguchi (1):
      kdump: Execute kmsg_dump(KMSG_DUMP_PANIC) after smp_send_stop()

Shawn Guo (1):
      ARM: imx6: exit coherency when shutting down a cpu

Sjur Br=C3=A6ndeland (2):
      remoteproc: fix print format warnings
      remoteproc: fix missing fault indication in error-path

Steven Rostedt (1):
      tracing: Have tracing_off() actually turn tracing off

Takashi Iwai (2):
      xhci: Fix invalid loop check in xhci_free_tt_info()
      xhci: Don't free endpoints in xhci_mem_cleanup()

Tom Cassidy (1):
      USB: serial: sierra: Add support for Sierra Wireless AirCard 320U mod=
em

Tony Zelenoff (1):
      USB: mos7840: Fix compilation of usb serial driver

Trond Myklebust (2):
      NFSv4.1: Fix a request leak on the back channel
      NFSv4: Fix unnecessary delegation returns in nfs4_do_open

nagalakshmi.nandigama@lsi.com (1):
      SCSI: mpt2sas: Fix unsafe using smp_processor_id() in preemptible

=E8=AF=B4=E4=B8=8D=E5=BE=97 (1):
      USB: option: add more YUGA device ids


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJP5MaYAAoJEDjbvchgkmk+zUIP/1/Hyj5wEdq1WY//Vy0MvbQ0
SAC+76F8oX1bt3EmLF3Mz0JoqxUaH7jDKhq95bdaOiRJ3gGD35wuFQAbJ60JwfIE
a2y2Kn/8fV3Xxweo+UMLSKXwjtEh1Vm4EbkUftL26fE7SCw2Vxb/QGE0mZXNAbKz
xicZWc8pWBKmWxiGRd6eMG8DILVHJprgVt7e/TX69HvD8d6P4F5TqdpzSEvj96dL
JAoMwSD+Sq/6I0M+XUtqODXAJwHxtdrMAFLn4mWPE6qLApRfWTzzNvSayk72buQE
D/WT6T+OBZPkJq/vVls8JToTURo1BSpduWjHCuClNi6ud2kgs13ToXne6ViRH8BF
rG4/Bl4q4eDLWCdBKH91fmYvVJIre/SAwLZcMPgK75OaXTd/iOg2/2VNAl284mXp
eakUJYk04PA6++OD0Q8jDspFcF2CmbgPaBPK1KMxedNTjpCg6UASiSgGccpuq06w
C3JDIDzR6YmXTzJvvBkbF5IWKH0bRcfsvqTlETqEtEJEk4Jh+jkJmanfRIgKvniG
7bS7Gx4RNzT7dW6uZ+RqJvfqPmFaMJs+phLK4/cpPD8utQYgRFM0DEq5waPTuiT7
rEzFb+je/3Ws3rR6zU3EeVF9PejfVjGaRLWLE0lo1y4Z9E5w7cRciWPKzeY/Udfn
mG+ffsz2poSc+xM9qxLz
=SnHy
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
