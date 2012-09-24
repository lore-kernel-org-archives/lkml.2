Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2IXTe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:34:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50853 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757718Ab2IXTeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:34:25 -0400
Date: Mon, 24 Sep 2012 20:34:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        dwmw2@infradead.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Jan Terstegge <jan@terstegge.net>
Message-ID: <20120924193421.GH29217@decadent.org.uk>
References: <1347294365-6509-1-git-send-email-Larry.Finger@lwfinger.net>
 <1348180259.4801.9.camel@deadeye.wl.decadent.org.uk>
 <505C9254.5090101@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <505C9254.5090101@lwfinger.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] rtlwifi/rtl8712u Revert firmware
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 21, 2012 at 11:14:12AM -0500, Larry Finger wrote:
> On 09/20/2012 05:31 PM, Ben Hutchings wrote:
> >On Mon, 2012-09-10 at 11:26 -0500, Larry Finger wrote:
> >>Although the newest firmware for the RTL8192SU, which is found in vendor
> >>driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404, works with =
most
> >>devices, it causes drops of the wireless connection for the ASUS WL-167=
G V3
> >>(USB ID 0b05:1791), the D-Link DWA131 (07d1:3303), and probably others.
> >>Tests show that the firmware from vendor driver
> >>rtl8712_8188_8191_8192SU_usb_linux_v7_0.20100831 works better.
> >>
> >>This commerts reverts to that older firmware.
> >>
> >>Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> >[...]
> >
> >This is the original blob added by:
> >
> >commit 8f919160792e4702c6b7a67a243cea4f757407e4
> >Author: Larry Finger <Larry.Finger@lwfinger.net>
> >Date:   Mon Nov 1 23:56:52 2010 -0500
> >
> >     linux-firmware: Add firmware files for Realtek RTL8712U and RTL8192=
CE
> >
> >There have been two updates since then:
> >
> >commit f8ddc05e13c4c6dd9d725bc376b287f307eb223a
> >Author: Larry Finger <Larry.Finger@lwfinger.net>
> >Date:   Tue Aug 16 11:12:14 2011 -0500
> >
> >     rtlwifi: rtl8712u: Upgrade to firmware found in vendor's V2.6.6
> >
> >commit d8f60751d3f09545f51aac5d8e451f7668063ebf
> >Author: Larry Finger <Larry.Finger@lwfinger.net>
> >Date:   Wed Jul 11 13:18:30 2012 -0500
> >
> >     r8712u: Update to latest firmware
> >
> >     A new firmware file is used in the vendor driver with name/version
> >     rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404.
> >
> >Sure you want to revert both of these, not just the latest?
>=20
> Yes. Both of the updates work on my hardware (D-Link and Rosewill),
> but both fail on an ASUS WL-167g v3 as reported privately to me. I
> will work with Realtek and the OP to resolve the problem, and then
> update the fw once again.
=20
OK, I've reverted as requested.

Ben.

--=20
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus

--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUBUGC1vOe/yOyVhhEJAQpvPg/6A3igrukIgZbJQsv857F3im1I4CYKg0cP
Q8n+h8Z/Z/ruOvgisGFMCBIi0+2MAf6vURqvFWwR5NESsQ1FGKvW8ODgbnqdRXUE
6iM+51ovtMEgxpx6bOx9LWh4qGqWRTlHqlk/Fq2z9jtlDDiAVVcuNaT+cGdJtZpF
BcRip5s0aFANGl+QmqQGT6r+U2fXDyQnhLWVTisxSNYPgvbpydrirR3Fbfon9V5k
NZjnwTg8eCwQ6GrtruAoJrIh2v+Ts5SumTTzBqjBXBQ9MGHg8kYBZNUeDMeyTIzn
oTreB8yhBGHg7OretKoiaJihPM+jfgjumtNt3+m0B27WqUVaaXgdVofca8AAw+3s
NRMmZ9KCNvO64wOhzcBEiejudriMr7KPCpM6az3D+X98gVBUDI1U+ROicaKbOeVj
kcMo5dvqEdh9MzTP0wMr0Iaewrc+WqBHai1tiRLLD2NFk6i+5P/uYfRvp2KlRcPn
Mk49Nlhv9UmYvfpzy0w8fkxbYbZi0w0eFIXy7j8t95cd0fZbFYP3IBL4awTp4ZkG
iu4ekADeVVveWaiOCu9aVbPL/AE62N07P8Ioldnu3VB0gp/zt/wjCDZW24mCfHPu
CQTSjN4ZGr25FsPmeO97Hii1soFf6/1T6AMqUQVQwL0oSCxqBWmzfQFnFwtzaxYB
mBit5O/HDDw=
=RYQO
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
