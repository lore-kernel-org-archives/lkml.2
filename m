Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab1AEXte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:49:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50176 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753883Ab1AEXtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:49:32 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Sergej Pupykin <ml@sergej.pp.ru>, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110105230323.978508482@clark.site>
References: <20110105230323.978508482@clark.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nnb46EEIJ3cOh3jiWtZV"
Date: Wed, 05 Jan 2011 23:49:05 +0000
Message-ID: <1294271346.3044.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [06/49] drm/kms: remove spaces from connector
 names (v2)
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nnb46EEIJ3cOh3jiWtZV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-01-05 at 15:00 -0800, Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Alex Deucher <alexdeucher@gmail.com>
>=20
> commit e76116ca9671e2e5239054a40303b94feab585ad upstream.
>=20
> Grub doesn't parse spaces in parameters correctly, so
> this makes it impossible to force video=3D parameters
> for kms on the grub kernel command line.
>=20
> v2: shorten the names to make them easier to type.
[...]
> --- a/drivers/gpu/drm/drm_crtc.c
> +++ b/drivers/gpu/drm/drm_crtc.c
> @@ -144,10 +144,10 @@ static struct drm_conn_prop_enum_list dr
>  	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
>  	{ DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
>  	{ DRM_MODE_CONNECTOR_Component, "Component", 0 },
> -	{ DRM_MODE_CONNECTOR_9PinDIN, "9-pin DIN", 0 },
> -	{ DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
> -	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
> -	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
> +	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
> +	{ DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
[...]

Why change 'DisplayPort', which doesn't have a space in it?  This might
break a previously working kernel command line.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-nnb46EEIJ3cOh3jiWtZV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATSUDbOe/yOyVhhEJAQIq8A//Vio2dyctkz8ShPoGZF16JoMokgA2dVsI
oX1X7NBmd0BtsVDoiwHu+dbwJoSKJ8oqo6nMhNDxUFzhvANGBZBldaEAsze4S4XW
DqMaICm48VxNzvvU4IdNMWj3Uz81HCzw1zhUEe9J7d3x45Xsi3+EV/in4Bo+8Mys
1u/KRoA5OZ4/hcygpq706sa1R2PuymGbetyIhzUVdP7kaf7hyFqO+yM849ONLTL+
xPkJr9+hGGpgaUUsPTCB3uWJ5TjJ3F2nqH+x2UbfFNxbzmO8E8TF9gzaXYHPp0sF
hDjmiUnZVgLF/Utd4NgA3eqN+8rs+qFfqmBcwI9UIaQAXrH5krrRjyzwhmpsdeZK
j94gmoACEGEuou653otBEXqvD7kw2Y+yDNJ8n/VES8amoxFhNc+dzy+YmxlCyPse
QTvn6p3YPe8xEFPoOgenhS+BORsm1WWXz3MfgW2k3NIwBbPFa1kDIC8Rc8nDUWdA
CqCOqTBXQM12ZoHtcmTlosngHm48dncRN6Oa67Kh9FQqmvamG1qtIhqCQehP6T6l
unkaQvUMzHineG9ifRzG5aysRmT+a6PAmbMv6RZ30PZSleA8ioPBcTbibkuqWX9d
cFDyh+b+R0xSlUu4zk5hDuurv4QFI36xe4s5qiIHHHc5ep7M/qMmrIpMTXBS4Xvs
+EeErdtzrtU=
=hRAa
-----END PGP SIGNATURE-----

--=-nnb46EEIJ3cOh3jiWtZV--
