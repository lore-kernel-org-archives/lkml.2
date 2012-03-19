Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031925Ab2CSQSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:18:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63408 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161460Ab2CSQSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:18:42 -0400
Date: Mon, 19 Mar 2012 09:18:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.12
Message-ID: <20120319161838.GA10561@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.12 kernel.

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

 Documentation/hwmon/w83627ehf                   |    2=20
 Documentation/hwmon/zl6100                      |   14 ++--
 Makefile                                        |    2=20
 arch/sparc/Makefile                             |    2=20
 arch/x86/kernel/cpu/perf_event_intel.c          |   17 +++--
 arch/x86/lib/delay.c                            |    4 -
 block/genhd.c                                   |   42 ++++++++------
 drivers/block/sx8.c                             |    2=20
 drivers/hwmon/pmbus/zl6100.c                    |   11 +--
 drivers/hwmon/w83627ehf.c                       |   17 ++---
 drivers/i2c/algos/i2c-algo-bit.c                |    8 ++
 drivers/media/video/omap3isp/ispccdc.c          |    3 -
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    4 -
 drivers/net/ethernet/packetengines/Kconfig      |    1=20
 drivers/net/ethernet/realtek/r8169.c            |    8 ++
 drivers/net/ethernet/sfc/rx.c                   |    4 -
 drivers/net/ppp/ppp_generic.c                   |   23 ++++++++
 drivers/net/usb/asix.c                          |    4 +
 drivers/net/vmxnet3/vmxnet3_drv.c               |    7 --
 drivers/net/vmxnet3/vmxnet3_int.h               |    4 -
 drivers/net/wireless/rt2x00/rt2x00dev.c         |    6 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c         |    9 +++
 drivers/net/wireless/rt2x00/rt2x00queue.c       |    3 +
 drivers/pci/pcie/aspm.c                         |    3 +
 drivers/platform/x86/acer-wmi.c                 |   30 ++++++++++
 drivers/rapidio/devices/tsi721.h                |   30 +++++-----
 drivers/regulator/tps6524x-regulator.c          |    2=20
 drivers/target/iscsi/iscsi_target.c             |    2=20
 drivers/target/target_core_pr.c                 |   34 +++++++----
 drivers/target/target_core_transport.c          |    1=20
 fs/aio.c                                        |   22 +++----
 fs/block_dev.c                                  |   16 ++++-
 fs/cifs/file.c                                  |   69 +++++++++++++++++++=
-----
 fs/namei.c                                      |    4 -
 fs/partitions/check.c                           |   48 +++++++++++++---
 include/linux/genhd.h                           |    1=20
 include/linux/skbuff.h                          |   10 +++
 include/linux/workqueue.h                       |    4 +
 kernel/workqueue.c                              |    7 ++
 net/bridge/br_multicast.c                       |    7 +-
 net/core/neighbour.c                            |    2=20
 net/ipv4/tcp_input.c                            |   23 +++++---
 net/ipv4/xfrm4_mode_beet.c                      |    5 -
 net/ipv4/xfrm4_mode_tunnel.c                    |    6 --
 net/ipv6/addrconf.c                             |    4 +
 net/ipv6/xfrm6_mode_beet.c                      |    6 --
 net/ipv6/xfrm6_mode_tunnel.c                    |    6 --
 sound/pci/hda/patch_realtek.c                   |    8 ++
 sound/soc/samsung/neo1973_wm8753.c              |    4 -
 49 files changed, 377 insertions(+), 174 deletions(-)

Al Viro (2):
      aio: fix io_setup/io_destroy race
      aio: fix the "too late munmap()" race

Alan Stern (1):
      Block: use a freezable workqueue for disk-event polling

Alexandre Bounine (1):
      rapidio/tsi721: fix bug in register offset definitions

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
      atl1c: dont use highprio tx queue
      ipsec: be careful of non existing mac headers

Greg Kroah-Hartman (1):
      Linux 3.2.12

Guenter Roeck (3):
      hwmon: (w83627ehf) Fix writing into fan_stop_time for NCT6775F/NCT677=
6F
      hwmon: (w83627ehf) Fix memory leak in probe function
      hwmon: (zl6100) Enable interval between chip accesses for all chips

Ike Panhc (1):
      acer-wmi: No wifi rfkill on Lenovo machines

Jean Delvare (1):
      hwmon: (w83627ehf) Fix temp2 source for W83627UHG

Joerg Neikes (1):
      usb: asix: Patch for Sitecom LN-031

Jun'ichi Nomura (1):
      block: Fix NULL pointer dereference in sd_revalidate_disk

Kailang Yang (1):
      ALSA: hda/realtek - Apply the coef-setup only to ALC269VB

Laurent Pinchart (1):
      omap3isp: ccdc: Fix crash in HS/VS interrupt handler

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

Nicholas Bellinger (2):
      iscsi-target: Fix reservation conflict -EBUSY response handling bug
      target: Fix compatible reservation handling (CRH=3D1) with legacy RES=
ERVE/RELEASE

Pavel Shilovsky (1):
      CIFS: Do not kmalloc under the flocks spinlock

Peter Zijlstra (1):
      perf/x86: Fix local vs remote memory events for NHM/WSM

Shreyas Bhatewara (1):
      vmxnet3: Fix transport header size

Stanislaw Gruszka (2):
      rt2x00: fix random stalls
      block: fix __blkdev_get and add_disk race condition

Thomas Gleixner (1):
      x86: Derandom delay_tsc for 64 bit

Ulrich Weber (1):
      bridge: check return value of ipv6_dev_get_saddr()

Ville Syrjala (1):
      i2c-algo-bit: Fix spurious SCL timeouts under heavy load

fran=E7ois romieu (1):
      r8169: corrupted IP fragments fix for large mtu.

stephen hemminger (1):
      packetengines: fix config default


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPZ1xeAAoJEDjbvchgkmk+7b4QALhpBcLRFUkeBxKwYycRhW/4
lmKadTdWEyOmse9djaZgPzZ7DIb7zYqCaepz+Ki5cTyjoVAn7Ocorz366iIKP6kO
XCg8lCx8mO85bRBteMchMuAg0PwbRYbprC/BeX+qrlZfO7Ls+wlHcmROPA0u64Vp
pKvJRk8s36Oz+9V2M/Qo0LPuIlCNITXSkcjrFTxZd3A8rqoJ63S5+kc9yWPQmMxz
DLf7myeRh0qUjdkxfEv1GyXd28/SHjTTNrTEfAtMtZoobSg/1L3jtqnyJL7Vzb30
FXTu08hGj2+i0JJDpPsFM54ZS+PSmtvtN0KC0Y2EJR4oGKtLYKG9vuKx8r6RWvZd
YEFQ15cVhnN1nTUYI9r7rAT3b3zFsCjoLWBtDtq221oL4nB99y99zdqozjrXfSxb
hgn+bkXniVMlPg84e6kGuaFtKfgX+p7HHaqCdQB7yVTJhf7qvAmc9h8avwOgpQE6
icgxWvkFw7JAHctiQqmIK6m7sITshXbaI3M7EmCNpMSPtVtgEBHUZvbDBQ9RubDt
kdI+vKj7m04WBUrsRQFXoT6tbyzM6jJDRL1pHdHmGTHKJHTEYN8HAhzrt5fJkwVi
0DeVPJ2Gy93Jw76cjX4vU59VeegWvdpRvIPjcQhMc5nonURgUTngqHJhkvo0B4xl
b5/eQ9DWIkmY/2zFUtOH
=pnls
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
