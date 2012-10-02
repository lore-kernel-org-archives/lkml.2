Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2JBODJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:03:09 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42141 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab2JBODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:03:08 -0400
Date: Tue, 2 Oct 2012 09:51:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (frontswap) stable/for-linus-3.7-tag
Message-ID: <20121002135136.GA15917@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git stable/for-linus-3.7-tag

which has one tiny feature used by one backend (ramster) and a couple
of fixes.

Please pull!

Dan Magenheimer (1):
      frontswap: support exclusive gets if tmem backend is capable

Konrad Rzeszutek Wilk (1):
      mm: frontswap: remove unneeded headers

Seth Jennings (1):
      mm/frontswap: fix uninit'ed variable warning

Wanpeng Li (1):
      mm/frontswap: cleanup doc and comment error

Zhenzhong Duan (1):
      mm: frontswap: fix a wrong if condition in frontswap_shrink

 include/linux/frontswap.h |    2 ++
 mm/frontswap.c            |   34 ++++++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAEBAgAGBQJQavFkAAoJEFjIrFwIi8fJNrQH/RWoMDesiNzLsmaaeCO5zLH0
9X8u5Q5N7L99kUSdfUaU8FODbAR9+w62dbt0VfhkrdYIW2P34EJMvfno1c+SAPrB
yVg1wkJtfAhppRUQvHajzoEl/SM1DdQruV/k7LD2aSx7Y8RvvDiz4VVqglS9Ex6T
nghBtj9JVKMA7l+XR1fU4TeTmTvTmtQ90b24A1ByYN/lfT0zQrnk2OsmGz0lt9Ho
lurkduoRVbP4KtMCReCU+V/6E+brGsJFOHqu6eVpp8kkAcQ6RWCTj4vgyzThApGY
WGOim1DlnaIeH07zs4Ul4fWIjvIRPzmmVnkJghckxHBNIEkY1Cj8veHFDTkKLaE=
=m/Fy
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
