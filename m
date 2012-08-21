Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2HUNW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:22:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56679 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab2HUNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:22:24 -0400
Date: Tue, 21 Aug 2012 14:22:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
Message-ID: <20120821132222.GF7995@opensource.wolfsonmicro.com>
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
 <20120821124146.GA21557@sirena.org.uk>
 <20120821124243.GG10347@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3yNHWXBV/QO9xKNm"
Content-Disposition: inline
In-Reply-To: <20120821124243.GG10347@arwen.pp.htv.fi>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3yNHWXBV/QO9xKNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 21, 2012 at 03:42:45PM +0300, Felipe Balbi wrote:
> On Tue, Aug 21, 2012 at 01:41:46PM +0100, Mark Brown wrote:
> > > +	regmap_read(smsc->regmap, SMSC_DEV_ID, &ret);
> > > +	dev_dbg(&i2c->dev, "SMSC Device ID: %d\n", ret);

> > I'd make these log messages dev_info() or something.

> dev_info() ? It'lll just make boot noisier for no good reason. Which
> user wants to see this during boot up ? That's a debugging feature for
> develop IMHO.

Most of the registers appeared to be chip revision information which is
most definitely useful to tell people about, though possibly with neater
formatting ("why is this batch of boards failing...  oh, right").  If
they're fixed device IDs then the driver should instead be verifying
that the registers contain the expected values and bombing out if they
don't.  Either way dev_dbg() isn't too helpful.

--3yNHWXBV/QO9xKNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM4t4AAoJEFJkBDiqVpZ47ycP/3WlVznBTOKwzSi3GAfbVkUN
qLeaURQHyUCVP95PzsrrnelTdWJb0nH0fDh51RwpywlwHOjMry8fqVXba4/BVwQS
xMsGNvhRkhcXfV7CkvqtdGEqBiGH2ZW8ksOoPB9CO2SJhcH5KpzEFnvPlDDg9+8L
MBGlIuB37WASTj7B8lEdW66FbQe+ZAYIKt5vIolUIoK6P048Ys43bldwq0FjaYZF
AZv2qdz0CACSDlmcoMBMfw91pavo+kdeHFIUMoThU3QVAkAhbXGyRhhPBPkalGiI
bvHchuVz3x92IvXclt7EQRkTHFIvHgIgBddYQBsa36lD4A/GfxwGFVtwl8BsPZiX
34tFTA+KA/oXArE3tO/OmEhXSbSG/AUYYdFfl0b54oV/5+KBGkrCOVsx+UuuysHw
LQYj6vJPTzNrgnMaP4HyUrBtnt2fyJNZSocpjborf++8B4fTM5jVQInT6IQNnUEM
XfluppGEUJoLnLeWTGgdev0JzCZ/mzzXaKqtUcxSQO1AELvVOa1AnbxrUcnRIk2M
8sDnES6BYokH+4UgIOSnucieYTlhI639xCEGJq31Yom1CE2DVrG0DbcncLUhkzmm
BD6f8h0jmeQ5CbTNGVMgt5hy9wuLK2dEBY9V+Ha1sZD5SPe3k/7Dc5AHsrEKHsIC
Nnhomm337Jkcj5Ytlelc
=5Dag
-----END PGP SIGNATURE-----

--3yNHWXBV/QO9xKNm--
