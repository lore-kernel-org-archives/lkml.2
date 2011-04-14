Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1DNESi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 00:18:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39158 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab1DNESh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 00:18:37 -0400
Date: Thu, 14 Apr 2011 14:18:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: build warnings after merge of the usb tree
Message-Id: <20110414141831.16796e84.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Apr_2011_14_18_31_+1000_.XJCgaXykCGfp4LR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Apr_2011_14_18_31_+1000_.XJCgaXykCGfp4LR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/usb/renesas_usbhs/pipe.c: In function 'usbhsp_pipectrl_set':
drivers/usb/renesas_usbhs/pipe.c:81: warning: cast from pointer to integer =
of different size
drivers/usb/renesas_usbhs/pipe.c:81: warning: cast from pointer to integer =
of different size
drivers/usb/renesas_usbhs/pipe.c: In function 'usbhsp_pipectrl_get':
drivers/usb/renesas_usbhs/pipe.c:92: warning: cast from pointer to integer =
of different size
drivers/usb/renesas_usbhs/pipe.c:92: warning: cast from pointer to integer =
of different size
drivers/usb/renesas_usbhs/pipe.c: In function 'usbhsp_pipe_select':
drivers/usb/renesas_usbhs/pipe.c:180: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c:180: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c: In function 'usbhsp_fifo_select':
drivers/usb/renesas_usbhs/pipe.c:350: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c:350: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c: In function 'usbhsp_setup_pipebuff':
drivers/usb/renesas_usbhs/pipe.c:604: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c:604: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c: In function 'usbhs_pipe_malloc':
drivers/usb/renesas_usbhs/pipe.c:775: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c:775: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c:775: warning: format '%d' expects type 'in=
t', but argument 3 has type 'long unsigned int'
drivers/usb/renesas_usbhs/pipe.c:795: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c:795: warning: cast from pointer to integer=
 of different size
drivers/usb/renesas_usbhs/pipe.c:795: warning: format '%d' expects type 'in=
t', but argument 4 has type 'long unsigned int'

Introduced by commit f1407d5c6624 ("usb: renesas_usbhs: Add Renesas USBHS
common code").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_Apr_2011_14_18_31_+1000_.XJCgaXykCGfp4LR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNpnWXAAoJEDMEi1NhKgbsGcIH+wUZ6d+Dk5Q2hv+Oyda5Li5n
PIC2i7YbNcDLe0oBnsZGHykhRqWRYccrptdaGdh7SFOUTpaqUDyXAKkAF1Hc9IAW
miIavBPxDT+xDflV02YEZHrtWoD+aDYigMkylzsfkv933QWz/sQoeGg22FYYxU+I
wsQ8JVXXbYDCxPitdQdn7p8GJVLfDca62cplt4Am0bNff7sVGgRinM6ztLZ87CCK
xJRyrhfsMHqrqxWYRxL4qIfFVLKR4pnDvCpFKfGzDAwpGYWAGInG8dNsqkJSUG0A
YfXlGZn1HHRt0/sSWD9KohqhFk5CwDnu4feyvJzGMPxhf4fa6ramgBiimxI3G6s=
=1lLS
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Apr_2011_14_18_31_+1000_.XJCgaXykCGfp4LR--
