Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab1LTSgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:36:37 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:60336 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1LTSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:36:32 -0500
Date: Tue, 20 Dec 2011 13:35:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: sandr8@gmail.com, stefan.bader@canonical.com, Ian.Campbell@citrix.com,
        Olaf Hering <olaf@aepfle.de>
Subject: [GIT PULL] (xen) stable/for-linus-fixes-3.2 for 3.2-rc6 (a revert)
Message-ID: <20111220183523.GA8534@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4EF0D5AA.0046,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull this branch:

git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-fixes-3.2

which has a revert for a kexec feature (where a guest could now properly
kexec as an HVM guest) that causes the Linux kernel to not boot under
Amazon EC2 anymore. The runway is quite short and with the holidays we
won't be able to fix this so reverting the feature is the only way.

Thanks!

 drivers/xen/xenbus/xenbus_xs.c     |   13 -------------
 include/xen/interface/io/xs_wire.h |    3 +--
 2 files changed, 1 insertions(+), 15 deletions(-)

Konrad Rzeszutek Wilk (1):
      Revert "xen/pv-on-hvm kexec: add xs_reset_watches to shutdown watches from old kernel"


--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJO8NVmAAoJEFjIrFwIi8fJ5xsIAM0BXHCKBoATUGXrHXFnsm39
HMk/9JldjKdFLF/tEG1ffxvbmgxmDmv1mqcI02SP9sfZK2ECw921oiuJApiHkM/2
7tlknh477Oyh65/D+W3LoMTvuqNIy5RaI919xwDdPbLAwwp8tsGjWKv+gJd1x0Wo
/Sz1QmyirKaE2Noa6lTdPY6nBzKbUv8aG3hFBwrKwkratp/VwiCdcsJQV0qSh2Q3
oWkl16HNcnEAc5mJIJllU7Hv8IeENEH9gvtmZ6Wqh7FkOlm4uxAiNhno/+n08N4N
oBLqPd/lyGy7dONUUEEhpEwRnTReP8lqKxTVgGxjD3KIkV0xr0H8z0veIMX0xto=
=R/hO
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
