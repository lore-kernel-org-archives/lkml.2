Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2EAS1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 14:27:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48127 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab2EAS1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 14:27:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Date: Tue, 1 May 2012 14:28:14 -0400
User-Agent: KMail/1.13.7 (Linux/3.3.4; KDE/4.6.5; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <201204271926.14872.vapier@gentoo.org> <20120501133429.GB23919@mudshark.cambridge.arm.com>
In-Reply-To: <20120501133429.GB23919@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2288888.c4ZMpV8PUX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201205011428.16299.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2288888.c4ZMpV8PUX
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 01 May 2012 09:34:29 Will Deacon wrote:
> On Sat, Apr 28, 2012 at 12:26:11AM +0100, Mike Frysinger wrote:
> > i am strongly in favor though of agreeing on & documenting the baseline
> > API first before attempting to clean anything up.  sorry to keep harping
> > on this.
>=20
> It would be nice if we could just use asm-generic/io.h as the documention,
> i.e. if you want to write a portable driver, just stick to the functions
> implemented there.

we have Documentation/DocBook/deviceiobook.tmpl where we can document what=
=20
should be used in device drivers for portability, and what should be avoide=
d. =20
then we can refer to asm-generic/io.h for just the API level stuff (i.e.=20
inputs/outputs/return values).

then we update asm-generic/io.h to:
 - refer device driver authors to deviceiobook for the higher level=20
documentation
 - explicitly state that the API here is the baseline and any new functions=
=20
should be discussed first on linux-arch/lkml
 - explicitly state what API functions have been omitted, and what should b=
e=20
used instead of those

how's that sound as a plan ?

> It would be nice if we could just use asm-generic/io.h as the documention,
> i.e. if you want to write a portable driver, just stick to the functions
> implemented there. Apart from the string accessors, I think it's already
> fairly accurate. The __raw_* functions seem to be missing on s390 but I
> don't think driver portability is a huge concern for that architecture.

as long as we document expectations at the top of the file, that's fine.  t=
his=20
implicit assumption doesn't fly in general for asm-generic/ because it's be=
en a=20
constantly increasing code base as it merges more arches.  there were a bun=
ch=20
of files/apis i extended in asm-generic/ as i converted Blackfin over to it=
=2E =20
this is what we wanted from the beginning (afaik; i'm sure Arnd can correct=
=20
me).
=2Dmike

--nextPart2288888.c4ZMpV8PUX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPoCtAAAoJEEFjO5/oN/WBS9wP+wZqZym22lU+NulzrwLrTO2S
ZbeZBGvt+FWDVZkx+QOT/fxp5f8PPEZ8oygc12zt+naY9B+IiLAg5L8GyJnu2soC
uZWErush1VBpdDqLux4L71R8YdESrcgV624bDfx0c8C+VLd+uD5JFK1l7XXKfbIZ
T3sG2pMtF3Ch5o+m3lii0Ev73kPi7Z+CbzBEEgL1lI7mRi0TlOcgc5jI7Tgl/8w8
IFzOVZWG242/MtacUumb/bedjksCYuqR2lFnEQLTukgw2X47+8GvDh6OK412l31e
k7gtYDP0QQn4WCJVGi8yrUcrazYf1b8lb69KlfY1WwhTqVyw8sgZdbfuD7j+cCAS
neN8WNw0Zp0SJFnAm6kQhZYR7RYZGsun976iqkv6qfntAvozLB7rfGlqGg1h9++J
+QQdJZLwrp6Ql5GN0Z9lZKs9y+pdM3uI5xqbAcempKlmV1bXC9UA59lT+W/8kEtj
82IemJHZ3YZKrC7uK73t/y+BKBuCel+piu3hyz/hMSlNuaS4sQxDHMNx7GATGF4I
tapjASmQOWQDWAZhRxiatvONvTjsQk+Ync0o+dxGmB+2BauViyKhf/B+6xTtmJtq
6CwXCNnyz5jQTH0YPffMmgFHyxMzIZfxxyiaUznXXLs7NKPU4EUMzi/4QgzH3H9y
kcRG1EtvcWtxMiY9zvxp
=R9hM
-----END PGP SIGNATURE-----

--nextPart2288888.c4ZMpV8PUX--
