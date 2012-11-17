Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab2KQVcC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 16:32:02 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38198 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2KQVb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 16:31:59 -0500
Date: Sat, 17 Nov 2012 13:31:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.19
Message-ID: <20121117213156.GA9869@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.19 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                        |    2=20
 arch/x86/xen/mmu.c                              |   21 ++++++-
 drivers/gpu/drm/drm_fops.c                      |    5 +
 drivers/gpu/drm/i915/intel_drv.h                |    4 -
 drivers/gpu/drm/i915/intel_sdvo.c               |   59 ++++++++++++++-----
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |    2=20
 drivers/gpu/drm/radeon/evergreen_cs.c           |    3 +
 drivers/gpu/drm/radeon/evergreend.h             |    4 +
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1=20
 drivers/gpu/drm/radeon/si.c                     |    1=20
 drivers/gpu/drm/radeon/sid.h                    |    1=20
 drivers/gpu/drm/udl/udl_drv.h                   |    2=20
 drivers/gpu/drm/udl/udl_fb.c                    |   12 ++--
 drivers/gpu/drm/udl/udl_transfer.c              |    5 +
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c          |    2=20
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |    5 +
 drivers/hwmon/w83627ehf.c                       |    1=20
 drivers/input/touchscreen/tsc40.c               |    1=20
 drivers/mmc/host/sdhci.c                        |   23 ++++---
 drivers/net/ethernet/nxp/lpc_eth.c              |    1=20
 drivers/net/usb/usbnet.c                        |    3 +
 drivers/net/wireless/ath/ath9k/xmit.c           |   10 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c         |    2=20
 drivers/target/iscsi/iscsi_target.c             |    4 +
 drivers/target/iscsi/iscsi_target_core.h        |    1=20
 drivers/target/iscsi/iscsi_target_login.c       |    1=20
 drivers/target/iscsi/iscsi_target_util.c        |   22 ++++++-
 drivers/target/iscsi/iscsi_target_util.h        |    1=20
 drivers/target/target_core_configfs.c           |    3 -
 drivers/target/target_core_device.c             |   18 +++---
 drivers/target/target_core_tmr.c                |    6 +-
 drivers/usb/serial/mos7840.c                    |    1=20
 drivers/xen/gntdev.c                            |   36 ++++++------
 fs/nfs/dir.c                                    |    4 -
 fs/nfs/dns_resolve.c                            |    5 +
 fs/nfs/internal.h                               |    5 +
 fs/nfs/mount_clnt.c                             |    2=20
 fs/nfs/namespace.c                              |   19 ++++--
 fs/nfs/nfs4namespace.c                          |    3 -
 fs/nfs/nfs4proc.c                               |   37 ++++++++----
 fs/nfs/super.c                                  |    2=20
 fs/nfsd/export.c                                |    6 +-
 fs/xfs/xfs_log_recover.c                        |    2=20
 include/linux/sunrpc/cache.h                    |   16 +++++
 include/net/cfg80211.h                          |    9 +++
 include/sound/core.h                            |    3 +
 include/trace/events/xen.h                      |    8 ++
 kernel/futex.c                                  |   41 +++++++------
 net/core/dev.c                                  |    2=20
 net/ipv4/inet_diag.c                            |    5 +
 net/ipv4/tcp.c                                  |    8 +-
 net/ipv4/tcp_illinois.c                         |    8 +-
 net/ipv6/ndisc.c                                |    3 -
 net/ipv6/route.c                                |    4 -
 net/l2tp/l2tp_eth.c                             |    1=20
 net/mac80211/ibss.c                             |    2=20
 net/mac80211/rx.c                               |   72 ++++++++++++++++++-=
-----
 net/mac80211/util.c                             |   39 ++++++++++---
 net/netlink/af_netlink.c                        |   19 +++++-
 net/sctp/sm_sideeffect.c                        |    3 -
 net/wireless/core.c                             |    3 -
 net/wireless/util.c                             |   14 ++--
 sound/core/compress_offload.c                   |    9 ++-
 sound/core/control.c                            |    5 +
 sound/core/hwdep.c                              |   12 +++-
 sound/core/init.c                               |   50 ++++++++++------
 sound/core/oss/mixer_oss.c                      |   11 +++
 sound/core/oss/pcm_oss.c                        |    7 ++
 sound/core/pcm.c                                |   13 +++-
 sound/core/pcm_native.c                         |   35 +++++++++--
 sound/core/rawmidi.c                            |   26 ++++++++
 sound/core/sound.c                              |   11 +++
 sound/core/sound_oss.c                          |   10 ++-
 sound/usb/card.c                                |   14 +++-
 sound/usb/card.h                                |    1=20
 sound/usb/endpoint.c                            |    9 ++-
 sound/usb/mixer.c                               |   65 ++++++++++++++-----=
--
 sound/usb/mixer_quirks.c                        |   37 +++++++++++-
 sound/usb/pcm.c                                 |   35 ++++++++---
 sound/usb/proc.c                                |    4 -
 sound/usb/usbaudio.h                            |    2=20
 81 files changed, 701 insertions(+), 263 deletions(-)

Alex Deucher (2):
      drm/radeon/cayman: add some missing regs to the VM reg checker
      drm/radeon/si: add some missing regs to the VM reg checker

Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN

Ben Hutchings (1):
      nfs: Show original device name verbatim in /proc/*/mount{s,info}

Chris Ball (1):
      mmc: sdhci: fix NULL dereference in sdhci_request() tuning

Cyrill Gorcunov (1):
      net: inet_diag -- Return error code if protocol handler is missed

Daniel Vetter (2):
      drm/i915: fixup infoframe support for sdvo
      drm/i915: clear the entire sdvo infoframe buffer

Dave Airlie (1):
      drm/udl: fix stride issues scanning out stride !=3D width*bpp

Dave Chinner (1):
      xfs: fix reading of wrapped log data

David Vrabel (1):
      xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF

Egbert Eich (1):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.

Eric Dumazet (2):
      netlink: use kfree_rcu() in netlink_release()
      tcp: fix FIONREAD/SIOCINQ

Eric Leblond (1):
      af-packet: fix oops when socket is not present

Felix Fietkau (2):
      ath9k: fix stale pointers potentially causing access to free'd skbs
      cfg80211: fix antenna gain handling

Greg Kroah-Hartman (1):
      Linux 3.4.19

Hannes Frederic Sowa (1):
      ipv6: send unsolicited neighbour advertisements to all-nodes

Hemant Kumar (1):
      net: usb: Fix memory leak on Tx data path

Ilija Hadzic (1):
      drm: restore open_count if drm_setup fails

J. Bruce Fields (1):
      nfsd: add get_uint for u32's

Javier Cardona (2):
      mac80211: Only process mesh config header on frames that RA_MATCH
      mac80211: don't inspect Sequence Control field on control frames

Jean Delvare (1):
      hwmon: (w83627ehf) Force initial bank selection

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois

Johan Hovold (1):
      USB: mos7840: remove unused variable

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

NeilBrown (1):
      NFS: fix bug in legacy DNS resolver.

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

Trond Myklebust (3):
      NFSv4: nfs4_locku_done must release the sequence id
      NFSv4.1: We must release the sequence id when we fail to get a sessio=
n slot
      NFS: Fix Oopses in nfs_lookup_revalidate and nfs4_lookup_revalidate

Zijie Pan (1):
      sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()


--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQqAJMAAoJEDjbvchgkmk+/18QAKM9PAbe6W6ZP562atXFN0S0
wUV1GGlLlvDpSkqK4U0Y1YBN8AommkbtyjVMGS+0zkFPFzFSg/pfx5iNvlj96sB6
usAoemsvrtKujhxsiZoloWaRVB9rSSQWEhnb8jFFeg7oYPqYd/shisEzyhcba+1J
lF3QIPCsTlCbTummnMu8i2P5I3+llND5hAKHwC9gYLQRbFPH5w31S+Ll/DadPtN3
py94WO2T9gtI6Eq6M8Tk2VPHWxf0J/uToOkExp6tATlfb+yLkj6E0PSERio7WNDt
6MFdqWMuuhWZI5WD+r8JI7lJouYs1lV650u2qe1I3c7fa2W6S3QSwkkIPkLBdxi4
dMTZyhjpcMS3D2oaVZMnkMhsQ/ADTKgliDXlFx69zeavi6E0FZEPiPSkeF3SOGtk
YOvXlt6lD+nb7a/g+Chevhk1bLD06Qd+gMvAAejY9SMPk8/Rn7iN6nO7K7aDRFtY
b+9/G41NpgL75gKNbAml25PFsdVdMOLiK/zRBXlJo9YcjpnHIgihh405qJFTa58s
fJV+WMQTaagMA4xPT8NNv6i/tskZgvHrt9uTwiGttdMWseEYNNayT2JiSVYaq5fT
WMpo9zrn6V4z9mSvKfAugiMQ/gdq/gH9UxsZulnRmpvzxByMFx7N/pqFvcIoSlg0
3ay/Sr6qeMFc4/a12rMO
=LkTa
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
