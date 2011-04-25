Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab1DYLOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:14:12 -0400
Received: from csamuel.org ([74.50.50.137]:34959 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab1DYLOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:14:11 -0400
From: Chris Samuel <chris@csamuel.org>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: FW: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad Pentium Pro system
Date: Mon, 25 Apr 2011 21:13:49 +1000
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; x86_64; ; )
Cc: Thomas Meyer <thomas@m3y3r.de>, Yuhong Bao <yuhongbao_386@hotmail.com>,
        hpa@zytor.com, alan@lxorguk.ukuu.org.uk, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org
References: <201104222333.25546.chris@csamuel.org> <201104241022.17009.chris@csamuel.org> <BANLkTi=jKhd5foP=Avdv4cGUntbSMSDZrg@mail.gmail.com>
In-Reply-To: <BANLkTi=jKhd5foP=Avdv4cGUntbSMSDZrg@mail.gmail.com>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@^SdaXtmdYGRq
	[>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<{n8m;X_
	g\Y9LQ=v/b5`)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)F!1M3=w:i9MsWp&v;%usOXL;w
	6kF?wAZjss.+y(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2988556.4uPfsocj85";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201104252113.54049.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2988556.4uPfsocj85
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Yinghai,

On Sun, 24 Apr 2011 06:46:03 PM Yinghai Lu wrote:

> You may need to your .config to have
> CONFIG_SMP
> CONFIG_PCI
> CONFIG_X86_MPPARSE
> set to use mptable from BIOS.

Thanks for that - I already have all 3 of those set I'm afraid.

All the best,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart2988556.4uPfsocj85
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUATbVXbo1yjaOTJg85AQIkUwf/d2EQ8/RGHawlbeigWwQUohtNlUXHRum8
zsWFtKaISYoyWZ8hxGaaC7dfPGAisK4Yq5BTtLqeKRwzoLUA1VbubwF78ZWLK4+A
pjM4JUMM11sazhykGYz23FKbI8u9qIQUBp7WpitcsvediOY6MQ9wCsAhFuSyMbHO
x5u46wfIv1zPyAhcxN6kGOk/4ChJiwZnt9abHtzAqeMixlYy07rLxc+NA9YmxFdh
u+swAT0DtQvqUFUo5zszbj18WUNCE9ZBQXF6vq6FrbLrwGv06iCRrPCdhaEVl87O
BkwHbA57xJcFsfPpVfnMFWao2xbVfaFNEesQRQItIOM3oLGGkGfZhw==
=T4yI
-----END PGP SIGNATURE-----

--nextPart2988556.4uPfsocj85--
