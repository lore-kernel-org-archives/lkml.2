Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab1JXPDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:03:54 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:31628 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab1JXPDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:03:53 -0400
Date: Mon, 24 Oct 2011 11:03:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david.vrabel@citrix.com
Subject: [GIT PULL] (xen) stable/e820-3.2 for Linux 3.2-rc0
Message-ID: <20111024150339.GA2320@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4EA57E54.00C5:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please git pull the following git branch:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/e820-3.2

wherein:

#stable/e820-3.2 is based of git commit d93dc5c (Linux 3.1-rc7):
and removes a lot of the old E820 parse code to a) make it easier to unders=
tand,=20
b) working properly when ballooning, and c) removes lots of code!

David Vrabel (5):
      xen/balloon: account for pages released during memory setup
      xen/balloon: simplify test for the end of usable RAM
      xen: allow balloon driver to use more than one memory region
      xen: allow extra memory to be in multiple regions
      xen: release all pages within 1-1 p2m mappings

 arch/x86/xen/setup.c  |  284 +++++++++++++++++++++------------------------=
----
 drivers/xen/balloon.c |   50 ++++++----
 include/xen/page.h    |   12 ++-
 3 files changed, 165 insertions(+), 181 deletions(-)

--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOpX5LAAoJEFKFlzJcLqlYZpkP/3AR1SgQ4rdWF/Iv97gZz7XA
u56f5QLva27fAwpJmqvY8RR7+LpPXf9hL0PcVA8vg2f8tvhtuCJ1dBauL4pmD3y7
gNlutHw081ouIv32GpsrbEMQaso2fEJ4UqdVoOF9m2kbMBwIJtfPz5Bhwc5dDx4i
X/+jnEyBJ3AEvgmolGOij9SqqDtKz+LKNwpVC1vU96rPVRjqYSEPOf/K0RsTwQ5o
fwGxvBBp0i9CcEy02XVzirwmDuvS7zi4lDKQM8NcQqe214sB++fHgzG+e8WEXxm4
jdRlsCULNOL/xQYfjaYSYAinLz4zLin892Pxb53icuSD6zYQJgzatPB8IShULPYb
4qcFWW18XhNOtmr02u5KNgJNvzIj48F8BeEwJeT9zqt+QyigR1p/hUoqtcQsdPs6
TX0Y4cqjDB+q65StjNdycguSUnPvKhIhjFN/8omvd8kTkhd1CwkK99oD810W6fbl
i6eYVnszfESrGZQPIjWP2oCVWaQt71Dp7FUu9TXftSQ5+oE2hUl6djYW7WMF4cX7
VnxWU+NXP3xnbv4kuGwVN53idBmXRmP57nbdlsrpjc1P+kW0otXkh+/N4p8eHyMr
xMvWVqZ3iKqGEp/FBI3O0XRZPCXXqTAJFkAfet95+eNV53zCeFnyretx+4rsMsEo
vE0S/EOmJ2qDmgCdJGZM
=bg9b
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
