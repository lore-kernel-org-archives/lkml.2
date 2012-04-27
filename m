Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837Ab2D0RPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:15:02 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:33409 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760780Ab2D0RO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:14:59 -0400
Date: Fri, 27 Apr 2012 10:14:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.30
Message-ID: <20120427171455.GA16222@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.30 kernel.

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

 Makefile                                   |    2=20
 crypto/sha512_generic.c                    |    2=20
 drivers/bluetooth/ath3k.c                  |    2=20
 drivers/bluetooth/btusb.c                  |    1=20
 drivers/media/rc/winbond-cir.c             |    1=20
 drivers/net/8139cp.c                       |   10 ++-
 drivers/net/atlx/atl1.c                    |   12 +---
 drivers/net/atlx/atl1.h                    |    3 -
 drivers/net/atlx/atlx.c                    |    2=20
 drivers/net/bonding/bond_main.c            |    6 +-
 drivers/net/davinci_mdio.c                 |    5 +
 drivers/net/dummy.c                        |    6 +-
 drivers/net/ks8851_mll.c                   |    2=20
 drivers/net/ksz884x.c                      |    2=20
 drivers/net/ppp_generic.c                  |    3 -
 drivers/net/smsc911x.c                     |   14 +----
 drivers/net/usb/smsc75xx.c                 |    1=20
 drivers/net/wimax/i2400m/netdev.c          |    3 -
 drivers/net/wireless/rt2x00/rt2800usb.c    |   35 ++++++------
 drivers/pci/quirks.c                       |   34 ++++++++++++
 drivers/spi/spi.c                          |    2=20
 drivers/tty/amiserial.c                    |    4 +
 drivers/tty/serial/clps711x.c              |   14 ++---
 drivers/tty/serial/pch_uart.c              |    4 +
 drivers/usb/core/hub.c                     |    3 -
 drivers/usb/core/message.c                 |    6 +-
 drivers/usb/gadget/f_fs.c                  |    2=20
 drivers/usb/host/ehci-hcd.c                |    7 ++
 drivers/usb/misc/yurex.c                   |   10 +--
 drivers/usb/musb/omap2430.c                |    9 +--
 drivers/usb/serial/cp210x.c                |    9 ++-
 drivers/usb/serial/sierra.c                |    6 +-
 drivers/uwb/hwa-rc.c                       |    3 -
 drivers/uwb/neh.c                          |   12 +++-
 drivers/xen/gntdev.c                       |    2=20
 drivers/xen/xenbus/xenbus_probe_frontend.c |   69 ++++++++++++++++++------
 fs/btrfs/ctree.h                           |    2=20
 fs/eventpoll.c                             |    4 +
 fs/ext4/extents.c                          |    2=20
 fs/jbd2/commit.c                           |    4 -
 fs/lockd/clnt4xdr.c                        |    2=20
 fs/lockd/clntxdr.c                         |    2=20
 fs/nfsd/nfs3xdr.c                          |   22 ++-----
 fs/ocfs2/alloc.c                           |    2=20
 fs/ocfs2/refcounttree.c                    |   12 ++--
 fs/ocfs2/suballoc.c                        |    4 -
 fs/splice.c                                |    5 +
 include/linux/socket.h                     |    2=20
 mm/swap_state.c                            |    2=20
 net/ax25/af_ax25.c                         |    9 +--
 net/bridge/br_multicast.c                  |   81 ------------------------=
-----
 net/bridge/br_private.h                    |    4 -
 net/core/net_namespace.c                   |   33 ++++++-----
 net/core/skbuff.c                          |    4 +
 net/ipv4/tcp.c                             |    2=20
 net/ipv4/tcp_input.c                       |    8 ++
 net/ipv6/mcast.c                           |    2=20
 net/ipv6/tcp_ipv6.c                        |    4 +
 net/netlink/af_netlink.c                   |   24 ++++----
 net/phonet/pep.c                           |    3 +
 net/sched/sch_gred.c                       |    7 --
 net/sctp/socket.c                          |    5 +
 net/socket.c                               |    6 +-
 net/wireless/util.c                        |    2=20
 sound/pci/hda/patch_conexant.c             |    9 ++-
 tools/perf/util/hist.c                     |    4 -
 66 files changed, 314 insertions(+), 266 deletions(-)

AceLan Kao (1):
      Bluetooth: Add support for Atheros [04ca:3005]

Al Viro (8):
      ext4: fix endianness breakage in ext4_split_extent_at()
      nfsd: fix compose_entry_fh() failure exits
      btrfs: btrfs_root_readonly() broken on big-endian
      ocfs2: ->l_next_free_req breakage on big-endian
      ocfs: ->rl_used breakage on big-endian
      ocfs2: ->rl_count endianness breakage
      ocfs2: ->e_leaf_clusters endianness breakage
      lockd: fix the endianness bug

Alan Cox (1):
      rt2800: Add support for the Fujitsu Stylistic Q550

Alan Stern (2):
      EHCI: always clear the STS_FLR status bit
      USB: fix deadlock in bConfigurationValue attribute method

Alexander Shiyan (1):
      ARM: clps711x: serial driver hungs are a result of call disable_irq w=
ithin ISR

Andrzej Pietrasiewicz (1):
      usb: gadget: eliminate NULL pointer dereference (bugfix)

Bj=F8rn Mork (1):
      USB: sierra: avoid QMI/wwan interface on MC77xx

Christian Riesch (1):
      davinci_mdio: Fix MDIO timeout check

Dan Carpenter (1):
      ksz884x: don't copy too much in netdev_set_mac_address()

David H=E4rdeman (1):
      media: rc-core: set mode for winbond-cir

David Ward (1):
      net_sched: gred: Fix oops in gred_dump() in WRED mode

David Woodhouse (1):
      ppp: Don't stop and restart queue on every TX packet

Davide Ciminaghi (1):
      net/ethernet: ks8851_mll fix rx frame buffer overflow

Eduardo Bacchi Kienetz (1):
      rt2800usb: Add new device ID for Belkin

Eric Dumazet (4):
      tcp: allow splice() to build full TSO packets
      netlink: fix races after skb queueing
      net: fix a race in sock_queue_err_skb()
      tcp: fix tcp_grow_window() for large incoming frames

Eric W. Biederman (1):
      net ax25: Reorder ax25_exit to remove races.

Gertjan van Wingerde (3):
      rt2x00: Properly identify rt2800usb devices.
      rt2x00: Add USB device ID of Buffalo WLI-UC-GNHP.
      rt2x00: Identify rt2800usb chipsets.

Greg Kroah-Hartman (1):
      Linux 3.0.30

Herbert Xu (1):
      bridge: Do not send queries on multicast group leaves

Hiroaki SHIMODA (1):
      dummy: Add ndo_uninit().

Hugh Dickins (1):
      mm: fix s390 BUG by __set_page_dirty_no_writeback on swap

Jason Baron (1):
      Don't limit non-nested epoll paths

Jason Wang (1):
      8139cp: set intr mask after its handler is registered

Julia Lawall (1):
      drivers/tty/amiserial.c: add missing tty_unlock

Julian Anastasov (1):
      netns: do not leak net_generic data on failed init

Kent Yoder (1):
      crypto: sha512 - Fix byte counter overflow in SHA-512

Kishon Vijay Abraham I (1):
      usb: musb: omap: fix crash when musb glue (omap) gets initialized

Konrad Rzeszutek Wilk (1):
      xen/xenbus: Add quirk to deal with misconfigured backends.

Laurent Pinchart (1):
      spi: Fix device unregistration when unregistering the bus master

Lukasz Kucharczyk (1):
      cfg80211: fix interface combinations check.

Neal Cardwell (2):
      tcp: fix tcp_rcv_rtt_update() use of an unscaled RTT sample
      tcp: fix TCP_MAXSEG for established IPv6 passive sockets

Oliver Neukum (2):
      uwb: fix use of del_timer_sync() in interrupt
      uwb: fix error handling

Phil Sutter (1):
      wimax: i2400m - prevent a possible kernel bug due to missing fw_name =
string

RongQing.Li (1):
      ipv6: fix array index in ip6_mc_add_src()

Sasha Levin (1):
      phonet: Check input from user before allocating

Shaohua Li (1):
      jbd2: use GFP_NOFS for blkdev_issue_flush

Shubhrajyoti D (1):
      usb: musb: omap: fix the error check for pm_runtime_get_sync

Stefano Stabellini (1):
      xen/gntdev: do not set VM_PFNMAP

Stephane Fillod (1):
      net: usb: smsc75xx: fix mtu

Takashi Iwai (1):
      ALSA: hda/conexant - Don't set HP pin-control bit unconditionally

Thomas Graf (1):
      sctp: Allow struct sctp_event_subscribe to grow without breaking bina=
ries

Thomas Jarosch (1):
      PCI: Add quirk for still enabled interrupts on Intel Sandy Bridge GPUs

Tomoki Sekiyama (2):
      USB: yurex: Remove allocation of coherent buffer for setup-packet buf=
fer
      USB: yurex: Fix missing URB_NO_TRANSFER_DMA_MAP flag in urb

Tomoya MORINAGA (1):
      pch_uart: Fix dma channel unallocated issue

Tony Zelenoff (1):
      atl1: fix kernel panic in case of DMA errors

Veaceslav Falico (1):
      bonding: properly unset current_arp_slave on slave link up

Will Deacon (1):
      net: smsc911x: fix skb handling in receive path

Yuri Matylitski (1):
      USB: serial: cp210x: Fixed usb_control_msg timeout values

Zeev Tarantov (1):
      Perf: fix build breakage


--ibTvN161/egqYuK8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPmtQOAAoJEDjbvchgkmk+6pcP/1AbEFZ4+ORUexChsYccdHlo
naLokZO3Qnlh/FLk/uYKnvvjtULfx38k6eQGUo/jYdOG/ScltiXsIRw0405GwAP6
4TuIRBUwc8iC3t/C4Duo0NOtG9iq2dYOXcr7lbMTfnTfBdvt+GuDxZ6y0bMyqDEi
tIK8a2Bo+aAB1CwLrsulFNO3HVyoqbBkoNiUvfqQVHVNlNk2HeJAasKBEMxCb5LC
50kEorgAClJLf+VjcFdR0e6BPZbx/VR9tFkAEyTC4pq9KxpvCVrCCvSUvDfZY/y0
ER5/yQ7yYTVAv5M6ZGFHZ8Y1l5EzdbB1esf/YW+M9FtgK8S5TEmd8R9DEp/9xWcU
tFkIK+UssIfseyXB4OwSJSrX9CoiF2i/CEjwcM827flGV7N1GkqCNYPrgJ3ChkEZ
9k5ZqZJ4lD4PRR0N6S7BJJor887xZmMb6dDNLRX4/mdVBYZubRWY35gDg+AEo8DO
oOYUqVx+4SzhfUwW03HjhQToUYPp9USM5nrJeadGbuu9ih2DrVO+pUx8q0RS+UT3
MVm8dELsHcVAT6o2XfHhEG1y9gqo08+cDI+/PzeYtbrWuhMLcmhf2t1SuJ93gDKc
19Rm1oGwHtRwQUEKMBlo8nt8hXPajwWcMmABVebtCIh+ei+4XZT6RPRPoRYnCOu+
il9KLh/84fhYZAIxRynd
=D+Gn
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
