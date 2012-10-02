Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2JBIIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:08:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2JBIII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:08:08 -0400
Date: Tue, 2 Oct 2012 10:07:52 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sekhar Nori <nsekhar@ti.com>
Cc: "Philip, Avinash" <avinashphilip@ti.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH 1/2] pwm: pwm-tiecap: Add device-tree binding support for
 APWM driver
Message-ID: <20121002080751.GA16928@avionic-0098.mockup.avionic-design.de>
References: <1348658863-29428-1-git-send-email-avinashphilip@ti.com>
 <1348658863-29428-2-git-send-email-avinashphilip@ti.com>
 <20121002060014.GA4298@avionic-0098.mockup.avionic-design.de>
 <506A94C0.1010106@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <506A94C0.1010106@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:ljCxTfNd2CuNXeW5y3lOyevVp0n3IgwwdeOO/UX5b/b
 4GoNlghBhfgluztqwzEnAsRlxjq9kvE5CzzLvmDW6XQTntzPFC
 qqwmG/JrNE5FSEN/TtkmxOKIBPRjnsXD7ppSjDiex9jk++9MDV
 kDX8JYFD7XsBsOC2Rq2ULLsi4uDvlBibR5FgWKTzTjWpQiqym9
 BzwJ1OcYnF04zvg7fOV5WjvSp8LqtAuZK9Zz57DOZBFifd8E+y
 wGSG6XO6l0EV4eesVSMSTOjVJ9px4Yt4YHbwGl2xdenIyNpLv/
 DFNrC7U7baoc0z7rb3su2xCIUha9y9UqCLro+JnXWOTKf26qX2
 ewuZXt77M5NZXH1wouwF2chp92fhFNhpNTKA9HfGEKeJS30RWW
 MLcnBbMdJJ2eehVeIIyObeY+KIm1SxELsmCGDJYGJqJSEVGt9c
 XmD18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 02, 2012 at 12:46:16PM +0530, Sekhar Nori wrote:
> Hi Thierry,
>=20
> On 10/2/2012 11:30 AM, Thierry Reding wrote:
> > On Wed, Sep 26, 2012 at 04:57:42PM +0530, Philip, Avinash wrote:
> > [...]
> >> +#include <linux/platform_data/ti-pwmss.h>
> > [...]
> >> +static struct pwmss_platform_data am33xx_data =3D {
> >> +	.has_configspace	=3D true,
> >> +};
> >=20
> > This structure is defined in a public header. I don't see why it has to,
> > given that it's only used to associate some data with an of_device_id
> > entry below. Since AM33xx never had anything but OF support in the
> > mainline kernel I don't think we should add platform data.
>=20
> Avinash probably introduced platform data because the same PWM IP is
> used in older DaVinci family SoCs (DA830 and DA850) which are not
> converted to DT. There are existing boards for those SoCs  (supported in
> mainline) which could benefit from this driver.

Okay. If that's the case platform data should be added along with
support for those SoCs. Ideally, of course, the DaVinci boards would be
converted to DT first so we wouldn't have to introduce platform data
just to get rid of it when the conversion does take place. Until now it
seems like the boards have managed to get by without PWM support so
maybe they just don't use or need it?

Thierry

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQaqDXAAoJEN0jrNd/PrOh8k4P/j/ow/GwmGgT4xuofIXB8LSg
R4g1wBxWtqc/3d2brjSt6kW3A8Qe2BWmWdJnFLE3gHt8ka918+7gIG0PpnNAHLNQ
agG7gSd3TExtujJSFOiYnoQGwzRCMr456qrh6X1KV+vb5nfFfnrXeeBaKbV2Zb1A
zx7P8aCE3a2cGbbrYScnbh0whVP171ETvC+i1EchNxiFaKrer9XK4FxgZ5kERztT
zeTlRELn20R9FQUIXT1wugCPveoEkyZ4rxm8Tm6pRdGcy08baJ9/S562m0SrFCD1
XLHovormuj7FK/sbdnvHrvoEsESc4EndzcmtD9GuO8Tk+Ywe1lJYw9NMsOiauA1N
TAaOTltidtOOBjs0M2+uMvBpElfwG9sMluByKWs0LVfDUN339EkmGK8X4mAL/pmR
6mhZzm1T1mYjN+6qT3UBXstWlBId0Rc2sX3ZspXTrVi0Jw2k5lpGKrQykU2y9OzI
QNZJB104N0qLqjGN58MgXKwKEYAsj5XzCEtujCM710uealTR2e3Sal3GmE1ON06f
65qZ9gNiYQcJY09zogFY2oL4HzgCfq7pPyE9yR2r8qlzOmJsgDgqGSThWLvSI1cr
gSbWTWcOEDrTw+Kw6y+WKMXby86xS2TdODWjxQpDQq+7nKY61pc3fn/vDNsncuI4
afaeObx4AGitUjCw5M+R
=zORE
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
