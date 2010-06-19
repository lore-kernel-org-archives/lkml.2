Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0FSI0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:26:19 -0400
Received: from smtp204.alice.it ([82.57.200.100]:44393 "EHLO smtp204.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754711Ab0FSI0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:26:17 -0400
Date: Sat, 19 Jun 2010 10:25:58 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Alan Ott <alan@signal11.us>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/2] HID: hidraw documentation
Message-Id: <20100619102558.86fa43dc.ospite@studenti.unina.it>
In-Reply-To: <1276913623-6126-1-git-send-email-alan@signal11.us>
References: <1276832283-12084-1-git-send-email-alan@signal11.us>
	<1276913623-6126-1-git-send-email-alan@signal11.us>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__19_Jun_2010_10_25_58_+0200_Qu=KyNXjGTH+P0_b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__19_Jun_2010_10_25_58_+0200_Qu=KyNXjGTH+P0_b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jun 2010 22:13:41 -0400
Alan Ott <alan@signal11.us> wrote:

> These patches add the hidraw.txt file to a new Documentation/hid/ directo=
ry.
>=20
> The example program has been moved out of the document and fixed up for s=
tyle
> (it's now checkpatch.pl clean), and a Makefile has been created for it.
>=20
> I integrated the comments provided.
>=20
> hiddev.txt has been moved from Documentation/usb/ to Documentation/hid/
>=20
>=20
> Alan Ott (2):
>   HID: Documentation for hidraw
>   HID: Move hiddev.txt to the new Documentation/HID directory
>

Acked-by: Antonio Ospite <ospite@studenti.unina.it>

>  Documentation/hid/Makefile            |    8 ++
>  Documentation/hid/hid-example.c       |  167 +++++++++++++++++++++++++++=
++++++
>  Documentation/{usb =3D> hid}/hiddev.txt |    0
>  Documentation/hid/hidraw.txt          |  119 +++++++++++++++++++++++
>  4 files changed, 294 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hid/Makefile
>  create mode 100644 Documentation/hid/hid-example.c
>  rename Documentation/{usb =3D> hid}/hiddev.txt (100%)
>  create mode 100644 Documentation/hid/hidraw.txt
>=20
>=20
>=20


--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Sat__19_Jun_2010_10_25_58_+0200_Qu=KyNXjGTH+P0_b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwcfxYACgkQ5xr2akVTsAHP7ACeJuxVcJK+dI2uZpoNhh9jLEUL
E5MAoJGZCiFVsXsY6ZpKwzbARRWUA2Us
=6IdX
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Jun_2010_10_25_58_+0200_Qu=KyNXjGTH+P0_b--
