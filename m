Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2BMTkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:40:06 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38132 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078Ab2BMTkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:40:01 -0500
X-Sasl-enc: XMoBe/HiIybcKc6QbUOOs05Z4LWAP1FHCL4seBnEwcNM 1329162000
Date: Mon, 13 Feb 2012 11:31:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.57
Message-ID: <20120213193111.GA29302@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.32.57 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                              |    2 +-
 drivers/gpu/drm/i915/intel_tv.c       |   16 ++++++++--------
 drivers/infiniband/hw/mlx4/mad.c      |    7 ++-----
 drivers/misc/cb710/core.c             |    1 +
 drivers/staging/android/binder.c      |   13 +++++++++++--
 drivers/staging/asus_oled/asus_oled.c |   10 ++++++++--
 drivers/usb/gadget/f_loopback.c       |    2 +-
 drivers/usb/host/pci-quirks.c         |    6 ++++++
 drivers/usb/serial/ftdi_sio.c         |    1 +
 drivers/usb/serial/ftdi_sio_ids.h     |    7 +++++++
 drivers/video/atmel_lcdfb.c           |    2 +-
 fs/ecryptfs/read_write.c              |    4 ++--
 fs/nfs/nfs4proc.c                     |   29 ++++++++++++++++++++++-------
 fs/nfs/nfs4state.c                    |   19 ++++++++++---------
 fs/udf/super.c                        |    6 ++++++
 include/net/sock.h                    |   15 +--------------
 mm/filemap_xip.c                      |    7 ++++++-
 net/core/skbuff.c                     |   30 ++++++++++++++++++++++++++++++
 net/ipv4/udp.c                        |    4 ++--
 net/sunrpc/xprtsock.c                 |    8 ++------
 20 files changed, 128 insertions(+), 61 deletions(-)

Arve Hj=F8nnev=E5g (2):
      Staging: android: binder: Don't call dump_stack in binder_vma_open
      Staging: android: binder: Fix crashes when sharing a binder file betw=
een processes

Axel Lin (1):
      mmc: cb710 core: Add missing spin_lock_init for irq_lock of struct cb=
710_chip

Bian Naimeng (1):
      rpc client can not deal with ENOSOCK, so translate it into ENOCONN

Carsten Otte (1):
      mm/filemap_xip.c: fix race condition in xip_file_fault()

Eric Dumazet (2):
      net: fix sk_forward_alloc corruptions
      net: sock_queue_err_skb() dont mess with sk_forward_alloc

Greg Kroah-Hartman (1):
      Linux 2.6.32.57

Hubert Feurstein (1):
      atmel_lcdfb: fix usage of CONTRAST_CTR in suspend/resume

Jack Morgenstein (1):
      IB/mlx4: pass SMP vendor-specific attribute MADs to firmware

Jan Kara (1):
      udf: Mark LVID buffer as uptodate before marking it dirty

Jayachandran C (1):
      usb: Skip PCI USB quirk handling for Netlogic XLP

Li Wang (1):
      eCryptfs: Infinite loop due to overflow in ecryptfs_write()

Milan Kocian (1):
      USB: usbserial: add new PID number (0xa951) to the ftdi driver

Pekka Paalanen (1):
      Staging: asus_oled: fix image processing

Rodrigo Vivi (1):
      drm/i915: Fix TV Out refresh rate.

Timo Juhani Lindfors (1):
      usb: gadget: zero: fix bug in loopback autoresume handling

Trond Myklebust (5):
      NFSv4: Fix up the callers of nfs4_state_end_reclaim_reboot
      NFSv4: The state manager shouldn't exit on errors that were handled
      NFSv4: Ensure the state manager handles NFS4ERR_NO_GRACE correctly
      NFSv4: Handle NFS4ERR_GRACE when recovering an expired lease.
      NFSv4: Fix open recovery


--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPOWT/AAoJEDjbvchgkmk+zSIQALHCshos81cDzBcBJmYIFK5W
Y8aqlUXlqBo7ROa7izAfU/q07g2x9rZRX/j9Zwssk6uQ7n2qtuqlMAtVInnqMyjb
m1FH1g7Qv6P/6Xv2N0+NCpa61tyLz7Y5NJUKKrCKV5rK3MQESNFt/TZl45+/hqGQ
GXQRnZ8bZKrwWqJ9Q1lVVewPIvbyaWMAvxKuyfNylH08DnXmu0Yv4J1ZXNov2TTs
OIVCRifAfJ9Sykh011tQhEPhx0NqG2Sm7zJlOqCYwx4sMpmBGcNa/RmOvKw+Ulyz
0g0iIbTd6yUCSKLE4DW04hSb5H0mIA5IGkI9uHG3vNLiP4HNgehMebXDxM76HGmN
zdHbH95EkFIvers4O9aVbDkUExrsl2tRO7pdchO009bZ2QqaXm1wuQ8k9CbUeWUF
LNWiOsITHqT6hCRP5sU+37jMnGSTktpnye+jKkX233e2p8kKFs0UqOA1Jq6LFj7l
Aga/W++NZFiewunfsjSxq3EXwq3IkaZ7zeNQpU0zawHIVskGpeCbbXM8wr0N+SlN
8qrwv0vnk2AA6lF3kzOA53YbhGXbuLsgnaKaJWZMMS53Bhs/TXc04oxDTadOTrst
FyTDspRxaaj/OlT3uwMvqq+6KQseasdRlmjhcMRARzmdCPn34hE1TFoREmZOJ10o
OdZEw+2iH6C9RTEHmIoH
=GM1T
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
