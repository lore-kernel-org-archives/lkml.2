Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0DFAGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 20:06:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59556 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab0DFAG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 20:06:27 -0400
Date: Tue, 6 Apr 2010 02:06:24 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Ben Dooks <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: i2c-drivers: Remove dangling pointers
Message-ID: <20100406000624.GA2893@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <20100405225925.GC32401@fluff.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
In-Reply-To: <20100405225925.GC32401@fluff.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

> > here is a patch series fixing I2C drivers which free their private data
> > structure and leave the clientdata pointer dangling or do the cleanup i=
n the
> > wrong order. All occurences were found using coccinelle [1] and the sem=
antic
> > patch below. The matches have been reviewed, and sometimes adapted.

[...]

> From the list of things here, there's nothing in here that I should be
> worried about (just checking) ?

Correct. Just ignore this series.

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAku6ewAACgkQD27XaX1/VRvttgCgin2BILMMKf22Dl1cEG/KCBi/
UcEAn2btQWLqN9K0+4x7hl1iT22zsRlp
=nHqp
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
