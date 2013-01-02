Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab3ABCj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 21:39:58 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:38075 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3ABCj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 21:39:56 -0500
Date: Wed, 2 Jan 2013 13:39:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Bill Pemberton <wfp5p@virginia.edu>
Subject: linux-next: manual merge of the drivers-x86 tree with the
 driver-core.current tree
Message-Id: <20130102133946.e384e5c4bfd7e2d529ed0937@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Jan_2013_13_39_46_+1100_nKItrdkXfwSgj1Dc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jan_2013_13_39_46_+1100_nKItrdkXfwSgj1Dc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got conflicts in
drivers/platform/x86/apple-gmux.c, drivers/platform/x86/compal-laptop.c,
drivers/platform/x86/fujitsu-tablet.c,
drivers/platform/x86/ideapad-laptop.c,
drivers/platform/x86/intel_oaktrail.c and
drivers/platform/x86/toshiba_acpi.c between commit 7264eabec580
("Drivers: platform: x86: remove __dev* attributes") from the
driver-core.current tree and various commits from the drivers-x86 tree.

I fixed it up (using the driver-core.current tree versions) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__2_Jan_2013_13_39_46_+1100_nKItrdkXfwSgj1Dc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ453yAAoJEECxmPOUX5FETIUP/3lMwmyM6PB7IYaMCHWFI2nE
6FZsPk/Pq+vvCYpxhm1D8ijoIRU0jf1HeFgk7GPsD4YD3XlVRQilrxxju2Xe559V
FCtQifQ9kYXqb/H7XiMt5YKThX++XpHyjelosnK+kIDsTNift/46DzUvdwoJ2ZIa
+mwPfhvWji3akJuVXVU1J1LsMmYUT0YYm25MBCVHDK677tk++tQDNOKlKXl9igA9
BD24h4wP2WN9RiVJaDiRl9AC1vBzLCGcHCQZROYwMlt1DU8KIa//g0WFx+RDOeMw
kzJtG/WrcTqUh4rGveK4ECAai41kWybUYFVg7vuET53v+pt4thcuuW59omGykUry
vzBqC7VisKtz2Na+YYN0xz+BACeq+ctoIlD5xoYwwvlHSIdKN8fJJXxwELCoV602
XEv6egQdrs25hIqRHwNnGkr+WCuB2f4uUCyXXRaVoP0/wBZY5Fp1jkiHFSI7UStk
vbR2hRS7jzYqfGrXeL2a456tF4u7aYBUkgHdoZMcPWVdqZSZZ3CxL+h+9S+vMOv/
UNzjDvsXdqDjpiK01ofgeDhdWU0NZnZQChgqr/uLlOCaSAuI083w+/RgrCTcvrT/
n+7+eMQfzIxjKumg+3BMJmFexma0VbwbdrtM9C7TosBaw3FZziAm8NqMlZtl+MMI
c8PhE8zWVjHq/PC6Dada
=7EFv
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jan_2013_13_39_46_+1100_nKItrdkXfwSgj1Dc--
