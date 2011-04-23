Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254Ab1DWEeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 00:34:10 -0400
Received: from csamuel.org ([74.50.50.137]:50966 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab1DWEeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 00:34:07 -0400
From: Chris Samuel <chris@csamuel.org>
To: Yuhong Bao <yuhongbao_386@hotmail.com>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 14:33:46 +1000
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
  boundary="nextPart1754902.zmMJkIWYff";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104231433.50230.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1754902.zmMJkIWYff
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Apr 2011 11:46:13 AM Yuhong Bao wrote:

> > Would be happy to try with some instructions if it would help.
>=20
> Enter these instructions using the A command and execute with the T
> command: mov AX, E801
> INT 15
> INT 3
> And provide the results of the AX, BX, CX, and DX registers after
> the INT 15h.

I should have asked previously - is this possible with FreeDOS ?

I don't have an DOS media myself.

=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1754902.zmMJkIWYff
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbJWq41yjaOTJg85AQJBMwf/Y0l6s8Fnw1D0eS/TRfcHOxpf0P3zmGE1
M/WYwIdLqCHCpHcSaBhbSkv/Ui2cj+fidY1pccqvRmajWohjfG4w6tjWjfC9aib4
5+xh35MDHxZlSH3Ys/odXpLeLzHwZUxM0pgLoXJTErCEClwuWBn7yR3t0o6b6UmK
QTGo4hgYM75NxueAivyBzcFh1KeYy006BvVzxeGlLotyt+h/49ANqcX2nExS30lo
cWNS3UNukxZWxKe1JlwL3qkuI3PJX2u3Zv+mDUQE8Qj8TZeU1cZucDrml+WUFN08
sogB7oCsSCp1KdIDMqwMkRubM42AMJ8PGO2Yyx9o6Uw4TqQZWv+OLw==
=CvCW
-----END PGP SIGNATURE-----

--nextPart1754902.zmMJkIWYff--
