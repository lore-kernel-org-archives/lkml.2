Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab2KQVdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:33:22 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33047 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2KQVdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:33:20 -0500
Date: Sat, 17 Nov 2012 13:33:15 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.7
Message-ID: <20121117213315.GA17550@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.7 kernel.

All users of the 3.6 kernel series must upgrade.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                         |    2=20
 arch/x86/xen/mmu.c                               |   21 ++++++
 drivers/gpu/drm/drm_fops.c                       |   44 +++++++++-----
 drivers/gpu/drm/i915/i915_dma.c                  |    3=20
 drivers/gpu/drm/i915/intel_overlay.c             |   14 +++-
 drivers/gpu/drm/i915/intel_sdvo.c                |   62 +++++++++++++------
 drivers/gpu/drm/i915/intel_sdvo_regs.h           |    2=20
 drivers/gpu/drm/radeon/evergreen_cs.c            |    3=20
 drivers/gpu/drm/radeon/evergreend.h              |    4 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c  |    1=20
 drivers/gpu/drm/radeon/si.c                      |    1=20
 drivers/gpu/drm/radeon/sid.h                     |    1=20
 drivers/gpu/drm/udl/udl_drv.h                    |    2=20
 drivers/gpu/drm/udl/udl_fb.c                     |   12 ++-
 drivers/gpu/drm/udl/udl_transfer.c               |    5 -
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c           |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c              |    5 +
 drivers/hwmon/w83627ehf.c                        |    1=20
 drivers/input/touchscreen/tsc40.c                |    1=20
 drivers/mmc/host/sdhci.c                         |   23 ++++---
 drivers/mmc/host/sh_mmcif.c                      |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |    3=20
 drivers/net/ethernet/nxp/lpc_eth.c               |    1=20
 drivers/net/usb/usbnet.c                         |    3=20
 drivers/net/wireless/ath/ath9k/xmit.c            |   10 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c          |    2=20
 drivers/target/iscsi/iscsi_target.c              |    4 -
 drivers/target/iscsi/iscsi_target_core.h         |    1=20
 drivers/target/iscsi/iscsi_target_login.c        |    1=20
 drivers/target/iscsi/iscsi_target_util.c         |   22 ++++++-
 drivers/target/iscsi/iscsi_target_util.h         |    1=20
 drivers/target/target_core_configfs.c            |    3=20
 drivers/target/target_core_device.c              |   18 ++---
 drivers/target/target_core_spc.c                 |    2=20
 drivers/target/target_core_tmr.c                 |    6 -
 drivers/xen/gntdev.c                             |   36 ++++++-----
 fs/gfs2/lops.c                                   |   14 ----
 fs/gfs2/trans.c                                  |    8 ++
 fs/nfs/dns_resolve.c                             |    5 -
 fs/nfs/internal.h                                |    5 -
 fs/nfs/mount_clnt.c                              |    2=20
 fs/nfs/namespace.c                               |   19 ++++--
 fs/nfs/nfs4namespace.c                           |    3=20
 fs/nfs/nfs4proc.c                                |   40 +++++++-----
 fs/nfs/super.c                                   |    2=20
 fs/xfs/xfs_buf_item.c                            |   18 +++++
 fs/xfs/xfs_log_recover.c                         |    2=20
 include/net/cfg80211.h                           |    9 ++
 include/sound/core.h                             |    3=20
 include/trace/events/xen.h                       |    8 ++
 kernel/futex.c                                   |   41 +++++++------
 net/batman-adv/bridge_loop_avoidance.c           |    8 +-
 net/batman-adv/routing.c                         |    8 ++
 net/core/dev.c                                   |    2=20
 net/core/skbuff.c                                |    6 +
 net/ipv4/inet_diag.c                             |    5 +
 net/ipv4/route.c                                 |    9 +-
 net/ipv4/tcp.c                                   |    8 --
 net/ipv4/tcp_illinois.c                          |    8 +-
 net/ipv4/tcp_input.c                             |    3=20
 net/ipv6/ndisc.c                                 |    3=20
 net/ipv6/route.c                                 |    4 -
 net/l2tp/l2tp_eth.c                              |    1=20
 net/mac80211/ibss.c                              |    2=20
 net/mac80211/rx.c                                |   72 +++++++++++++++++-=
-----
 net/mac80211/util.c                              |   42 +++++++++++--
 net/netlink/af_netlink.c                         |   19 ++++--
 net/sctp/sm_sideeffect.c                         |    3=20
 net/wireless/core.c                              |    3=20
 net/wireless/util.c                              |   14 ++--
 sound/core/compress_offload.c                    |    9 ++
 sound/core/control.c                             |    5 +
 sound/core/hwdep.c                               |   12 +++
 sound/core/init.c                                |   50 +++++++++------
 sound/core/oss/mixer_oss.c                       |   11 ++-
 sound/core/oss/pcm_oss.c                         |    7 ++
 sound/core/pcm.c                                 |   13 +++-
 sound/core/pcm_native.c                          |   35 +++++++++--
 sound/core/rawmidi.c                             |   26 +++++++-
 sound/core/sound.c                               |   11 ++-
 sound/core/sound_oss.c                           |   10 ++-
 sound/usb/card.c                                 |   14 ++--
 sound/usb/card.h                                 |    1=20
 sound/usb/mixer.c                                |   65 +++++++++++++-----=
--
 sound/usb/mixer_quirks.c                         |   58 ++++++++++++++++--
 sound/usb/pcm.c                                  |   49 ++++++++++-----
 sound/usb/proc.c                                 |    4 -
 sound/usb/stream.c                               |    1=20
 sound/usb/usbaudio.h                             |    2=20
 89 files changed, 798 insertions(+), 308 deletions(-)


Alex Deucher (2):
      drm/radeon/cayman: add some missing regs to the VM reg checker
      drm/radeon/si: add some missing regs to the VM reg checker

Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN

Ben Hutchings (1):
      nfs: Show original device name verbatim in /proc/*/mount{s,info}

Benjamin Marzinski (1):
      GFS2: Test bufdata with buffer locked and gfs2_log_lock held

Bryan Schumaker (1):
      NFS: Wait for session recovery to finish before returning

Chris Ball (1):
      mmc: sdhci: fix NULL dereference in sdhci_request() tuning

Chris Wilson (1):
      drm/i915: Only kick out vesafb if we takeover the fbcon with KMS

Cyrill Gorcunov (1):
      net: inet_diag -- Return error code if protocol handler is missed

Daniel Vetter (2):
      drm/i915: clear the entire sdvo infoframe buffer
      drm/i915: fix overlay on i830M

Dave Airlie (1):
      drm/udl: fix stride issues scanning out stride !=3D width*bpp

Dave Chinner (2):
      xfs: fix reading of wrapped log data
      xfs: fix buffer shudown reference count mismatch

David Vrabel (1):
      xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF

Egbert Eich (1):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.

Eric Dumazet (3):
      netlink: use kfree_rcu() in netlink_release()
      tcp: fix FIONREAD/SIOCINQ
      net: fix secpath kmemleak

Eric Leblond (1):
      af-packet: fix oops when socket is not present

Felix Fietkau (2):
      ath9k: fix stale pointers potentially causing access to free'd skbs
      cfg80211: fix antenna gain handling

Greg Kroah-Hartman (1):
      Linux 3.6.7

Guennadi Liakhovetski (1):
      mmc: sh_mmcif: fix use after free

Hannes Frederic Sowa (1):
      ipv6: send unsolicited neighbour advertisements to all-nodes

Hemant Kumar (1):
      net: usb: Fix memory leak on Tx data path

Ilija Hadzic (2):
      drm: restore open_count if drm_setup fails
      drm: set dev_mapping before calling drm_open_helper

Jacob Keller (1):
      ixgbe: PTP get_ts_info missing software support

Javier Cardona (2):
      mac80211: Only process mesh config header on frames that RA_MATCH
      mac80211: don't inspect Sequence Control field on control frames

Jean Delvare (1):
      hwmon: (w83627ehf) Force initial bank selection

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois

Johannes Berg (5):
      wireless: drop invalid mesh address extension frames
      mac80211: use blacklist for duplicate IE check
      mac80211: check management frame header length
      mac80211: verify that skb data is present
      mac80211: make sure data is accessible in EAPOL check

Konrad Rzeszutek Wilk (1):
      xen/mmu: Use Xen specific TLB flush instead of the generic one.

Li RongQing (1):
      ipv6: Set default hoplimit as zero.

Linus L=FCssing (1):
      batman-adv: Fix broadcast packet CRC calculation

NeilBrown (1):
      NFS: fix bug in legacy DNS resolver.

Nicholas Bellinger (1):
      target: Re-add explict zeroing of INQUIRY bounce buffer memory

Pavel Emelyanov (1):
      tcp-repair: Handle zero-length data put in rcv queue

Peter Senna Tschudin (1):
      drivers/net/ethernet/nxp/lpc_eth.c: Call mdiobus_unregister before md=
iobus_free

Roland Dreier (3):
      target: Don't return success from module_init() if setup fails
      target: Avoid integer overflow in se_dev_align_max_sectors()
      iscsi-target: Fix missed wakeup race in TX thread

Rolf Eike Beer (1):
      Input: tsc40 - remove wrong announcement of pressure support

Scott Mayhew (1):
      nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd time=
outs

Stanislaw Gruszka (1):
      rt2800: validate step value for temperature compensation

Steffen Klassert (1):
      ipv4: Fix flushing of cached routing informations

Steve Hodgson (1):
      target: Fix incorrect usage of nested IRQ spinlocks in ABORT_TASK path

Sven Eckelmann (1):
      ath9k: Test for TID only in BlockAcks while checking tx status

Takashi Iwai (8):
      ALSA: PCM: Fix some races at disconnection
      ALSA: usb-audio: Fix races at disconnection
      ALSA: usb-audio: Use rwsem for disconnect protection
      ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
      ALSA: Add a reference counter to card instance
      ALSA: Avoid endless sleep after disconnect
      ALSA: Fix card refcount unbalance
      ALSA: usb-audio: Fix mutex deadlock at disconnection

Thomas Gleixner (1):
      futex: Handle futex_pi OWNER_DIED take over correctly

Thomas Hellstrom (2):
      drm/vmwgfx: Fix hibernation device reset
      drm/vmwgfx: Fix a case where the code would BUG when trying to pin GM=
R memory

Tom Parkin (1):
      l2tp: fix oops in l2tp_eth_create() error path

Trond Myklebust (2):
      NFSv4: nfs4_locku_done must release the sequence id
      NFSv4.1: We must release the sequence id when we fail to get a sessio=
n slot

Zijie Pan (1):
      sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()


--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQqAKaAAoJEDjbvchgkmk+ggoP/RXrhVbS9gbhjm4vZWLgt72a
ww0205LCtNIhI6GdqOqIE+3ueoZdsn1wKxx/ZhsYkpHoS59zzm0j5rQwE16mlv4R
w2lz0p0wViaNYfxu2j7iEKFmulFx4oB+RWY3tnD0toG7sjx4ZXR/+bomuUPVK3z7
Bmu2oXoxlu6BTRuAsy3HS6fRGZne5Ia4I41+9cdWpvYaBC9R+ze1g5lw79EDxNVV
08VYKQIwVFcWZpNOA/Xo7njioBJ/Zr8d9uIzsFw1DhHi360RyiAid9IjQsTgtjtR
HusBmQDvU3Fwm5VD5Ml2ZDBpkccXu13J4mQxHS9rcxY1apIsk5TcTmLnkCS+P9+u
RrQGy4X2561T2egq2v7eforUgOdpId848d1eT2Kd4gBwtIGENuT2TiKkoKG6gzeK
Me8wszy/33I/+FQTIvZ81lCXiE+e56FhijMwjoGjlPQ4hGKem0pEmdzPkgwYMq8r
zGoO1kS0kVMmZo7Jx1I1zQQsQ3AgCb1C3mwS+jbWEEb9KH7JREMtJmbl5Vw4X7Dm
lFeNTbQL1Ej5KXKyI2y97TjBKXNA9DCzS+BSD/DEaRcb+dmdMvRiceKjsZLG++MH
UGQeKJ0GdEbK/SZ7RclgR7EzOAAgxdG0wrE854j+4RbGwpXuyJYIkZb6/3Zmc0t/
092AqhbI8aV1TsZQFjjF
=gwQq
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
