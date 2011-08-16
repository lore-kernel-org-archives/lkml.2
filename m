Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab1HPHDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 03:03:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47443 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1HPHDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 03:03:17 -0400
Date: Tue, 16 Aug 2011 17:03:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: Re: linux-next: build warning after merge of the final tree
Message-Id: <20110816170311.78935e0cae3d6c3f5955e1c0@canb.auug.org.au>
In-Reply-To: <20110816060410.GA7013@gondor.apana.org.au>
References: <20110816152234.26afbea89bfe896d95177ad7@canb.auug.org.au>
	<20110816060410.GA7013@gondor.apana.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Aug_2011_17_03_11_+1000_+skORLd1/7_wTEDk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Aug_2011_17_03_11_+1000_+skORLd1/7_wTEDk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Tue, 16 Aug 2011 14:04:10 +0800 Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
>
> Does this patch fix the problem?

Yes, it does.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Aug_2011_17_03_11_+1000_+skORLd1/7_wTEDk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOShYvAAoJEDMEi1NhKgbsBZ8H+gNJ+2rh/8VCcHDt2yvPgPuX
A9FT8gqWGfU/YM2kKWdS+XTTa483t4TF0a50vtmFsGjp8ndogRad3EJoNiT6S7ly
cUxXOJlVxwWFrfcvmFjUOFc94kUD0LIktkgD6PAPFLCryNqm0NuTYP1MWz4eEMU1
+ow2F402LTt2pSqVyXmbflCOf2/gl2Ix795wuYvYmjgNFIkne9qbf+1HMRNSdmTu
5GJh/K/+4UGlcq2jAEZB1Y88z7SjoYdMigFbstCLnxnsJVd3FqcB4/dY7JBqL4lp
1CBZjkFZ+uY/O65+YGw7KpNKQ9ycjzqxt28XLabm3dQrdvbrWaZtUH6su0QH1IQ=
=byw8
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Aug_2011_17_03_11_+1000_+skORLd1/7_wTEDk--
