Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2CUKEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:04:32 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:60148 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756151Ab2CUKE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:04:29 -0400
Date: Wed, 21 Mar 2012 12:04:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb gadget: fix a section mismatch when compiling g_ffs
 with CONFIG_USB_FUNCTIONFS_ETH
Message-ID: <20120321100402.GL3092@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1331472670-28589-1-git-send-email-LW@KARO-electronics.de>
 <1331474926-9237-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PZYVFYZbFYjzBslI"
Content-Disposition: inline
In-Reply-To: <1331474926-9237-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PZYVFYZbFYjzBslI
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Mar 11, 2012 at 03:08:46PM +0100, Lothar Wa=DFmann wrote:
> Hi,
>=20
> please ignore the previous message. I sent the patch out too early.
> Here is a revised version.
>=20
>  commit 28824b18ac4705e876a282a15ea0de8fc957551f:
>  |Author: Michal Nazarewicz <m.nazarewicz@samsung.com>
>  |Date:   Wed May 5 12:53:13 2010 +0200
>  |
>  |    USB: gadget: __init and __exit tags removed
>  |
>  |    __init, __initdata and __exit tags have have been removed from
>  |    various files to make it possible for gadgets that do not use
>  |    the __init/__exit tags to use those.
>  obviously missed (at least) this case leading to a section mismatch in
>  g_ffs.c when compiling with CONFIG_USB_FUNCTIONFS_ETH enabled.
>=20
> Signed-off-by: Lothar Wa=DFmann <LW@KARO-electronics.de>

please send in proper patch format and while at that include any Acks
you already got.

--=20
balbi

--PZYVFYZbFYjzBslI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaaeSAAoJEIaOsuA1yqREo9gP/04GUt9AEvtf11IGp6ftC2AD
ydy/gWPJTv5T1bskp+4JtqXAbNp21WTElFF6lUmHlY/rxOttTOShvfZoKJFd1pnb
P7iBvXj+JXwWGMwRT9OPGLnVsVcszZLeOjA2ox8xrvhU0eY/EQsD+3iYHNTl8JjY
EQ0OmjKMyBfPKZpQxDRt3Fpx9lwvP7wlOSdbfPx1MQtGT+0jwiJlyIYIapCQLRcN
otWT2UzXz1fHl5BeQrli+KUhKoc47nOKVfqz3CtI+DDGNjU9fEf8BQYqsPDzfyak
LS3Yie0Hm3QGsmdjKAMumPsfmNxoBU7YL05/GZDMREXFQjrbI7P6h35Jik+85MHm
fbUyOhW0ZfP760EynZ+sESZHRx2WnVZtnyeFrz3PhUzfVgNdQKcC640ZAjhim8w4
4ovf6pgS4/RDCkk+SEY148obYXjQO+LkuNOV/0gYIO7V0O0xWqVr0jqeUMpqyFg0
xSzdTCLrcbFyjlgRCzG0txgP0+0bEcUq4xyNlCZiDAJwtBQrYgR4jllhXg9PSQ+N
jZybnmKwZsvzSU4B3hjv3iHBUtg49vgzz0PG7opAQLtYQZjXPiXRmKHMAvw7mF59
UD3/4mE4r/zClCEgZOzV2zsjhI4JG0EClaC8YWj/iJmi1mxNTdOBgi24Iek4pgL+
W08l8ho83UjMXa+Szq06
=BW0n
-----END PGP SIGNATURE-----

--PZYVFYZbFYjzBslI--
