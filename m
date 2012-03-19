Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161971Ab2CSQR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:17:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47671 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032066Ab2CSQRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:17:53 -0400
Date: Mon, 19 Mar 2012 09:17:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.25
Message-ID: <20120319161749.GA4101@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.25 kernel.

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

 Makefile                                  |    2=20
 arch/s390/kernel/setup.c                  |    1=20
 arch/sparc/Makefile                       |    2=20
 arch/x86/lib/delay.c                      |    4=20
 block/genhd.c                             |   42 +++++-----
 drivers/base/core.c                       |    6 -
 drivers/block/sx8.c                       |    2=20
 drivers/firewire/core-cdev.c              |   24 +++++
 drivers/firewire/core-device.c            |   15 ++-
 drivers/hwmon/w83627ehf.c                 |    9 --
 drivers/i2c/algos/i2c-algo-bit.c          |    8 +
 drivers/net/atl1c/atl1c_main.c            |    4=20
 drivers/net/ppp_generic.c                 |   23 +++++
 drivers/net/sfc/rx.c                      |    4=20
 drivers/net/usb/asix.c                    |    4=20
 drivers/net/vmxnet3/vmxnet3_drv.c         |    7 -
 drivers/net/vmxnet3/vmxnet3_int.h         |    4=20
 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 +
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    9 ++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3=20
 drivers/pci/pcie/aspm.c                   |    3=20
 drivers/platform/x86/acer-wmi.c           |  121 +++++++++++++++++++++++++=
-----
 drivers/regulator/tps6524x-regulator.c    |    2=20
 drivers/s390/char/fs3270.c                |    1=20
 fs/aio.c                                  |   22 ++---
 fs/block_dev.c                            |   16 ++-
 fs/namei.c                                |    4=20
 fs/partitions/check.c                     |   48 +++++++++--
 include/linux/genhd.h                     |    1=20
 include/linux/skbuff.h                    |   10 ++
 include/linux/workqueue.h                 |    4=20
 kernel/workqueue.c                        |    7 +
 net/bridge/br_multicast.c                 |    7 +
 net/core/neighbour.c                      |    2=20
 net/ipv4/tcp_input.c                      |   23 +++--
 net/ipv4/xfrm4_mode_beet.c                |    5 -
 net/ipv4/xfrm4_mode_tunnel.c              |    6 -
 net/ipv6/addrconf.c                       |    4=20
 net/ipv6/xfrm6_mode_beet.c                |    6 -
 net/ipv6/xfrm6_mode_tunnel.c              |    6 -
 sound/soc/samsung/neo1973_wm8753.c        |    4=20
 41 files changed, 350 insertions(+), 131 deletions(-)

Al Viro (2):
      aio: fix io_setup/io_destroy race
      aio: fix the "too late munmap()" race

Alan Stern (2):
      PM / Driver core: leave runtime PM enabled during system shutdown
      Block: use a freezable workqueue for disk-event polling

Axel Lin (1):
      regulator: Fix setting selector in tps6524x set_voltage function

Ben Hutchings (1):
      sfc: Fix assignment of ip_summed for pre-allocated skbs

Ben McKeegan (1):
      ppp: fix 'ppp_mp_reconstruct bad seq' errors

Dan Carpenter (1):
      block, sx8: fix pointer math issue getting fw version

David S. Miller (1):
      sparc32: Add -Av8 to assembler command line.

Denis 'GNUtoo' Carikli (1):
      ASoC: neo1973: fix neo1973 wm8753 initialization

Eric Dumazet (2):
      ipsec: be careful of non existing mac headers
      atl1c: dont use highprio tx queue

Greg Kroah-Hartman (1):
      Linux 3.0.25

Guenter Roeck (2):
      hwmon: (w83627ehf) Fix writing into fan_stop_time for NCT6775F/NCT677=
6F
      hwmon: (w83627ehf) Fix memory leak in probe function

Heiko Carstens (1):
      compat: Re-add missing asm/compat.h include to fix compile=A0breakage=
 on s390

Ike Panhc (1):
      acer-wmi: No wifi rfkill on Lenovo machines

Jiri Slaby (1):
      compat: Re-add missing asm/compat.h include to fix compile breakage o=
n s390

Joerg Neikes (1):
      usb: asix: Patch for Sitecom LN-031

Jun'ichi Nomura (1):
      block: Fix NULL pointer dereference in sd_revalidate_disk

Lee, Chun-Yi (2):
      acer-wmi: support Lenovo ideapad S205 wifi switch
      acer-wmi: check wireless capability flag before register rfkill

Li Wei (1):
      IPv6: Fix not join all-router mcast group when forwarding set.

Matthew Garrett (1):
      PCI: ignore pre-1.1 ASPM quirking when ASPM is disabled

Michel Machado (1):
      neighbour: Fixed race condition at tbl->nht

Miklos Szeredi (2):
      vfs: fix return value from do_last()
      vfs: fix double put after complete_walk()

Neal Cardwell (3):
      tcp: fix false reordering signal in tcp_shifted_skb
      tcp: don't fragment SACKed skbs in tcp_mark_head_lost()
      tcp: fix tcp_shift_skb_data() to not shift SACKed data below snd_una

Seth Forshee (1):
      acer-wmi: Add wireless quirk for Lenovo 3000 N200

Shreyas Bhatewara (1):
      vmxnet3: Fix transport header size

Stanislaw Gruszka (2):
      rt2x00: fix random stalls
      block: fix __blkdev_get and add_disk race condition

Stefan Richter (2):
      firewire: cdev: fix 32 bit userland on 64 bit kernel compat corner ca=
ses
      firewire: core: handle ack_busy when fetching the Config ROM

Thomas Gleixner (1):
      x86: Derandom delay_tsc for 64 bit

Ulrich Weber (1):
      bridge: check return value of ipv6_dev_get_saddr()

Ville Syrjala (1):
      i2c-algo-bit: Fix spurious SCL timeouts under heavy load


--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPZ1wtAAoJEDjbvchgkmk+o9kP/jr9eimqrQgl2N8NwFH55LH7
9mBaU6m+N/fskux/Bb9JZQ/C5t4QeNpPlypWa6xMTLsoo3LNgZYGNigLwTuuE4Kv
R4Igdy3hJwi+tLkHCQ2q2jCcQSebrKtmm7YchZB2k0ZCZEbbe1aP6cQbfy0GunM0
q92OHPYbidsL5n/Kx4tzorCsUap/CR3rHc0bubOsgOtKxJUEhWn4VFAcoJaC8yZG
lzpgHBlngqYxal6DFlTESczHzuRbnQ7NqGqKUJuk3CLxF7ZOtuNVl4ztXdkaY0Qv
/Fr1N28dhuDBPUJDzzKQBGDoa1AE84NaGT3UZo60ntyTUVJf9e/sTUqjGhqjYeHQ
gUQanmvT+B9wzc9TmWmcvBtX27VCTmoPBDmahwampvAaNULgkD/S7oNuF1kEGTVy
iFhZFadBGVrtssFGVxo23hudly/YYGIWoehdGPRnTnIi56cGlbPJYgaMht3K7cCE
+LVO819Vu858pyjCS54oJZGdXitPUxKCf1ljkhPbuKWwJpArRNfUCBaQShGqmuHy
as/SfGwB68dSIVL7NFmEygMZb38FwpeHbwux6/NoTrllbTlxUa+55M1DvEG20tI/
wOkWIg/D4CPNUUM6dnG+zQlHK6mW8P+lua5nrGF2fptTbHl2YFOL0tl1y5SXIssF
2xqiqWBYLm1+7jVC1IWZ
=OdQs
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
