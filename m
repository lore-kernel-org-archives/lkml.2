Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239Ab2JANiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:38:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab2JANiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:38:03 -0400
X-Authority-Analysis: v=2.0 cv=WKj9rwQR c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ryrs6W6k5W4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kO2SeoYvgLQA:10 a=VwQbUJbxAAAA:8 a=LgbLIiRoEce-g8Y5PDEA:9 a=QEXdDO2ut3YA:10 a=y3OXxtZUb9NDqmw4rPkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121001133055.594443758@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 01 Oct 2012 09:30:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 0/4] [GIT PULL] localmodconfig: clean ups and fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Linus,

Bill Pemberton added some changes to make streamline-config.pl
work again as a stand-alone tool (outside of make localmodconfig).

Also, he added a couple of updates to make the code be more
"Perl proper".

*Note* I changed the gpg subkey that I use to sign with because the
old one is about to expire. You may need to refresh my key to
get the new subkeys.

Main key which you should have:
  5ED9 A48F C54C 0A22 D1D0  804C EBC2 6CDB 5A56 DE73

Old subkey (expires tomorrow):
  C66DAA00

New subkey:
  71B30B4C

Please pull the latest localmodconfig-v3.7 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig.git
localmodconfig-v3.7

Head SHA1: 88050b21c2ca96aff36dc2cb1f29ee72d0a70fe6


Bill Pemberton (4):
      localmodconfig: Set default value for ksource in streamline_config.pl
      localmodconfig: Rework find_config in streamline_config.pl
      localmodconfig: Use 3 parameter open in streamline_config.pl
      localmodconfig: Use my variable for loop in streamline_config.pl

----
 scripts/kconfig/streamline_config.pl |   48 ++++++++++++++++--------------=
----
 1 file changed, 22 insertions(+), 26 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQaZy2AAoJEOdOSU1xswtM7m4H/3LJHpoly1uetgV9NpbpNuTG
4ZpIRMDAkcPhlNkqQCvftO00dLoEqXWHqAN3d4cY8qyDa+DPXEH/VZGlZS6LWCjT
DY8257wpFN7sVGNgoOJuaLVKX8CdTtGR0StzTtxLypNqBi4l5VIxKU0cXK9wk4nL
eCGU4ZWXHsGaw0GeRWs7LHdKhqBjRr7OAM1a2tTvJl37EaqhKHRRZm7o3pSq18+O
BNNAbJcUj9jodpD2YRRjdDkjf56MZUOl3g2qIk4INWMsK3KDVOBXHqNWTvf67HBT
fvXJJPMaRdEVRXLoG/OksrNoCURHiOX8CTQgdGqMYeBwRJsVQqkke5wAV3uxt34=
=fvme
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
