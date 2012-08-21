Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab2HUKvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:51:45 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:54463 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756514Ab2HUKvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:51:44 -0400
Date: Tue, 21 Aug 2012 13:47:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 3/4] arm/dts: omap5-evm: Add keypad support
Message-ID: <20120821104744.GV10347@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345545940-2232-1-git-send-email-sourav.poddar@ti.com>
 <1345545940-2232-4-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pbi2MkfjSbXbI4MN"
Content-Disposition: inline
In-Reply-To: <1345545940-2232-4-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pbi2MkfjSbXbI4MN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2012 at 04:15:39PM +0530, Sourav Poddar wrote:
> Add keypad data node in omap5-evm.
>=20
> Based on I2C support patch for omap5, which has been
> already posted as a different series.
>=20
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Tested on omap5430 sdp with 3.5 custom kernel.
>=20
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

after fixing my only comment below, you can add my:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/omap5-evm.dts |   95 +++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 95 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-ev=
m.dts
> index 200c39a..6473983 100644
> --- a/arch/arm/boot/dts/omap5-evm.dts
> +++ b/arch/arm/boot/dts/omap5-evm.dts
> @@ -18,3 +18,98 @@
>  		reg =3D <0x80000000 0x40000000>; /* 1 GB */
>  	};
>  };
> +
> +&i2c5 {
> +	clock-frequency =3D <400000>;
> +
> +	smsc@38 {
> +		compatible =3D "smsc";
> +		reg =3D <0x38>;
> +		clock =3D <0x13>;
> +		keypad {
> +			compatible =3D "smsc,keypad";
> +			interrupt-parent =3D <&gpio5>;
> +			interrupts =3D <23>; /* gpio line 151 */
> +			keypad,num-rows =3D <8>;
> +			keypad,num-columns =3D <16>;
> +			linux,keymap =3D < 0x20041 /*KEY_F7*/

please add spaces around /* and */ so it's easier to read. Ditto to all
others.

--=20
balbi

--Pbi2MkfjSbXbI4MN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQM2dQAAoJEIaOsuA1yqREp+gP/38+lT6kTwuvjYUTEfTaupzE
40KShz9dqxWebvcpzKM6w3EFG7Gt66kzvMpXuv/Ih5+rD5+6wn2hvaCOiS6zPXCL
rvhiCNEaE4HUblMH6HDK22Z6XwczEUdkrZRmfjdr5G6HHVB3sK19oOB4M8uHjt/r
k37C6i6HT7qxa0Wi8Y3dqpq9z6aPq3ndp5aO/fbidZNkYJhXZCEszCbrtul+pRw5
pXNCUycqjSqOlAMUzo4Jb+0qMd37FX3Ax2gRVJ81+ZF2f/lw8SwQpkP+kNwe+7j3
IkBV+tHraXxGXG4ln0Eyp72/sqmEqqEeNeYKbotLgyB8n/xvPi1bU3kVDSHR1HsW
MZp4OU02re52qdPwGCL4jvr3kHumNcEueQu6ZaQPTWDYxl0v3U4+0XkaLUeg4BbT
XmuDtK0l3hS3uvOlIcD6ak9VQIzTX/C7UAxOdpY5ILzb++JO8OFTT68A5U0x52Qk
whps3aHSAFFMU/ORjpxUw4TppbaghhpqiDVPVJ34FD6xeNVS04iDbo4z6sqZ6nyv
zTpUMHVsSCJjN72ZpbOaezuNGF1DiNwWKaTkJMe3IBfzpFSIpkjhUjVI9YskKZM6
jnUP+mftSqIB8ADEkQ9ncX8Vc57vsPOE+D9iS9CCMwK/8evSbrKaqgL2X3sP2J0C
GT3rCPEzEDxbQd3Tcd6W
=qow1
-----END PGP SIGNATURE-----

--Pbi2MkfjSbXbI4MN--
