Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2AZLWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:22:53 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57747 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2AZLWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:22:49 -0500
Date: Thu, 26 Jan 2012 13:22:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tasslehoff Kjappfot <tasskjapp@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        davinci-linux-open-source@linux.davincidsp.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: musb: make modules behave better
Message-ID: <20120126112242.GN15110@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1327574749-18552-1-git-send-email-balbi@ti.com>
 <4F21371F.7010403@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xexMVKTdXPhpRiVT"
Content-Disposition: inline
In-Reply-To: <4F21371F.7010403@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xexMVKTdXPhpRiVT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jan 26, 2012 at 12:21:03PM +0100, Tasslehoff Kjappfot wrote:
> On 01/26/2012 11:45 AM, Felipe Balbi wrote:
> >There's really no point in doing all that
> >initcall trickery when we can safely let
> >udev handle module probing for us.
> >
> >Remove all of that trickery, by moving everybody
> >to module_init() and making proper use of
> >platform_device_register() rather than
> >platform_device_probe().
> >
> >Signed-off-by: Felipe Balbi<balbi@ti.com>
> >---
> >
>=20
> Tested-by: Tasslehoff Kjappfot <tasskjapp@gmail.com>

Thanks, I have added this line to the commit.

--=20
balbi

--xexMVKTdXPhpRiVT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPITeCAAoJEIaOsuA1yqRE6dsQAIE4GFnLPNTiOtAqqTRLgMPd
x5NYFpk7Zw9naUxd/g1LK887RUh/PoTFpd8L/r3uXkMejuxr1bwfFw/ikYxtzWcw
XdU2m3dk9wC5u5hKEqE1WwwVqPQQsKpKFV8rrvk8Xn4m/8UY2+2TPpwySGhk/aNc
y3GziFY4HeR7jGiT1LC/mQdyGAN6vYU2XFjII1xQVZiAYqEmYQLiWgFmB7vbSbmU
XVwTastYbEv7vLbrL0seGgD/mHt1xM5rYCsGQvBgq6oS+WEnnHE9Pg7KfIp7RgWl
2A52TXIbNyYuF5cQ4N2tpB6MarPV/09FEytwmBOLWOsMBF/XsgDHa0o2BPiZjgem
bvjAjwWc0y7GrmHu+o3BOoO79l+oVuSzKdymYCqhFu2+nRtr/AxnkM/Svb1c+XFn
i5k7GV3lU3SJzTZAG3D1t3ZQbapIUCyM0D27mV6wcDQ+owve+SVl3HwSQH07kqgx
1YJ02xsCt0owWoyo4P9x2TyjSw3xHoY+WiiW0mLuxwFwSQUoiRGK414nEiXxZ4kk
sI8undTVrR3zIOvjVolOb+SARz66B91cyCryLIyMezbOzYwPutiEpDnJ+oDXhS3S
bcAYOHISNCFVH9163vAw4KnHu/XxIX4TW48xtBQ9MecKn0MoqmQu9sxZYyXK/cW5
avxx/Kz9u7/jSgqCx79k
=q7Hi
-----END PGP SIGNATURE-----

--xexMVKTdXPhpRiVT--
