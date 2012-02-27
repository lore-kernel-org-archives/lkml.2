Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2B0Ofk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:35:40 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:55657 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409Ab2B0Ofi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:35:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.152.102.237 as permitted sender) smtp.mail=balbi@ti.com
Date: Mon, 27 Feb 2012 16:35:30 +0200
From: Felipe Balbi <balbi@ti.com>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: balbi@ti.com, dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] amd5536udc: Fix brace coding style issues.
Message-ID: <20120227143528.GT26445@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
 <1330132502-17057-2-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p609JBPwWeYlfsbE"
Content-Disposition: inline
In-Reply-To: <1330132502-17057-2-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p609JBPwWeYlfsbE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 25, 2012 at 02:14:57AM +0100, Cyril Roelandt wrote:
> Remove a bunch of unneeded braces.
>=20
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

applied, thanks

--=20
balbi

--p609JBPwWeYlfsbE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPS5SwAAoJEIaOsuA1yqREvuEP/RYppoKz5jbXDwVkfQj5/aPR
YtNsWWUoAch6tcAStdgfRZGZxe86/VYE25vpd+PwzUZ5bXEW2DIjO52JfPYbwo8F
QGCFG2Qj90JKRnyZj2IvDc2ExUEP1gps96XNXH+6jY+vkY6N6aNA9VYuUof4f2Rr
WiF3+1gl2Slr4kxqQoAb7CQELua65Lz4u7FwD5e0lDViRSAmbBX2el3EIYMqlfLG
H4PCKFxLQZUDrtxzxMkvF8PqXaryizl10ZGl6dZvrIR5yi8dHncvNSNMs3yQ+IxH
NQVSaO5uFBWdEAY8jdVBl1Se0vZjsdeAfOv9zB2bp9PslFXXiS4vo7EeyRwm1Wsi
dpUqR04buC+P3a+66Z9BN9E7UD1/64SKvLb/iAMPAbiclB81af6IKwaVC603pD9x
HZBDl932lA/SUV+JnsfXCohKsjcS4llAYS3Lh8EtvM33F33o+QIBjjlIAHWtS6EZ
XUokMrvO3LUTcviZCSpGvU5XXSbOvq1fCjGEftX50EvROhJuqcCVgThlV2BwlvDs
UWOyRh+2YuXT7TiDg+SVZrTq2QJP4WLcBfhRP38x07GInl4pCR1lop3+Pp27MMSk
SfZRHBbxWdWHQTlPmEy8XIjcxzVyc1425BQwVWYkxSh+o+faSSwQq61Xv8nUeX11
DMlENhlIKVYXH4lLQEOX
=bfAh
-----END PGP SIGNATURE-----

--p609JBPwWeYlfsbE--
