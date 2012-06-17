Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076Ab2FQS37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:29:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50699 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572Ab2FQS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:29:55 -0400
Date: Sun, 17 Jun 2012 11:29:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.35
Message-ID: <20120617182951.GA8982@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.35 kernel.

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

 Makefile                                   |    2 -
 arch/powerpc/kernel/module_32.c            |   11 ++---
 arch/x86/crypto/aesni-intel_asm.S          |    6 ++-
 arch/x86/kernel/cpu/mcheck/mce_amd.c       |   55 +++++++++++++++++++++++-=
-----
 drivers/acpi/video.c                       |    5 +-
 drivers/char/agp/intel-agp.c               |    1=20
 drivers/char/agp/intel-agp.h               |    1=20
 drivers/hwmon/fam15h_power.c               |    8 ++--
 drivers/net/can/c_can/c_can.c              |   16 ++++----
 drivers/net/can/c_can/c_can.h              |    1=20
 drivers/net/e1000/e1000.h                  |    2 +
 drivers/net/e1000/e1000_main.c             |   18 ++++-----
 drivers/net/usb/sierra_net.c               |   14 +++++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |    2 -
 fs/fuse/dir.c                              |    1=20
 fs/fuse/fuse_i.h                           |    3 +
 fs/fuse/inode.c                            |   17 ++++++++
 kernel/sched.c                             |    9 +---
 lib/btree.c                                |    4 +-
 mm/hugetlb.c                               |   29 ++++++++++++---
 mm/vmalloc.c                               |   11 +++--
 net/mac80211/iface.c                       |   12 ++++++
 net/mac80211/offchannel.c                  |   16 ++++++++
 net/wireless/util.c                        |   19 +++++++++-
 24 files changed, 195 insertions(+), 68 deletions(-)

Alan Cox (1):
      acpi_video: fix leaking PCI references

Andre Przywara (1):
      hwmon: (fam15h_power) Increase output resolution

AnilKumar Ch (3):
      can: c_can: fix "BUG! echo_skb is occupied!" during transmit
      can: c_can: fix an interrupt thrash issue with c_can driver
      can: c_can: fix race condition in c_can_open()

Bj=F8rn Mork (1):
      net: sierra_net: device IDs for Aircard 320U++

Borislav Petkov (1):
      x86, MCE, AMD: Make APIC LVT thresholding interrupt optional

Dave Hansen (1):
      hugetlb: fix resv_map leak in error path

Dean Nelson (1):
      e1000: save skb counts in TX to avoid cache misses

Dimitri Sivanich (1):
      sched: Fix the relax_domain_level boot parameter

Emmanuel Grumbach (1):
      iwlwifi: don't mess up the SCD when removing a key

Eugeni Dodonov (1):
      char/agp: add another Ironlake host bridge

Greg Kroah-Hartman (1):
      Linux 3.0.35

Johannes Berg (2):
      mac80211: clean up remain-on-channel on interface stop
      cfg80211: fix interface combinations check

KyongHo (1):
      mm: fix faulty initialization in vmalloc_init()

Mathias Krause (1):
      crypto: aesni-intel - fix unaligned cbc decrypt for x86-32

Minchan Kim (1):
      mm/vmalloc.c: change void* into explict vm_struct*

Pavel Shilovsky (1):
      fuse: fix stat call on 32 bit platforms

Roland Dreier (1):
      btree: fix tree corruption in btree_get_prev()

Steffen Rumler (1):
      powerpc: Fix kernel panic during kernel module load


--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJP3iIfAAoJEDjbvchgkmk+4OsP/31fa2nRR1w3+PPMjxcoTu6L
JFcs02jFnRgcn9JzMermzinE4XRTMpzGsY7LrT01e0SQlVnMKaukkWEjhdSMqzQ8
ZCDXdSpSxg3UdjQG7tXomTsDuif0DrV7fw5yxG+tPOAmsJoP1gdD74MrD3SsM7mt
4lnFwxKnMcxbfNxye39sYVQvJUBE6atTRwkuGA62iNuRJwufHB7jGmH+jSE8owqp
3OM9uqvDI5Q2+Ct4LRtHdiZGbF5M/dUtBB0dOY5rDmt8WA0NVdhQIKXH+DdhSnlW
yf9ywjOAfVlMo0o77ZXWW4Y+7/7IX5kptaHULSGGQxmI7ec7sshzKTod+9IGL1Pp
w0/d7R2mgk27N6bl/zoG4enacmVb3IK66tBdC3HQs9U9oi60bmWrUsMx5CDUGzj+
rP5XUgpd2w4AqKNIXYEquRdSlrmW+BZnhcYNw0rHplR6TmDry+PZZ6wPwaE8H3Jx
SlK9WEcp8+m3pAwNnYKmrOAvspPrUyGqcYhHKVvLlQGDu9YNKuzdgpdDmqMfzqzm
O7vCmAMbTWqA8t95QXIKtrgEsCO+FsEYx4k/Kw25/72BuvJbSpTt61/Iy8j9Z9ul
jqbha2aID7FqB4QSog7AGNXsAkvyK3aZUVsAokoBajj933gJJY/pzTAIkA+j3xUo
g70DuY8AvuA4P+cE57Hg
=bBhK
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
