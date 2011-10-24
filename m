Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab1JXNOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:14:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:50212 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab1JXNOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:14:51 -0400
Date: Mon, 24 Oct 2011 08:56:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: olaf@aepfle.de, ruslan@rpisarev.org.ua
Subject: [GIT PULL] (xen) stable/cleanups-3.2 for Linux 3.2-rc0
Message-ID: <20111024125620.GC19100@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4EA56315.008B:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please pull the following branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/cleanups-3.2

which has some exciting merge conflict patches. These patches are based on
git commit 8ded371 (Merge branch 'for-3.1/drivers' of git://git.kernel.dk/linux-block).

They are patches mostly created from running scripts/checkpatch.pl and fixing things up.
They also cause merge conflicts: git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen linux-next
has the resolution of that - but it should be fairly easy to fix it up.

Please pull!

Olaf Hering (1):
      xen: use static initializers in xen-balloon.c

Ruslan Pisarev (6):
      Xen: fix whitespaces,tabs coding style issue in drivers/xen/balloon.c
      Xen: fix whitespaces,tabs coding style issue in drivers/xen/events.c
      Xen: fix braces coding style issue in gntdev.c and grant-table.c
      Xen: fix whitespaces,tabs coding style issue in drivers/xen/pci.c
      Xen: fix braces coding style issue in xenbus_probe.h
      Xen: fix braces and tabs coding style issue in xenbus_probe.c

 drivers/xen/balloon.c             |   15 +++++++--------
 drivers/xen/events.c              |    9 ++++-----
 drivers/xen/gntdev.c              |    3 +--
 drivers/xen/grant-table.c         |    2 +-
 drivers/xen/pci.c                 |    4 ++--
 drivers/xen/xen-balloon.c         |   17 ++++++++---------
 drivers/xen/xenbus/xenbus_probe.c |    7 +++----
 drivers/xen/xenbus/xenbus_probe.h |    3 +--
 8 files changed, 27 insertions(+), 33 deletions(-)

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpWB0AAoJEFKFlzJcLqlY1D4P/jl71mFzoNCQICOxBtW4AE/p
PwwHn3fHw9YImIu4uDYudsPusQV0bAweLrQYFH8svMWUVRS4tiXa9erFOTqg3p8E
nkr7vpfZHzJlVV8XxJbwCzQfBf8RAqOF5J20sOtP0PzcuVTNCEiRKbzXcXwiPkJW
tDVRs3ZYeduCMcjCk+DBy/Yt3TwMFf2x+IAOOXlnI1YfuFUN/Dt64ZZQbuYUTRO3
qQYMc5Zpj5MNKcgHshF46w18j7C7lLI+Be2rV4aW5scyLNaUqFa1bVADm4D19TV/
I3o/BWmfqtWJjSZ0CNxEq5pRFDtde+5kpgpA4zXDtBJy62iIkFGEOzpR+wC/aKKH
4ZCjGf/MXYmy20f9lnjSIyKvDzEikxg8hBVhZ1+r16zXXyzvZvzGjplY7JFXA2LX
kJDQdwYWYwsyQVGY+kSbj6kLyBFlLyC0O/N2yKCMeuXwwrxC99sctPaYqPf6C103
O6u95OTLDj3cCawnykxVe7/rdbj/laqPyBopPEpW3RQZEq/epmTXXG6H81NRH830
L6ZSvWr1VH1nfvzcM1r1sKUptGlVV4F1GJ2CXj7uMQzbl3GGJbS/L1N8rRZpShGZ
fa592aeOHJAYom+B0eh6fLxKO+cN1ZeSs0PmIRRU6unzveFe4afJ3PbEHZJN3TMD
W58DaD+EA/pcTNDVzDGd
=FIlR
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--
