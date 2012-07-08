Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab2GHRVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 13:21:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57933 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab2GHRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 13:21:17 -0400
Message-ID: <1341768068.25597.237.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH V2] rtlwifi: rtl8192ce: rtl8192se: rtl8192de: Update to
 rtl_92ce_92se_92de_linux_mac80211_0004.0816.2011 driver
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org
Date: Sun, 08 Jul 2012 18:21:08 +0100
In-Reply-To: <1341767819.25597.234.camel@deadeye.wl.decadent.org.uk>
References: <1341713001-5077-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1341767819.25597.234.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cnDLOwfe9E29opnQU8hf"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cnDLOwfe9E29opnQU8hf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-07-08 at 18:16 +0100, Ben Hutchings wrote:
> On Sat, 2012-07-07 at 21:03 -0500, Larry Finger wrote:
> > Realtek driver rtl_92ce_92se_92de_linux_mac80211_0004.0816.2011 introdu=
ced new
> > versions of the firmware for rtl8192se, and rtl8192de. It also adds new
> > firmware for new cuts of the RTL8192CE chips.
> [...]
> > --- a/WHENCE
> > +++ b/WHENCE
> > @@ -1589,6 +1589,8 @@ Licence: Redistributable. See LICENCE.rtlwifi_fir=
mware.txt for details.
> >  Driver: rtl8192ce - Realtek 802.11n WLAN driver for RTL8192CE
> > =20
> >  File: rtlwifi/rtl8192cfw.bin
> > +File: rtlwifi/rtl8192cfwU.bin	- Driver for newer A cut chip
> > +File: rtlwifi/rtl8192cfwU_B.bin - Driver for newer B cut chip
> [...]
>=20
> Whatever gave you the idea that you could put free text after a
> filename?  Add an Info field if you must.

I see that there are still a few other instances of this in the current
WHENCE, which I'm going to fix now.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-cnDLOwfe9E29opnQU8hf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/nBhOe/yOyVhhEJAQq5RQ/8CNE0S8kHKc6n2qZx3nB7GmboXBaBS17o
DToAKcmC9/MugWi1VBoPN59Ei8qf2NVVDlZktdVo2e+CWwFN9MpWEw3cJayhvP0M
Aqq/SnCfRFyHDn1cHki7J2B6WMlMZBGEdjzBVbN6IuUWhYe/F7f1gBj3z33Jg5bn
a8948HeDTyl5mIad4MihvEjqJQy1xPqI5qsVlsrR7ob1J59sI5PfYHKC8wHRmihS
g5xLJhb02Ui3SYcvxIPfapX9HhOZEya84fkp+bRWchdMY9Demw877kvsfHhc7SrR
pTfZAyuoY64N0v+Z4MfK1TLDXMpPI+ltuhjmIJOxv/35FSoYZC20sEEDcQmb0xwr
Ea2HTJFoWrI2RxnWuUeI7FTNOvdVkUFmtuPTXjAAskSI1wHX/q7MjwJ4ENlhsUtE
0ZclAxv8WPWvlTroyQXb32mk9UfZgzJ7Ydyr/Lpgw8Nmog701JLgtXbGq0xaS2si
eEi1YYj8wmPu30JZttgwSfczO2DIXENyuOLcU9jP5tM652KJqbUVkRAuy9NmAg7+
f8JUHxXm7Y8zDCkpG+cWaFCF1ki0vn1BnnQ5e6DBtVzoDvymuTY6pA9XZBIqcwus
8xqQK4dDt+6IVVW+noFXC9yebzUn1U4/FqWbBe7FTJb5CK9M7yWaAh05fku5OFkt
9gQEG8CkdLw=
=VxsG
-----END PGP SIGNATURE-----

--=-cnDLOwfe9E29opnQU8hf--
