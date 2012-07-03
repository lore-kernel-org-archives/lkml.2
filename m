Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab2GCGYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:24:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63047 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754Ab2GCGYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:24:00 -0400
Date: Tue, 3 Jul 2012 08:23:51 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-ID: <20120703062351.GA25217@avionic-0098.mockup.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
 <201206301920.21158.arnd.bergmann@linaro.org>
 <20120630194139.GA24300@avionic-0098.mockup.avionic-design.de>
 <201206302012.32476.arnd.bergmann@linaro.org>
 <20120701065639.GA25470@avionic-0098.adnet.avionic-design.de>
 <20120703154318.9e32d4a490c0b32e7d955ca4@canb.auug.org.au>
 <20120703061115.GA27989@avionic-0098.mockup.avionic-design.de>
 <20120703161846.59fee8d3815993bcea122eeb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20120703161846.59fee8d3815993bcea122eeb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:/E2k+I6zfBrNbXRp4B+wKIH2dqy1mGMaI5d3UavO3lP
 S/T1KMZiBAYzKXpwJ2HQmvfga1yWvJag8C7RqEBq410wjHFKDh
 ImoGocmTB539XfbcUX9v31W9LEDKOGSCfrtvK+P5cPHVVfHtKE
 7KjtuB2A/VA71oTWMK8qbqYoZItDpKYG25agFki78Dh0Zy98NK
 AsoIqwXA7TI0ydIDtmi0PddGvHnCXrmr95Qdfhx3gWgjhcySnt
 RIyO63Bn2M9ZK1ga8sT82ZeA0t2Q9C+yvnpztxrdokWSdTomYW
 kq3rKruOIp38wJNUXwdiLjlWhIKW1pze8JlkuJtFXHiSjABXzp
 EIM+6NCHBLJRUDhZXExw3yDsCoPs7MbpQscnJP7dzV89SdYm4m
 AieWoNwAWTbY9PF61nCZLePgsRC3yhLCXk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 03, 2012 at 04:18:46PM +1000, Stephen Rothwell wrote:
> Hi Thierry,
>=20
> On Tue, 3 Jul 2012 08:11:15 +0200 Thierry Reding <thierry.reding@avionic-=
design.de> wrote:
> >
> > I don't see how that can happen. If you have CONFIG_TWL6030_PWM=3Dy, th=
en
> > you should also have CONFIG_HAVE_PWM=3Dy, which would in turn conflict
> > with CONFIG_PWM=3Dy.
> >=20
> > I'll have to fetch a powerpc toolchain and try to reproduce this.
>=20
> CONFIG_HAVE_PWM only exists on arm, mips and unicore32 ... so the "select
> HAVE_PWM" will not do anything on any other architecture.

So one option would be to add HAVE_PWM on powerpc, or alternatively to
explicitly add a conflict to the TWL6030_PWM symbol (and any others that
implement the legacy API). I'd think the second alternative is
preferable and actually matches what Arnd proposed previously. Maybe
this was exactly the reason he suggested that solution in the first
place.

Thierry

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8o/3AAoJEN0jrNd/PrOhikQP/1N5iTAHvQoan/xxlknxdixN
w7dg3jGIBCEDX2dwKXMeU9ZXCmB6Z+mDnT6xIlE0m85DyyJ1nJlGQkT8D7pxHj0y
FFH2WXz+ZCj9UZiQstCy8WJFPKd0IWQAK/BlsNogK9ye+EY8tswAg/FttX2arI58
BKGx4CEa+ITxkK+6NC1A0Qa/WlxZSftNHK3KWoKpa+wuKL6PU7f3yzxTFZIPiDLh
y/TOttMU4NOFCNJ79ZQfafRXpNtwrSgCxni73gY6+KHV/alzrXmDVUHBHm37hXLZ
XmOgcv3afXVRhBcKXPtkH7c7JVxDp8dozwCgFb7XxdYfrIK/nKVqGUN87TfiO3Z6
bhwEhPkk27Xnf6j3RSV5JtVnqLlamTbeI+3awQXZRs21sbrDD3677FPbMogdlVCi
A6R8MHD5Bs8ngUe6880jNwxYVyqK/ro35jnJFCNi+scfiLlyZnyUqjfWjlEApiZ8
NQPHGMrg+WtPdS8HMz+TFk0Tt5s/JNlA4neaVsUWaLtGosE4auQd7vOJaoKmARiX
nVp7tzCStAa5RRWFQvGq5L+lGualx2Lx2pMvS2pi+XeaEEZALMCgfrSWLNidrUUW
svYVHLqGawym971/OoUhQ9FIbHpj3DknfUcKKJq5u5fYNl7ycCUIuA+8r5EbmM6c
Cx8HLNuOB0JMDBoM0d5n
=J0nQ
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
