Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab0DIAJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 20:09:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60744 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab0DIAJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 20:09:05 -0400
Date: Fri, 9 Apr 2010 10:08:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Timo =?UTF-8?B?VGVyw6Rz?= <timo.teras@iki.fi>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: powerpc boot failure
Message-Id: <20100409100858.149feccc.sfr@canb.auug.org.au>
In-Reply-To: <4BBD966D.8020404@iki.fi>
References: <20100408165848.38f75f40.sfr@canb.auug.org.au>
	<4BBD81B3.3030500@iki.fi>
	<20100408172316.e6ee451d.sfr@canb.auug.org.au>
	<4BBD85ED.4090209@iki.fi>
	<20100408174549.2f45ceea.sfr@canb.auug.org.au>
	<4BBD966D.8020404@iki.fi>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Apr_2010_10_08_58_+1000_HEJRLD/N5y2v5aDn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Apr_2010_10_08_58_+1000_HEJRLD/N5y2v5aDn
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Timo,

On Thu, 08 Apr 2010 11:40:13 +0300 Timo Ter=C3=A4s <timo.teras@iki.fi> wrot=
e:
>
> Can you try if this helps?

That patch allows my machine to boot.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Apr_2010_10_08_58_+1000_HEJRLD/N5y2v5aDn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku+cBoACgkQjjKRsyhoI8wk4gCdGPjIZLArsbPae/gChDy/Wa+P
bBUAoLYU4GfeOd81j2FtkCsYLuxVKBYc
=fpg6
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Apr_2010_10_08_58_+1000_HEJRLD/N5y2v5aDn--
