Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043Ab2GYWva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:51:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37663 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab2GYWv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:51:29 -0400
Date: Thu, 26 Jul 2012 08:51:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-Id: <20120726085127.1205fa271d6c5d7c485c5397@canb.auug.org.au>
In-Reply-To: <20120720133349.b71eeca40aa1758a12725dea@canb.auug.org.au>
References: <20120720133349.b71eeca40aa1758a12725dea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__26_Jul_2012_08_51_27_+1000_RnE4xSSBhyj_mksy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Jul_2012_08_51_27_+1000_RnE4xSSBhyj_mksy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg, Alan,

[Sorry, Alan, I forgot to cc you the first time around.]

On Fri, 20 Jul 2012 13:33:49 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> drivers/staging/serqt_usb2/serqt_usb2.c: In function 'qt_set_termios':
> drivers/staging/serqt_usb2/serqt_usb2.c:1198:29: error: incompatible type=
s when initializing type 'struct ktermios *' using type 'struct ktermios'
> drivers/staging/serqt_usb2/serqt_usb2.c:1304:14: error: invalid type argu=
ment of '->' (have 'struct ktermios')
>=20
> Presumably caused by commit adc8d746caa6 ("tty: move the termios object
> into the tty").
>=20
> Under previous instructions about staging drivers, I have added the
> following patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 20 Jul 2012 13:31:39 +1000
> Subject: [PATCH] disable USB_SERIAL_QUATECH2 broken by tty update
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/serqt_usb2/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/staging/serqt_usb2/Kconfig b/drivers/staging/serqt_u=
sb2/Kconfig
> index f4fed40..dc624a4 100644
> --- a/drivers/staging/serqt_usb2/Kconfig
> +++ b/drivers/staging/serqt_usb2/Kconfig
> @@ -1,6 +1,7 @@
>  config USB_SERIAL_QUATECH2
>  	tristate "USB Quatech ESU-100 8 Port Serial Driver"
>  	depends on USB_SERIAL
> +	depends on BROKEN
>  	help
>  	  Say Y here if you want to use the Quatech ESU-100 8 port usb to
>  	  serial adapter.
> --=20
> 1.7.10.280.gaa39

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__26_Jul_2012_08_51_27_+1000_RnE4xSSBhyj_mksy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQEHhvAAoJEECxmPOUX5FEJRgP/R1cVP3ZgwdWC2CZ7JrhcT3U
hYHGfwvrbBN3ART1HTMBw34cAUS+Bm6ejOz71lIuSHRHIwNUBpZJlBPUjB4Jn/DF
A7bugC9ueP7npDIyX+Q+nxPL3ZMVeVKd6LPwpX2tPE7P4fQwikdB/IYKi7Vfouvt
YDVN/RsaCCr8nYPIgT5iz7I7oKIRQlN/dXTuTW/qSySB7tHbr7n/tS0pib34ycDW
3Z1YUIgsLn2wQevRsS0N2bGhs+o2FUPwiARd68sCzWlhOuqkR/I3zh1uPlrPBIFe
SVohFAgjn/k+0tFG7smpl+/Y2PnmrNIuXPGRrFF+FuWh6tyCBzMXqnadE5A60FvW
jBqqSPtzrR9S4s1d+MdDcUCLwRwOnKB/DtbCWFepX+wY/Ui6r0rVoXgGSWD8fDSb
ZUquOoCPwPplTg8/3H9VXCmAwcHWp0S5oBFDvsoKEY0PRocAojsbKtxaCAVl6Ra3
5eYCw/bpkE205BaPGijygRrE18xterqWWjWaeS/FE7ghpiIVCh7YWgj4yKxIFsEf
WBrxkexrbbDSUa3T85YYW8QaDwhD0Mjt5c8Cp1gQzq7b/2FdHTUCdK6frSZ7Y8cU
oy63BmwDP/dSF8Dj+jsQUJTJDpG3UWjbHcC5G9gAWXCJs5Xw2v01hDW4Uo9fo/Xy
yki8jXkiRML0K8pglzkm
=PZpA
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Jul_2012_08_51_27_+1000_RnE4xSSBhyj_mksy--
