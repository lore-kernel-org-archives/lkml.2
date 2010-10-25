Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab0JYIx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 04:53:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48417 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0JYIx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 04:53:58 -0400
Date: Mon, 25 Oct 2010 19:53:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: error importing i2c quilt series
Message-Id: <20101025195349.f5ac62eb.sfr@canb.auug.org.au>
In-Reply-To: <20101025103404.73c24f45@endymion.delvare>
References: <20101025105900.83472a69.sfr@canb.auug.org.au>
	<20101025103404.73c24f45@endymion.delvare>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_19_53_49_+1100_CXlm2./E65s.neWm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_19_53_49_+1100_CXlm2./E65s.neWm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Mon, 25 Oct 2010 10:34:04 +0200 Jean Delvare <khali@linux-fr.org> wrote:
>
> This patch depends on a patch adding/updating PCI IDs which I thought
> was in Jesse Barnes' pci tree which you also pull in linux-next.
> Apparently my assumption was wrong.

Your series file says that your series is based on 2.6.36-git5, not
Jesse's pci tree.  You can add:

# NEXT-BASE pci

to your series file to force me to import your series on top of Jesse's
tree instead of 2.6.36-rc5.

> Jesse, where's this patch?
>   https://patchwork.kernel.org/patch/230361/
> I certainly hope it's scheduled for merge soon!
>=20
> Meanwhile I've removed the other patch from my i2c-next tree, it will
> be back only when I'm certain it applied fine.

OK, thanks

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_19_53_49_+1100_CXlm2./E65s.neWm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxUWdAAoJEDMEi1NhKgbskTMH/25DsYpqv103XjfwozsgJSYa
NuZYIBEtcc0gWRCjeSSVXhkRTg+7bS3X4+9DOEhW5LeJSoL60/dpZ1Cvnx5JkObZ
0IhC1gV1KkVdLVmxHVWh+ib1hKmYjlzUw9o4Awu+icuO/Tpq/IwQekqp+IeUcjhC
K+yV+7gvVn8HJwBuzkskT1F98z2wFbFJWY0Mb9DXycdtsvlmRpUTHe2P5fviIdqL
1YrS8YiRwGxN1DJB67LY161vBeS4uNdn7BlLpRNQhwT8reu7111OgojVHJOf5dRU
ThJTAqzgFiCez1VxDoT/B3h9xm9theIl1gEqx/7FCNukFdYxnv2Dw/Xp5HcNgaw=
=xSS/
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_19_53_49_+1100_CXlm2./E65s.neWm--
