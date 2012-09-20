Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab2IUOK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 10:10:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49385 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab2IUOKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 10:10:25 -0400
Message-ID: <1348180259.4801.9.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] rtlwifi/rtl8712u Revert firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Jan Terstegge <jan@terstegge.net>
In-Reply-To: <1347294365-6509-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1347294365-6509-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-iojFm8NyISB3K0CowScz"
Date: Thu, 20 Sep 2012 23:31:00 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.4.3-1 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iojFm8NyISB3K0CowScz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-09-10 at 11:26 -0500, Larry Finger wrote:
> Although the newest firmware for the RTL8192SU, which is found in vendor
> driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404, works with mo=
st
> devices, it causes drops of the wireless connection for the ASUS WL-167G =
V3
> (USB ID 0b05:1791), the D-Link DWA131 (07d1:3303), and probably others.
> Tests show that the firmware from vendor driver
> rtl8712_8188_8191_8192SU_usb_linux_v7_0.20100831 works better.
>=20
> This commerts reverts to that older firmware.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
[...]

This is the original blob added by:

commit 8f919160792e4702c6b7a67a243cea4f757407e4
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Mon Nov 1 23:56:52 2010 -0500

    linux-firmware: Add firmware files for Realtek RTL8712U and RTL8192CE

There have been two updates since then:

commit f8ddc05e13c4c6dd9d725bc376b287f307eb223a
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Tue Aug 16 11:12:14 2011 -0500

    rtlwifi: rtl8712u: Upgrade to firmware found in vendor's V2.6.6

commit d8f60751d3f09545f51aac5d8e451f7668063ebf
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Wed Jul 11 13:18:30 2012 -0500

    r8712u: Update to latest firmware
   =20
    A new firmware file is used in the vendor driver with name/version
    rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404.

Sure you want to revert both of these, not just the latest?

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-iojFm8NyISB3K0CowScz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUFuZI+e/yOyVhhEJAQozihAAsKx1mpxbBV5mVysiB4qn2JzvKImJcyav
ahLjTwTkmN91L83SacV1O+fh7H7B4aWYpvyPsnjabnrMqrGD06RlB7HkeweJHjIg
p3fnRRghK52p43wW+2x7BYawiyxd0K/nke68OypBdQRtOdjCj16vrmS1ja1GYH8M
JgAKLQ+rUr1aksT/fNHoadq5rm40pWNplmUKOw1PFgT7lSWUZH+i3BtGG8tjP5JE
mv20rk40+b5xFMmSs//famBLvSsOYk1uTvAOZ8yjr13K5UKo0ng08tCHDvI36TDP
+8T2lhI7F8RbYhe9VAU6xODyTlLVYxsE6Lhe3dvyglO23H1DgctFIxC4BOwfcllr
+Ddbr6BF1foUCUVHQ4+NU+dl22UCefMtgO2imwJ1sSBmjdqa6TDPLQD3Ft80AR/X
xfLiucKIbE56zf+OhUKEUwHbzyQZR4KvgfhYQjSrjc2FESDR634SVA41zrzxeUgH
BSRBVHB3wtXVF+NN96gcFvGOMB7At3jFriZcSfZpRuICvn3WmFDcXmCkrKTIQpz/
c4IqBK5z5xbbovmaLc4Nuj7Ixa9aFM7Ybt/VAaTAyNMygtmorxQYqGfYCQ/TbDzm
r17XG1BjmTTAV03J9zSnVKoaUQMinWg+maQCQ/nfJgXd1Ez0QBLFgsp1MCeSxFkS
NDgrQngtYKw=
=26Aw
-----END PGP SIGNATURE-----

--=-iojFm8NyISB3K0CowScz--
