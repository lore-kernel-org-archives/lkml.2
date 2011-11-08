Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1KHMJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:09:46 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:33693 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298Ab1KHMJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:09:43 -0500
Date: Tue, 8 Nov 2011 14:09:38 +0200
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        David Rientjes <rientjes@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 1/3] usb: gadget: replace usb_gadget::is_dualspeed with
 max_speed
Message-ID: <20111108120936.GT6921@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <f127dba0535f87bae91173e87f01a2054b6fafbd.1318956277.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NHfequSh1hmJPP0s"
Content-Disposition: inline
In-Reply-To: <f127dba0535f87bae91173e87f01a2054b6fafbd.1318956277.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NHfequSh1hmJPP0s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 18, 2011 at 09:55:02AM -0700, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> This commit replaces usb_gadget's is_dualspeed field with
> a max_speed field.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>

applied this series

--=20
balbi

--NHfequSh1hmJPP0s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuRwAAAoJEIaOsuA1yqRESRQQAKpeZntzxk1th7Yqi9nq13Y+
/aLs4qIkO7HzSEFXb2D+vxfP5kZCmP9t/jEfOTT/yAdyALGOaJTkF+1A0IKF8TcO
LLaVqqrH5Ast/90C1ji7gxDfThkolgXXOxjpJGRE2Zfq9hr0X60M21ll/WKV0kyi
YAzx4xZWWQoUS222zO1vtm8w98me+wqiT0pfBMJNpSpw9yFKlkQx/sczcDvZX7jB
I6HZSBzEMLdZqM/O6kAP5swjl/E3PwfUvWLU5ZYESnle5HwTl9xO3VxXirW6PYC4
ZOZMMQj2yDij91mgcU8y6+mNFPGC3jG/hlh0m5coyIH0rOiCHigMtGL/hT8717Lr
Lc8uZBzQ7PUOcqiga/DsEsYX4mIQIy+BgadlyZqJ8KgJiodedkee9jmF5viZ+pcZ
t2S0T45bCEUjbVKZw2bp+XS8O6vV1wwkSOjOswSV+h0hPGFPHy0DhogFD7Rix5Uu
VWSVvGx9LruImFYDzGyUzGbAyrRlQEnbVCRncvAX2l/qxgCh+oVxBstbWu/lTaSF
mmjXpVQNo59R3q2rR1Qgfaazkt29DFOM4kM/Dzd0PFFKVxUg9TrCPuschTnNDWwJ
1fRvaJy9go8cDEIMpa52lHfRAywnT7plfxFjyFaAOZvZGzI/Kuafi7C85kBi3KIW
1uv4xuPsRTj7cGducU+l
=P2iM
-----END PGP SIGNATURE-----

--NHfequSh1hmJPP0s--
