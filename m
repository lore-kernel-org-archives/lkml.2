Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab1K0TL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:11:58 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:49594 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753808Ab1K0TKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:10:55 -0500
X-Sasl-enc: 3c+tSedWDqNrKw9Hdhnn0RrDSQumsT8WXC/fyDTZrAsQ 1322421054
Date: Mon, 28 Nov 2011 04:08:34 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.11
Message-ID: <20111127190834.GA11921@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.11 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                    |    2=20
 arch/arm/kernel/head.S                      |    2=20
 drivers/base/core.c                         |    3 +
 drivers/base/node.c                         |   14 +++--
 drivers/gpu/drm/i915/i915_drv.h             |    1=20
 drivers/gpu/drm/i915/i915_reg.h             |    9 +++
 drivers/gpu/drm/i915/i915_suspend.c         |    2=20
 drivers/gpu/drm/i915/intel_display.c        |   42 +++++++++++++++--
 drivers/media/video/saa7164/saa7164-cards.c |   66 +++++++++++++++++++++++=
+++++
 drivers/media/video/saa7164/saa7164-dvb.c   |    1=20
 drivers/media/video/saa7164/saa7164.h       |    1=20
 drivers/misc/Kconfig                        |   15 +++---
 drivers/misc/pch_phub.c                     |   22 ++++++++-
 drivers/misc/spear13xx_pcie_gadget.c        |    2=20
 drivers/net/wireless/libertas/if_spi.c      |    1=20
 drivers/net/wireless/rt2x00/rt2x00.h        |    1=20
 drivers/net/wireless/rt2x00/rt2x00dev.c     |   22 ++++++++-
 drivers/scsi/aacraid/linit.c                |    4 +
 drivers/scsi/hpsa.c                         |    5 ++
 drivers/scsi/scsi_scan.c                    |    6 --
 drivers/tty/hvc/hvc_dcc.c                   |    2=20
 drivers/tty/serial/Kconfig                  |   14 ++---
 drivers/tty/serial/pch_uart.c               |   13 ++++-
 drivers/tty/tty_ldisc.c                     |   30 +++++++++---
 drivers/usb/class/cdc-acm.c                 |    8 ++-
 drivers/usb/core/hub.c                      |    6 ++
 drivers/usb/core/quirks.c                   |   27 +++++++++++
 drivers/usb/host/ehci-sched.c               |   15 ++++--
 drivers/usb/host/pci-quirks.c               |    7 +-
 drivers/usb/host/xhci-mem.c                 |    5 --
 drivers/usb/host/xhci-ring.c                |   13 ++---
 drivers/usb/host/xhci.c                     |   34 +++++++-------
 drivers/usb/serial/ark3116.c                |   10 ++--
 drivers/usb/serial/ftdi_sio.c               |   14 ++++-
 drivers/usb/serial/option.c                 |   23 +++++++++
 drivers/usb/serial/pl2303.c                 |    1=20
 drivers/usb/serial/pl2303.h                 |    4 -
 drivers/usb/storage/protocol.c              |    7 +-
 fs/nfs/dir.c                                |    2=20
 fs/nfs/file.c                               |   32 +++++++++++++
 fs/nfs/inode.c                              |    2=20
 fs/nfs/nfs3proc.c                           |    1=20
 fs/nfs/nfs4proc.c                           |    1=20
 fs/nfs/proc.c                               |    1=20
 fs/xfs/linux-2.6/xfs_buf.h                  |    1=20
 fs/xfs/linux-2.6/xfs_file.c                 |   34 +++++++++++---
 fs/xfs/linux-2.6/xfs_iops.c                 |   16 +++++-
 fs/xfs/linux-2.6/xfs_super.c                |   34 +++-----------
 fs/xfs/quota/xfs_qm.c                       |    3 -
 fs/xfs/xfs_buf_item.c                       |    1=20
 fs/xfs/xfs_mount.c                          |   29 ++++--------
 fs/xfs/xfs_vnodeops.c                       |   14 ++++-
 include/linux/nfs_fs.h                      |    3 +
 include/linux/nfs_xdr.h                     |    1=20
 kernel/irq/spurious.c                       |    2=20
 net/ipv6/ip6_tunnel.c                       |    8 ++-
 net/mac80211/rx.c                           |    9 ++-
 net/mac80211/util.c                         |    4 +
 net/wireless/nl80211.c                      |    3 -
 net/wireless/reg.c                          |    3 +
 60 files changed, 487 insertions(+), 171 deletions(-)

Adam Jackson (1):
      drm/i915/pch: Save/restore PCH_PORT_HOTPLUG across suspend

Alan Stern (3):
      USB: XHCI: resume root hubs when the controller resumes
      USB: workaround for bug in old version of GCC
      usb-storage: Accept 8020i-protocol commands longer than 12 bytes

Andrew Worsley (1):
      USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c

Axel Lin (1):
      pcie-gadget-spear: Add "platform:" prefix for platform modalias

Bart Hartgers (1):
      USB: ark3116 initialisation fix

Carlos Maiolino (1):
      xfs: Fix possible memory corruption in xfs_readlink

Catalin Marinas (1):
      ARM: 7150/1: Allow kernel unaligned accesses on ARMv6+ processors

Christoph Hellwig (5):
      xfs: fix error handling for synchronous writes
      xfs: fix xfs_mark_inode_dirty during umount
      xfs: avoid direct I/O write vs buffered I/O race
      xfs: fix buffer flushing during unmount
      xfs: fix ->write_inode return values

Claudio Scordino (1):
      drivers/base/node.c: fix compilation error with older versions of gcc

Dave Chinner (1):
      xfs: dont serialise direct IO reads on page cache

Don Zickus (2):
      usb, xhci: Clear warm reset change event during init
      usb, xhci: fix lockdep warning on endpoint timeout

Edward Donovan (1):
      genirq: Fix irqfixup, irqpoll regression

Ferenc Wagner (1):
      USB: option: add PID of Huawei E173s 3G modem

Gertjan van Wingerde (1):
      rt2x00: Fix sleep-while-atomic bug in powersaving code.

Greg Kroah-Hartman (1):
      Linux 3.0.11

Havard Skinnemoen (1):
      USB: cdc-acm: Fix disconnect() vs close() race

James Bottomley (1):
      fix WARNING: at drivers/scsi/scsi_lib.c:1704

Jeff Layton (1):
      nfs: when attempting to open a directory, fall back on normal lookup =
(try #5)

Jesper Juhl (1):
      Net, libertas: Resolve memory leak in if_spi_host_to_card()

Jesse Barnes (2):
      drm/i915: fix IVB cursor support
      drm/i915: always set FDI composite sync bit

Jiri Slaby (3):
      TTY: ldisc, allow waiting for ldisc arbitrarily long
      TTY: ldisc, move wait idle to caller
      TTY: ldisc, wait for ldisc infinitely in hangup

Johannes Berg (3):
      mac80211: fix NULL dereference in radiotap code
      mac80211: fix bug in ieee80211_build_probe_req
      nl80211: fix HT capability attribute validation

Josh Boyer (2):
      ip6_tunnel: copy parms.name after register_netdevice
      USB: add quirk for Logitech C600 web cam

Luis R. Rodriguez (1):
      cfg80211: fix bug on regulatory core exit on access to last_request

Matthew Garrett (1):
      hpsa: Disable ASPM

Mitsuo Hayasaka (2):
      xfs: Return -EIO when xfs_vn_getattr() failed
      xfs: use doalloc flag in xfs_qm_dqattach_one()

Peter Chen (1):
      PM / driver core: disable device's runtime PM during shutdown

Sarah Sharp (1):
      xhci: Set slot and ep0 flags for address command.

Stephen Boyd (1):
      tty: hvc_dcc: Fix duplicate character inputs

Thomas Poussevin (1):
      USB: EHCI: fix HUB TT scheduling issue with iso transfer

Tomoya MORINAGA (5):
      pch_phub: Support new device LAPIS Semiconductor ML7831 IOH
      pch_phub: Fix MAC address writing issue for LAPIS ML7831
      pch_uart: Fix hw-flow control issue
      pch_uart: Fix DMA resource leak issue
      pch_uart: Support new device LAPIS Semiconductor ML7831 IOH

Tony Jago (1):
      saa7164: Add support for another HVR2200 hardware revision

Vasily Averin (1):
      aacraid: controller hangs if kernel uses non-default ASPM policy

sordna (1):
      USB: quirks: adding more quirky webcams to avoid squeaky audio

wangyanqing (1):
      USB: serial: pl2303: rm duplicate id

zheng.zhijian@zte.com.cn (1):
      USB: option: release new PID for ZTE 3G modem


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO0oqyAAoJEDjbvchgkmk+OI0QAIH1PhLrPAUS3i7TucjqTnl4
W6WWh516ulOnxEPvxiP59UjAvXdFWHOz6Q8LVr+1VY8WdDxEY7nOi3H7N/0LRRo9
xNkVe0pZmzhhRXxe8KzlWiOzEtumrMIbPoE+TKIaz1xMuFzMpIUxuh3qrE8vb8P8
IOlqXNOR0RhKuTbPLCRljlANuOyzCa+DsrmyY/8eDlsUXfZUVxiy313hNr6OTqGV
DxYsTvvYR/kgwVdXe99rf7YMGCrVZrUd7nHjnfv0MqRQpzn/9w38yHcHyqnC2oGf
DD9TFKAVhh3DuVhZgZ2YPvHi53HYKlB1EtlzCuHpGNGvCHg2gBxRIRG1shp5a0Po
kG+kouiTHWmYt9QmVY41NGr+u7NK2X29FW0r37gKpOUZgGhKsD8vbQnOl9sQMIOv
Ll94/aNhHM31AxE84bsd3+8guyTfGCzoMN+RFGDnQXR89rN4ysXkcFGBN7XIYEl0
l3U0aCNmLWcq+sQIppYep0D66CvcTj7dwRjT79L+OthNgd8aupPcMNEKQc4lvEQ4
JWVo2J7PySph8mPLMuDwyRRGCd+y2Fag1h84u+irtu8lhhXzMozhsLrIC+Y1wAHw
6MtldLBcqyXe1y4JJKIu7QsVR8w9wRmyRqvt9VhJiHMfcgzJLKJ2MI3z7iHbLTHT
KXFoL+pZdnv+OfUUaeUT
=e+gt
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
