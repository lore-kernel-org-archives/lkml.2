Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3ACMxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:53:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab3ACMxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:53:07 -0500
Subject: GFS2: Pull request (fixes)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rAmh7tKyjXQVNr7Vkxq2"
Organization: Red Hat UK Ltd
Date: Thu, 03 Jan 2013 12:28:40 +0000
Message-ID: <1357216120.2696.22.camel@menhir>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rAmh7tKyjXQVNr7Vkxq2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Please consider pulling the following GFS2 fixes,

Steve.
---------------------------------------------------------------------------=
------------------------

Here are four small bug fixes for GFS2. There is no common theme here
really, just a few items that were fixed recently. The first fixes
lock name generation when the glock number is 0. The second fixes a
race allocating reservation structures and the final two fix a performance
issue by making small changes in the allocation code.

---------------------------------------------------------------------------=
------------------------

The following changes since commit 4a490b78cb7e0e5efa44425df72a9fedc1c36366=
:

  Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2=
012-12-30 10:00:37 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes.git ma=
ster

Abhijith Das (1):
      GFS2: Fix race in gfs2_rs_alloc

Bob Peterson (2):
      GFS2: Stop looking for free blocks at end of rgrp
      GFS2: Reset rd_last_alloc when it reaches the end of the rgrp

Nathan Straz (1):
      GFS2: Initialize hex string to '0'

 fs/gfs2/lock_dlm.c |    1 +
 fs/gfs2/rgrp.c     |   35 ++++++++++++++++++++---------------
 2 files changed, 21 insertions(+), 15 deletions(-)


--=-rAmh7tKyjXQVNr7Vkxq2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ5Xl0AAoJEMrg3m4a/8jSmecQAIJx/ajHTfMgVmUjpzU4Ehnp
kz7hNpiP3rLrXBf8Vsuf1Nlq/dgop7W1WrAK6BT42B/6SOxfWzqMz0WJnXGd/qa1
WcA9GUy5SMNlGu6apu939vQZYskxA8LfnI6kVp4qwuowI2A/L4YtOiX11JikBShr
W9UrkEmeu4jxiTvU/Oxon56C1SXRz8LTovD+V3at8A0seT3CPjl05N7wEckfOxF9
Va2cVaCleZJUaSa/Etk9BhtBSdoAGeshZJA+Sy4HVOtb3ZpcPrwjLwH1TiMYHD9+
9rNSei5L/dKFG99wV4rCX83hPMZZZ+8dafeWuCz6dMZLhgrXieaDvyVffPDvdEPt
lDWDmOAD7AqB6EjjPzln9CWkJMrfjoFiJJAXADq9Xpc5EUztEh+wMyLeHqQB2ny9
7yrtgrPkcwAhla6ryPmp1JDC1YGpGNb92dyN+kOVkTi/FyHLTublTm9BaXUimytd
XCm0RsWxk/P6yhvUGfRgvLrllh3rrJTFMffFrRY8ovS3PJGZRwkXzYxOrhKZto0R
gbaJOQ85V7r6/JZswmG90TDy8+SUl+JQLOtWdPlPbUqnm+CwpRw+Iy1vmJnh5rJN
dwqG8ivPMyoqlmm1qDsZ5Qe6Nja+A/Bh86GPs5E3oOiMzTg2MzUzhY8lF9S7ZdEc
dZSrEyMLuE83SRSYEc0H
=iPNE
-----END PGP SIGNATURE-----

--=-rAmh7tKyjXQVNr7Vkxq2--

