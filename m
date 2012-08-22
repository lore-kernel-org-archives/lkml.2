Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2HVFmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:42:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63818 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab2HVFmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:42:24 -0400
Date: Wed, 22 Aug 2012 07:42:05 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>, Alex Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
Message-ID: <20120822054205.GA28845@avionic-0098.mockup.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
 <1345535069.4085.7.camel@deskari>
 <1562509.b0FYTUZ1D8@percival>
 <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
 <1345539465.4085.22.camel@deskari>
 <20120821091306.GA4819@avionic-0098.mockup.avionic-design.de>
 <1345542860.4085.40.camel@deskari>
 <20120821165738.GY7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <20120821165738.GY7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:MdXYeNDoCu8fLYVia11gT6AFwYwWPLPok9+W7sTDpPD
 LHl3oDOEg3ev67moIu8OhA/b9NTCkOt2+8ZUtnmRbuZjXBgBZj
 Ngu7iHEggrY9MpsYEpZJX0xvo31yxg53gVHO9ABQ677Cy/zlnd
 36hGaiL4PKELsTcgzZY7QlIe7RvxkS3GVLZQPgXWCwHgY4Fb+Y
 AjLMUjb85fAGHO6rwRthUTvkUeJ9q0xfpThtV/tEjOyqdsgh43
 YP2BwGeyRo0eZ24ONDPlBUF37siYQbpeYcfiTGXc1xuW7k0Hke
 6ga9YTRthjs5Aoe+8z9MHLLVzpbGGDlQkNlj/ewii6VdKRIGvF
 bSAPKG65e+4pfEy5/lkrRT6malLpccpvouPEVhsZEJNOW05zNa
 CmYAhapEMpCgaCuVYHFz5zicJDJBGbpLmI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 05:57:38PM +0100, Mark Brown wrote:
> On Tue, Aug 21, 2012 at 12:54:20PM +0300, Tomi Valkeinen wrote:
>=20
> > However, if we already have a generic driver for that type of panel,
> > (which we would need anyway for the DT based approach), the developer
> > only needs to add the name of the panel and the data for the power
> > sequence to the panel driver's database, which is about the same amount
> > of work as with DT.
>=20
> > So it's really just a question of where to put the data in question, DT
> > or driver. Both contain the same data, and the data structure may also
> > be the same. In DT's case it just needs to be parsed first, whereas in
> > database case you'll enter the data in structs.
>=20
> I think the device tree idiomatic way of doing this is to have a bunch
> of .dtsi files for the panels which then get included by reference in
> the board files.  This isn't helpful to people working on non-DT
> architectures though.

One problem that's likely to crop up here again is that the panels won't
be properly describable in the DT. Typically there is no device that can
be addressed by the CPU. This is the same as for backlights and fixed
regulators.

Thierry

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQNHEtAAoJEN0jrNd/PrOhUUIQAJDp2eepbgrmwXCTk4WKJ8mS
seP2HOS9qyr4MfJemkP2jTBtFLb0H4xuyT7Npv2AWPsuoRk//ifmfgyOGw7xQabY
tj9e8KmGQIEXx0TTOV0qxP9fo3+A+HS8itYvvc0u8+QmRkmj7Z6eIY7jTXQjVSPe
QcvHQqPcYnIZTfbg1l9GEeXFTJwr7iDlnVMwtttoDkX8rRsj1+YfpMkk4DvkPCwh
vdcTlTIz/0eJnk1sp7MffE1muFGiVy+wOBMnBe6MgQ2gjseh/yPtBlkQa2U6bik2
Usr/+lwZ6MTKYa0VKA4Ct8YvK4Ep15s4rEaO9OUHUBCV4H3KtkOm7YMwNEw2tre4
gYHi+yH3dIm9LgN+e372A6kqquBa553ClqtFfy5yZd1/nVKWEF1VnHnH3arV3vHR
jJsRHajbrE1EZkbdmTV9WdSAZaqru4MWMCGBRVGskviABXboAwlPIU6NVWZspXtn
paLLMzFY0kzNz6WLMSKg9leDoO+2PrPFfUR8RQUpH1uWvGQUiGWbA7KeI8+HPX30
g2WgAKTzql9O6Rkf3H/85LbqM5WOYg9NBn7FsKWNi6yUVLQj4TYio2QDrggl4G7b
pTTKK/gfxfl2pSd7qQBUgvvKhCwkUNwim2asr4iZJ0AomAj5rMRLEedeLHDsRoSQ
mDDcSMWoaaklQj/lcMaQ
=yaLS
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
