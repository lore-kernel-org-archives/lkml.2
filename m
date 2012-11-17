Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2KQEGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 23:06:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55198 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab2KQEGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 23:06:46 -0500
Message-ID: <1353125193.4867.95.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.34
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Sat, 17 Nov 2012 04:06:33 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oKP9PmFCbbdsevz5y+JG"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oKP9PmFCbbdsevz5y+JG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.34 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/feature-removal-schedule.txt      |    8 ---
 Makefile                                        |    2 +-
 arch/arm/mach-at91/at91rm9200_devices.c         |    2 +-
 arch/arm/mach-at91/at91sam9260_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9261_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9263_devices.c        |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c         |    2 +-
 arch/arm/mach-at91/setup.c                      |    2 +-
 arch/x86/include/asm/system.h                   |    7 --
 arch/x86/kernel/process.c                       |   24 -------
 arch/x86/xen/mmu.c                              |   21 +++++-
 crypto/cryptd.c                                 |   11 +++-
 drivers/block/floppy.c                          |   48 ++++----------
 drivers/gpio/gpio-timberdale.c                  |    4 +-
 drivers/gpu/drm/drm_fops.c                      |    5 +-
 drivers/gpu/drm/i915/intel_drv.h                |    4 +-
 drivers/gpu/drm/i915/intel_overlay.c            |   14 +++-
 drivers/gpu/drm/i915/intel_sdvo.c               |   59 ++++++++++++-----
 drivers/gpu/drm/i915/intel_sdvo_regs.h          |    2 +
 drivers/gpu/drm/nouveau/nouveau_drv.c           |   34 ++++++----
 drivers/gpu/drm/nouveau/nouveau_state.c         |    4 +-
 drivers/gpu/drm/nouveau/nv04_dac.c              |    8 +--
 drivers/gpu/drm/nouveau/nv04_dfp.c              |    6 +-
 drivers/gpu/drm/nouveau/nv04_tv.c               |    4 +-
 drivers/gpu/drm/radeon/evergreen.c              |    2 +-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c          |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c             |    5 ++
 drivers/hid/hid-microsoft.c                     |   18 ++++--
 drivers/hwmon/w83627ehf.c                       |    1 +
 drivers/input/touchscreen/tsc40.c               |    1 -
 drivers/net/ethernet/marvell/sky2.c             |    4 +-
 drivers/net/ethernet/realtek/r8169.c            |    7 +-
 drivers/net/usb/usbnet.c                        |    3 +
 drivers/net/wireless/ath/ath9k/xmit.c           |   10 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c         |    2 +-
 drivers/target/iscsi/iscsi_target.c             |    4 +-
 drivers/target/iscsi/iscsi_target_core.h        |    1 +
 drivers/target/iscsi/iscsi_target_login.c       |    1 +
 drivers/target/iscsi/iscsi_target_util.c        |   22 ++++++-
 drivers/target/iscsi/iscsi_target_util.h        |    1 +
 drivers/target/target_core_configfs.c           |    3 +-
 drivers/target/target_core_device.c             |   18 +++---
 drivers/usb/serial/mos7840.c                    |    1 -
 drivers/xen/gntdev.c                            |   36 ++++++-----
 fs/cifs/cifsacl.c                               |   49 ++++++--------
 fs/ecryptfs/main.c                              |   23 ++++++-
 fs/nfs/dns_resolve.c                            |    5 +-
 fs/nfs/internal.h                               |    5 +-
 fs/nfs/mount_clnt.c                             |    2 +-
 fs/nfs/namespace.c                              |   19 ++++--
 fs/nfs/nfs4namespace.c                          |    3 +-
 fs/nfs/nfs4proc.c                               |   40 +++++++-----
 fs/nfs/super.c                                  |    2 +-
 fs/nfsd/export.c                                |    6 +-
 fs/notify/fanotify/fanotify.c                   |    1 +
 fs/xfs/xfs_log_recover.c                        |    2 +-
 include/linux/if_link.h                         |    1 +
 include/linux/rtnetlink.h                       |    3 +
 include/linux/sunrpc/cache.h                    |   16 +++++
 include/net/cfg80211.h                          |    9 +++
 include/net/rtnetlink.h                         |    2 +-
 include/sound/core.h                            |    3 +
 include/trace/events/xen.h                      |    8 +++
 kernel/module.c                                 |   24 +++----
 mm/vmscan.c                                     |    2 +
 net/bluetooth/hci_conn.c                        |    2 +
 net/core/dev.c                                  |    2 +-
 net/core/rtnetlink.c                            |   78 +++++++++++++++++--=
----
 net/ipv4/tcp.c                                  |    8 +--
 net/ipv4/tcp_illinois.c                         |    8 ++-
 net/ipv6/ndisc.c                                |    3 +-
 net/ipv6/route.c                                |    4 +-
 net/l2tp/l2tp_eth.c                             |    1 +
 net/mac80211/ibss.c                             |    2 +-
 net/mac80211/rx.c                               |   71 ++++++++++++++++---=
--
 net/netlink/af_netlink.c                        |   19 ++++--
 net/sctp/sm_sideeffect.c                        |    3 +-
 net/wireless/core.c                             |    3 +-
 net/wireless/util.c                             |   14 ++--
 sound/core/control.c                            |    5 ++
 sound/core/hwdep.c                              |   12 +++-
 sound/core/init.c                               |   50 +++++++++------
 sound/core/oss/mixer_oss.c                      |   11 +++-
 sound/core/oss/pcm_oss.c                        |    7 ++
 sound/core/pcm.c                                |   13 +++-
 sound/core/pcm_native.c                         |   35 ++++++++--
 sound/core/rawmidi.c                            |   26 +++++++-
 sound/core/sound.c                              |   11 +++-
 sound/core/sound_oss.c                          |   10 ++-
 sound/pci/hda/patch_analog.c                    |    1 +
 sound/pci/hda/patch_cirrus.c                    |   16 +++--
 sound/pci/hda/patch_realtek.c                   |    2 +
 sound/pci/hda/patch_via.c                       |   25 ++++++--
 sound/usb/card.c                                |   14 ++--
 sound/usb/card.h                                |    1 +
 sound/usb/endpoint.c                            |    9 ++-
 sound/usb/mixer.c                               |   65 ++++++++++++-------
 sound/usb/mixer_quirks.c                        |   37 +++++++++--
 sound/usb/pcm.c                                 |   35 +++++++---
 sound/usb/proc.c                                |    4 +-
 sound/usb/usbaudio.h                            |    2 +-
 102 files changed, 847 insertions(+), 407 deletions(-)

Alex Deucher (1):
      drm/radeon: fix typo in evergreen_mc_resume()

Alexander Stein (1):
      ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Antonio Quartulli (1):
      mac80211: fix SSID copy on IBSS JOIN

Ben Hutchings (3):
      Bluetooth: Avoid calling undefined smp_conn_security()
      nfs: Show original device name verbatim in /proc/*/mount{s,info}
      Linux 3.2.34

Ben Skeggs (3):
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets
      drm/nouveau: fix suspend/resume when in headless mode
      drm/nouveau: headless mode by default if pci class !=3D vga display

Bo Shen (1):
      ARM: at91/i2c: change id to let i2c-gpio work

Bryan Schumaker (1):
      NFS: Wait for session recovery to finish before returning

Cyril Brulebois (1):
      r8169: Fix WoL on RTL8168d/8111d.

Dan Carpenter (1):
      gpio-timberdale: fix a potential wrapping issue

Daniel J Blueman (1):
      ALSA: HDA: Fix digital microphone on CS420x

Daniel Vetter (3):
      drm/i915: fix overlay on i830M
      drm/i915: fixup infoframe support for sdvo
      drm/i915: clear the entire sdvo infoframe buffer

Dave Chinner (1):
      xfs: fix reading of wrapped log data

David Vrabel (1):
      xen/gntdev: don't leak memory from IOCTL_GNTDEV_MAP_GRANT_REF

Egbert Eich (1):
      DRM/Radeon: Fix Load Detection on legacy primary DAC.

Eric Dumazet (3):
      rtnetlink: fix rtnl_calcit() and rtnl_dump_ifinfo()
      netlink: use kfree_rcu() in netlink_release()
      tcp: fix FIONREAD/SIOCINQ

Eric Leblond (1):
      af-packet: fix oops when socket is not present

Eric Paris (1):
      fanotify: fix missing break

Felix Fietkau (2):
      cfg80211: fix antenna gain handling
      ath9k: fix stale pointers potentially causing access to free'd skbs

Greg Rose (1):
      rtnetlink: Fix problem with buffer allocation

Hannes Frederic Sowa (1):
      ipv6: send unsolicited neighbour advertisements to all-nodes

Hemant Kumar (1):
      net: usb: Fix memory leak on Tx data path

Herton Ronaldo Krzesinski (2):
      floppy: do put_disk on current dr if blk_init_queue fails
      floppy: properly handle failure on add_disk loop

Ilija Hadzic (1):
      drm: restore open_count if drm_setup fails

Ivan Shugov (1):
      ARM: at91: at91sam9g10: fix SOC type detection

J. Bruce Fields (1):
      nfsd: add get_uint for u32's

Javier Cardona (2):
      mac80211: Only process mesh config header on frames that RA_MATCH
      mac80211: don't inspect Sequence Control field on control frames

Jean Delvare (1):
      hwmon: (w83627ehf) Force initial bank selection

Jeff Layton (1):
      cifs: fix potential buffer overrun in cifs.idmap handling code

Jesper Dangaard Brouer (1):
      net: fix divide by zero in tcp algorithm illinois

Jiri Slaby (1):
      HID: microsoft: fix invalid rdesc for 3k kbd

Johan Hovold (1):
      USB: mos7840: remove unused variable

Johannes Berg (4):
      wireless: drop invalid mesh address extension frames
      mac80211: check management frame header length
      mac80211: verify that skb data is present
      mac80211: make sure data is accessible in EAPOL check

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent d=
ata corruption

Kailang Yang (1):
      ALSA: hda - Add new codec ALC668 and ALC900 (default name ALC1150)

Konrad Rzeszutek Wilk (1):
      xen/mmu: Use Xen specific TLB flush instead of the generic one.

Len Brown (1):
      x86: Remove the ancient and deprecated disable_hlt() and enable_hlt()=
 facility

Li RongQing (1):
      ipv6: Set default hoplimit as zero.

Michal Schmidt (1):
      r8169: use unlimited DMA burst for TX

Mirko Lindner (1):
      sky2: Fix for interrupt handler

Nathan Walp (1):
      r8169: allow multicast packets on sub-8168f chipset.

NeilBrown (1):
      NFS: fix bug in legacy DNS resolver.

Roland Dreier (3):
      target: Don't return success from module_init() if setup fails
      target: Avoid integer overflow in se_dev_align_max_sectors()
      iscsi-target: Fix missed wakeup race in TX thread

Rolf Eike Beer (1):
      Input: tsc40 - remove wrong announcement of pressure support

Rusty Russell (1):
      module: fix out-by-one error in kallsyms

Scott Mayhew (1):
      nfsv3: Make v3 mounts fail with ETIMEDOUTs instead EIO on mountd time=
outs

Stanislaw Gruszka (1):
      rt2800: validate step value for temperature compensation

Sven Eckelmann (1):
      ath9k: Test for TID only in BlockAcks while checking tx status

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from k=
swapd()

Takashi Iwai (11):
      ALSA: PCM: Fix some races at disconnection
      ALSA: usb-audio: Fix races at disconnection
      ALSA: usb-audio: Use rwsem for disconnect protection
      ALSA: usb-audio: Fix races at disconnection in mixer_quirks.c
      ALSA: Add a reference counter to card instance
      ALSA: Avoid endless sleep after disconnect
      ALSA: hda - Force to reset IEC958 status bits for AD codecs
      ALSA: hda - Fix empty DAC filling in patch_via.c
      ALSA: hda - Fix invalid connections in VT1802 codec
      ALSA: Fix card refcount unbalance
      ALSA: usb-audio: Fix mutex deadlock at disconnection

Thomas Hellstrom (2):
      drm/vmwgfx: Fix hibernation device reset
      drm/vmwgfx: Fix a case where the code would BUG when trying to pin GM=
R memory

Tim Sally (1):
      eCryptfs: check for eCryptfs cipher support at mount

Tom Parkin (1):
      l2tp: fix oops in l2tp_eth_create() error path

Trond Myklebust (2):
      NFSv4.1: We must release the sequence id when we fail to get a sessio=
n slot
      NFSv4: nfs4_locku_done must release the sequence id

Tyler Hicks (1):
      eCryptfs: Copy up POSIX ACL and read-only flags from lower mount

Zijie Pan (1):
      sctp: fix call to SCTP_CMD_PROCESS_SACK in sctp_cmd_interpreter()


--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-oKP9PmFCbbdsevz5y+JG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKcNSee/yOyVhhEJAQqAVw/+OEaidHHTenLJ9CW85s7CbUy/0l+4PmGI
5cwouIQXCHp3zK8peDy28Bf36NfwUeMfWPQ7YoOpwyuO2p+UzMmiuqpbmsfFQbTH
znWJQEF7PHEiB/XKOr14KJx/y3Zxwlq5Nl4PkA0Pfay0ZcyzYoMlga4n0zu476Z9
9utZukegPvCCNrhiu7sb/D6X6DKXpwnGGw13ilG7eqW1gKF5/FVYBuNiV/NAO9Xi
hUN9u1h2DG7t8b3+MIPx+G35JQRR0qTkEfdEHJxNQX6sMss7XD/HsxCJ8DL42ty/
lZp02t7uSW8GhO1NoV59GjOeXMMzF5CXbWK5Ffslt1E4uQ60U9JU1++ryMczLaAh
xLYuXUmsuqMnQynCQTVwdg+oUuHKCXKrjYYw3EYUF9Bmd7Q06ntniVTIxeA+xToq
jwkr9AHlgyi+eCFpGLK1V7BUqHCUDNdONMQTeAC9gbFHOAFpZgPgEfTrOEi7xhxI
r7+op9cFBNKYvJ5nhRjnd6oSLeBIoeVqfFVV1z4Qs5c0qBw3pWbh439yK6MfQSzO
wd426mR3zaRJEnpRC7RHo57phYZ/KcmAAQFsfrR0plOEM5I0xhHslH9AsCiiSBkN
iD0FwbKujEijx+eIC9KeCFEyqdgPZgm4GwtipmZjuRuvLwHDQxAs8ONSx6sFJlCq
x05GH9MlcuE=
=EVet
-----END PGP SIGNATURE-----

--=-oKP9PmFCbbdsevz5y+JG--
