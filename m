Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932250Ab2AEASH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:18:07 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34519 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2AEASF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:18:05 -0500
Date: Thu, 5 Jan 2012 11:17:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
Subject: Re: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120105111758.d0d640b9d072f04104a5fc4e@canb.auug.org.au>
In-Reply-To: <CAPXgP13TC4iuy=MW-p8x05VG8ad-9rC+jxm6qHtx90tBX9zhTw@mail.gmail.com>
References: <20111228174518.721624fad9d048f9f85b3d50@canb.auug.org.au>
	<20120104230720.GD24583@kroah.com>
	<20120105104835.fd6c0fd173622af59d11012f@canb.auug.org.au>
	<CAPXgP13TC4iuy=MW-p8x05VG8ad-9rC+jxm6qHtx90tBX9zhTw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jan_2012_11_17_58_+1100_35FJ=6Nbob1jkk2c"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jan_2012_11_17_58_+1100_35FJ=6Nbob1jkk2c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kay,

On Thu, 5 Jan 2012 01:01:51 +0100 Kay Sievers <kay.sievers@vrfy.org> wrote:
>
> Yes, that look like the right pattern.

Good, thanks.

> Stephen, thanks a lot for your help here, it's very much appreciated.
> I know we cause a lot of trouble every other year. :)

Its how I justify myself :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Jan_2012_11_17_58_+1100_35FJ=6Nbob1jkk2c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBCAAGBQJPBOw2AAoJEECxmPOUX5FEsX8P+MT7LK9RucY5uKwc6FqdyxXk
HojASocxFv30zk9NZRyXJtplghJcqNQul2CyZSuDRL4JWmobTK4Ng6NFC/T/c/38
O85Q2CLlSHTg5Sz61fqPYoggAeR78eP9+ovnOQkFSR7oiNDaH4ftqd7N6I+hQqgk
XxQL/KtyT83I78OBvQPQjPGbaZ8gj1LK/STFL0QJtpHac0gKaArBANdpY/1Rxwy4
0jifj5YHQL8VpPTmmVE6Zx7Pt6Zy2erTH/htIGpZ++5ByZRwS3fgEiP5+89UO29N
VOtbvY2QEL+m/QvP6Ipr99FWMMkpZZAhYchri6wrfuoIllgbpXMYbFoghvFX4Rw1
aU01cluaorDccUixyv9X722STZlUZRNBCQAJIbBsXUvgPbSWLIyDVdwz7Xfqn0Wt
CKEPECl4Terag4Jhhx0fc6aXlCy/DZFux7kdb66YgeJ3hpdcTkmDzGcbYmH+jfKA
45n6KbDW7HvMn4ekqbNvZRzW4l+yKt1MOXV+vM8q0hPT5vrqK6ucQwxTcXFDfbVR
qjaoh04poPpqqUBArJ1z26l7u6pqmQ6IeTE6nxeJbLhMgJyE6AJJFGnsagtCQlDj
xy4qYhxhjdCh9UwVc8RBGnEr3gjtOX2MWcgHLoJyrkTvwEWU7UveLQL+x8xXsbUw
f8dL3d+P/l/bbqfeE90=
=KgZk
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jan_2012_11_17_58_+1100_35FJ=6Nbob1jkk2c--
