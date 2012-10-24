Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab2JXKIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:08:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33189 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218Ab2JXKIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:08:47 -0400
Date: Wed, 24 Oct 2012 13:02:55 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] Revert "serial: omap: fix software flow control"
Message-ID: <20121024100254.GG5665@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350396562-32579-1-git-send-email-balbi@ti.com>
 <20121016151357.GN15569@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lHGcFxmlz1yfXmOs"
Content-Disposition: inline
In-Reply-To: <20121016151357.GN15569@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lHGcFxmlz1yfXmOs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, Oct 16, 2012 at 08:13:59AM -0700, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [121016 07:16]:
> > This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
> > (serial: omap: fix software flow control).
> >=20
> > As Russell has pointed out, that commit isn't fixing
> > Software Flow Control at all, and it actually makes
> > it even more broken.
> >=20
> > It was agreed to revert this commit and use Russell's
> > latest UART patches instead.
> >=20
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
>=20
> This seems like the best way to go for the -rc series:
>=20
> Acked-by: Tony Lindgren <tony@atomide.com>

Any chance you can pick this one up for v3.7-rc3 ?

cheers

--=20
balbi

--lHGcFxmlz1yfXmOs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQh7zOAAoJEIaOsuA1yqREI4IQAKVXiIKQc489tzBZannUfi/w
yfwWLwedUJZKof0kzdM/dKxqZL+qCilL2u0piuKLnuRzH4GQcVPbuXP+AGx9/766
V+Ljkltz+09hhRTMZWtxvgWYGYHyZNnveVAYh0bp1u+05XRPsiJLuoXnEfZNkWkU
2bYSMtTo0qcNaTZkkC3+0ea7mJHysLBXqbnbwcLhdhPGndk1uhinKcQfWuGXZSAe
/p6emuM0OMpPoqpKy/cnQrgccTYP4nMCMI/NW8LiAuswffMu3ohS8GM4ZBsZp6NK
+4zetajE70xugcIeOvL30VdIIcVdEjMg+tvXOh8hpYSof3FiUPLXIeKUZuEiDyTy
HdRHV87OQnS5Zk4TqqJNBSuilpzMKxRSRNYDTXlA3BF12BNTvOj+OkrH/2yAQp68
lT5Er+tsPdvgb328DLFehs92YKmZafdAKZivSjpxn+mqMbVkvQjd46k+OKcztWKS
/IuQ/JMO9HxSpWEYOftktO851UOVJnWQ5qUeSlRHYVHc8EMwpA/J61eZWfDV8oEA
2KQhNlQwTxiAWI4Do0MXOkhdBV049pCL4Wk2WOYMpvFRD/dANqTy/vWRkZhYzjNY
pSQpiOVEatwU8cojWujJWJJVmjC8UdRnA0dveftU3zFLhUHHruomflWoAZzdIekC
2OPjOtDE1EQKJj0EvkEE
=4Hvm
-----END PGP SIGNATURE-----

--lHGcFxmlz1yfXmOs--
