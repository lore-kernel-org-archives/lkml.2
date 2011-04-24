Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab1DXAQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 20:16:39 -0400
Received: from csamuel.org ([74.50.50.137]:45116 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab1DXAQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 20:16:38 -0400
From: Chris Samuel <chris@csamuel.org>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sun, 24 Apr 2011 10:16:22 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Yuhong Bao <yuhongbao_386@hotmail.com>, hpa@zytor.com,
        alan@lxorguk.ukuu.org.uk, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <SNT125-W501A69BD9948F037646EDFC3940@phx.gbl> <1303566747.12067.10.camel@localhost.localdomain>
In-Reply-To: <1303566747.12067.10.camel@localhost.localdomain>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8152719.G48shb3xVh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104241016.22639.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8152719.G48shb3xVh
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Apr 2011 11:52:27 PM Thomas Meyer wrote:

> That should fix your misdetection.

A fuller kernel does proceed further than before, before running
into issues where both the e100 and aix7xxx drivers complain about
not being able to find their IRQ's and that this might be due to
a buggy MP table.

I presume this is unrelated to the initial problem ?

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart8152719.G48shb3xVh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbNr1o1yjaOTJg85AQKmywf+P2CebSHEcGsSrBLXWcMIGLOIljdUEgbq
49NDvLcmuzob9bl/F+V8y7Z15m3M5FDzACJy++5iMzUlM1c2EQQ+cXRsrCQ19LIJ
hnJm9VdW1VFs1TW7ueyo3KApFsv/v0uTtIxLwZ3bsJf9GQSYyhRIiDytcnPsN48S
Njv9LcLLhTnALBw0BlL8uLHtFqM7TmNa3YiZN4jqasWKjvGtzjD3Si61Jn4LjPyK
O5ZfC7aqRrWXc02CgycJRnDGn+Qd8pukVRZk13fucbWY6TZv954l0Q1ptzWna8xp
Q+fjRenleeXjM1/HStKCcICwgw9/qQqlgbUYmc2BX/H2B57jlABZiQ==
=9uqZ
-----END PGP SIGNATURE-----

--nextPart8152719.G48shb3xVh--
