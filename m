Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1JKTT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 15:19:27 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:40015 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755198Ab1JKTTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 15:19:25 -0400
Date: Tue, 11 Oct 2011 22:19:19 +0300
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
Message-ID: <20111011191915.GF13794@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111011081352.GC10155@legolas.emea.dhcp.ti.com>
 <Pine.LNX.4.44L0.1110111000460.2177-100000@iolanthe.rowland.org>
 <20111011140839.GF12293@legolas.emea.dhcp.ti.com>
 <alpine.DEB.2.00.1110111136280.1664@utopia.booyaka.com>
 <20111011191214.GC13794@legolas.emea.dhcp.ti.com>
 <alpine.DEB.2.00.1110111315030.1664@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1110111315030.1664@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 11, 2011 at 01:17:03PM -0600, Paul Walmsley wrote:
> > > On Tue, 11 Oct 2011, Felipe Balbi wrote:
> > >=20
> > > > maybe, but let's go with EXPORT_SYMBOL_GPL(). My only concern is th=
at
> > > > this IP comes from synopsys, and I'm not really keen on adding
> > > > OMAP-specific, integration-related knowledge on a driver which was
> > > > supposed to be reusable ;-)
> > > >
> > > > But at least for the time being, I guess that's what we need to do =
;-)
> > >=20
> > > Which IP is coming from Synopsys - the TLL ?  The EXPORT_SYMBOL appro=
ach=20
> >=20
> > TLL and UHH are OMAP-only wrappers. EHCI and OHCI are Synopsys IPs for
> > all I know.
>=20
> Ah, I see.
>=20
> > > shouldn't add anything OMAP-specific to the TLL driver.  So the expor=
ted=20
> > > symbols should still be usable by drivers on other SoCs.  But perhaps=
 I am=20
> > > misunderstanding your point?
> >=20
> > A bit :-)
> >=20
> > EHCI/OHCI will need to ask TLL to enable TLL clock, because it's
> > EHCI/OHCI who configure the port. Unless I misunderstood what Keshava
> > did (and no, I didn't just read the code, too lazy :-)
>=20
> The calls to the TLL driver only need to go into the OMAP-specific=20
> ehci-omap.c and ohci-omap3.c wrappers, as far as I can see.  So I don't=
=20
> think there's a need to modify the generic OHCI/EHCI drivers...

those where the ones I was talking about. That ehci-omap.c and
ohci-omap3.c refer to Synopsys IPs, so (in theory at least) that same
file can be used by any other SoC who uses a Synopsys IP.

--=20
balbi

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOlJazAAoJEIaOsuA1yqREescP/2jfPePXq2l/aYdTjOQlakks
kCFa+wY2yxG2i9erzhY2Rr2FLduvwDgqMU4ZZ7fwkzTTFZbAqOli6MnyXwq1fNRi
U5OSsak2xgcfW5Ybc9/iv1QGQxQVrbnaM70C6K7LFzvPxCh+ERUg/vvxne9vxYhF
4muS+RZBs+3sq03dSayFO1is3BhISgohspNXk2DUIM2ynWY0/KhuSnl2QBi2/UZK
BvVftHqNBEvauRFxU3biW8RI+2S21RU8A94AOOaykSBbLJlD/RedcCWA4S11EAuc
BPNZuHRnhdZ8inM9S+968Ipc+bNUJqJg/TPSI4FlJnR1FxyywgbdsMWvFDVRHAhI
jSzHaRSNYQvY5slGd1sIY5pz15opOixODfBtH+9+UOf4qtQQWS15KzM2rqfpYMZt
HGO2dBoYLzPFaUq4CeXWb37oL2btmlxQ4xBqGx2OScyd2Enhci2F3XmGForLJxa6
AWjaZlebhXgklY66WuMw8joaBPJ0CfG70EL++9azMwlza40qRx61jTrGhR/USbKt
x8Mg9uGxtTBBXBTgqa0J6qG9vun9ZrovuFy7O5dkxGaVsjHrUUSF3WwrPaz629gc
lwg9tOSf4Okv3W9YoU1R+4HxIyyqIlcz9F+VezoYvZDgproN4BDbp4JmWSG9ox+j
j7RgMlYymqpFvYbPvxDs
=Ti58
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
