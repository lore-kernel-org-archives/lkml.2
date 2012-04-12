Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933747Ab2DLAGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:06:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52007 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933639Ab2DLAGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:06:33 -0400
Date: Thu, 12 Apr 2012 10:06:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tony@bakeyournoodle.com, mmarek@suse.cz,
        lacombar@gmail.com
Subject: Re: [PATCH 3/5] drivers/net: remove IS_ENABLED usage from wiznet
 drivers
Message-Id: <20120412100619.9cbd13da03b2a7ecac143392@canb.auug.org.au>
In-Reply-To: <20120411.195444.540814653660043985.davem@davemloft.net>
References: <1334188257-3449-1-git-send-email-paul.gortmaker@windriver.com>
	<1334188257-3449-4-git-send-email-paul.gortmaker@windriver.com>
	<20120411.195444.540814653660043985.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__12_Apr_2012_10_06_19_+1000_TJV4j_z/.nl7lSo0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Apr_2012_10_06_19_+1000_TJV4j_z/.nl7lSo0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 11 Apr 2012 19:54:44 -0400 (EDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Wed, 11 Apr 2012 19:50:55 -0400
>=20
> > The use of IS_ENABLED in C code (vs just in CPP #if directives)
> > causes us to carry the burden of a huge autoconf.h file.  It is
> > also misleading in that a casual inspection of the code would
> > leave one thinking that the if statements were evaluated at
> > runtime, when TX_FLOW is a Kconfig bool and hence evaluated
> > at configure time as an either/or.
> >=20
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>=20
> Want me to toss this into net-next?

Sure - *after* it has been reviewed, and tested :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__12_Apr_2012_10_06_19_+1000_TJV4j_z/.nl7lSo0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhhx7AAoJEECxmPOUX5FEzagP/2YL8E0bmw9bF/0UYw7SprgL
RYqJxlTiN+SnrhXIOijPaQG+4WEVraHXZ4f196/r5ZbE7dfhVNG05u0tfLc2a3tV
m/ZwAZkFo49hModSicWVHY35buAdFI0cSoTbGS+hI8LpqV1fkVcXPX+cK7G4ugrG
iDnCDo3uHaeenfGbm22YEP0rwC/jx1FxPwqkDaBG64SGIRVSt2hTzN3pRI5E8mQb
cdp3ZR7exl82pJ2/7x3A4VoT3XP8U7u5+ryo48+ztdmnkZDUOjd4XrVR9kI8qGh2
Ibfi5c4fxcx7Js1udUJbLSApnwfg9raFVVEyG0Zxgqdz/UX/z63x3v+5LptBhcc1
XyHsR3QeWoE8u1YyBjP9iAEdi5w4La1U7fDRGxWTbQSElLWW8bFVjC6a+1LQicNL
6HVvzmF+j04vWaQGuaI/r2cOeE7/UFYJLTobifxf5tQas8DZtEY2nq8HcnA7BtRj
VdK8j172lgqFXCjRG5tJQ8eJsReCczgbhzugCFMtpi2yFht/omMnbjlGcszFZdbX
JTGPrch2HH9bvaE4y0qhOpDVdNaLmcU/kkOxTq+b3DZeZJHQzD8Rmhoy7cPZwhsf
+wwmBJGj2/20UDNFqKNwAPG/rdQ8NoPPE+fONpU/E2zUQknTUTTNAvUDYOIqUFQF
q9hDKrBmwoVTsUBbUPe3
=eZU4
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Apr_2012_10_06_19_+1000_TJV4j_z/.nl7lSo0--
