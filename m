Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2BUJxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 04:53:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60569 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639Ab2BUJxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 04:53:12 -0500
Date: Tue, 21 Feb 2012 09:53:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>, Cyril Chemparathy <cyril@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Group TI TPSxxxxx regulators together
Message-ID: <20120221095309.GB3079@opensource.wolfsonmicro.com>
References: <1329799491.7033.1.camel@phoenix>
 <4F432D7A.7030805@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mxv5cy4qt+RJ9ypb"
Content-Disposition: inline
In-Reply-To: <4F432D7A.7030805@nvidia.com>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mxv5cy4qt+RJ9ypb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 21, 2012 at 11:06:58AM +0530, Laxman Dewangan wrote:
> On Tuesday 21 February 2012 10:14 AM, Axel Lin wrote:
> >Group TI TPSxxxxx regulators together and sort them in alphabetical order.
> >This change makes it easier for users to find config options.

> Should we only arrange the tps regulators or all regulators in
> alphabetical order?
> I will prefer to arrange all which inherently will arrange tps as
> all ti regulators start with tps..

We should just sort the whole list.

--mxv5cy4qt+RJ9ypb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQ2l7AAoJEBus8iNuMP3dRQcP/2QU9vRzq0WzgGGKXJwB7WU4
R+AIUGW1PAU2r855bMFOj1XsvT9+eYCcJsDFXAkHQIxIzfOOMUGEq4daD83xBpDN
CQzsXhr3/akfoFMiqYzDAhU8lNgvu9MeOBL9get9M3EKqyW7QzMKlxSi/PuFolCi
Cs7iTrHsotOrE9IWBKKVdes+TPOHjTFUZJUbnBVywPby4K/5auyp58eR1yZu/dMj
LCClof+HR9lUBHGFnLV88ErvHYeIF17Tlwxd6tmkvzKIMeUokNZr1kI9j2Au0aNt
KT4fMXlynG6/kCr+ZuFhXd+6YMcfBltv6zoCv6amB90ZFfsH6Qnfm1BSZrzeXplH
8iYmlJTc30FvbM+3Gtf0NgnEXSjmizgfZEP4vmtqoSMu3z/OpEV/3QKRGf4YDqQG
r6BYI7dKjHdTP+JDxsbNvWCnyO9xeHOrI4V1us+Xis3En+KgRfzAJxb4DQ2/+fgg
GbIW/vhNkJnowdF/1eqsHVNsheHaRRIGRKUDiaXIq4uIL6xcetY9NmnhLnH6MKcy
woP1HZe3xXFisCXIfWjT8I5uwyp4cJMS6Zmp+M7cKPYQdJZi3mrxCqEh7mjxXODN
HgU+onrFQSHqJNFUyyVvw2dKmM8IXg0ZVX0dTSfxURJHlN20jVGyRzRYHmjG5CNf
UpSiJ4M9STDSqRsmJ2xk
=vAYI
-----END PGP SIGNATURE-----

--mxv5cy4qt+RJ9ypb--
