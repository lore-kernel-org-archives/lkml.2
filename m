Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab2J2QYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:24:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495Ab2J2QYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:24:37 -0400
Date: Mon, 29 Oct 2012 18:18:42 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <b-cousson@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RESEND/PATCHv3] arm: dts: omap5-evm: Add keypad support
Message-ID: <20121029161842.GJ27566@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351507226-10328-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IA03tywDYuoVKXrw"
Content-Disposition: inline
In-Reply-To: <1351507226-10328-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IA03tywDYuoVKXrw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 04:10:26PM +0530, Sourav Poddar wrote:
> Add keypad data node in omap5-evm.
>=20
> Based on I2C support patch for omap5, which has been
> already posted as a different series.
>=20
> Tested on omap5430 evm with 3.7-rc1 kernel.
>=20
> Cc: Felipe Balbi <balbi@ti.com>

you can change this into an Acked-by: Felipe Balbi <balbi@ti.com> if you
wish.

> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>=20
> Tested on omap5430 sdp with 3.7-rc1 kernel.
>=20
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
>  arch/arm/boot/dts/omap5-evm.dts |   95 +++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 95 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-ev=
m.dts
> index c663eba..b812d6d 100644
> --- a/arch/arm/boot/dts/omap5-evm.dts
> +++ b/arch/arm/boot/dts/omap5-evm.dts
> @@ -140,3 +140,98 @@
>  &mcbsp3 {
>  	status =3D "disabled";
>  };
> +
> +&i2c5 {
> +	clock-frequency =3D <400000>;
> +
> +	smsc@38 {
> +		compatible =3D "smscece1099";
> +		reg =3D <0x38>;
> +		clock =3D <0x13>;
> +		keypad {
> +			compatible =3D "smsc,keypad";
> +			interrupt-parent =3D <&gpio5>;
> +			interrupts =3D <23>; /* gpio line 151 */
> +			keypad,num-rows =3D <8>;
> +			keypad,num-columns =3D <16>;
> +			linux,keymap =3D < 0x20041 /* KEY_F7 */
> +					0x30001 /* KEY_ESC */
> +					0x4003e /* KEY_F4 */
> +					0x50022 /* KEY_G */
> +					0x70023 /* KEY_H */
> +					0x9009a /* KEY_CYCLEWINDOWS */
> +					0xc000e /* KEY_BACKSPACE */
> +					0xd0057 /* KEY_F11 */
> +					0xe009f /* KEY_FORWARD */
> +					0xf006e /* KEY_INSERT */
> +					0x1020036 /* KEY_RIGHTSHIFT */
> +					0x1030011 /* KEY_W */
> +					0x1040010 /* KEY_Q */
> +					0x1050012 /* KEY_E */
> +					0x1070013 /* KEY_R */
> +					0x1080016 /* KEY_U */
> +					0x10c0017 /* KEY_I */
> +					0x10d0067 /* KEY_UP */
> +					0x10e0018 /* KEY_O */
> +					0x10f0019 /* KEY_LEFT */
> +					0x2020003 /* KEY_2 */
> +					0x2040004 /* KEY_1 */
> +					0x2050005 /* KEY_3 */
> +					0x2070008 /* KEY_4 */
> +					0x2080009 /* KEY_7 */
> +					0x20b0064 /* KEY_8 */
> +					0x20c006c /* KEY_RIGHTALT */
> +					0x20d000a /* KEY_DOWN */
> +					0x20e0001 /* KEY_0 */
> +					0x20f006a /* KEY_RIGHT */
> +					0x3010061 /* KEY_RIGHTCTRL */
> +					0x302001f /* KEY_S */
> +					0x303001e /* KEY_A */
> +					0x3040020 /* KEY_D */
> +					0x3050021 /* KEY_F */
> +					0x3070024 /* KEY_J */
> +					0x3080025 /* KEY_K */
> +					0x30c001c /* KEY_ENTER */
> +					0x30d0026 /* KEY_L */
> +					0x30e0027 /* KEY_SEMICOLON */
> +					0x400002a /* KEY_LEFTSHIFT */
> +					0x402002d /* KEY_X */
> +					0x403002c /* KEY_Z */
> +					0x404002e /* KEY_C */
> +					0x405002f /* KEY_V */
> +					0x4070032 /* KEY_M */
> +					0x4080033 /* KEY_COMMA */
> +					0x40c0039 /* KEY_SPACE */
> +					0x40d0033 /* KEY_DOT */
> +					0x40e0035 /* KEY_SLASH */
> +					0x40f006b /* KEY_END */
> +					0x501001d /* KEY_LEFTCTRL */
> +					0x5020040 /* KEY_F6 */
> +					0x503000f /* KEY_TAB */
> +					0x504003d /* KEY_F3 */
> +					0x5050014 /* KEY_T */
> +					0x5070015 /* KEY_Y */
> +					0x508001a /* KEY_LEFTBRACE */
> +					0x50d0044 /* KEY_F10 */
> +					0x50e001b /* KEY_RIGHTBRACE */
> +					0x50f0066 /* KEY_HOME */
> +					0x602003f /* KEY_F5 */
> +					0x604003c /* KEY_F2 */
> +					0x6050006 /* KEY_5 */
> +					0x60601d0 /* KEY_FN */
> +					0x6070007 /* KEY_6 */
> +					0x60a008b /* KEY_MENU */
> +					0x60c002b /* KEY_BACKSLASH */
> +					0x60d0043 /* KEY_F9 */
> +					0x7020042 /* KEY_F8 */
> +					0x703003a /* KEY_CAPSLOCK */
> +					0x704003b /* KEY_F1 */
> +					0x7050030 /* KEY_B */
> +					0x7070031 /* KEY_N */
> +					0x70b0038 /* KEY_LEFTALT */
> +					0x70d0058 /* KEY_F12 */
> +					0x70f006f >; /* KEY_DELETE */
> +			linux,input-no-autorepeat;
> +		};
> +	};
> +};
> --=20
> 1.7.1

--=20
balbi

--IA03tywDYuoVKXrw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjqxiAAoJEIaOsuA1yqREMHcP/32FqaZCGJz0L9OsbU5NKj2/
UFXIiw7hnve1v4GzlXG8yEQkV8T1aXQ7oJIZPIb6WukoIen9A//gThbeuLxEIiJy
+HAxbtSOLcuiP0RLr0jf4giCsiv/K24yASmwHhJU+nCDxaCBw9bzobqDgnfIfNgD
Y54vSNxyjxe+UcaLoJ1mmaJ8MWMDwhfBtC+KK2W75H8OOnvjwab8Xng61HNu6QXt
3ta7j5Fntj3z10yrmW8hd0FcRz+8IqWiLxk6LUyDFUdvlAEc5lY17IJErpCN6Laq
wRhJeggk8vZB0gwiCaqMBlRFI7YQuugtCX+sKZ+L2wnGHyOW5/ge+f53G+NSJ8Hp
PRTG6baXEVrBjRK4mMPUr2qy9VCClyC7OKwihq8IMnWUblvivBeuZ48LThVNX0rm
REpyUQ/4/s1feh21w4IAMhc+aXHoaKqZHtRSU8w6TRIZBp2DrxxnRlU0qYG3+TF8
/bNaxJRyrogh6FsoMbfPdm/aKT25+HeGZVM1bdyuthwaUxSpjUNnguBz1R+r175X
s4ucPLBLxPMwr+1qj9D8Ri3eEbgsIq+70OC4JsCUJP1cc6BmCMNUDaMVV4Sv/JhQ
zImiQp8BRNCKr3DIaOeWxkRKTYG8ok2qi/YzTKnm5f7Y+Afblu6C183Eri1xfVw9
Sz7ciWmjbzJRXpMvjGOK
=Es8J
-----END PGP SIGNATURE-----

--IA03tywDYuoVKXrw--
