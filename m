Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422682Ab2JLN5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 09:57:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:43032 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab2JLN53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 09:57:29 -0400
Date: Fri, 12 Oct 2012 09:45:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.7-uapi-tag for v3.7-rc0
Message-ID: <20121012134529.GA1560@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-3.7-uapi-tag

which has the UAPI disintegration work done by David Howells.

Please pull!

 include/uapi/xen/Kbuild    |    2 +
 include/uapi/xen/evtchn.h  |   88 +++++++++++++++++++++++++++++++++++++++
 include/uapi/xen/privcmd.h |   98 ++++++++++++++++++++++++++++++++++++++++++++
 include/xen/Kbuild         |    2 -
 include/xen/evtchn.h       |   88 ---------------------------------------
 include/xen/privcmd.h      |   98 --------------------------------------------
 6 files changed, 188 insertions(+), 188 deletions(-)

David Howells (1):
      UAPI: (Scripted) Disintegrate include/xen


--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQeB71AAoJEFjIrFwIi8fJSwoH/Akc2Xbe7KNox4qsrIcpCFdm
QBsdNbH/VCU5IToc7hPpjobD2Zt/JDCjUNFpVwnxjUAQLfqgAvu/ifceFJVQS5zy
YCpuyqcknThVaRvfonx7sp/omXKm9XIQiGAnUGs8XscSP8x6SZlYCD1NxbtiZdY+
dSleBgcPaoW2fVmEqQVp11F5UOOeMeJ9HdWcemd3VcmL9r+73nbOTHWQwX+V+jgj
FFi/ZDdvIywwi7Z/I5FuijtxeWbE6xd+kfsf+gUwb2DUE8SZPV7rE2VApi5N5vEr
tqd0pNCHy0IW8qWRpO0cMtB0vbmYd5Yyg+YlMphMQoSPaJ32VAVOI9eLBHuUFNA=
=y67z
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
