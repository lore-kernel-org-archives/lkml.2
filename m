Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab2BTWO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 17:14:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53753 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2BTWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 17:14:24 -0500
Date: Mon, 20 Feb 2012 14:13:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.7
Message-ID: <20120220221317.GA21208@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.7 kernel.

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

 Makefile                                       |    2=20
 arch/x86/pci/xen.c                             |    2=20
 crypto/sha512_generic.c                        |   83 ++++++--------
 drivers/gpu/drm/i915/intel_dp.c                |   20 ---
 drivers/gpu/drm/i915/intel_lvds.c              |    8 +
 drivers/hwmon/f75375s.c                        |    4=20
 drivers/mmc/host/atmel-mci.c                   |    3=20
 drivers/mmc/host/dw_mmc.c                      |  144 +++++++++++++-------=
-----
 drivers/net/ethernet/intel/igb/igb_main.c      |    3=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    3=20
 drivers/net/ethernet/toshiba/Kconfig           |    2=20
 drivers/net/wireless/ath/ath9k/hw.c            |    7 -
 drivers/net/wireless/ath/ath9k/init.c          |    9 -
 drivers/net/wireless/ath/ath9k/recv.c          |    8 +
 fs/cifs/connect.c                              |    7 -
 fs/cifs/dir.c                                  |    2=20
 fs/fs-writeback.c                              |   16 +-
 include/linux/bitops.h                         |   20 +++
 include/linux/mmc/dw_mmc.h                     |    6 -
 include/linux/proportions.h                    |    4=20
 include/trace/events/writeback.h               |    7 -
 kernel/relay.c                                 |   10 +
 mm/backing-dev.c                               |   25 +++-
 net/mac80211/rx.c                              |    2=20
 sound/pci/hda/patch_realtek.c                  |   23 +++
 sound/pci/hda/patch_via.c                      |    3=20
 sound/pci/intel8x0.c                           |    6 +
 tools/perf/bench/mem-memcpy-x86-64-asm.S       |    6 +
 tools/perf/util/evsel.c                        |    1=20
 29 files changed, 268 insertions(+), 168 deletions(-)

Alexey Dobriyan (1):
      crypto: sha512 - use standard ror64()

Atsushi Nemoto (1):
      net: enable TC35815 for MIPS again

Dan Carpenter (1):
      relay: prevent integer overflow in relay_open()

Daniel T Chen (1):
      ALSA: intel8x0: Fix default inaudible sound on Gateway M520

Daniel Vetter (1):
      drm/i915: no lvds quirk for AOpen MP45

Eliad Peller (1):
      mac80211: timeout a single frame in the rx reorder buffer

Felix Fietkau (2):
      ath9k: fix a WEP crypto related regression
      ath9k_hw: fix a RTS/CTS timeout regression

Greg Kroah-Hartman (1):
      Linux 3.2.7

Greg Rose (2):
      ixgbe: fix vf lookup
      igb: fix vf lookup

Herbert Xu (2):
      crypto: sha512 - Use binary and instead of modulus
      crypto: sha512 - Avoid stack bloat on i386

Jeff Layton (2):
      cifs: request oplock when doing open on lookup
      cifs: don't return error from standard_receive3 after marking respons=
e malformed

Jiri Olsa (1):
      perf tools: Fix perf stack to non executable on x86_64

Keith Packard (1):
      drm/i915: Force explicit bpp selection for intel_dp_link_required

Ludovic Desroches (1):
      mmc: atmel-mci: save and restore sdioirq when soft reset is performed

Mohammed Shafi Shajakhan (1):
      ath9k: Fix kernel panic during driver initilization

Naveen N. Rao (1):
      perf evsel: Fix an issue where perf report fails to show the proper p=
ercentage

Nikolaus Schulz (2):
      hwmon: (f75375s) Fix bit shifting in f75375_write16
      hwmon: (f75375s) Fix automatic pwm mode setting for F75373 & F75375

Rabin Vincent (1):
      backing-dev: fix wakeup timer races with bdi_unregister()

Seungwon Jeon (1):
      mmc: dw_mmc: Fix PIO mode with support of highmem

Stefano Stabellini (1):
      xen pvhvm: do not remap pirqs onto evtchns if !xen_have_vector_callba=
ck

Takashi Iwai (2):
      ALSA: hda - Fix initialization of secondary capture source on VT1705
      ALSA: hda - Fix silent speaker output on Acer Aspire 6935

Wu Fengguang (3):
      lib: proportion: lower PROP_MAX_SHIFT to 32 on 64-bit kernel
      writeback: fix NULL bdi->dev in trace writeback_single_inode
      writeback: fix dereferencing NULL bdi->dev on trace_writeback_queue


--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPQsV9AAoJEDjbvchgkmk+jn0P/1e4USL0A/O985OVcsq7oEDz
IbK3q2obgTB2Tp4s4bKp92flxBBKbNyn2N/EuaXUQDPQg7tYutFmPbXa6Ypvgsdg
FyQ4E/oMqvkQOmMB9TR5sC/d1z/7E5cLVdmbh/53dYqaZvLw3u7jq5s48XkXBktD
eGTysHalilcP+KVZtiNZ04RiT6MpGrJUXo0JEJwXlV/dkS4WOiRbpfyvyQs8YQig
v83v6ucpqLAnAu/ilepLjF8kI3ZQwRjzM4mI4X5VEdYT7DEd2zdYi6G9xljoy07U
WvVhb2Ev51FC3pVn9I/ncImmamlbjNUepmnzyR0F/8FCEWauYfS7eMIbkdNY6kZl
FgARafmm4RlZwR+SlEE7bDTla5FbVetfyAWwaJ/uk4kdMmHmhh71VPtfbck1koSy
K1fi5O47Upin1igVlMhwycKHVPe8Ue4ac9uleVxM0zGi2U0DAAv3inTPyUmwxd7j
a+HO7S1LpnGQIVXLP/LXcmNoANugfumZePcSLrhpZkU2eXvoCl/YDFYMSm9cHVMQ
96Ma5I2L9tLAbBVc/1Ip7FEcPbX02m8n8V1Qe0P9sY1mdMpyD5DNuDPzTbLO0bvQ
ChMasEHIOkO+dkrU10RU/WcTHnaQhMr+N04tKERdINxPJFHdlXjWrEWRpQ+8NbBH
3KnF4xr/iwZ47AXS38p2
=N2Tc
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
