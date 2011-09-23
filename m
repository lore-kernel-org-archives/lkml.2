Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1IWKEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:04:51 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:57668 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1IWKEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:04:50 -0400
Date: Fri, 23 Sep 2011 20:04:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Wan ZongShun <mcuos.com@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [linux-next next-20110922] build failure due to missing
 arch/arm/mach-nuc93x/Kconfig
Message-Id: <20110923200442.32ef868c5203a3a29925343f@canb.auug.org.au>
In-Reply-To: <20110923195236.6a885bf02e6161f537d22347@canb.auug.org.au>
References: <1316697473.6704.4.camel@phoenix>
	<20110923195236.6a885bf02e6161f537d22347@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Sep_2011_20_04_42_+1000_mMeBr1lCvX+aqBm9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Sep_2011_20_04_42_+1000_mMeBr1lCvX+aqBm9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Axel,

On Fri, 23 Sep 2011 19:52:36 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 22 Sep 2011 21:17:53 +0800 Axel Lin <axel.lin@gmail.com> wrote:
> >
> > I got below error with today's linux-next tree (next-20110922).
> >=20
> > $ make menuconfig
> > scripts/kconfig/mconf Kconfig
> > arch/arm/Kconfig:972: can't open file "arch/arm/mach-nuc93x/Kconfig"
> > make[1]: *** [menuconfig] Error 1
> > make: *** [menuconfig] Error 2
>=20
> This commit appeared in next-20110922:
>=20
> commit 6adc1e7ff19d9befdbb7781b26fff42bb0bc21e2
> Author: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date:   Wed Aug 3 15:50:38 2011 +0100
>=20
>     ARM: mach-nuc93x: delete

And today a new verison was committed that removes the include of
arch/arm/mach-nuc93x/Kconfig, so it should be fixed in next-20110923.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Sep_2011_20_04_42_+1000_mMeBr1lCvX+aqBm9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOfFm6AAoJEDMEi1NhKgbseFUH/An5NG7V3xQj5/33BeoB9ZMi
pO0f8+MxQp4Q6wMAO4mQi0zOKxPwWt2S4ofjwGcDv1o3gNbiJu/pGStMiDUPW0Bm
XqfGE3sdpAsWNd5LsLLkiHGPTqab8eFSbiHAtNqY1bV/5gWdz3FmB0xQY1HPPBOw
otz0ZyXjk5Kt0MC8dpfZe9qBANEovwDMA83nWrE8lQggxRFdqYUvj94bNDAG1Vtx
E5vMQjnjUZSQra11KfzuYBXijjsg694x3TaErWsR5vpY8LbzB4ebf180Tmj/xI2u
fWPQUGCpS3QbIRIvnarvYlUEWuG+eolq6dzS7KrxAOU+/MuiLhmVDWK6J9yCG/E=
=cOeb
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Sep_2011_20_04_42_+1000_mMeBr1lCvX+aqBm9--
