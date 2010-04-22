Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab0DVH74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 03:59:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57246 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab0DVH7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 03:59:54 -0400
Date: Thu, 22 Apr 2010 09:59:37 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Farid Hammane <farid.hammane@gmail.com>, ben-linux@fluff.org,
       Enrik.Berkhan@ge.com, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-algo-pca: fix all coding style issues in
	i2c-algo-pca.c
Message-ID: <20100422075937.GN24384@pengutronix.de>
References: <1271877097-10939-1-git-send-email-farid.hammane@gmail.com> <20100421235738.GB24384@pengutronix.de> <20100422092524.77b7aa84@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lBqJz4CGKwlWe7/k"
Content-Disposition: inline
In-Reply-To: <20100422092524.77b7aa84@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lBqJz4CGKwlWe7/k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 22, 2010 at 09:25:24AM +0200, Jean Delvare wrote:
> On Thu, 22 Apr 2010 01:57:38 +0200, Wolfram Sang wrote:
> > Hi Farid,
> >=20
> > thanks for this approach. Have you checked that the binary is the same
> > before/after your patch? If so, please mention in your patch descriptio=
n.
> >=20
> > Also, always keep in mind that checkpatch helps to make code readable. =
Some of
> > your changes should keep readability in mind not just fixing the warnin=
gs.
> >=20
> > On Wed, Apr 21, 2010 at 09:11:37PM +0200, Farid Hammane wrote:
> > > This patch fixes all coding style issues found by checkpatch.pl.
> >=20
> > >=20
> > > Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> > > ---
> > >  drivers/i2c/algos/i2c-algo-pca.c |   74 ++++++++++++++++++++++------=
---------
> > >  1 files changed, 44 insertions(+), 30 deletions(-)
> > >=20
> > > diff --git a/drivers/i2c/algos/i2c-algo-pca.c b/drivers/i2c/algos/i2c=
-algo-pca.c
> > > (...)
> > > @@ -178,12 +178,12 @@ static int pca_rx_ack(struct i2c_algo_pca_data =
*adap,
> > >  }
> > > =20
> > >  static int pca_xfer(struct i2c_adapter *i2c_adap,
> > > -                    struct i2c_msg *msgs,
> > > -                    int num)
> > > +		struct i2c_msg *msgs,
> > > +		int num)
> >=20
> > One more tab maybe?
>=20
> Better use tab + spaces and align on the opening parenthesis. What
> checkpatch.pl complains about here isn't the alignment, it's the use of
> more than 8 consecutive spaces.
>=20

OK

> > > (...)
> > > @@ -241,8 +244,10 @@ static int pca_xfer(struct i2c_adapter *i2c_adap,
> > >  			completed =3D pca_address(adap, msg);
> > >  			break;
> > > =20
> > > -		case 0x18: /* SLA+W has been transmitted; ACK has been received */
> > > -		case 0x28: /* Data byte in I2CDAT has been transmitted; ACK has be=
en received */
> > > +		case 0x18: /* SLA+W has been transmitted;
> > > +			      ACK has been received */
> > > +		case 0x28: /* Data byte in I2CDAT has been transmitted;
> > > +			      ACK has been received */
> >=20
> > First, check CodingStyle for how multiline comments should look like. F=
or
> > readability, I'd like to keep them single line, though. I think this co=
uld
> > be done by rewording. Same for all following comments.
>=20
> Please keep in mind that Farid doesn't know the code. He is "only"
> helping with formatting cleanups. Asking him to reword the comments

I think s/has been//g will help already. And getting accoustomed to the code
you are modifying is not that bad ;)

> doesn't seem wise. And there's nothing wrong with two-line comments as
> above. The "preferred comment format" in CodingStyle is often
> unrealistic IMHO, I'm not always following it in my own code.

I disagree here. I'd rather break the 80 columns limit than having multiline
comments not really standing out.

Also, I feel a bit uneasy as changing the comments spoils the history for
git-blame in case you want to know when/if the state-machine was changed. T=
hen
again, I like properly formatted code.

Summa summarum, just send V2, it's not really worth fighting over it :)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--lBqJz4CGKwlWe7/k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvQAekACgkQD27XaX1/VRvcOQCgm3eIvaWEoYzQcdvM6RrJ21RU
39wAn0yL9JVFtxXHq56QO2Hg3Wi5lr61
=AN/P
-----END PGP SIGNATURE-----

--lBqJz4CGKwlWe7/k--
