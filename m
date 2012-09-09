Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab2IIS7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 14:59:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49325 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173Ab2IIS7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 14:59:06 -0400
Message-ID: <1347217142.7709.61.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] rtlwifi/rtl8723e: Add firmware for new driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org
Date: Sun, 09 Sep 2012 19:59:02 +0100
In-Reply-To: <1345480950-11107-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1345480950-11107-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fBBq5iH7FF3tWfuMFrm4"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fBBq5iH7FF3tWfuMFrm4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-08-20 at 11:42 -0500, Larry Finger wrote:
> The driver and firmware are new additions to the rtlwifi family of driver=
s.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  WHENCE                  |   10 ++++++++++
>  rtlwifi/rtl8723fw.bin   |  Bin 0 -> 11662 bytes
>  rtlwifi/rtl8723fw_B.bin |  Bin 0 -> 22996 bytes
>  3 files changed, 10 insertions(+)
>  create mode 100755 rtlwifi/rtl8723fw.bin
>  create mode 100755 rtlwifi/rtl8723fw_B.bin
[...]

Applied, thanks.

Ben.

--=20
Ben Hutchings
Time is nature's way of making sure that everything doesn't happen at once.

--=-fBBq5iH7FF3tWfuMFrm4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUEzm9ue/yOyVhhEJAQrz2w/9HDHlr9CXy8+I7zzcbJbKaECoiyNGDeRy
7do8kMscG6jGUsCeB2xZ7NwY4O1dei2ufY2/XCm+FYCUoCDTbvdJ0eB9SNf03xr5
VLqKcdrZlN3g8zNz+djsZPlUCw6ylN2erVeNaVpojXuH+81QmtwnQz2+O1mF2H1J
+YToTdMJ2CAbmG0yN2gNdSs229I8YYgGMp332idyG2gvPMVK7b8+ZKlZF7MgUR4V
YCulywIgKuiqugOzYo7ThPEyxPzfkxda0B3yI9KTIW+IzkNXDQ5QJsmZwoBzWter
YaQW8KxcEgOCl7ZrVWq+YecA4J7+hMTjvZb1HLZ6vG3XDAic6b2fcUg7xD5QjRxQ
Jl2NedWsj49xvmJnlpRSgq6YLDXOmgaL53Pxs+nahbuRKSm6vRvkllaFgNRJI6RI
Qyhk4S050NGH0PZmWrgr93UUjQIIzkMsGUn70kN2lm+NPOQ7HxFfp0vK2MwV3Tlt
63ADVuEkmlFHBhMCViH8JF7g7BXWsE4x6PlHa/bxHcLj4z5M45EoNeYC+VTnOmkK
kPvLogzaEK5+S4MfHf55VGWWE3tEIGaTxTl8Q35zfXaYW8r8ErrDiTHNYpef6AIs
+O5JS7EKbsjtuC/IsJwV4Q5MZa/Ak32fqJDHuvO6BqFtXBgrAYebUAhmQmsEVBSz
ycAfCG2mqf4=
=n2LY
-----END PGP SIGNATURE-----

--=-fBBq5iH7FF3tWfuMFrm4--
