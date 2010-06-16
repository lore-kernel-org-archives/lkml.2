Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab0FPGaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:30:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33608 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab0FPGax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:30:53 -0400
Date: Wed, 16 Jun 2010 16:30:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, bhutchings@solarflare.com
Subject: Re: linux-next: build warnings after merge of the net tree
Message-Id: <20100616163048.f72345c7.sfr@canb.auug.org.au>
In-Reply-To: <20100615.215212.214211994.davem@davemloft.net>
References: <20100616133854.1bbbbb37.sfr@canb.auug.org.au>
	<20100615.215212.214211994.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Jun_2010_16_30_48_+1000_+er/GVaxO2Thwcku"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Jun_2010_16_30_48_+1000_+er/GVaxO2Thwcku
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 15 Jun 2010 21:52:12 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> I've commited the patch below to deal with this, thanks for the report.

Thanks.

> There's some pre-existing warnings someone will need to deal with at
> some point:
>=20
> drivers/usb/gadget/rndis.c: whole file: warning: coding style is bolixed

:-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Jun_2010_16_30_48_+1000_+er/GVaxO2Thwcku
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwYb5gACgkQjjKRsyhoI8zAagCfSiACMgT3znDDo3zHjcbpY9B2
FCkAnRom+lesCiC4AgaVR0jJDHHDsROX
=EG3p
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Jun_2010_16_30_48_+1000_+er/GVaxO2Thwcku--
