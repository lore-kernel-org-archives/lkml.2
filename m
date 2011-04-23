Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab1DWFWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 01:22:23 -0400
Received: from csamuel.org ([74.50.50.137]:60866 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1DWFWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 01:22:22 -0400
From: Chris Samuel <chris@csamuel.org>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 15:22:01 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: alan@lxorguk.ukuu.org.uk, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <201104231135.54966.chris@csamuel.org> <SNT125-W632CB71E47020C0C05FBDCC3940@phx.gbl>
In-Reply-To: <SNT125-W632CB71E47020C0C05FBDCC3940@phx.gbl>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1303541318.HbHQbzzNRL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104231522.06057.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1303541318.HbHQbzzNRL
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Apr 2011 11:46:13 AM Yuhong Bao wrote:

> Enter these instructions using the A command and execute with the T
> command: mov AX, E801
> INT 15
> INT 3
>
> And provide the results of the AX, BX, CX, and DX registers after
> the INT 15h.

OK, so I'm a novice so I'll recap what I did.  Starting with FreeDOS
boot floppy and copied debug.com and debug98.com to the FreeDOS
directory on it.  Booted from the floppy, selected option 2 (safe=20
mode, no drivers loaded).  Typed debug and then:

=2D A
2890:0100 mov AX, E801
2890:0103 int 15
2890:0105 int 3
2890:0106
=2D t
AX=3DE801 BX=3D0000 CX=3D0000 DX=3D0000 SP=3DFFFE BP=3D0000 SI=3D0000 DI=3D=
0000
DS=3D2890 ES=3D2890 SS=3D2890 CS=3D2890 IP=3D0103 NV UP DI PL NZ NA PO NC
2890:0103 CD15      INT      15
=2D

Does that look correct ?  I presume it was just <enter> to leave
the 'A' mode to go back to the command mode ?

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1303541318.HbHQbzzNRL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbJh+Y1yjaOTJg85AQJMWAf/Vbz51CnB9hIHIGAqy7giyRedlnB3Lr0Y
jtH23UjVfBS3t/s+bmF5Apot9/9/aexDajVTmieHpHPiWGdk72ijcdUVqCbcM1MH
Af0Yb8tcQboPtoI6wHjBdqspq9BN4sJIJQOxsAJDU+JXew+qWkyieLt6kwQalDSl
vzjjo5+5eggr4c8tN7lAmEltmtyHo6H3DQOOGQTi8gSfaCa3UPT28JnaQ6mVJMxz
6QBIRhwv0LrQUnd7f+b2z8nAoOzmqaaqJP1MQfxe7otpgTLUbz4WvS9KRQXgQYs+
SBeCE4kJR2gwlNo7xxSFhWcWx9gx0ktxxZHr6g2XWHCYBIriGBgz1A==
=yjZR
-----END PGP SIGNATURE-----

--nextPart1303541318.HbHQbzzNRL--
