Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1DWKgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 06:36:20 -0400
Received: from csamuel.org ([74.50.50.137]:53056 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab1DWKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 06:36:18 -0400
From: Chris Samuel <chris@csamuel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 20:35:59 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <201104231016.23579.chris@csamuel.org> <20110423103536.1c7ff2a8@lxorguk.ukuu.org.uk>
In-Reply-To: <20110423103536.1c7ff2a8@lxorguk.ukuu.org.uk>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1393430.9uuplCYmxS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104232036.02758.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1393430.9uuplCYmxS
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Apr 2011 07:35:36 PM Alan Cox wrote:

> On Sat, 23 Apr 2011 10:16:18 +1000
>  Chris Samuel <chris@csamuel.org> wrote:
> > Syt mae Alan! ;-)
>=20
> G'day ;)

Touch=E9!

> > That would explain an awful lot..
>=20
> Could be something has disturbed its memory detect or could be a
> bug in the PPro memory quirk.
>=20
> If you boot with mem=3D and force the memory size what happens ?

Same behaviour I'm afraid, hangs claiming 16MB of LOWMEM. :-(

> > INT 15h =3D f000:f859 DOS RAM: 638K (0x9f800) INT 12h: 638K
> > (0x9f800) INT 15 88: 0x3c00 (15360K) INT 15 E801: 0x0000 (0K)
> > 0x0000 (0K)
>=20
> Ah.. do you have a BIOS setting called something like OS/2
> compatibility ?

That's the really odd thing, I am yet to find a way to access
the BIOS settings on this beast. I've tried the usual DEL, F2
and F1 with no success and there is no prompt I've ever seen
to offer access to one.  I do have a ZIP file that contains
the last BIOS upgrade for it that was released so I'll see if
I can make that bootable and see if that reveals any options.

> > Hope life is still good in Abertawe!
>=20
> This part of the world has changed rather a lot. Not sure
> you'd recognize half of it.

I can imagine, it's been a while since I've been back in
South Wales!

Take care,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1393430.9uuplCYmxS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbKrj41yjaOTJg85AQJpNgf/YgCGfNT9mteq+O4ssE7wS76CE36qduHx
jk8qN5MlxIYi02QDr9X+PbJ/EzSVC3s9ebol4slwnJYAsNz/e5g5Iv+dAmmBAkj1
b/aIjLi5mPk6+p98fxe2kgC0goDnfxkyissYrfgLPswOqfwkUhm6aKkW2DPyNquG
ZUD+F+aq2DlHotS5AGClSNxzFGCi/RX9cb9x+dPOH7dYP+yMB89JzoPxYXARfiFH
NEyNUlEfrRcx3jrvdzmF+/1pf0EMbhy/FIf+uSMF6jn/woM8ingBzLQtSldPG7+p
nqYFFt3A1p5ODwj51vEOuLrrS7q1KcSrSXNX1KdqH3icVfisM7iPtw==
=BQD2
-----END PGP SIGNATURE-----

--nextPart1393430.9uuplCYmxS--
