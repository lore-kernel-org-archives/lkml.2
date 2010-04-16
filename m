Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab0DPVHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 17:07:53 -0400
Received: from diva.malsain.org ([91.121.19.57]:54634 "EHLO diva.malsain.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757825Ab0DPVHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 17:07:52 -0400
X-Greylist: delayed 1604 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Apr 2010 17:07:51 EDT
Subject: Athlon L110 CPU and powernow-k8
From: Josselin Mouette <joss@debian.org>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EF4CXaHGSsb9bkCW3CLZ"
Date: Fri, 16 Apr 2010 22:40:58 +0200
Message-ID: <1271450458.6794.33.camel@tomoyo>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EF4CXaHGSsb9bkCW3CLZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have a Packard-Bell Dot-M/A which is based on an Athlon L110 CPU, and
I noticed that powernow-k8 does not recognize this CPU=E2=80=99s frequencie=
s,
which leads to an insane power consumption, leaving it at 1,2 GHz
permanently.

The Gateway LT31, based on the same CPU, has the same issue, as reported
Krists Krilovs: http://www.pow.za.net/

In both cases, the issue is the same: the DSDT table provided by the
BIOS does not include the P-states. Waiting for a hypothetical BIOS
update that would fix this bug requires some faith that I don=E2=80=99t hav=
e. It
is possible to work around this by compiling the kernel with a custom
DSDT table with appropriate P-states patched in, however I consider this
a developer hack. (Krists Krilovs has the patched DSDT for the LT31, and
I can provide the one for the Dot-M/A upon request as well - I used the
same P-states.)

I wonder what is possible to do to support this CPU correctly in the
kernel. The only sane solution I can think of is to hardcode the
P-states for this CPU model in the powernow-k8 driver itself.=20

I=E2=80=99m quite a newbie when it comes to ACPI, but I can provide any
information that could help to fix this. If you think it=E2=80=99s feasible=
 by a
random hacker, I can also have a look given the correct pointers.

Cheers,
--=20
 .''`.      Josselin Mouette
: :' :
`. `'  =E2=80=9CIf you behave this way because you are blackmailed by someo=
ne,
  `-    [=E2=80=A6] I will see what I can do for you.=E2=80=9D  -- J=C3=B6r=
g Schilling

--=-EF4CXaHGSsb9bkCW3CLZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBLyMtYrSla4ddfhTMRAqy9AKDYqyO6ifn2AfHRUxoaqZtPd1Em5gCggL1r
xvkAqmIP1Zq3UA+VAj24G7Q=
=ExS5
-----END PGP SIGNATURE-----

--=-EF4CXaHGSsb9bkCW3CLZ--

