Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2GWPj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:39:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27243 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2GWPj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:39:26 -0400
Date: Mon, 23 Jul 2012 11:29:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: minchan@kernel.org, levinsasha928@gmail.com, liwp.linux@gmail.co
Subject: [GIT PULL) (frontswap) stable/for-linus-3.6-rc0-tag
Message-ID: <20120723152932.GC21870@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please git pull the following tag:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git stable=
/for-linus-3.6-rc0-tag

which has cleanups in the code and in the documentation. Also a bit of refa=
ctoring
is done. No functional, bug-fixes or features added.

Note: Earlier I had a feature to add tracing but one of the reviewers did n=
ot like it so
I pulled the patch out a couple of days ago and was going to restart the de=
bate on it.
But instead of using revert I rebased  - and fixed up the conflict..  and e=
nded up
committing the patch that had a conflict with me as the author instead of S=
asha
(this is the "mm: frontswap: remove unneeded headers")!

I realized this just today when I was prepping this email up and fixed it u=
p - hence the git=20
tree looks fresher - but the change was just to do 'git commit --ammend --a=
uthor..'

That teaches me to play with 'git rebase' instead of doing 'git revert' as =
you had
been rightfully pointing out <sigh>.

 Documentation/vm/frontswap.txt |    4 +-
 mm/frontswap.c                 |  150 ++++++++++++++++++++++++------------=
----
 2 files changed, 92 insertions(+), 62 deletions(-)

Sasha Levin (9):
      mm: frontswap: remove casting from function calls through ops structu=
re
      mm: frontswap: trivial coding convention issues
      mm: frontswap: split out __frontswap_curr_pages
      mm: frontswap: split out __frontswap_unuse_pages
      mm: frontswap: split frontswap_shrink further to simplify locking
      mm: frontswap: make all branches of if statement in put page consiste=
nt
      mm: frontswap: remove unnecessary check during initialization
      mm: frontswap: split out function to clear a page out
      mm: frontswap: remove unneeded headers

Wanpeng Li (1):
      mm/frontswap: cleanup doc and comment error


--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQDW3YAAoJEFjIrFwIi8fJb7kIANVKWQr+GfBSmLhb2NUk9XE+
uLe5M5a2ewRAngvFTi7g/SlzRnbHQUZi7jY8hmO6aFelDtxZQTdPfxkuMHCpkTiz
v4ez+P8KNKHpMs5BM9AidggXAxeYLXP3IpQ8HgnysO/GVJXzKxzxWadJrRiq1toc
a2KKX05dHXqft8wFC+NKj93TvrKanVInp6fMkUToRN8U5nL8KUrQ/vygV/0Vj17C
hkZD0MCyqlkd9OSPnEVofUaIwEOH06hG/OMWwduKmh9BRmI9eZTv0xFWIKlipfWP
nZ+kAAMSblMejS2oMRpRvyJPY5KAlGFpT5OIRDoitJTY2cJJfosDTbpipJTt9Qs=
=GPqs
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
