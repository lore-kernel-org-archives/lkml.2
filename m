Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab2HTNEj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:04:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755129Ab2HTNEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:04:35 -0400
Message-ID: <1345467862.22400.139.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.28
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Mon, 20 Aug 2012 14:04:22 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-D50e6QLHJIk/O867jLv7"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D50e6QLHJIk/O867jLv7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.28 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Makefile                                      |    2 +-
 arch/arm/configs/mxs_defconfig                |    1 -
 arch/arm/mach-pxa/raumfeld.c                  |    2 +-
 arch/s390/kernel/compat_linux.c               |    2 -
 arch/s390/kernel/compat_wrapper.S             |    4 +-
 arch/x86/kvm/vmx.c                            |    1 +
 drivers/gpu/drm/i915/i915_drv.h               |    7 +--
 drivers/gpu/drm/i915/i915_gem.c               |   23 ++++++++
 drivers/gpu/drm/i915/intel_ringbuffer.c       |   37 +++++--------
 drivers/gpu/drm/radeon/evergreen.c            |   71 ++++-----------------=
----
 drivers/gpu/drm/radeon/ni.c                   |   14 +++--
 drivers/gpu/drm/radeon/radeon_asic.h          |    8 +--
 drivers/gpu/drm/radeon/rv515.c                |   13 -----
 drivers/input/touchscreen/eeti_ts.c           |   21 +++++---
 drivers/mfd/ezx-pcap.c                        |    2 +-
 drivers/net/caif/caif_serial.c                |    3 ++
 drivers/net/ethernet/broadcom/bnx2.c          |    6 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c |   10 ++--
 drivers/net/ethernet/intel/e1000e/82571.c     |    4 +-
 drivers/net/tun.c                             |    6 ++-
 drivers/net/usb/kaweth.c                      |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    1 +
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 drivers/net/wireless/ath/ath9k/pci.c          |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |   13 +++--
 drivers/net/wireless/rt2x00/rt61pci.c         |    3 +-
 drivers/net/wireless/rtlwifi/usb.c            |   14 +++--
 drivers/net/wireless/rtlwifi/wifi.h           |    1 +
 fs/hfsplus/wrapper.c                          |    2 +-
 include/linux/input/eeti_ts.h                 |    1 +
 include/linux/mfd/ezx-pcap.h                  |    1 +
 net/caif/caif_dev.c                           |    2 +-
 net/core/rtnetlink.c                          |    8 ++-
 net/ipv4/cipso_ipv4.c                         |    6 ++-
 net/ipv4/tcp.c                                |    5 +-
 net/ipv4/tcp_input.c                          |    4 +-
 net/mac80211/mesh.c                           |    1 +
 net/sched/sch_sfb.c                           |    2 +
 net/sctp/input.c                              |    7 +--
 net/sctp/socket.c                             |   12 ++++-
 net/wanrouter/wanmain.c                       |   51 ++++++++----------
 net/wireless/core.c                           |    5 ++
 net/wireless/core.h                           |    1 +
 net/wireless/util.c                           |    2 +-
 sound/pci/hda/patch_conexant.c                |    1 -
 sound/pci/hda/patch_realtek.c                 |    7 ++-
 46 files changed, 193 insertions(+), 198 deletions(-)

Alan Cox (3):
      sch_sfb: Fix missing NULL check
      caif: fix NULL pointer check
      wanmain: comparing array with NULL

Alex Deucher (2):
      drm/radeon: fix bank tiling parameters on evergreen
      drm/radeon: fix bank tiling parameters on cayman

Arnd Bergmann (2):
      ARM: pxa: remove irq_to_gpio from ezx-pcap driver
      Input: eeti_ts: pass gpio value instead of IRQ

Ben Hutchings (1):
      Linux 3.2.28

Dan Carpenter (1):
      USB: kaweth.c: use GFP_ATOMIC under spin_lock

Daniel Drake (1):
      cfg80211: process pending events when unregistering net device

Daniel Vetter (2):
      drm/i915: fixup seqno allocation logic for lazy_request
      drm/i915: correctly order the ring init sequence

David Henningsson (2):
      ALSA: hda - remove quirk for Dell Vostro 1015
      ALSA: hda - Fix double quirk for Quanta FL1 / Lenovo Ideapad

Dean Nelson (1):
      e1000: add dropped DMA receive enable back in for WoL

Felix Kaechele (1):
      ALSA: hda - add dock support for Thinkpad X230

Hangbin Liu (1):
      tcp: Add TCP_USER_TIMEOUT negative value check

Heiko Carstens (2):
      s390/compat: fix compat wrappers for process_vm system calls
      s390/compat: fix mmap compat system calls

Janne Kalliom=C3=A4ki (1):
      hfsplus: fix overflow in sector calculations in hfsplus_submit_bio

Jerome Glisse (1):
      drm/radeon: do not reenable crtc after moving vram start address

Jiri Benc (1):
      net: fix rtnetlink IFF_PROMISC and IFF_ALLMULTI handling

Jiri Kosina (1):
      tcp: perform DMA to userspace only if there is a task waiting for it

Johannes Berg (2):
      mac80211: cancel mesh path timer
      iwlwifi: disable greenfield transmissions as a workaround

Larry Finger (1):
      rtlwifi: rtl8192cu: Change buffer allocation for synchronous reads

Marek Vasut (1):
      ARM: mxs: Remove MMAP_MIN_ADDR setting from mxs_defconfig

Mathias Krause (1):
      net/tun: fix ioctl() based info leaks

Michael Chan (1):
      bnx2: Fix bug in bnx2_free_tx_skbs().

Mohammed Shafi Shajakhan (1):
      ath9k: Add PID/VID support for AR1111

Neil Horman (1):
      sctp: Fix list corruption resulting from freeing an association on a =
list

Paul Moore (1):
      cipso: don't follow a NULL pointer when setsockopt() is called

Philipp A. Mohrenweiser (1):
      ALSA: hda - add dock support for Thinkpad T430s

Sean Paul (1):
      drm/i915: Add wait_for in init_ring_common

Sjur Br=C3=A6ndeland (1):
      caif: Fix access to freed pernet memory

Stanislaw Gruszka (1):
      rt61pci: fix NULL pointer dereference in config_lna_gain

Stefan Bader (1):
      KVM: VMX: Advertise CPU_BASED_RDPMC_EXITING for nested guests

Tushar Dave (1):
      e1000e: NIC goes up and immediately goes down



--=-D50e6QLHJIk/O867jLv7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUDI11ue/yOyVhhEJAQpU3w//Tp9eWYiul4M/qHd7xU76O+zJ1eZVYABe
YuliamtYS8K5Z3TmJaNrUdCyRi0y2onNF4XHrdFrivcPx2rm5282ME8J/Fz1nHz1
akwNUiRvQeZ/jwLbymx6uaKAzHwG/4tfbYmQAXGp8K5geB99ySSiqOKgv2QJ9G+e
+VPu1Uudi86Nr9lmRsrfSK1wtiINw2/KQTndQbx2w8zmD/djAXIkW5fnn4Qwrkc0
Ob9ePAoX45mQ07q1t5rRtUqTKz0Jt9jYlG31N3UlbMsUkeujOLK5GzOlz0S+n1OB
XbzvAnziV++m9iicBiaIhrM0hZXAku4KAqaYDw4eBUSMCYb0NxF1EVPwpsYYQWnC
kDp7kSQO7WVyLsVI1EBAg26pW0G1rdShv8AtcR2stkkZHALPKh6ajelkez01pL3w
3YdSw9nwz7rywgtPIJPGhEI62qnRjL4FRxT4P3Jicrkxd3REdxY8J0PMj0ioDHds
XF7mB0O+9DqvkvMZv/XYywuQ0yzGzsxC++y/adN3KeS0DbLbxtI7kxLE6fh7YxdO
hSdFMLGa6FrENEb7hkJn4ozcvUAfhPK6Re1HzSD/6cREDz3qceQhalzg2tfFCtPi
rgHPLlCyydDWENgnUV3ZLQc9SdS/acoDRivNRu6jFGZg+wybGsV1B/WGbpnO2iIw
GR8ZG7dx2Qw=
=YaW1
-----END PGP SIGNATURE-----

--=-D50e6QLHJIk/O867jLv7--
