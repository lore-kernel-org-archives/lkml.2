Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1KXLg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 06:36:29 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:47733 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753027Ab1KXLg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 06:36:28 -0500
Date: Thu, 24 Nov 2011 13:36:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: gadget: rename usb_gadget_driver::speed to
 max_speed
Message-ID: <20111124113621.GH3352@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
 <cc474a48df8db0ec55a1baecac9708de46b8c151.1321719300.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yxUjl2uTvAeSG6i1"
Content-Disposition: inline
In-Reply-To: <cc474a48df8db0ec55a1baecac9708de46b8c151.1321719300.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yxUjl2uTvAeSG6i1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 19, 2011 at 06:27:38PM +0100, Michal Nazarewicz wrote:
> This commit renames the =E2=80=9Cspeed=E2=80=9D=C2=A0field of the usb_gad=
get_driver
> structure to =E2=80=9Cmax_speed=E2=80=9D.  This is so that to make it more
> apparent that the field represents the maximum speed gadget
> driver can support.
>=20
> This also make the field look more like fields with the same
> name in usb_gadget and usb_composite_driver structures.  All
> of those represent the *maximal* speed given entity supports.
>=20
> After this commit, there are the following fields in various
> structures:
> * usb_gadget::speed - the current connection speed,
> * usb_gadget::max_speed - maximal speed UDC supports,
> * usb_gadget_driver::max_speed - maximal speed gadget driver
>   supports, and
> * usb_composite_driver::max_speed - maximal speed composite
>   gadget supports.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>

applied, thanks

--=20
balbi

--yxUjl2uTvAeSG6i1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOziw1AAoJEIaOsuA1yqREzf0P/3mUjs6VKEpi6xU/Kn30AD0M
bHrOGemIyYOpAFo7xIBX8j8EqjkY/2sMhe0PqrZk3DzTNiZvkHC4FcSLCbvDQK72
4lvZJysgLEV7+X+mIYyZ/KjCAsDDOg468dbYMxECLkXlvll/paZtqZqBdWFggXL+
SaPfY/QmIsh+XKjwFNEkspbUlr7w17DjrvY1bKeET5Qswtq/p2MjE3lhQSUehJHH
yd2lbJaiarOuXyqlpkUXR7qiesKeOaSLyIjHyTjFwWdvnbonPz+Yn5GMTy/Zf5ty
DSzhQsN0AHWjoWmhdS+OPIx+dXMNDWSBgQ6YYFS5Bod9faVtszbKfqx3z47CvLE2
SQLuCd/BhMYGY+UdUTh5LgJDKQCRtkRWVqUfWye3NLg7+uqgYCFNsOcvObWJYPZa
4VADxYPvKEgHWxhq0akTiVdyKs77vysdl96h+K5buGWkq8fQa7IJtVDVvo7IM8Fd
UB1nnlvEfmtWjOZWcT6uQeJgxgWe6Z0et9sGjygDtZc0ns1f/AhBXMcd7JhcmAnh
LcybwS1h+v3FTqK3hL99iyJzUpGL9WFQ3Xq+CRO9RPOkWesStIpxi5Lbn9TqNLYr
Hugls36/nz59LAXG79bcj7gsTE9QHFBaKT5g653C4+pZ1FEi3Cz3fdfkx6nhl4oY
IaIf7Qj+C2HTugsmRXdS
=lBIF
-----END PGP SIGNATURE-----

--yxUjl2uTvAeSG6i1--
