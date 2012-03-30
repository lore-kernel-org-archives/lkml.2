Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365Ab2C3U3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:29:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56140 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759571Ab2C3U3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:29:07 -0400
Date: Fri, 30 Mar 2012 22:29:00 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Denis Kuzmenko <linux@solonet.org.ua>,
        Dong Aisheng-B29396 <B29396@freescale.com>
Subject: Re: [PATCH RESEND] gpio: add flags to export GPIOs when requesting
Message-ID: <20120330202900.GA15083@pengutronix.de>
References: <1323797641-7277-1-git-send-email-w.sang@pengutronix.de>
 <20120106152741.GE2610@pengutronix.de>
 <20120116163154.GF4223@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <20120116163154.GF4223@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2012 at 09:31:54AM -0700, Grant Likely wrote:
> On Fri, Jan 06, 2012 at 04:27:41PM +0100, Wolfram Sang wrote:
> > On Tue, Dec 13, 2011 at 06:34:01PM +0100, Wolfram Sang wrote:
> > > Introduce new flags to automatically export GPIOs when using the conv=
enience
> > > functions gpio_request_one() or gpio_request_array(). This eases supp=
ort for
> > > custom boards where lots of GPIOs need to be exported for customer
> > > applications.
> > >=20
> > > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > > ---
> > >=20
> > > Based on 3.2-rc5. Previous discussion (with kind of acks) can be foun=
d here
> > >=20
> > > http://lkml.org/lkml/2011/11/15/378
> >=20
> > Ping. I am using this patch with v3.2 right now and it is really useful
> > (and no build failure this time (I owe you a drink for my last patch!))
>=20
> Applied, thanks.

Has it been missed? I don't see it in linus-tree or your gpio-next?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk92F4wACgkQD27XaX1/VRucBwCdGRbkDV45TSvQJ7E7YGX3hUi/
H0EAni3spRlCwoPf0ukYQWvKuFcsFAWd
=olvM
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
