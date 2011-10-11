Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab1JKTM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:12:26 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:35860 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948Ab1JKTMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:12:24 -0400
Date: Tue, 11 Oct 2011 22:12:16 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, khilman@ti.com, b-cousson@ti.com,
        gadiyar@ti.com, sameo@linux.intel.com, parthab@india.ti.com,
        tony@atomide.com, johnstul@us.ibm.com, vishwanath.bs@ti.com,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
Message-ID: <20111011191214.GC13794@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111011081352.GC10155@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1110111000460.2177-100000@iolanthe.rowland.org>
 <20111011140839.GF12293@legolas.emea.dhcp.ti.com>
 <alpine.DEB.2.00.1110111136280.1664@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NU0Ex4SbNnrxsi6C"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110111136280.1664@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NU0Ex4SbNnrxsi6C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 11, 2011 at 12:52:05PM -0600, Paul Walmsley wrote:
> Hi Felipe
>=20
> On Tue, 11 Oct 2011, Felipe Balbi wrote:
>=20
> > maybe, but let's go with EXPORT_SYMBOL_GPL(). My only concern is that
> > this IP comes from synopsys, and I'm not really keen on adding
> > OMAP-specific, integration-related knowledge on a driver which was
> > supposed to be reusable ;-)
> >
> > But at least for the time being, I guess that's what we need to do ;-)
>=20
> Which IP is coming from Synopsys - the TLL ?  The EXPORT_SYMBOL approach=
=20

TLL and UHH are OMAP-only wrappers. EHCI and OHCI are Synopsys IPs for
all I know.

> shouldn't add anything OMAP-specific to the TLL driver.  So the exported=
=20
> symbols should still be usable by drivers on other SoCs.  But perhaps I a=
m=20
> misunderstanding your point?

A bit :-)

EHCI/OHCI will need to ask TLL to enable TLL clock, because it's
EHCI/OHCI who configure the port. Unless I misunderstood what Keshava
did (and no, I didn't just read the code, too lazy :-)

--=20
balbi

--NU0Ex4SbNnrxsi6C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlJUOAAoJEIaOsuA1yqREIMMP/RRGz/S50L9iCuJUSv5pVGKV
IBoVtqdDJ7m1IJGXoDAkCwAn9c4VRkk6lCsa8jpS4Yl9O7Hp/WuaggGcp0PmQYdQ
urOm1QWBaYW9g7rEjKlmH+9aib6LgKmtAJkD24HOp1STCozi+bA3CxEDzhORG2mA
HQdOaGin8LsfRUA4bPo56HAgwxSIAoZZW43SJLjjxzTWqM33CjFkJFC+yGN1G17K
OHNebo4fOmfOIG51ANyqW8MTR04M/QjXsqcNrT512AmRRHEcmPB0/RgtaeUOYbQy
4UO1gL5gURDU1vk4dvh+38MbOQvYF8T/o7wO0GpxnB1AtmOhsgmyH+/5RcblWtRC
uwbuaXlDp3KWXfdVu4n1FHFSHxQKwkYHa5GblreQP0nfL6E8P3uj7lYLpY72VHZi
vK+ENfIZ9lJrWO7jtKVmI0q8Obz5KYN0pQcQ8Pg3YagAKvDzwGpubg0c4Z780RhL
lcoE+Jzu8AwGk3JTM1z+D247fF6jSZ/L4dO5iEp5lZHpcRcKq1nL0HzHRk/FJtjo
wIsgHKYmKuk/TSQGA3aRVbia3AGOBcrh7aimy41Bu2HkQelVUBbF1PE3aGMEcnnM
Se5SBCJtejXUGg1rj/3CXVCby4cgTKa3FGXhDgu1inzzyhlGBN3n8Wr6hpae/yQr
O78VYmqwfv7+cVO0G7Qs
=HPpT
-----END PGP SIGNATURE-----

--NU0Ex4SbNnrxsi6C--
