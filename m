Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2B0OhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 09:37:11 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:36058 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753451Ab2B0OhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 09:37:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.152.45.134 as permitted sender) smtp.mail=balbi@ti.com
Date: Mon, 27 Feb 2012 16:37:03 +0200
From: Felipe Balbi <balbi@ti.com>
To: Cyril Roelandt <tipecaml@gmail.com>
Cc: balbi@ti.com, dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] amd5536udc: use the DEFINE_PCI_DEVICE_TABLE macro.
Message-ID: <20120227143702.GW26445@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
 <1330132502-17057-5-git-send-email-tipecaml@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yTwVabqJa5IUz21H"
Content-Disposition: inline
In-Reply-To: <1330132502-17057-5-git-send-email-tipecaml@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yTwVabqJa5IUz21H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 25, 2012 at 02:15:00AM +0100, Cyril Roelandt wrote:
> Use DEFINE_PCI_DEVICE_TABLE instead of "const struct pci_device_id".
>=20
> Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>

applied, thanks

--=20
balbi

--yTwVabqJa5IUz21H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPS5UNAAoJEIaOsuA1yqREZt4QAKon15i/MHPu05yo042lr24z
1/GO8TgLdPnsMncEbhLanwz+/4LiCzRiZwI0VcEhfBRS5t4gUNf/kdAV0MJP3SPg
M4JZg883p5J600LC6SBxwEUX1OkR4qHxJANGGMqzbiqNUGwOC84lHnGZ9tudEwxs
DkWM5hKS5RJUMILyK8JssrZdaGu7M6iaTA/NlGyo9f0+q6Ya6NseNyNCDXOB07KY
N+mDQ7esQ6G7i32ZCLQU/wSlDDIV1wZoHpnQ1JlbzBsq6kgdEgEMPV+a5f9KHeTA
tAfyLoaHPQ0SICkHs/IV2MO7Tz3kJs8JUEiD8+BULRYXV1u/v+aO22XmteBij9y9
YwtA/WmBkzeKQP2LYFf//tXT+o8O29CorJOfltppve+/4spfcOI6CA9Cnqw16E28
V9ftFdtCK+gyvsSkLg4bYmPRKI5oKPaa+17ULSuwMCTKO5bggqdi//j6cf/u6x3/
sztKSDnXF/NWFySy/wHQiDPs1ZhszHiEUAqY+VGGDVYP/BZbl4S3JVeZCUNR5Bud
YvEJZ0Ibrd4kJihRyyXPXCv1kWNqo4NO+mNzFpLmo2OSj1wMVZhQicZHZKBafE3Z
Pp3TBFYBCTwKYqCJ4ldtmtO/qH+pBhEYilxKSM5WqqVcuE2YVTT7WknZzKg/joZ3
YjMVp5gRBUeJf5aIniX2
=sAvt
-----END PGP SIGNATURE-----

--yTwVabqJa5IUz21H--
