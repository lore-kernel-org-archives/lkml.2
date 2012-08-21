Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab2HUMqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:46:48 -0400
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:52079 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757163Ab2HUMqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:46:44 -0400
Date: Tue, 21 Aug 2012 15:42:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
Message-ID: <20120821124243.GG10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
 <20120821124146.GA21557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J1ldk4ymECC/Y9sn"
Content-Disposition: inline
In-Reply-To: <20120821124146.GA21557@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J1ldk4ymECC/Y9sn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 01:41:46PM +0100, Mark Brown wrote:
> > +	regmap_read(smsc->regmap, SMSC_DEV_ID, &ret);
> > +	dev_dbg(&i2c->dev, "SMSC Device ID: %d\n", ret);
>=20
> I'd make these log messages dev_info() or something.

dev_info() ? It'lll just make boot noisier for no good reason. Which
user wants to see this during boot up ? That's a debugging feature for
develop IMHO.

--=20
balbi

--J1ldk4ymECC/Y9sn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM4JDAAoJEIaOsuA1yqREyHgP/2209InzsuTouGTtyopqRUTI
8KAx2RzoVLNcP0qwGyEDd8jNyYXpcp5x4uwNsSRn3tL8zMC6RWuDl7LtWGTs7pBC
hn4x2sEOw0IP1jVYjDucX6FICxpXO3sxG3THFU4f6Yu4LvNFZI30mDL1qkd9Dvzj
71v33lfamXo9QIZJJqUBjNvHy5I4LX8R22kP/0x9DyrBHNcOSq0GWQ0KGqiwEY9V
OVwsMk5zXnntU1cbj803MIgCQNsVDyJZnFpng6G8/rgcnzQHd7X2tFG/NyMbVpfz
IrdDLeKpomui8zO7L3nVRdoofauekL4s61gNWb6Zc8Q4FrSfn/qyNZtO9xXHwdJ9
pBl+Fit18uSWjpG5TLj5NxehpbBe6Gr3+V9wpGb8v8TGdOLn2M+mkKWplnl1yOaB
ohKeSyrCH1W8szrDp8xQK60h61LPS1hcY8wfQIMQTPkqxtZ5lQ1ipaD1bIllGbDf
V97Xy0peYc9Oz9PTvT5ktPQAQ6YOZkJPAoZ8FnOD9qlevQ4W2IQBjulY8FSvIV1l
bRBayJYEfjF/wcrB9bBTqfMCKc4Q8MgbP9nHxuHvokNEbd2/QJDCpn3DnPNu+7iK
jSjPPqKW99Kp9OIvgDPDD9k8erK1a3xASf+ZAJ3GsLMgnYo1Qf/AuB1gX8ueX6Wy
UVrH7jQNDoVUY5S/J8LE
=oLTt
-----END PGP SIGNATURE-----

--J1ldk4ymECC/Y9sn--
