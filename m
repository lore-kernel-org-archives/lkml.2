Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab1LISJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 13:09:03 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51558 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab1LISJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 13:09:02 -0500
X-Sasl-enc: 6G8/8+CvWSSJU7VNsIU3s9k/OhG2dsJvGvOwtQhtBKXj 1323454141
Date: Fri, 9 Dec 2011 10:08:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.50
Message-ID: <20111209180842.GA11218@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.32.50 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                             |    2=20
 arch/arm/Kconfig                     |   12 +++++
 arch/arm/kernel/process.c            |    3 +
 arch/x86/include/asm/timer.h         |   23 ++++++++++
 arch/x86/kernel/mpparse.c            |    2=20
 arch/x86/oprofile/init.c             |    7 ++-
 drivers/i2c/algos/i2c-algo-bit.c     |    4 -
 drivers/net/wireless/p54/p54spi.c    |    5 +-
 drivers/pci/hotplug/shpchp_core.c    |    4 -
 drivers/pci/hotplug/shpchp_hpc.c     |    4 -
 drivers/scsi/scsi_lib.c              |   12 +++--
 drivers/staging/comedi/comedi_fops.c |   75 +++++++++++++++++++++++++-----=
-----
 drivers/staging/usbip/vhci_rx.c      |   10 ++--
 drivers/usb/host/whci/qset.c         |    2=20
 drivers/usb/serial/ftdi_sio.c        |    1=20
 drivers/usb/serial/ftdi_sio_ids.h    |    1=20
 drivers/usb/serial/option.c          |    1=20
 drivers/usb/storage/unusual_devs.h   |    7 +++
 fs/cifs/misc.c                       |    3 +
 fs/ecryptfs/crypto.c                 |    4 -
 kernel/irq/manage.c                  |    5 +-
 kernel/time/clockevents.c            |    1=20
 kernel/time/tick-broadcast.c         |    2=20
 kernel/time/timekeeping.c            |    4 +
 net/core/dev.c                       |    1=20
 net/sunrpc/xprtsock.c                |    3 -
 net/wireless/nl80211.c               |    4 -
 sound/pci/lx6464es/lx_core.c         |   16 +++++--
 28 files changed, 164 insertions(+), 54 deletions(-)

Bart Westgeest (1):
      staging: usbip: bugfix for deadlock

Benjamin Poirier (1):
      gro: reset vlan_tci on reuse

Bernd Porr (1):
      staging: comedi: fix oops for USB DAQ devices.

Bjorn Helgaas (2):
      PCI hotplug: shpchp: don't blindly claim non-AMD 0x7450 device IDs
      x86/mpparse: Account for bus types other than ISA and PCI

Dan Carpenter (1):
      USB: whci-hcd: fix endian conversion in qset_clear()

Eliad Peller (1):
      nl80211: fix MAC address validation

Federico Vaga (1):
      Staging: comedi: fix signal handling in read and write

Greg Kroah-Hartman (1):
      Linux 2.6.32.50

Hannes Reinecke (1):
      SCSI: Silencing 'killing requests for dead queue'

Hector Palacios (1):
      timekeeping: add arch_offset hook to ktime_get functions

Ido Yariv (1):
      genirq: Fix race condition when stopping the irq thread

Jeffrey (Sheng-Hui) Chu (1):
      i2c-algo-bit: Generate correct i2c address sequence for 10-bit target

Jiri Slaby (1):
      SCSI: scsi_lib: fix potential NULL dereference

Marcin Ko=C5=9Bcielnicki (1):
      usb: ftdi_sio: add PID for Propox ISPcable III

Michael B=C3=BCsch (2):
      p54spi: Add missing spin_lock_init
      p54spi: Fix workqueue deadlock

Qinglin Ye (1):
      USB: usb-storage: unusual_devs entry for Kingston DT 101 G2

Robert Richter (1):
      oprofile, x86: Fix crash when unloading module (nmi timer mode)

Salman Qazi (1):
      sched, x86: Avoid unnecessary overflow in sched_clock

Suresh Jayaraman (1):
      cifs: fix cifs stable patch cifs-fix-oplock-break-handling-try-2.patch

Thomas Gleixner (2):
      tick-broadcast: Stop active broadcast device when replacing it
      clockevents: Set noop handler in clockevents_exchange_device()

Tim Blechmann (1):
      ALSA: lx6464es - fix device communication via command bus

Trond Myklebust (1):
      SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared

Tyler Hicks (1):
      eCryptfs: Extend array bounds for all filename chars

Veli-Pekka Peltola (1):
      usb: option: add SIMCom SIM5218

Will Deacon (1):
      ARM: 7161/1: errata: no automatic store buffer drain


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO4k6qAAoJEDjbvchgkmk+jWMP/2nXju5C0UTNMiKANjJHNPYg
ULsF0LmXzIJ+kHv3SJw2BRxGq3A7JegO/thG2j/CvAQvA3FJJ4MGAC22A6K6bSXt
4e6CocAWcy6W0Aik45JdNw7w8/8UzdlddBrephym5vFGkKGdl2XX0QwbM6V3u22X
jLARNcFMVNrvKOUpg8eh1SmTtidj2HUDBoCz5SB2fnejwbnAJeR4Mya0jiz0yUuM
mdjHsJP1mAXJm6L4xaWYRbBPmMolvU1gs0XBrQPOmjKqr7YwvOzu6DwBgDSehCP6
QY6vgD35Oj82YSKF9mgD67ZYgUwkPmtPLL1cUYy0MsBpAhas13ySNmm2uVKkzy/R
t1Vn9cFKgtfUFI8HtjxhvkqVGlzhrQAGvxbq+1y8EG7luUfGebk0EQmzA98Kk1KZ
0QuByKz4iH+YORiW3TbGDz1Z+eHLHQ9USM7nm/DW38mNIMs6A7Y58twExp6bl9Tf
EuHsF7NNDEhjqChQ0WqflXHW/uFSHEGDFsMv5RCzu0dgsp05xXTShUcdOFtdjKWW
9VHYf4k2i5GuI2P21qiqiHAqCEiz5U2dFEVEsnamWVDIfgJsFbtNbDqXnV7s+xDB
+Z8UPjFeEKXyd9YjjziSQPf2r2zXSLfnYo2x+yvlrP2O9hqHQ5QgNTtrC5e6/a6W
h/VLsTXToO7BFCSRNesW
=hpjc
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
