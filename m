Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab0C2Roz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:44:55 -0400
Received: from vps.mortis.eu ([79.99.135.181]:49459 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab0C2Roy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:44:54 -0400
Date: Mon, 29 Mar 2010 19:44:52 +0200
From: Giel van Schijndel <me@mortis.eu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Hans de Goede <hdegoede@redhat.com>,
       Jean Delvare <khali@linux-fr.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] resource: shared I/O region support
Message-ID: <20100329174452.GA4063@salidar.me.mortis.eu>
References: <20100325125005.6d58cfaf@lxorguk.ukuu.org.uk>
 <1269523063-30346-1-git-send-email-me@mortis.eu>
 <20100325155705.1ec79dbc@lxorguk.ukuu.org.uk>
 <20100325180347.GA2761@salidar.me.mortis.eu>
 <20100325181633.0313b8a5@lxorguk.ukuu.org.uk>
 <20100329081834.GB27956@salidar.me.mortis.eu>
 <20100329090713.1317942b@jbarnes-piketon>
 <20100329173800.GA3583@salidar.me.mortis.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20100329173800.GA3583@salidar.me.mortis.eu>
OpenPGP: id=CEE5E742; url=http://gpg.mortis.eu/me.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 29, 2010 at 07:38:00PM +0200, Giel van Schijndel wrote:
> On Mon, Mar 29, 2010 at 09:07:13AM -0700, Jesse Barnes wrote:
>> I can take it; sometimes Linus applies resource stuff directly though.
>>=20
>> Can you resend with the appropriate s-o-bs etc?
>=20
> Sure.
>=20
> (I copied Alan's signed-off-by from his reply to the patch)
>=20
> Patch after this line:
> ... snip ...

PS (to be sure authorship is maintained):
> This patch was originally written by Alan Cox [1]. I only updated it to
> apply correctly to Linus' current tree and changed IORESOURCE_MUXED's
> value from 0x00200000 to 0x00400000 because the former has already been
> taken in use since.
> =20
> [1] https://patchwork.kernel.org/patch/32397/

--=20
Met vriendelijke groet,
With kind regards,
Giel van Schijndel

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuw5xQACgkQZBYm/87l50KBQQCgpmVYuuvUDsQagKCPzAdjnu1w
qL8AoJBtJFH7byjLt5sutvyMdL5oPqCJ
=WYdE
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
