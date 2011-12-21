Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1LUVVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:21:42 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52937 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827Ab1LUVVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:21:39 -0500
X-Sasl-enc: sR5ZXthCj7UODNzzzOThdQzkduRV43x0u0bGwG/1RTEN 1324502498
Date: Wed, 21 Dec 2011 13:21:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.51
Message-ID: <20111221212111.GA15958@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.32.51 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Makefile                                 |    2=20
 arch/arm/mach-davinci/board-dm646x-evm.c |    6 +-
 arch/x86/oprofile/backtrace.c            |   46 ++++++++++++++++++++--
 arch/x86/oprofile/nmi_int.c              |    8 +--
 drivers/oprofile/buffer_sync.c           |   21 +++++-----
 drivers/usb/class/cdc-acm.c              |   10 ++++
 fs/ext4/inode.c                          |    2=20
 fs/hfs/btree.c                           |   20 +++++++--
 fs/jbd/journal.c                         |    8 +++
 fs/jbd2/journal.c                        |    8 +++
 include/linux/log2.h                     |    1=20
 kernel/taskstats.c                       |    1=20
 mm/percpu.c                              |   32 +++++++++------
 mm/util.c                                |   13 ++++++
 net/xfrm/xfrm_algo.c                     |    4 -
 sound/pci/hda/patch_realtek.c            |    2=20
 sound/pci/sis7019.c                      |   64 +++++++++++++++++++++++++-=
-----
 17 files changed, 193 insertions(+), 55 deletions(-)

Andrea Arcangeli (1):
      ext4: avoid hangs in ext4_da_should_update_i_disksize()

David Dillow (1):
      ALSA: sis7019 - give slow codecs more time to reset

Eryu Guan (1):
      jbd/jbd2: validate sb->s_first in journal_get_superblock()

Greg Kroah-Hartman (1):
      Linux 2.6.32.51

Hans Verkuil (1):
      ARM: davinci: dm646x evm: wrong register used in setup_vpif_input_cha=
nnel_mode

Krzysztof Ha=C5=82asa (1):
      USB: cdc-acm: add IDs for Motorola H24 HSPA USB module.

Linus Torvalds (2):
      linux/log2.h: Fix rounddown_pow_of_two(1)
      Make TASKSTATS require root access

Phillip Lougher (1):
      hfs: fix hfs_find_init() sb->ext_tree NULL ptr oops

Robert Richter (4):
      oprofile: Free potentially owned tasks in case of errors
      oprofile: Fix locking dependency in sync_start()
      oprofile, x86: Fix nmi-unsafe callgraph support
      oprofile, x86: Fix crash when unloading module (timer mode)

Takashi Iwai (1):
      ALSA: hda/realtek - Fix Oops in alc_mux_select()

Tejun Heo (1):
      percpu: fix chunk range calculation

Tushar Gohad (1):
      xfrm: Fix key lengths for rfc3686(ctr(aes))

Xiao Guangrong (1):
      export __get_user_pages_fast() function


--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO8k3HAAoJEDjbvchgkmk+U3EP/3nS+4w9TLPlQAljOwkcblb/
hBHIOTDG2uXybqNJzuWK8vtVYLTpttOKHoY3B62o0/1WRja0Btk+Wu4d4IdBqHBa
D+hH6ht47Ey3g0ZE8Z7J1/kxJg/Y2JYG4mxaeOl775krYvINRMeG7WX7OoO0U27D
NK/7uqF7q60V8wv/OXcMB9RrQ6X8KPUNU1B7SkEWR4zIWuwdMzpQaKtYPmqBjsBI
uGeG4/tJqlDCz24Zh8fKcJ15SSJMmzb6tQrk6D07bDVwl7gHHM2QG8a80jJHwdjc
fWn0Kq3ebNW1TOvvFYHuBmZQRWzucBDCaBqd872pNQQEHL+0+vs8f0ZRUQMjTOGM
nKdsrK4oNdoIBG9hwDi3Bnvh7nH3zkp6KbYewTQ5xfYZ4pJ1SxM1eBQFMxEUY3n+
dKoE08w2ZfYajAc6Q0KuTS9IosihsL5UwTQsFU2/igY9UknudEbIdqH/vFd29fpy
P3fbkFTrWjkBbNauxbjxc4F+506imDeleUYSo1GwAs9lIgZsM+U2AKJsctENNTfD
9OBQAxymklpeHrVZCl0f+2G2QKNrD4fr1zdwTU/jenWFiwHu5GuiXQ+YvHJAQJes
+owb2zJaYxJTtD7O2aZItVsUCSfd3zt5nkyOa68Om46QITcoUAyjzoNWSICZtE91
F9VkOlziX1wglpRpgp9a
=NiJ+
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
