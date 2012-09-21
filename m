Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2IURXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 13:23:33 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:40262 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652Ab2IURXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 13:23:30 -0400
Date: Fri, 21 Sep 2012 20:18:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sekhar Nori <nsekhar@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 08/13] mmc: omap_hsmmc: limit max_segs with the EDMA
 DMAC
Message-ID: <20120921171840.GB10409@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348152226-13588-1-git-send-email-mporter@ti.com>
 <1348152226-13588-9-git-send-email-mporter@ti.com>
 <CANfBPZ81anOy8fWgKM1PgCtB4V2pEp2x1Qi4x1uPsq7QieMN5g@mail.gmail.com>
 <CANfBPZ-h7MD4X_NRYfwOmMnEyOKy0bTNNLNRmdbef2pe=2aHyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <CANfBPZ-h7MD4X_NRYfwOmMnEyOKy0bTNNLNRmdbef2pe=2aHyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 21, 2012 at 10:47:30PM +0530, S, Venkatraman wrote:
> On Fri, Sep 21, 2012 at 10:45 PM, S, Venkatraman <svenkatr@ti.com> wrote:
> > On Thu, Sep 20, 2012 at 8:13 PM, Matt Porter <mporter@ti.com> wrote:
> >> The EDMA DMAC has a hardware limitation that prevents supporting
> >> scatter gather lists with any number of segments. Since the EDMA
> >> DMA Engine driver sets the maximum segments to 16, we do the
> >> same.
> >>
> >> Note: this can be removed once the DMA Engine API supports an
> >> API to query the DMAC's segment limitations.
> >>
> >
> > I wouldn't want to bind the properties of EDMA to omap_hsmmc as this pa=
tch
> > suggests. Why don't we have a max_segs property, which when explicitly =
specified
> > in DT, will override the default ?
>=20
> If you are adventurous, this can be a generic mmc DT binding instead
> of restricting it to OMAP.

I say if it's a limitation in the DMAC, then DMAC's driver should handle
it, no ? Meaning that in this case you would copy from one multi-segment
sg into a one-segment sg and when transfer is complete, before calling
user's callback, copy data the other way around (?)

--=20
balbi

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQXKFwAAoJEIaOsuA1yqREWTUP/10iBfr1wNrAWCDghpd4U6dl
wDjgM4HgNKsrYRl3uMn+NShEjYNyPSxtETSmODVUbSU2wo3h/AVuo/LLQwJhcHCY
dQoF/h3Az2uEaJGZdfnwU48zv9SnQ/X//ZTstaSRzjZDkrC/WRPYiqmMtScgyklU
qvnF+BS7mNn+MHjQk5b8QsRUi8nk4rCiUlh3AouAhUlekPXPXkM3KF2PDEgin+9e
GKYu+8bMRy4w2/qbB2cSSCGNxVIfk250V8aAZfZ1vqNmGOMN7tD9F6qEZJYuq6OZ
aHHaumkj+KptFOjXlfk3mL1Q5sTgMMZRC5ZZXBzRlILl8H0NW0ghXTvQyqnX2Y2V
J7u1D11vXAQkgTSfzSr2JK7WXy9KYTnL82E/LsZhBmxrEGEVfPGGf97pKD7okt90
NYqF0PzR3CE6S7GPwBccjJwcBsusaT23+fXNS70GaWVqH8e+eUxDTubIak4ThNZC
MEqvjEXCNR6CDDa4L3JBdRFl9E1BQ5H1OvGKLHvxDItbSh3TTPHQCxjlaspGL2oW
CWaPAoZTF0EajhSN7zYHZFW8TzxYdY5sCcFOpY475myucPs2q/UonzDd6VHwurah
nINkgLb1H7HhnCdgbSHDvqbxB/a4yzCny2lJmWL5zYATVJL1g3uPsVhtVX4cz70u
Nj0JmrafhJRUR8v5flxs
=09if
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
