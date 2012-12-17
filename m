Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab2LQTgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:36:14 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59836 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab2LQTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:36:13 -0500
Date: Mon, 17 Dec 2012 11:36:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.11
Message-ID: <20121217193609.GA22102@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.11 kernel.

Note, this is the LAST kernel in the 3.6.y series, it is now
end-of-life.  Please move to the 3.7.y kernel series at this time.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                    |    2=20
 arch/arm/include/asm/hwcap.h                |    3=20
 arch/arm/include/asm/vfpmacros.h            |   12 +-
 arch/arm/vfp/vfpmodule.c                    |    9 +
 arch/powerpc/platforms/pseries/eeh_driver.c |   35 ++++--
 arch/x86/kernel/hpet.c                      |    4=20
 drivers/acpi/battery.c                      |   77 ++++++++++++++
 drivers/acpi/sleep.c                        |    8 +
 drivers/acpi/video.c                        |   14 ++
 drivers/acpi/video_detect.c                 |    8 +
 drivers/block/floppy.c                      |    5=20
 drivers/edac/edac_mc.c                      |   14 ++
 drivers/edac/i82975x_edac.c                 |   11 --
 drivers/gpu/drm/i915/intel_bios.c           |   11 --
 drivers/gpu/drm/i915/intel_display.c        |   11 ++
 drivers/hwmon/fam15h_power.c                |    4=20
 drivers/input/matrix-keymap.c               |    3=20
 drivers/mmc/host/sh_mmcif.c                 |    8 -
 drivers/net/bonding/bond_main.c             |    7 +
 drivers/net/bonding/bond_sysfs.c            |    2=20
 drivers/net/ethernet/8390/ne.c              |    1=20
 drivers/net/ethernet/sis/sis900.c           |    2=20
 drivers/net/irda/sir_dev.c                  |    2=20
 drivers/net/usb/cdc_ncm.c                   |   22 +++-
 drivers/net/usb/ipheth.c                    |    5=20
 drivers/pci/bus.c                           |    3=20
 drivers/pci/pcie/aer/aerdrv_core.c          |   20 ++-
 drivers/pnp/pnpacpi/core.c                  |    3=20
 drivers/staging/ipack/bridges/tpci200.c     |    2=20
 drivers/usb/class/cdc-acm.c                 |   38 ++++++
 drivers/usb/host/ehci-q.c                   |   12 --
 drivers/usb/host/ehci-sched.c               |    4=20
 drivers/usb/host/ohci-q.c                   |   19 +++
 drivers/usb/host/xhci-pci.c                 |    7 -
 drivers/usb/serial/cp210x.c                 |    1=20
 drivers/usb/serial/ftdi_sio.c               |    3=20
 drivers/usb/serial/ftdi_sio_ids.h           |    6 +
 drivers/usb/serial/option.c                 |   25 ++++
 drivers/usb/storage/Kconfig                 |    2=20
 include/linux/mempolicy.h                   |   16 --
 kernel/rcutree.c                            |   15 +-
 kernel/trace/ftrace.c                       |    2=20
 kernel/trace/ring_buffer.c                  |   16 ++
 kernel/workqueue.c                          |    4=20
 mm/dmapool.c                                |   31 +----
 mm/mempolicy.c                              |   22 ----
 mm/shmem.c                                  |   26 ++--
 net/ipv4/icmp.c                             |    3=20
 net/ipv4/inet_diag.c                        |  154 ++++++++++++++++++++++-=
-----
 net/ipv4/ip_fragment.c                      |   19 +--
 net/ipv4/route.c                            |    7 -
 net/ipv6/inet6_connection_sock.c            |    3=20
 net/sctp/chunk.c                            |   20 ++-
 net/sctp/socket.c                           |    4=20
 sound/soc/Makefile                          |    5=20
 tools/perf/builtin-test.c                   |   38 ++----
 56 files changed, 564 insertions(+), 246 deletions(-)

Alan Cox (1):
      ne2000: add the right platform device

Alan Stern (2):
      USB: OHCI: workaround for hardware bug: retired TDs not added to the =
Done Queue
      USB: EHCI: bugfix: urb->hcpriv should not be NULL

Alexander Shiyan (1):
      irda: sir_dev: Fix copy/paste typo

Bj=F8rn Mork (2):
      USB: option: blacklist network interface on Huawei E173
      net: cdc_ncm: add Huawei devices

Boris Ostrovsky (1):
      x86,AMD: Power driver support for AMD's family 16h processors

Chris Ball (1):
      Revert misapplied "mmc: sh-mmcif: avoid oops on spurious interrupts"

Dan Carpenter (1):
      ftrace: Clear bits properly in reset_iter_read()

Dan Williams (1):
      cdc-acm: implement TIOCSSERIAL to avoid blocking close(2)

Eric Dumazet (2):
      rcu: Fix batch-limit size problem
      ipv6: fix inet6_csk_update_pmtu() return value

Florian Fainelli (1):
      Input: matrix-keymap - provide proper module license

Francois Romieu (1):
      sis900: fix sis900_set_mode call parameters.

Greg Kroah-Hartman (2):
      USB: mark uas driver as BROKEN
      Linux 3.6.11

Guennadi Liakhovetski (1):
      mmc: sh-mmcif: avoid oops on spurious interrupts (second try)

Huang Ying (1):
      PCI/PM: Fix deadlock when unbinding device if parent in D3cold

Jan Beulich (1):
      x86: hpet: Fix masking of MSI interrupts

Jani Nikula (2):
      drm/i915: do not ignore eDP bpc settings from vbt
      drm/i915: do not default to 18 bpp for eDP if missing from VBT

Jay Purohit (1):
      usb/ipheth: Add iPhone 5 support

Jiri Kosina (1):
      floppy: destroy floppy workqueue before cleaning up the queue

Johannes Berg (1):
      ipv4: ip_check_defrag must not modify skb before unsharing

Julian Anastasov (1):
      ipv4: do not cache looped multicasts

Kamil Iskra (1):
      ACPI / battery: Correct battery capacity values on Thinkpads

Lan Tianyu (2):
      ACPI / PM: Add Sony Vaio VPCEB1S1E to nonvs blacklist.
      ACPI / video: Add "Asus UL30VT" to ACPI video detect blacklist

Marek Szyprowski (1):
      mm: dmapool: use provided gfp flags for all dma_alloc_coherent() calls

Markus Becker (1):
      USB: cp210x: add Virtenio Preon32 device id

Martin Teichmann (1):
      USB: ftdi_sio: Add support for Newport AGILIS motor drivers

Mauro Carvalho Chehab (2):
      i82975x_edac: Fix dimm label initialization
      edac: Fix the dimm filling for csrows-based layouts

Mel Gorman (1):
      tmpfs: fix shared mempolicy leak

Neal Cardwell (5):
      ipv4: avoid passing NULL to inet_putpeer() in icmpv4_xrlim_allow()
      inet_diag: fix oops for IPv4 AF_INET6 TCP SYN-RECV state
      inet_diag: validate byte code to prevent oops in inet_diag_bc_run()
      inet_diag: avoid unsafe and nonsensical prefix matches in inet_diag_b=
c_run()
      inet_diag: validate port comparison byte code to prevent unsafe reads

Paul Walmsley (1):
      ARM: 7566/1: vfp: fix save and restore when running on pre-VFPv3 and =
CONFIG_VFPv3 set

Peter Korsgaard (1):
      usb: ftdi_sio: fixup BeagleBone A5+ quirk

Peter Ujfalusi (1):
      ASoC: dmaengine: Correct Makefile when sound is built as module

Rafael J. Wysocki (1):
      ACPI / PNP: Do not crash due to stale pointer use during system resume

Samuel Iglesias Gons=E1lvez (1):
      Staging: ipack/bridges/tpci200: avoid kernel bug when uninstalling a =
device

Sarah Sharp (1):
      xhci: Extend Fresco Logic MSI quirk.

Sarveshwar Bandi (1):
      bonding: Bonding driver does not consider the gso_max_size/gso_max_se=
gs setting of slave devices.

Steven Rostedt (2):
      ring-buffer: Fix NULL pointer if rb_set_head_page() fails
      ring-buffer: Fix race between integrity check and readers

Tejun Heo (1):
      workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONC=
E()s

Tommi Rantala (2):
      sctp: fix memory leak in sctp_datamsg_from_user() when copy from user=
 space fails
      sctp: fix -ENOMEM result with invalid user space pointer in sendto() =
syscall

Zhang Rui (1):
      ACPI / video: ignore BIOS initial backlight value for HP Folio 13-2000

Zheng Liu (1):
      perf test: fix a build error on builtin-test

li.rui27@zte.com.cn (1):
      USB: add new zte 3g-dongle's pid to option.c

nikolay@redhat.com (1):
      bonding: fix race condition in bonding_store_slaves_active


--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQz3QpAAoJEDjbvchgkmk+hWgP/1mQedvdSPPaMv61DfKr7JOh
c/d4Cy0x/ARA91cM/Z0CrccfwR6FUWAVzsHgF4Cksr6DgDBDY25rIFfHrB/xpJ/3
vJi/cM+go2Filo1lN9opeR5M+gVuBMBweZArvRHPqMYqYcckKWwEUWG8GAwmBc6w
eGWS9Mc+FAvatQcfMqvSsQRrBwn4CbB2KByWuUcHP0uEdu0HC3f5wzfLT/L2af26
6z3XvtIDG/EdzaGkyGO47enQ1BRh0OQKZVHnD3hyjShGRBOG1qkpKnEnfwhdoQlc
8kh9ZoMakQZcbb9aZhhtkBETbsAvim9cuIQbalQukxhIQMg8mb2/7VIaM/a9R7GE
Gp3+WXYt3M1IWPImvGejLA7xe+pO0H2MzfYfqCiybQY+UdwSTReIhpuWZzpXw+2q
gpvljNXU6p3DBsMPmScfRmlfmYfd2DLPwY8Z13/aueWo9lErgc+iGOhOOlv22tTf
W8Cv7+hqKKeBnvkgSDr2tUYwkNzWMT6sBqVy2+M4fojXvIgHolkaDpRDg4bfQgF0
k6qFyxN0KiBIMBndAifWzL5ttRhoiwmVetvlxuLGl+gr1LKIypkbni98vymTg9Pl
2MCB6qPaU7kuRYYpXao6qelM6iICIj6U9SN/ZCnFTdDRO6SG/bZK7PE8uH1MXrTG
CZhv1OcPOrxn61ZgHcTH
=8FaI
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
