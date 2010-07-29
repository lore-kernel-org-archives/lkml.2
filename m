Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab0G2Lt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 07:49:57 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54734 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0G2Lt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 07:49:56 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tuxonice-devel@tuxonice.net
Subject: Re: [TuxOnIce-devel] kcryptd oops when resuming with TuxOnIce with KDB oops afterwards
Date: Thu, 29 Jul 2010 13:49:42 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.33.6-tp42-toi-3.1.1.1-04982-g768d8a0; KDE/4.4.5; i686; ; )
Cc: Nigel Cunningham <nigel@tuxonice.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>, dm-crypt@saout.de,
        Kernel development list <linux-kernel@vger.kernel.org>,
        kgdb-bugreport@lists.sourceforge.net
References: <AANLkTikjSiVXW+iGX-ofBs00crqiyT_d+DLpCBzFk4Ne@mail.gmail.com> <20100729024951.GC6247@khazad-dum.debian.net> <4C50F09C.6050201@tuxonice.net> (sfid-20100729_132109_707551_3736D1B7)
In-Reply-To: <4C50F09C.6050201@tuxonice.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2566615.5iqfl82LDi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007291349.53269.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2566615.5iqfl82LDi
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Donnerstag 29 Juli 2010 schrieb Nigel Cunningham:
> Hi Henrique.

Hi Nigel,

> On 29/07/10 12:49, Henrique de Moraes Holschuh wrote:
> > On Thu, 29 Jul 2010, Pedro Ribeiro wrote:
> >> I hit a bug when resuming with TuxOnIce. At the middle of a resume,
> >> it says Compress Read -22 and locks up. I caught the stack trace
> >> with kdb and took photos of that.
> >=20
> > Maybe this?
> > http://lkml.org/lkml/2010/7/28/398
>=20
> I don't think so. This issue has been around for a fair while. It's
> just impossible to reliably reproduce, and I haven't yet found the
> time to put some serious effort into tracking down the cause and
> fixing it.

I reported this one as - you said, its an TuxOnIce bug:
https://bugzilla.kernel.org/show_bug.cgi?id=3D15873

I switched compression on my ThinkPad T23 where it happened all 2-4 days=20
or so with 2.6.34 from LZO to LZF. And since then I didn't get the error=20
anymore, but with only 5 attempts so far, so I am not sure whether=20
switching to LZF "fixed" it:

deepdance:~> cat /sys/power/tuxonice/debug_info=20
TuxOnIce debugging info:
=2D TuxOnIce core  : 3.1.1.1
=2D Kernel Version : 2.6.34.1-tp23-toi-3.1.1.1-04990-g3a7d1f4
=2D Compiler vers. : 4.4
=2D Attempt number : 5
=2D Parameters     : 0 667656 0 1 0 0
=2D Overall expected compression percentage: 0.
=2D Checksum method is 'md4'.
  0 pages resaved in atomic copy.
=2D Compressor is 'lzf'.
  Compressed 776593408 bytes into 359897499 (53 percent compression).
=2D Block I/O active.
=2D Max outstanding reads 714. Max writes 5.
  Memory_needed: 1024 x (4096 + 200 + 76) =3D 4476928 bytes.
  Free mem throttle point reached 983.
=2D Swap Allocator enabled.
  Swap available for image: 229016 pages.
=2D File Allocator active.
  Storage available for image: 0 pages.
=2D I/O speed: Write 28 MB/s, Read 33 MB/s.
=2D Extra pages    : 26 used/500.
=2D Result         : Succeeded.

Maybe its a good idea to collect information in that bug report, even when=
=20
it really is a TuxOnIce one.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2566615.5iqfl82LDi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxRatcACgkQmRvqrKWZhMfhrwCgj70DmG8Rb5KMRd0C/+qAO3PP
OQkAn1AohSRsaZ7wzxcY1rQ9SwXr7O2x
=WFWb
-----END PGP SIGNATURE-----

--nextPart2566615.5iqfl82LDi--
