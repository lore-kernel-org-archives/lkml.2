Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2BWQ1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:27:11 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:48424 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752177Ab2BWQ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:27:08 -0500
Date: Thu, 23 Feb 2012 08:27:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: fix memleak when ACPI _CRS is not used.
Message-ID: <20120223082703.5d87dab4@jbarnes-desktop>
In-Reply-To: <1329787427-17890-1-git-send-email-yinghai@kernel.org>
References: <1329787427-17890-1-git-send-email-yinghai@kernel.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bj0o2i=pQojw=/5kVdQ==ti"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bj0o2i=pQojw=/5kVdQ==ti
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2012 17:23:47 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> got warning:
> unreferenced object 0xffff8801f6914200 (size 512):
>   comm "swapper/0", pid 1, jiffies 4294893643 (age 2664.644s)
>   hex dump (first 32 bytes):
>     00 00 c0 fe 00 00 00 00 ff ff ff ff 00 00 00 00  ................
>     60 58 2f f6 03 88 ff ff 00 02 00 00 00 00 00 00  `X/.............
>   backtrace:
>     [<ffffffff81c2408c>] kmemleak_alloc+0x26/0x43
>     [<ffffffff8113764f>] __kmalloc+0x121/0x183
>     [<ffffffff81ca8d93>] get_current_resources+0x5a/0xc6
>     [<ffffffff81c5bedd>] pci_acpi_scan_root+0x13c/0x21c
>     [<ffffffff81c2a745>] acpi_pci_root_add+0x1e1/0x421
>     [<ffffffff81408f50>] acpi_device_probe+0x50/0x190
>     [<ffffffff8149edc7>] really_probe+0x99/0x126
>     [<ffffffff8149ef83>] driver_probe_device+0x3b/0x56
>     [<ffffffff8149effd>] __driver_attach+0x5f/0x82
>     [<ffffffff8149d860>] bus_for_each_dev+0x5c/0x88
>     [<ffffffff8149eb87>] driver_attach+0x1e/0x20
>     [<ffffffff8149e7cc>] bus_add_driver+0xca/0x21d
>     [<ffffffff8149f47b>] driver_register+0x91/0xfe
>     [<ffffffff81409d09>] acpi_bus_register_driver+0x43/0x45
>     [<ffffffff8278bdc9>] acpi_pci_root_init+0x20/0x28
>     [<ffffffff810001e7>] do_one_initcall+0x57/0x134
>=20
> The system have _CRS for root buses, but they are not used because is old=
...
>=20
> Try free those not used resource array and name.
>=20
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Applied to for-linus, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/bj0o2i=pQojw=/5kVdQ==ti
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRmjXAAoJEIEoDkX4Qk9hKjoQAMG7ZZ+zVbef+R+uurwWOIKT
tP4lr1mBd2DJKvFHPXXrL3WlQKxh8F7Y9n5WsIFmqnpTGx9POzeVvH3pRiDGFjdE
I9VqqkNGAmyqNoNcZ+u5/xnzVBYL1Tc8J7m72WA2i+gCYvXXDiwNK4HfdgN8hQg1
xsXtKR2lKl6gDv0XzYi8zNE1AThVAyCD7ovNDFkknVM78Wv20pC9HBHQGPfiGyax
syLGLuNviU+B0Xs9kKn9S4Q4ScexeVRA5fjp8G007/yUknM3S8MXUke4imEMztyY
I8p0maDyYrR+W6xlAVsC8JoCpPzbzwjPuPtb1Fzigf5XlpJ7NvXucoQ9EVi+6LqX
wDSmp30HZ84+bAlaZPMy1XPg6IZHgS0C/YcXYjAX/8U3wblfesw8wUNO9q+DLTwT
GMrG//e0xGYa/L6RaaAY6S/YkXP85mLK3ctKxvpJo3RELm1exQjqClagXAP6qDV6
HSZZkWPL2HxD747wl9tuFU2VpylzejdyjOFy6xw4Gkj+fiTtJeq5vdLt5u2dkqVu
Qtog8pa1x5QHpROGjsQloYGCXDCypUk8d2+I5SZMEkIMPtpHWkSq94UCwYJtR17A
trOVCdWpwktnkxc+LoVT1KNewmIr31Rfu33fw0wMK11UrL0St4tJ6MA+2FgmNY1W
v8wD+IL9Ucmmyp0U/iGL
=v0ig
-----END PGP SIGNATURE-----

--Sig_/bj0o2i=pQojw=/5kVdQ==ti--
