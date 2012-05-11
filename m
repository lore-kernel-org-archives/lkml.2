Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060Ab2EKVL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:11:26 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43351 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab2EKVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:11:25 -0400
Date: Fri, 11 May 2012 17:05:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-jens-3.5 for your for-3.5/drivers branch.
Message-ID: <20120511210517.GA29181@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Jens,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.5

in your for-3.5/drivers branch. The changes in it are rather simple - cleaning
up some code and adding proper mechanism to unload without leaking memory.

 drivers/block/xen-blkfront.c |   44 +++++++++++++++++++++++------------------
 1 files changed, 25 insertions(+), 19 deletions(-)

Jan Beulich (2):
      xen-blkfront: properly name all devices
      xen-blkfront: module exit handling adjustments

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPrX8JAAoJEFjIrFwIi8fJQdYH/iTa44tNMNWktyDOOkrRLpYc
6igh0iZTwVXs8zVuL9vqYGqrMiawXZpyMuemQVJRE9qLkSzy58BZsOY1Fmf5d0tI
7MSric9w0wg7A6xE2h4z0r641rLo1BtwcCNI+nqC4oBS1DXSzamliCysRKr7qH3Q
GqwPX/E6lXI8duUCxu39vZgJAkMoXYNBjbZ4isXo8UE6J4dlcgbBE5cTzAtySH0U
9Wqz6QU1IsfJGE/2etYc4rYwRXTTdmtxcCX8bRNpyObvsGlLyiSaa3vgpFiVy8FC
zmQf6HhQZeHWihjBKTPzrElmYcghlqK7ObLHpHLWBopowY8y9U8Iy2GJTHZpJjM=
=0xDr
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
