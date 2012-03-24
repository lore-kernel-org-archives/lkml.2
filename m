Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2CXQxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:53:16 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51929 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2CXQxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:53:15 -0400
Date: Sat, 24 Mar 2012 12:48:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: JBeulich@suse.com
Subject: [GIT PULL] (bugfixes, xen) for for-3.4/drivers
Message-ID: <20120324164845.GA7940@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F6DFBF5.005A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Jens,

I've two small fixes for the xen-blkback - and I think one more will show up
eventually (a partial revert), but not sure when. So in the spirit of keepi=
ng
the patches flowing, please git pull the following branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git  stab=
le/for-jens-3.4-bugfixes

which is based of your for-3.4/drivers, git commit bc67f63650fad6b3478d9ddf=
d5406d45a95987c9
Stephen M. Cameron (1):
    cciss: Fix scsi tape io with more than 255 scatter gather elements
   =20
and has the following two commits:
Konrad Rzeszutek Wilk (2):
      xen/blkback: Squash the discard support for 'file' and 'phy' type.
      xen/blkback: Make optional features be really optional.

 drivers/block/xen-blkback/blkback.c |   19 +++----
 drivers/block/xen-blkback/common.h  |    6 --
 drivers/block/xen-blkback/xenbus.c  |   89 ++++++++++++-------------------=
---
 3 files changed, 40 insertions(+), 74 deletions(-)

Thank you!

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPbfW3AAoJEFjIrFwIi8fJWC8IAJD09I29yPT33XmcLancDu4s
jbMliq9BW0qM3DiuTPIe7BdtYQ1uEs3PIxeRA6JSim49T2VD2/F1ewoYqXF+/Y6k
Y4Tn0YbWInBaiajJmS3uzr2k1ROxqw3oC9BiAb7BQtqfJAblL0m2kzzLE81Cpmhc
J9SxSO1RPbG5/MxnSIcguz8+lmDKv7gPGqnprAPNld8YGSQFqZC49TT+ZA6ajX5x
s+3Ex6kczfmXpIsgWL1G7dQSKmej9cdYWIrGlbQ7kWuIwQCq74FCGidEZzWyjzh8
EHzhnU/z3UZsXL50ZTWe3O602tsK+MTrUTP2HtgLUxrSQAai8/IiUFQLNEW9Ag8=
=syu9
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
