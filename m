Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab1GTWbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:31:01 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:50730 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1GTWa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:30:59 -0400
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jul 2011 18:30:59 EDT
X-RZG-AUTH: :O2kGeEG7b/pS1EO8W3C+nMaWotNRcyCeCTTmQgOI2iYXpKw3NpaUJWKUTYdmTkw=
X-RZG-CLASS-ID: mo05
Subject: Re: [PATCH] drm/radeon: Fix ECS A740GM-M DVI-D EDID error flooding
 problem
From: Thomas Reim <reimth@gmail.com>
To: Stephen Michaels <Stephen.Micheals@gmail.com>,
        Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tyson Whitehead <twhitehead@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
In-Reply-To: <1311150845-19198-1-git-send-email-reimth@gmail.com>
References: <1309995012-5873-1-git-send-email-reimth@gmail.com>
	 <1311150845-19198-1-git-send-email-reimth@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3Thz0gf7hgIRTap9lP4a"
Date: Thu, 21 Jul 2011 00:18:42 +0200
Message-ID: <1311200323.18769.13.camel@Mark-Aurel.gas.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Thz0gf7hgIRTap9lP4a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Von: Stephen Micheals <stephen.micheals@gmail.com>
An: thomas.reim@nepomuc.de
Betreff: Re: [PATCH] drm/radeon: Fix ECS A740GM-M DVI-D EDID error
flooding problem
Datum: Wed, 20 Jul 2011 13:12:26 -0700

Acked-by: Stephen Michaels <Stephen.Micheals@gmail.com>

On Wed, Jul 20, 2011 at 1:34 AM,  <reimth@googlemail.com> wrote:
> From: Thomas Reim <reimth@gmail.com>
>
>   ECS A740GM-M with ATI RADEON 2100 sends data to i2c bus
>   for a DVI connector that is not implemented/existent on the board.
>
>   Fix by applying extented DDC probing for this connector.
>
>   Requires [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding p=
roblem
>
>   BugLink: http://bugs.launchpad.net/bugs/810926
>
> Signed-off-by: Thomas Reim <reimth@gmail.com>
> ---
>  drivers/gpu/drm/radeon/radeon_connectors.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm=
/radeon/radeon_connectors.c
> index 2e70be2..82dacc6 100644
> --- a/drivers/gpu/drm/radeon/radeon_connectors.c
> +++ b/drivers/gpu/drm/radeon/radeon_connectors.c
> @@ -449,6 +449,15 @@ static bool radeon_connector_needs_extended_probe(st=
ruct radeon_device *dev,
>                    (supported_device =3D=3D ATOM_DEVICE_DFP2_SUPPORT))
>                        return true;
>        }
> +       /* ECS A740GM-M with ATI RADEON 2100 sends data to i2c bus
> +        * for a DVI connector that is not implemented */
> +       if ((dev->pdev->device =3D=3D 0x796e) &&
> +           (dev->pdev->subsystem_vendor =3D=3D 0x1019) &&
> +           (dev->pdev->subsystem_device =3D=3D 0x2615)) {
> +               if ((connector_type =3D=3D DRM_MODE_CONNECTOR_DVID) &&
> +                   (supported_device =3D=3D ATOM_DEVICE_DFP2_SUPPORT))
> +                       return true;
> +       }
>
>        /* Default: no EDID header probe required for DDC probing */
>        return false;
> --
> 1.7.1
>
>


--=-3Thz0gf7hgIRTap9lP4a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAABAgAGBQJOJ1RCAAoJEII1bee/l5G+8E4H/2bn3CgTvrB5hRsxZs0tfKTl
OCzxipVwLn94Dxqa/866Bv/FiBtvCd07E/Nbbo/4xX8cqMBH4rN1ttRI4Q38CFgf
hNQaUzR1WqnEMZ//FAv9gMB7+edmRa8npcDVl8EPBADWK5KwjuZyIrkYE2Vq80H5
4lnxXFXvcf0tRyduC4Ume9fw7lee9qCx2cr4gVoZJ0kYwbx0cbQqrHjboiN9GvZN
AwAheAJf2WWdIX7Vb+YcphptBJvuz0g6/yVU79JFKGnPUD5fmzt5/0ErzeN8UwMN
g7UWuU5FJVATNQyS+3/4XqWXowgtaed2doHTbs8QM1q3uW3AUsLFSdcCGDkWGHY=
=swBe
-----END PGP SIGNATURE-----

--=-3Thz0gf7hgIRTap9lP4a--

