Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab2GHRRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 13:17:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57903 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405Ab2GHRRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 13:17:04 -0400
Message-ID: <1341767819.25597.234.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH V2] rtlwifi: rtl8192ce: rtl8192se: rtl8192de: Update to
 rtl_92ce_92se_92de_linux_mac80211_0004.0816.2011 driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org
Date: Sun, 08 Jul 2012 18:16:59 +0100
In-Reply-To: <1341713001-5077-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1341713001-5077-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7Xn0rm9+cDSldte2vMoh"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7Xn0rm9+cDSldte2vMoh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-07-07 at 21:03 -0500, Larry Finger wrote:
> Realtek driver rtl_92ce_92se_92de_linux_mac80211_0004.0816.2011 introduce=
d new
> versions of the firmware for rtl8192se, and rtl8192de. It also adds new
> firmware for new cuts of the RTL8192CE chips.
[...]
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1589,6 +1589,8 @@ Licence: Redistributable. See LICENCE.rtlwifi_firmw=
are.txt for details.
>  Driver: rtl8192ce - Realtek 802.11n WLAN driver for RTL8192CE
> =20
>  File: rtlwifi/rtl8192cfw.bin
> +File: rtlwifi/rtl8192cfwU.bin	- Driver for newer A cut chip
> +File: rtlwifi/rtl8192cfwU_B.bin - Driver for newer B cut chip
[...]

Whatever gave you the idea that you could put free text after a
filename?  Add an Info field if you must.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-7Xn0rm9+cDSldte2vMoh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/nAi+e/yOyVhhEJAQp2Ag//Y7/Pqs8BPaAAosgFpH32ZmVwqc3VGuSa
lLFAo9++ZubbFWbhotLFfNBRnLwaFa7jHI67lGZBo2cLDY3lXWZoXzJWtr3EyX9K
YHN2CsjISD31RvB6NvwYdd/kF2ooLJAGSfggiZk6O7hy/RHm+Yys2G5gCIdoNqqj
C7Usn+7oelzyoSr3L+qP3iIkImCSI4uxsqGQ/icNPsqPoldA5rWn0D17zR/bto/b
J+QrFnB8Gt+Ftn8oSe9mHVXNIf8UKizHcZgx7UTES7wFTuSoL8oYiAcNOI+GHfTC
vVqPUj2W/0LLfar/9RP0qApQ7k8gMulOcSR7qzqsVFedna9XtCPQjOTf/0yXFj/0
HE+Ugufy8u87y5zcU3ZF+hcWkaePZdHjVrkWHpvGKgispz0ZUX5ypd82/zOQvnNK
PPlg6tYldmt3j/TU2U2M/tl4XsrF9iFX/KNQ71QTZ239hvJFALjPeEy0+UdADApv
yBMtSz3yycdothlveOm1ApULVtIoKMF6ot6FaYhnfQaKawdntV+82mcV9f2989r4
l1T66W3WHNXXrCy5Lypvuj/td3DJbFhVvNI4rxFxjQt8G4f5S3wptkK50HgdkuCw
O2e9gzWc16Zx6cJJWxU2yE5d35O1qtP9iSdL1Smffamow3opbUhszBItydWIQ/sZ
JOrGNkB8m0M=
=oESc
-----END PGP SIGNATURE-----

--=-7Xn0rm9+cDSldte2vMoh--
