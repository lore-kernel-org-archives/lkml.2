Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2ELOmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 10:42:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35498 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab2ELOme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 10:42:34 -0400
Date: Sat, 12 May 2012 16:42:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        ben-linux@fluff.org, olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 1/2] i2c: tegra: make all resource allocation through
 devm_*
Message-ID: <20120512144220.GK20673@pengutronix.de>
References: <1336373179-12739-1-git-send-email-ldewangan@nvidia.com>
 <4FA7F5E5.4070609@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TC23+W66xmFESAX"
Content-Disposition: inline
In-Reply-To: <4FA7F5E5.4070609@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TC23+W66xmFESAX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 07, 2012 at 10:18:45AM -0600, Stephen Warren wrote:
> On 05/07/2012 12:46 AM, Laxman Dewangan wrote:
> > Use the devm_* for the memory region allocation, interrupt request,
> > clock handler request.
> > By doing this, it does not require to explicitly free it and hence
> > saving some code.
> >=20
> > Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>=20
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
>=20
> Note thought that devm_clk_get() appears to have been introduced very
> recently in linux-next, so in order to merge this patch one of the
> following has to happen:
>=20
> a) This patch goes through the tree that merged the addition of
> devm_clk_get() (which I think is Russell King's ARM tree)

I think it would be way more fitting if those go in via I2C.

> b) Whichever tree takes this patch must first merge a branch that
> contains that patch that adds devm_clk_get().

I have been pointed recently to subtle bugs when converting to devm_*.
Even more, there is still the ongoing idea of platform_devm_* to
simplify further. I need to scratch my head about those in general, but
I won't do this before my 10 day vacation starting tomorrow. Until I am
done with that, the devm_get_clock is probably in mainline. While devm_*
patches are nice, they are not really critical. So, I prefer to take
some extra time to get it right.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6TC23+W66xmFESAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+udswACgkQD27XaX1/VRsOUACfbqPnh7/87f57bU87RajFJidE
fZkAn3mQSm5t3taootaMcr2Fp0WHsBVn
=0ssT
-----END PGP SIGNATURE-----

--6TC23+W66xmFESAX--
