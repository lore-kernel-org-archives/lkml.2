Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2HUNbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:31:46 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:37663 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453Ab2HUNbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:31:43 -0400
Date: Tue, 21 Aug 2012 16:27:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: smsc: Add support for smsc gpio io/keypad driver
Message-ID: <20120821132741.GI10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-2-git-send-email-sourav.poddar@ti.com>
 <20120821124146.GA21557@sirena.org.uk>
 <20120821124243.GG10347@arwen.pp.htv.fi>
 <20120821132222.GF7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JVYm2bz4YjPqKA1I"
Content-Disposition: inline
In-Reply-To: <20120821132222.GF7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JVYm2bz4YjPqKA1I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 02:22:22PM +0100, Mark Brown wrote:
> On Tue, Aug 21, 2012 at 03:42:45PM +0300, Felipe Balbi wrote:
> > On Tue, Aug 21, 2012 at 01:41:46PM +0100, Mark Brown wrote:
> > > > +	regmap_read(smsc->regmap, SMSC_DEV_ID, &ret);
> > > > +	dev_dbg(&i2c->dev, "SMSC Device ID: %d\n", ret);
>=20
> > > I'd make these log messages dev_info() or something.
>=20
> > dev_info() ? It'lll just make boot noisier for no good reason. Which
> > user wants to see this during boot up ? That's a debugging feature for
> > develop IMHO.
>=20
> Most of the registers appeared to be chip revision information which is
> most definitely useful to tell people about, though possibly with neater
> formatting ("why is this batch of boards failing...  oh, right").  If
> they're fixed device IDs then the driver should instead be verifying
> that the registers contain the expected values and bombing out if they
> don't.  Either way dev_dbg() isn't too helpful.

I still beg to differ. Even if it fails, dmesg will still contain the
message (provided you have it enabled). I really don't think we want
this to print to console on every boot.

If you're still testing your new batch of boards, you're not just a
simple user and you will have debugging enabled anyway. dev_info() will
be visible to anyone who's got a console running. Not sure how useful
that would be to my neighbor.

--=20
balbi

--JVYm2bz4YjPqKA1I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM4zNAAoJEIaOsuA1yqRE2u0P/1E2CIENR9R9DEuu1Zna1UJ6
hrefGLqEJMtFtQp4FgTb74Ah+yi7UcDBuODTNDR8YLZ81s38ITGp60akRtujuHeX
QkKToGPy6B3pDgD4bQe2DRKJ/om7U+Zw3QiU8GdUpznxO/wDcwSWoucDk5hZjKN6
/hFf/oT1ws60ECBI4zC028hYQ/MXymEy7k16XVvgd7KEHlxqaYmMAWeZaNY9fJlq
JNLVaXblYKj/LiJ9m80PJUrLb7+nrFJGIgftvXwd5pBrFB8UBpy9zSxaKrD6O2Ox
68y9/VFjR6ssHAgI3zL0LofobZMOfaQ2h63TiLI+NoHTz08LnZK/EUHKnT+keTLi
guX0MjXCmM35qm24Ft8IIxMlG+Z6B8obCGjziZTr0vlTgX1yYVw3oWL8EK9oh8GC
iBhicTUrMTYXiX+0nQ0jmOFcrKUnE488a/AFg+1VqMbcW6oOveHzDf5G6kOgEHq7
FTsDodRfi8T6dD3hv7QIWZ0JVHnDSu+PRzWJ6P0hDADiTzheFBIlAzz8ZFN2VueM
6O8/Lrnh//4HSRirCXMPvxLFhQMjXvY7R7+S4pmXCzhc39+wOwQwn9fbk0yxc1jD
hvKJ8odxvS/EkKi58UiW5VfLFHI2K0kHHMKetLlVJPn29YQ7UFbEVTY9YYCmp5QZ
Qeh6KBPriMn7z5jFIh0W
=dtOa
-----END PGP SIGNATURE-----

--JVYm2bz4YjPqKA1I--
