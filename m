Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2LYX0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 18:26:52 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57086 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510Ab2LYX0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 18:26:50 -0500
Message-ID: <1356477982.21837.93.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] rtk_btusb: Add Bluetooth firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Champion Chen <champion_chen@realsil.com.cn>
Date: Tue, 25 Dec 2012 23:26:22 +0000
In-Reply-To: <1356057465-15669-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1356057465-15669-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-UkPLcTTKGmkekd3jElAp"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 82.132.229.161
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UkPLcTTKGmkekd3jElAp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-12-20 at 20:37 -0600, Larry Finger wrote:
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Champion Chen <champion_chen@realsil.com.cn>
> ---
>  WHENCE              |    8 ++++++++
>  rtl_bt/rtl8723a.bin |  Bin 0 -> 23772 bytes
>  2 files changed, 8 insertions(+)
>  create mode 100644 rtl_bt/rtl8723a.bin
>=20
> diff --git a/WHENCE b/WHENCE
> index 3b2f282..f485111 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1811,6 +1811,14 @@ Licence: Redistributable. See LICENCE.rtlwifi_firm=
ware.txt for details.
> =20
>  ------------------------------------------------------------------------=
--
> =20
> +Driver: rtk_btusb - Realtek Bluetooth driver
> +
> +Info: Supplied by champion_chen@realsil.com.cn along with driver source =
code
> +File: rtl_bt/rtl8723a.bin
> +
> +Licence: Redistributable. See LICENCE.rtlwifi_firmware.txt for details.
[...]

There seem to be some serious problems with the driver that uses this.
So, if this is not already in use with an external firmware blob, could
you perhaps add some sort of header to the blob and have the driver make
some sanity checks before uploading to the device?

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-UkPLcTTKGmkekd3jElAp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNo2Hue/yOyVhhEJAQqFUg//QLLgM4kiatk13w765aiKdwVnghDp5cwH
6M1TAep90UurMBsG4Bzk9k7mr1XKU6v+rp8iPmfr4obXx+nGzNANfO/xpg/TEQwh
SZiD0wg68IO2GaHCl+cS0mQMgzFmJ2rSnmrlUGJEeXrXok20b+atA1epyyAwVohB
YeCpJf84PxZJrqnS/V1M2aFSdguFPVUjGVdIR7x1pNqDmxYebnHROkK1+ZsMgaj3
foVJMCeEY1WECe+FnORYiTQGXx4ookCTb0WOUcv93/Ez6eHwiZP7jXC2954P2Maq
sEngikNqf02pXBYnnSU9v5HqbUYYpNzfHQdODa9gNtIH1/4Ev36qWJPu6JtdnY06
dZ8+CYGGJzRXOIsOTXs3J2+URMkgsrQ1IGJ9dX/pJ2PFkaWFNPTXU6gDpAX/wT8r
zzZXa8q7Ve/tNnguW5xqtb4YimbdHrw1SHRjPMeHSmAoEwxjMLOnuqvoe/lyorm2
qJ10+NVcylNCUgf/X2SY1YSwYlKsvk+LLwqN8FWFR7OZ5tTDeZ6jnRaJASw+C/k8
//lbjGFbA/SxY27UCsfhFfT62EQ3P9RpQYrGRTOZwjUXlMxPE6g1YIZy2Wmk0gJh
9OgF6xUsqoQ3JdiNITpikZ7xxXsk0l40pVRnx4GCjz2B50UC416jEoak6APGEjSw
R7WdNqxBCkc=
=COnG
-----END PGP SIGNATURE-----

--=-UkPLcTTKGmkekd3jElAp--
