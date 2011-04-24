Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab1DXAWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 20:22:33 -0400
Received: from csamuel.org ([74.50.50.137]:42682 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab1DXAWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 20:22:32 -0400
From: Chris Samuel <chris@csamuel.org>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sun, 24 Apr 2011 10:22:16 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, hpa@zytor.com,
        alan@lxorguk.ukuu.org.uk, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <1303566747.12067.10.camel@localhost.localdomain> <201104241016.22639.chris@csamuel.org>
In-Reply-To: <201104241016.22639.chris@csamuel.org>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1358884.F4STa2czzR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104241022.17009.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1358884.F4STa2czzR
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Sun, 24 Apr 2011 10:16:22 AM Chris Samuel wrote:

> A fuller kernel does proceed further than before, before running
> into issues where both the e100 and aix7xxx drivers complain about
> not being able to find their IRQ's and that this might be due to
> a buggy MP table.

Booting with noapic nolapic removes the IRQ warning but the
system still times out trying to mount the root filesystem and
reboots itself.

I'll be away for a day or two now.

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1358884.F4STa2czzR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbNtOI1yjaOTJg85AQK9Ugf9HQxrJIg4bVzUZK1mmXZRSF7+3XzGeEaL
5Xyps2lFbVXmoVOtHOHBtRU9HPCGPFqaDlC2T6AOt2cy6FnZW3Zspct38CedC9zy
fF9KZhDynAw/NlkW34bX2MCWxmsAUMpTipaTv9VYuSNXa0KlaV4ftp2yMtd2y2LV
OCLQ8xcaynTUE4xZbPiEUAlGDRuSfr8LvqTkR3Xb8z1P1HwmrtR0ZG3XL0fjfCU1
x5fj/u+tK0G3ib/bBjvwt0oyHqlNipKnUxQttwp70RL5AozkY8iL7x84H8+i3uEs
30ZCvB2vGj1llmPAHkzaCQt7ANpbuON2I4IM4l7dgTncBqcGKCwdvw==
=wzNg
-----END PGP SIGNATURE-----

--nextPart1358884.F4STa2czzR--
