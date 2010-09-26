Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab0IZPRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 11:17:22 -0400
Received: from vps.mortis.eu ([79.99.135.181]:44178 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab0IZPRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 11:17:21 -0400
Date: Sun, 26 Sep 2010 17:17:18 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Cc: Wim van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/3] watchdog: f71808e_wdt: Cleaned up and replaced
 some magic numbers by constants
Message-ID: <20100926151718.GC7185@salidar.me.mortis.eu>
References: <20100926143820.GD2150@kreios.titan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <20100926143820.GD2150@kreios.titan>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 26, 2010 at 04:38:20PM +0200, Lutz Ballaschke wrote:
> Cleaned up and replaced some magic numbers by constants.
>=20
> Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
> ---
>=20
>  drivers/watchdog/f71808e_wdt.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)

Signed-off-by: Giel van Schijndel <me@mortis.eu>

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel
--
"A clever person solves a problem. A wise person avoids it."
  -- Albert Einstein

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyfY/4ACgkQZBYm/87l50JhbwCfSajwVdRFRKhvAX534729G8rq
gKcAniEKX9BpfqmFB86T4fS7LqDKMHSL
=hjDh
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
