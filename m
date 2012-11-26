Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab2KZUXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 15:23:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:60437 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112Ab2KZUXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 15:23:37 -0500
Date: Mon, 26 Nov 2012 12:23:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.53
Message-ID: <20121126202334.GA8605@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.53 kernel.

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

 Makefile                                   |    2=20
 arch/m68k/include/asm/signal.h             |    6 -
 arch/mips/Makefile                         |    2=20
 arch/mips/kernel/Makefile                  |    2=20
 arch/s390/mm/gup.c                         |    2=20
 crypto/cryptd.c                            |   11 +-
 drivers/gpu/drm/i915/intel_overlay.c       |   14 ++
 drivers/net/r8169.c                        |    2=20
 drivers/net/sky2.c                         |    4=20
 drivers/pci/setup-bus.c                    |   31 +++--
 drivers/pci/setup-res.c                    |  155 ++++++++++++++++++------=
-----
 drivers/usb/serial/option.c                |    9 +
 drivers/usb/serial/usb-serial.c            |    6 -
 fs/ecryptfs/main.c                         |   23 ++++
 fs/nfs/nfs4proc.c                          |    3=20
 fs/notify/fanotify/fanotify.c              |    1=20
 fs/reiserfs/inode.c                        |   10 +
 fs/reiserfs/stree.c                        |    4=20
 fs/reiserfs/super.c                        |   60 ++++++++---
 fs/ubifs/find.c                            |   12 +-
 fs/ubifs/lprops.c                          |    6 +
 fs/ubifs/ubifs.h                           |    3=20
 include/linux/pci.h                        |    1=20
 kernel/resource.c                          |    7 +
 mm/vmscan.c                                |    2=20
 net/core/dev.c                             |    4=20
 net/core/dev_addr_lists.c                  |    3=20
 net/ipv4/ip_sockglue.c                     |   33 +++---
 net/ipv4/netfilter/nf_nat_standalone.c     |    6 -
 net/ipv6/ipv6_sockglue.c                   |    1=20
 net/netfilter/nf_conntrack_proto_tcp.c     |   29 +----
 net/wireless/reg.c                         |    5=20
 scripts/Kbuild.include                     |   12 +-
 scripts/gcc-version.sh                     |    6 -
 scripts/gcc-x86_32-has-stack-protector.sh  |    2=20
 scripts/gcc-x86_64-has-stack-protector.sh  |    2=20
 scripts/kconfig/check.sh                   |    2=20
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2=20
 security/selinux/netnode.c                 |    3=20
 sound/pci/hda/patch_analog.c               |    1=20
 sound/pci/hda/patch_cirrus.c               |    2=20
 sound/soc/codecs/wm8978.c                  |    2=20
 sound/soc/soc-dapm.c                       |    2=20
 tools/perf/Makefile                        |    2=20
 44 files changed, 330 insertions(+), 167 deletions(-)

Alexander Stein (1):
      ALSA: hda: Cirrus: Fix coefficient index for beep configuration

Andreas Schwab (1):
      m68k: fix sigset_t accessor functions

Artem Bityutskiy (2):
      UBIFS: fix mounting problems after power cuts
      UBIFS: introduce categorized lprops counter

Bryan Schumaker (1):
      NFS: Wait for session recovery to finish before returning

Dan Williams (2):
      USB: option: add Novatel E362 and Dell Wireless 5800 USB IDs
      USB: option: add Alcatel X220/X500D USB IDs

Daniel Vetter (1):
      drm/i915: fix overlay on i830M

Dave Jones (1):
      selinux: fix sel_netnode_insert() suspicious rcu dereference

Eric Millbrandt (1):
      ASoC: wm8978: pll incorrectly configured when codec is master

Eric Paris (1):
      fanotify: fix missing break

Greg Kroah-Hartman (1):
      Linux 3.0.53

Hannes Frederic Sowa (1):
      ipv6: setsockopt(IPIPPROTO_IPV6, IPV6_MINHOPCOUNT) forgot to set retu=
rn value

Heiko Carstens (1):
      s390/gup: add missing TASK_SIZE check to get_user_pages_fast()

Jan Kara (4):
      reiserfs: Fix lock ordering during remount
      reiserfs: Protect reiserfs_quota_on() with write lock
      reiserfs: Move quota calls out of write lock
      reiserfs: Protect reiserfs_quota_write() with write lock

Jan Safrata (1):
      usb: use usb_serial_put in usb_serial_probe errors

Jean Delvare (1):
      kbuild: Fix gcc -x syntax

Jiri Pirko (1):
      net: correct check in dev_addr_del()

Johannes Berg (1):
      wireless: allow 40 MHz on world roaming channels 12/13

Jozsef Kadlecsik (2):
      netfilter: Validate the sequence number of dataless ACK packets as we=
ll
      netfilter: Mark SYN/ACK packets as invalid from original direction

Jussi Kivilinna (1):
      crypto: cryptd - disable softirqs in cryptd_queue_worker to prevent d=
ata corruption

Michal Schmidt (1):
      r8169: use unlimited DMA burst for TX

Mirko Lindner (1):
      sky2: Fix for interrupt handler

Misael Lopez Cruz (1):
      ASoC: dapm: Use card_list during DAPM shutdown

Ram Pai (2):
      PCI : ability to relocate assigned pci-resources
      Resource: fix wrong resource window calculation

Takamori Yamaguchi (1):
      mm: bugfix: set current->reclaim_state to NULL while returning from k=
swapd()

Takashi Iwai (1):
      ALSA: hda - Force to reset IEC958 status bits for AD codecs

Tim Sally (1):
      eCryptfs: check for eCryptfs cipher support at mount

Tom Herbert (1):
      net-rps: Fix brokeness causing OOO packets

Tyler Hicks (1):
      eCryptfs: Copy up POSIX ACL and read-only flags from lower mount

Ulrich Weber (1):
      netfilter: nf_nat: don't check for port change on ICMP tuples

Xi Wang (1):
      ipv4: avoid undefined behavior in do_ip_setsockopt()

Yinghai Lu (1):
      PCI : Calculate right add_size


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQs8/GAAoJEDjbvchgkmk+/h4QAId2JfmQKAkxdbjTn7jw0wMs
OBzfo84RCyNPBilLgQmBaFN5OV4ufrcL5qLa9LgteMKSCaaKTgKGjUecE9A1fYBj
XTmIujcTMtFqUE2nxYnIx+OAixWfTJUG3IGdm8CxG/qwI0LFj6EhNy95KCisgmO5
JzLA1tFbavbzecZtS2g7KWG56hpXgWw2NpLlmy2WBIgZ79cgRElhQ/6Zz3W9++sX
+/oeCNbaWz/FSUOBzdsUeFfCWLPOkxq/HGU1+iV04iVY150A8krNycMYtuIPMRD4
dzZSAETSAJ74SmAqTFjh5POUOPeyZZthty7hGpj7kYB1HAgrgqZh7KfQ3irQ89IU
lTpd9QvPQtfIPc7LrRoiIyL0S021lciFpvwvTBdDYjWwYddhtzFdRmD3HV5HEQ2b
sNbQgzCJ+1Vxaxqzn2ABynb4tTJ9/QfdwHUQqMOUgR940JoRXWxURqmLnvllrlkQ
3lfkB7RqiAPeA20VJU+zj+laodNu6e25Oaau1wmEjhdDp3oEr+GDsSvboXvCrreW
v67KV/89Vrur8eQ/uw37fN7jTyffbkpX7iiHuWkC9kU7evRXCUruP6/1siGrGt5V
3bEOg/V1amUdngU4P3nd0zrSSrRFXGSIbMpbF1rhDI8e3WpAEvbRq2rAKAe5kcAu
9u0/fFXJLE0Cp6zeBpSa
=eCMu
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
