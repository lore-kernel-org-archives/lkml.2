Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab2KQVbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:31:20 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47522 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2KQVbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:31:18 -0500
Date: Sat, 17 Nov 2012 13:31:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.52
Message-ID: <20121117213113.GA8339@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.52 kernel.

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

 Makefile                                        |    2=20
 drivers/gpu/drm/drm_fops.c                      |    5 +
 drivers/gpu/drm/i915/intel_drv.h                |    2=20
 drivers/gpu/drm/i915/intel_sdvo.c               |   59 ++++++++++++++++---=
--
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |    2=20
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |    5 +
 drivers/hwmon/w83627ehf.c                       |    1=20
 drivers/net/usb/usbnet.c                        |    3 +
 drivers/net/wireless/ath/ath9k/xmit.c           |    2=20
 drivers/net/wireless/rt2x00/rt2800lib.c         |    2=20
 drivers/pci/intel-iommu.c                       |    4 -
 drivers/target/target_core_configfs.c           |    3 -
 drivers/usb/serial/mos7840.c                    |    1=20
 fs/nfs/dir.c                                    |    4 -
 fs/nfs/dns_resolve.c                            |    5 +
 fs/nfs/internal.h                               |    5 +
 fs/nfs/mount_clnt.c                             |    2=20
 fs/nfs/namespace.c                              |   19 +++++--
 fs/nfs/nfs4namespace.c                          |    3 -
 fs/nfs/nfs4proc.c                               |    1=20
 fs/nfs/super.c                                  |    2=20
 fs/nfsd/export.c                                |    6 +-
 fs/xfs/xfs_log_recover.c                        |    2=20
 include/linux/sunrpc/cache.h                    |   16 +++++
 include/sound/core.h                            |    3 +
 kernel/futex.c                                  |   41 ++++++++-------
 net/ipv4/tcp.c                                  |    8 +-
 net/ipv4/tcp_illinois.c                         |    8 +-
 net/ipv6/ndisc.c                                |    3 -
 net/ipv6/route.c                                |    4 -
 net/l2tp/l2tp_eth.c                             |    1=20
 net/mac80211/ibss.c                             |    2=20
 net/mac80211/rx.c                               |   16 ++++-
 net/netlink/af_netlink.c                        |   19 +++++--
 net/sctp/sm_sideeffect.c                        |    3 -
 net/wireless/core.c                             |    3 -
 net/wireless/util.c                             |   11 ++--
 sound/core/control.c                            |    5 +
 sound/core/hwdep.c                              |   12 ++++
 sound/core/init.c                               |   50 +++++++++++-------
 sound/core/oss/mixer_oss.c                      |   11 +++-
 sound/core/oss/pcm_oss.c                        |    7 ++
 sound/core/pcm.c                                |   13 ++++
 sound/core/pcm_native.c                         |   35 ++++++++++--
 sound/core/rawmidi.c                            |   26 +++++++++
 sound/core/sound.c                              |   11 +++-
 sound/core/sound_oss.c                          |   10 ++-
 sound/usb/card.c                                |   14 +++--
 sound/usb/card.h                                |    1=20
 sound/usb/mixer.c                               |   65 +++++++++++++++----=
-----
 sound/usb/mixer_quirks.c                        |   37 ++++++++++++-
 sound/usb/pcm.c                                 |   35 +++++++++---
 sound/usb/proc.c                                |    4 -
 sound/usb/urb.c                                 |    9 ++-
 sound/usb/usbaudio.h                            |    2=20
 56 files changed, 455 insertions(+), 171 deletions(-)

Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN

Ben Hutchings (1):
      nfs: Show original device name verbatim in /proc/*/mount{s,info}

Daniel Vetter (2):
      drm/i915: fixup infoframe support for sdvo
      drm/i915: clear the entire sdvo infoframe buffer

Dave Chinner (1):
      xfs: fix reading of wrapped log data

Egbert Eich (1):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.

Eric Dumazet (2):
      netlink: use kfree_rcu() in netlink_release()
      tcp: fix FIONREAD/SIOCINQ

Felix Fietkau (2):
      ath9k: fix stale pointers potentially causing access to free'd skbs
      cfg80211: fix antenna gain handling

Greg Kroah-Hartman (1):
      Linux 3.0.52

Hannes Frederic Sowa (1):
      ipv6: send unsolicited neighbour advertisements to all-nodes

Hemant Kumar (1):
      net: usb: Fix memory leak on Tx data path

Ilija Hadzic (1):
      drm: restore open_count if drm_setup fails

J. Bruce Fields (1):
      nfsd: add get_uint for u32's

Javier Cardona (1):
      mac80211: don't inspect Sequence Control field on control frames

Jean Delvare (1):
      hwmon: (w83627ehf) Force initial bank selection

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois

Johan Hovold (1):
      USB: mos7840: remove unused variable

Johannes Berg (2):
      wireless: drop invalid mesh address extension frames
      mac80211: check management frame header length

Li RongQing (1):
      ipv6: Set default hoplimit as zero.

NeilBrown (1):
      NFS: fix bug in legacy DNS resolver.

Roland Dreier (2):
      target: Don't return success from module_init() if setup fails
      intel-iommu: Fix AB-BA lockdep report

Scott Mayhew (1):
      nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd time=
outs

Stanislaw Gruszka (1):
      rt2800: validate step value for temperature compensation

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

Thomas Hellstrom (1):
      drm/vmwgfx: Fix hibernation device reset

Tom Parkin (1):
      l2tp: fix oops in l2tp_eth_create() error path

Trond Myklebust (2):
      NFSv4: nfs4_locku_done must release the sequence id
      NFS: Fix Oopses in nfs_lookup_revalidate and nfs4_lookup_revalidate

Zijie Pan (1):
      sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQqAIhAAoJEDjbvchgkmk+Pm0QALNQTXALVNFsCq7zJfUfDcpR
aS2AL3sZ0zNEcxYYY0zKSsdniAi8v7g0XkzFtH4Fl5E8BKDWt96YYFV9OiCc2tC6
/ictj5ME9wdkJePOS75Ofvhsv6K2XcutNU538DbHpnAsItOeYAciC2uIY2IZzB8l
+TgPRLg3nVdX1t68+t1eLk6F+zm0/IUDrFSg3dcMslJvSJr8xuw5O6ICeNhpIgJU
EuECivFdvVFtiXSjw/KQ4Tr2NP9NZGaZ5ZL41j6bfLechLyOq82rrVz/CsLdvj4b
VH3ZTWiA6XVyhJ9mVq3C+sVgAnSU+thGvoH2c6rq2EmzWkV/shKnPPvOTtEAMQSr
2zZj7jortVlWanrt2UoRdsQDXl/1ewEwTo0adkf5sq0RN/419BU2Ig6INvmxBzqO
rIWakIncJtPGDrW9CvLnp0eCO4gZflYJRoPQbc/3tPSb6D7rfM9kJBnwr6qG0CxH
A78dTAUGUIpUvmZHuZtcp/Aiz7qSXdN3+mZzuX8tkaS3gemQGsfdWRTE+M7471jl
otuBkMH/PszAsetlGzHoo45Ay9EfJxriKYObj2AdA5Xm0AyC4Vr/cw65DXZLq53E
5grx2ds5oYXMux9RDCgDO5IdG4RIssPyCDaHycXYabjLnflCaBVH898G1P68PeTh
7pUXmx42rDI0C9y91H69
=9Rzj
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
