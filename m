Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515Ab2GaXqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:46:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33812 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab2GaXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:46:08 -0400
Date: Wed, 1 Aug 2012 09:45:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Michael Neuling <mikey@neuling.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, anton@samba.org
Subject: Re: [PATCH] powerpc/crypto: fix pseries_defconfig break
Message-Id: <20120801094559.9d94ef062507d5010a049780@canb.auug.org.au>
In-Reply-To: <1343777691-25601-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1343777691-25601-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__1_Aug_2012_09_45_59_+1000_36XDmsUHeoJjLCWW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Aug_2012_09_45_59_+1000_36XDmsUHeoJjLCWW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Seth,

On Tue, 31 Jul 2012 18:34:51 -0500 Seth Jennings <sjenning@linux.vnet.ibm.c=
om> wrote:
>
> diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/config=
s/pseries_defconfig
> index 1f65b3c..9f4a936 100644
> --- a/arch/powerpc/configs/pseries_defconfig
> +++ b/arch/powerpc/configs/pseries_defconfig
> @@ -369,7 +369,8 @@ CONFIG_CRYPTO_TWOFISH=3Dm
>  CONFIG_CRYPTO_LZO=3Dm
>  # CONFIG_CRYPTO_ANSI_CPRNG is not set
>  CONFIG_CRYPTO_HW=3Dy
> -CONFIG_CRYPTO_DEV_NX=3Dm
> +CONFIG_CRYPTO_DEV_NX=3Dy
> +CONFIG_CRYPTO_DEV_NX_ENCRYPT=3Dm
>  CONFIG_VIRTUALIZATION=3Dy
>  CONFIG_KVM_BOOK3S_64=3Dm
>  CONFIG_KVM_BOOK3S_64_HV=3Dy

The same change is needed to ppc64_defconfig, please.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__1_Aug_2012_09_45_59_+1000_36XDmsUHeoJjLCWW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQGG43AAoJEECxmPOUX5FEiRwP/05L3CDFHy53dcu/LCTzm34d
yE5vTVE9ZLmTkASpT26nixBnrLt3e8HHJqRL9xRvEIzknGmQcguc1TPlRsefbk+i
msEDchWiv9brGdJ0fNdOX+XB1IwuQbz07V1F6Xb2noUvooQsSwSvQDXnXI+wQEoI
+N1QKvFwQxcE4DcWWptcnNdUkletpQAuiFAxlLY1qplWmsKbdIIa4M58vp1Y7mQ2
dcSfFJclChFuLgzJ9lAnZr9ZNxNlH54t72FL9fhjKIvzE+1u1SIIQZ4Kw/iZoEZT
IunF2iYE/jCS8cH0rhLDm7sVR14EQdJKqAb2DQtJFCUsGlqn640FxcupEptEw9hi
qXH1rC9cOPnePNHx4MBfIZpQRsJhW6HpW9P14CWdrtSMqdoo7g5XkqNdwm2yShAF
XFeO5nV8qmon4qhSI82/1n1xEfKPrjCYMKxfwZdrRzj+jjhC49yyV+nQvn3EV+bc
iw6Um7NzdLsGPe4SGeN1MN93LrvFL7pGt7+DZqf783xAK5SIkmILAS5NnGMMwIOL
OMGMw8t9EukW0eBbnEpdEZG/77MvP6qeLPUO0oSY3Tjowo9AACNSJBPBvHEL/fGT
wIlSITrwsJGZs1wl/hDAmzW7sKJB0Y6wHx1KKz4BMRDaWbdh4r+YA/OFOsNGYxU6
azqmmOTFSErfI28fiUWx
=evYP
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Aug_2012_09_45_59_+1000_36XDmsUHeoJjLCWW--
