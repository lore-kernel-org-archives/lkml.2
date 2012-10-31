Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205Ab2JaIvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 04:51:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935176Ab2JaIux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 04:50:53 -0400
Date: Wed, 31 Oct 2012 09:50:47 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: platform: Don't initialize driver-private data
Message-ID: <20121031085047.GE1835@avionic-0098.mockup.avionic-design.de>
References: <1350324222-26885-1-git-send-email-thierry.reding@avionic-design.de>
 <15899660.S8avMzQBpd@avalon>
 <20121031082607.GA1835@avionic-0098.mockup.avionic-design.de>
 <1397581.cKqVYz2Abn@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qz2CZ664xQdCRdPu"
Content-Disposition: inline
In-Reply-To: <1397581.cKqVYz2Abn@avalon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:IzMUFWeVhTE0NkON2Joz0vqj/wdyl123qO4bTYjuk9z
 ICiw2AlI5Kd8NaDxFN7ifXIhO5lq1nisoaPUsGRxfkqEfyX0Z0
 hB+Ys7vcK25yLA2mVrpuG7va9qUhJdIBj5/51+K2ZRwy6dXejb
 l9Z9jhhiJwi2eFP1DExRcMMrrby9X4iFy1LcY6ZeLFdvnTs3tx
 m482zfGRW7jajbjaIiGn6xOhQM4sEDqB7J0SXIPW085YpXS/Mn
 n2bgKM3RvQDTzsiOTcvpuLSXTe6TD6ZDDhJy6GcQhifGKGhBgv
 YoONRXCjiF+uadyAijJhYbTAqSRh7p6D97e8mN8QfmdPefbn7K
 vw0yeyUWSZG9NIBQnI3wiRL0e0t5teOIG60x4pg1rdqjllo+iO
 XOr7rHQGW8sA2Gu/2eSVxNquPDATtJ15z4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qz2CZ664xQdCRdPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2012 at 09:31:27AM +0100, Laurent Pinchart wrote:
> Hi Thierry,
>=20
> On Wednesday 31 October 2012 09:26:07 Thierry Reding wrote:
> > On Fri, Oct 26, 2012 at 04:06:27PM +0200, Laurent Pinchart wrote:
> > > On Monday 15 October 2012 20:03:42 Thierry Reding wrote:
> > > > Platform device drivers usually use the driver-private data for the=
ir
> > > > own purposes. Having it overwritten by drm_platform_init() is confu=
sing
> > > > and error-prone.
> > >=20
> > > If you want to push drivers that way, you should get rid of the
> > > pci_set_drvdata() call in core DRM as well. This would push device dr=
iver
> > > data handling down to all drivers, so I'm not convinced it would actu=
ally
> > > make things simpler.
> >=20
> > I think the problem doesn't exist for PCI-based DRM drivers, so I didn't
> > look at it. The issue only arises once the DRM needs to glue together
> > multiple devices, as is usual with the drivers for embedded devices,
> > where the drivers are based on platform devices.
> >=20
> > I agree, though, that for consistency it would be nicer not to do this
> > for the PCI-based DRM drivers either. If David agrees I can take a look
> > at converting the other drivers along with the change to the DRM core.
> >=20
> > Pushing the handling of the driver-private data down to the drivers may
> > not make things easier, but at least it would be consistent with other
> > drivers. I didn't mention this in the patch description but it actually
> > took me a day to track down why the driver kept crashing until I figured
> > out that drm_platform_init() actually modified the pointer.
>=20
> So we either need your patch, or a documentation update :-)
>=20
> The patch itself is fine, I'll let others comment on the approach.

The patch already went in through David's tree, so I guess that says
much about his opinion on the matter. =3D) Still I think there's some
value in making this consistent across all drivers and if everybody
agrees I'll volunteer to write the patch.

Thierry

--Qz2CZ664xQdCRdPu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQkOZnAAoJEN0jrNd/PrOhyv4P+wQVElDxfO7EcdCYSUzURUaA
3hfblLIS7pxGZtU2eORf6MRlLPOgenu9n6hm6A9S6wBjjoH1hcxF/0UZDAmSwqBF
y0CIKEfcpSwhlb92MPrzdrHrHp5ORjtilvPB/O8PmbxvTf5HJoO6PgugemqSCHDy
W5TlsQqcHY/7FLzgrPscB8QQXQhUhc26BIV1qroI2NdSaC1KifSBorovBD1RqrHF
R+jBKNwi1j7SVuBjckdR0cTHyvEHowLGXUNZ2WSnmQALGImsMnakusDHvl7WZlV6
hp7zkSfduhSEK/7Igg/oQ7BTeFWBV1o3NrEjp9JN0EiqFo+Dh+kwEsx6meKr8p5W
djFTQar41Phyl/WVGR0y3YA447OxQWvF2b8/cYd2SlKcdLIkXh52xPefw4/QLSM0
wsG+ahI8rFgcaRGhBZVDNNK4HON+XAD+fGOWIlDaHaUWCDTKUdum19idbSI6zWWw
lgSw2k9+hqlBqdcYeicKn1OJbjapYcBJYYn3GtH60cEa1Yvnca23Ux44usoUl8Al
XCBV4eex318Y9vSuQz4l9CDyvJWTFARD+tt4/MY6dE0fzV2k+n0eKStIlwZ2F8aJ
4sVcuBCyt5Bs1mjiSLSkjf1GQa2eUQ6w+6x9l83qRbUhDEVLPyigjsXiY727atfB
klh8ZUuGF6TtVV2o8eIU
=S9/s
-----END PGP SIGNATURE-----

--Qz2CZ664xQdCRdPu--
