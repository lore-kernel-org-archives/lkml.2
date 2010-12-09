Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab0LIDDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:03:36 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58848 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab0LIDDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:03:35 -0500
Date: Thu, 9 Dec 2010 14:03:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>
Subject: linux-next: build failure after merge of the slab tree
Message-Id: <20101209140325.bec98c5c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Dec_2010_14_03_25_+1100_NJvUOVig.E3n6YIB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Dec_2010_14_03_25_+1100_NJvUOVig.E3n6YIB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the slab tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

lib/built-in.o: In function `.zlib_inflate_blob':
(.text+0x8640): undefined reference to `.kmem_cache_alloc_notrace'

This build failure went away when I removed the lib directory from the
object tree and rebuilt.  So I guess we have an unexpressed dependency.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Dec_2010_14_03_25_+1100_NJvUOVig.E3n6YIB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNAEb9AAoJEDMEi1NhKgbsieAH/2DhG8jceMbmdeVPONKdlYha
6yXxsHYTNRkfvlva7bAkN8trV+rXVO68FsuIbIFflaOtYbXScWBcXIGEEncCqkKM
Ud4tJM81Jb7dZP82bO5YJlPZgRf+L+BMkT9XhR/ySENV3M4xkaY/s+HHqrFbw4cK
2oO8GNCeKf83A84w4IPk0cSNvS+1NHmLF9BXiU7uTCiya6ZAkBhsLA4aNqiZwLy3
7UDfO6Kq+D8tBbBgHCO9Quf2LohwP3bX9lP/2y8vcDf+tvd71z9zimZeHdPTEalK
l5rMn2p1j/zJLSJPRS/gacKPs4I+2Puiy4o4/SPJqepC5BQEbvtLn7evmwlBztA=
=clvF
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Dec_2010_14_03_25_+1100_NJvUOVig.E3n6YIB--
