Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414Ab2JURYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 13:24:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39626 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab2JURYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 13:24:49 -0400
Date: Sun, 21 Oct 2012 10:25:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.15
Message-ID: <20121021172512.GA5363@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.15 kernel.

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
 arch/arm/Kconfig                                |   10 ++
 arch/arm/include/asm/vfpmacros.h                |    4=20
 arch/arm/mm/cache-v7.S                          |    3=20
 arch/mips/kernel/kgdb.c                         |    9 ++
 arch/x86/xen/enlighten.c                        |   18 ++++
 block/blk-core.c                                |    2=20
 drivers/acpi/ec.c                               |   30 ++++++-
 drivers/char/tpm/tpm.c                          |   21 +++--
 drivers/firewire/core-cdev.c                    |    4=20
 drivers/gpu/drm/i915/intel_display.c            |    4=20
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    6 -
 drivers/md/raid10.c                             |    2=20
 drivers/net/ethernet/intel/e1000e/e1000.h       |    6 -
 drivers/net/ethernet/intel/e1000e/netdev.c      |    2=20
 drivers/net/wireless/ath/ath9k/beacon.c         |    2=20
 drivers/net/wireless/ath/ath9k/main.c           |    2=20
 drivers/net/wireless/ath/ath9k/xmit.c           |   53 ++++++------
 drivers/scsi/hpsa.c                             |   39 ++++++++-
 drivers/scsi/hpsa.h                             |    2=20
 drivers/scsi/hpsa_cmd.h                         |    1=20
 drivers/scsi/scsi_debug.c                       |    2=20
 drivers/scsi/storvsc_drv.c                      |    5 +
 drivers/target/iscsi/iscsi_target.c             |    2=20
 drivers/target/iscsi/iscsi_target_core.h        |    4=20
 drivers/target/iscsi/iscsi_target_tpg.c         |   12 ++
 drivers/target/target_core_configfs.c           |    8 +
 drivers/tty/vt/vt.c                             |   13 +++
 drivers/usb/class/cdc-acm.c                     |    3=20
 drivers/usb/gadget/at91_udc.c                   |    2=20
 drivers/video/udlfb.c                           |    2=20
 drivers/video/via/via_clock.c                   |   19 ++++
 fs/autofs4/root.c                               |    6 -
 fs/ceph/export.c                                |   18 +++-
 fs/ecryptfs/ecryptfs_kernel.h                   |    2=20
 fs/ecryptfs/file.c                              |  100 +++++++++++--------=
-----
 fs/ecryptfs/inode.c                             |   65 ++++++++-------
 fs/ecryptfs/main.c                              |    1=20
 fs/ecryptfs/mmap.c                              |   39 +++------
 fs/gfs2/export.c                                |    4=20
 fs/isofs/export.c                               |    2=20
 fs/jbd/commit.c                                 |   45 ++++++++--
 fs/jbd/transaction.c                            |   64 ++++++++++-----
 fs/lockd/mon.c                                  |    4=20
 fs/nfsd/nfs4idmap.c                             |    2=20
 fs/nfsd/nfs4state.c                             |    1=20
 fs/reiserfs/inode.c                             |    6 +
 fs/xfs/xfs_export.c                             |    3=20
 include/linux/netfilter/ipset/ip_set_timeout.h  |    4=20
 include/net/ip_vs.h                             |    2=20
 include/net/netfilter/nf_conntrack_ecache.h     |    1=20
 kernel/debug/kdb/kdb_io.c                       |   33 ++++++-
 kernel/module.c                                 |    4=20
 kernel/timer.c                                  |   10 +-
 mm/shmem.c                                      |    6 -
 net/core/pktgen.c                               |    2=20
 net/ipv4/netfilter/nf_nat_sip.c                 |   10 +-
 net/netfilter/ipvs/ip_vs_ctl.c                  |    5 -
 net/netfilter/nf_conntrack_core.c               |   16 ++-
 net/netfilter/nf_conntrack_expect.c             |   29 +-----
 net/netfilter/xt_hashlimit.c                    |    8 -
 net/netfilter/xt_limit.c                        |   13 +--
 net/netfilter/xt_set.c                          |   17 +++-
 net/sunrpc/xprtsock.c                           |   21 +++--
 sound/pci/ac97/ac97_codec.c                     |    2=20
 sound/pci/emu10k1/emu10k1_main.c                |    9 ++
 sound/pci/hda/patch_cirrus.c                    |    6 -
 sound/pci/hda/patch_realtek.c                   |    6 +
 sound/soc/codecs/wm2200.c                       |    3=20
 sound/soc/omap/omap-abe-twl6040.c               |    2=20
 sound/soc/sh/fsi.c                              |   15 +--
 71 files changed, 583 insertions(+), 297 deletions(-)

Alexander Holler (1):
      video/udlfb: fix line counting in fb_write

Amerigo Wang (1):
      pktgen: fix crash when generating IPv6 packets

Christoph Hellwig (1):
      iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp

Dan Carpenter (1):
      md/raid10: use correct limit variable

Daniel Drake (1):
      viafb: don't touch clock state on OLPC XO-1.5

David Henningsson (2):
      ALSA: hda - do not detect jack on internal speakers for Realtek
      ALSA: hda - Always check array bounds in alc_get_line_out_pfx

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy(=
).

Fabio Porcedda (1):
      usb: gadget: at91_udc: fix dt support

Felix Fietkau (1):
      ath9k: use ieee80211_free_txskb

Feng Tang (2):
      ACPI: EC: Make the GPE storm threshold a module parameter
      ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Florian Westphal (1):
      netfilter: limit, hashlimit: avoid duplicated inline

Greg Kroah-Hartman (1):
      Linux 3.4.15

Guennadi Liakhovetski (1):
      ASoC: fsi: don't reschedule DMA from an atomic context

Hildner, Christian (1):
      timers: Fix endless looping between cascade() and internal_add_timer()

Hiroaki SHIMODA (1):
      e1000e: Change wthresh to 1 to avoid possible Tx stalls

Hugh Dickins (1):
      tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Ian Kent (1):
      autofs4 - fix reset pending flag on mount fail

J. Bruce Fields (1):
      nfsd4: fix nfs4 stateid leak

Jan Engelhardt (1):
      netfilter: xt_limit: have r->cost !=3D 0 case work

Jan Kara (1):
      jbd: Fix assertion failure in commit code due to lacking transaction =
credits

Jani Nikula (1):
      drm/i915: use adjusted_mode instead of mode for checking the 6bpc for=
ce flag

Jason Wessel (2):
      mips,kgdb: fix recursive page fault with CONFIG_KPROBES
      kdb,vt_console: Fix missed data due to pager overruns

Jean-Christian de Rivaz (1):
      Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

Jozsef Kadlecsik (2):
      netfilter: ipset: fix timeout value overflow bug
      netfilter: ipset: timeout fixing bug broke SET target special timeout=
 value

Julian Anastasov (1):
      ipvs: fix oops in ip_vs_dst_event on rmmod

K. Y. Srinivasan (1):
      SCSI: storvsc: Account for in-transit packets in the RESET path

Konrad Rzeszutek Wilk (2):
      xen/bootup: allow {read|write}_cr8 pvops call.
      xen/bootup: allow read_tscp call for Xen PV guests.

Lin Ming (1):
      ipvs: fix oops on NAT reply in br_nf context

Lukas Czerner (1):
      SCSI: scsi_debug: Fix off-by-one bug when unmapping region

Malahal Naineni (1):
      NFSD: pass null terminated buf to kstrtouint()

Mark Brown (2):
      ASoC: wm2200: Use rev A register patches on rev B
      ASoC: wm2200: Fix non-inverted OUT2 mute control

Matthew Garrett (1):
      module: taint kernel when lve module is loaded

Maxim Kachur (1):
      ALSA: emu10k1: add chip details for E-mu 1010 PCIe card

Nicholas Bellinger (3):
      iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT P=
DU
      iscsi-target: Add explicit set of cache_dynamic_acls=3D1 for TPG demo=
-mode
      iscsi-target: Bump defaults for nopin_timeout + nopin_response_timeou=
t values

Pablo Neira Ayuso (3):
      netfilter: nf_conntrack: fix racy timer handling with reliable events
      netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expec=
tation
      netfilter: nf_ct_expect: fix possible access to uninitialized timer

Patrick McHardy (1):
      netfilter: nf_nat_sip: fix via header translation with multiple param=
eters

Peter Huewe (1):
      tpm: Propagate error from tpm_transmit to fix a timeout hang

Peter Senna Tschudin (1):
      target: fix return code in target_core_init_configfs error path

Peter Ujfalusi (1):
      ASoC: omap-abe-twl6040: Fix typo of Vibrator

Russell King (1):
      ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels

Simon Horman (1):
      ARM: 7541/1: Add ARM ERRATA 775420 workaround

Stanislav Kinsbursky (1):
      lockd: use rpc client's cl_nodename for id encoding

Stefan Richter (1):
      firewire: cdev: fix user memory corruption (i386 userland on amd64 ke=
rnel)

Stephen M. Cameron (1):
      SCSI: hpsa: dial down lockup detection during firmware flash

Takashi Iwai (2):
      ALSA: hda - Fix memory leaks at error path in patch_cirrus.c
      ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()

Tejun Heo (1):
      block: fix request_queue->flags initialization

Trond Myklebust (1):
      SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT

Tyler Hicks (5):
      eCryptfs: Unlink lower inode when ecryptfs_create() fails
      eCryptfs: Initialize empty lower files when opening them
      eCryptfs: Revert to a writethrough cache model
      eCryptfs: Write out all dirty pages just before releasing the lower f=
ile
      eCryptfs: Call lower ->flush() from ecryptfs_flush()


--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhC/4AAoJEDjbvchgkmk+Os0P/3KyhcXllA5xd/du9n71YQBs
6vunbB9BnJz/KunbmeSMbicYCsjwO4ORxhSDX2CyjM0KqeNPKv+s0ZtFcZv9ecg5
pmLb1V0AusxNxEblmi1MSfj0fo4gfB0pYVe0fMgMoLDPgfvLgo44LG6ZnQoKXh67
P/rcCYlIiH0rbUGWsXmTqQEO2r6Mg2KeIyUyTVem7qHsk1hI6fR6TtqO650AhLaN
0+HFbThC8FnazviR1pPpELK7Obc0AuqYhrTTfSBnjLugkbyuK5dNvaqEh0WE+3Hp
PUzEBO2km0UOqr3rUBfgnDUgzIjpMSSvAdZgd9Nc45fbBjU/Ykq19DrbtvLFIHzc
vBlPI9T+ZqjLCD4IU8Gbr10R+2mlPv9fnrpjSrOcpOVZNxxUY7ko7VcvpzkGNu0l
v/GYfbIS4LFLP53cwE+6iU9sgSImn4+HC+IVNJT7Dghhw/mBek4S9lVR7I1zF0IB
kYNHo3/69SzAJfhvpcm/uarUA5EfPjRMjqu09uiTnWvReVT4CRaQ4W4gDoqxbVJi
DL8ZLPTv04xW5F/HGwGfS5UndYVd6k7elHgKOUerrklhf/50UGVxAYT6CHKD4+fg
fi8w4TkhQ/LRJk0Twc9XsvpojAkh5q3AbWWy7WvNYEyWOfPKfV5S4N/cEE98nrZO
a7jbVa0Xz3RmXKChvHoR
=QeZZ
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
