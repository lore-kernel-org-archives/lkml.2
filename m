Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab1IZItn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:49:43 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:39229 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab1IZItl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:49:41 -0400
Date: Mon, 26 Sep 2011 11:49:36 +0300
From: Felipe Balbi <balbi@ti.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Felipe Balbi <balbi@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] sound: usb: mixer: increase control transfer timeout
Message-ID: <20110926084935.GJ3391@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1314616226-15942-1-git-send-email-balbi@ti.com>
 <s5hehzht34k.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bgQAstJ9X1Eg13Dy"
Content-Disposition: inline
In-Reply-To: <s5hehzht34k.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bgQAstJ9X1Eg13Dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 16, 2011 at 08:25:47AM +0200, Takashi Iwai wrote:
> At Mon, 29 Aug 2011 14:10:26 +0300,
> Felipe Balbi wrote:
> >=20
> > 100ms might not be enough for slower devices. Increasing
> > timeout to 1000ms doesn't seem like overkill.
> >=20
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
>=20
> Felipe, what is the status of this patch?
> Could you resend a revised patch?

Someone else can take care of it. It was supposed to be a very simple
patch and became something larger which I don't have enough time to
handle right now.

--=20
balbi

--bgQAstJ9X1Eg13Dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgDyfAAoJEAv8Txj19kN1dw8IAJNvnKPIkGCI0N2H60ow0I7Z
a92XDrzU5uBfqk/vWnV76RCnHGvfEsclujExnkcEm/HE9J/heMEXhSbTQRRRDFql
mFlV1JaI8B+8D4fFTZs4XAVW6xj8hfk824dYA/tU3AnseixGnTmF/vByzVTd2sid
73BP59GF0yi84ZRw0btldteHfz8Msouc1Vmnz9FnsouEhW0JbYwyvssMeKqYHZhv
wFjqk1n+2iCYmEz/pVpADrsBPu2sy3U3wo28spzSV26XzJG7axp0pr5MH0AnBw6K
vXrYuaU/b4eo+Qy6K3imZZTARgnQfpvnh7I3WmoF8k/o/dxLrA5TkiXCBBEggbI=
=VBir
-----END PGP SIGNATURE-----

--bgQAstJ9X1Eg13Dy--
