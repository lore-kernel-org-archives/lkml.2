Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1DWNMV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:12:21 -0400
Received: from csamuel.org ([74.50.50.137]:39202 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495Ab1DWNMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:12:19 -0400
From: Chris Samuel <chris@csamuel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Sat, 23 Apr 2011 23:11:58 +1000
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
  boundary="nextPart1813187.xNYfgVGlxX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104232312.02713.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1813187.xNYfgVGlxX
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Apr 2011 07:35:36 PM Alan Cox wrote:

> If you boot with mem=3D and force the memory size what happens ?

Using memmap=3D636K@0 memmap=3D255M@1M (from just naively converting
the e801 numbers from the 2.6.18 boot) it appears to get past that
issue and then panic because of no root filesystem (unsurprisingly
as it's based on an allnoconfig config).

Trying the same with the Debian Squeeze 2.6.32 based kernel results
in it not panic'ing when unpacking the initramfs but there are many
complaints about IRQ's happening and nobody caring and the system
ends up shutting itself down due to timing out bringing up the root
filesystem from the software RAID.

I'll be away from email for a few days now because of the Easter
holidays here, but I'll catch up when I'm back.

All the best, and thanks to everyone for the help so far!

Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart1813187.xNYfgVGlxX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbLQHo1yjaOTJg85AQKiEgf/VUwSqeUCU+kQB/5ylZeCCIztbiJhcXQ+
P24EiPiw8r2K9t8Svp2FAsr3JwN1JSmnPIkDgbsMraKN58uiEX0olw40YkGBZSKC
BMvdOcDYlpE7o9s+LDdNC7w/umK3wBsNvqosOA60m4DI8s0J1BpchJkShT9wkZCD
0MrApH4izn3ZZlU1tUYE9DHM/rr2bbX5HnrRyU5kUPJ+ZpgMS2b40v4RfsRI+aVo
DbKeLJj4iqmgLahXA62uS8/nRl1WvV5GAEprfOCI0Zsp741AOfKClYzW8dtGMzfw
ukBka9rXfWUKSASI/HuPlcDmdiJhR0XoSlHgoA+dP+xcfD+nw/KAAA==
=3o9n
-----END PGP SIGNATURE-----

--nextPart1813187.xNYfgVGlxX--
