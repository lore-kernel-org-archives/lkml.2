Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2CGLWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:22:13 -0500
Received: from ring0.de ([91.143.88.219]:57363 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab2CGLV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:21:56 -0500
X-Greylist: delayed 1945 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 06:21:55 EST
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
Date: Wed, 7 Mar 2012 11:49:23 +0100
From: Sebastian Reichel <sre@debian.org>
To: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        CarlosChinea <carlos.chinea@nokia.com>, linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        ext Linus Walleij <linus.walleij@linaro.org>,
        "peter_henn@gmx.de" <peter_henn@gmx.de>,
        "sjur.brandeland@stericsson.com" <sjur.brandeland@stericsson.com>,
        "govindraj.ti@gmail.com" <govindraj.ti@gmail.com>,
        "pawel.szyszuk@stericsson.com" <pawel.szyszuk@stericsson.com>,
        Andras Domokos <andras.domokos@nokia.com>,
        ext Shubhrajyoti <shubhrajyoti@ti.com>,
        ext Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [GIT PULL] HSI framework
Message-ID: <20120307104923.GB18093@earth.universe>
References: <1326461140.32183.40.camel@groo>
 <1326975259.28477.57.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <1326975259.28477.57.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 19, 2012 at 02:14:19PM +0200, Artem Bityutskiy wrote:
> On Fri, 2012-01-13 at 15:25 +0200, Carlos Chinea wrote:
> > Hi Linus,
> >=20
> > I have been working in an HSI framework. The High Speed Synchronous
> > Serial Interface (HSI) is a serial interface mainly used for
> > connecting application engines (APE) with cellular modem engines (CMT)
> > in cellular handsets.
> >=20
> > The framework is currently being used for some people and we would
> > like to see it integrated into the kernel for 3.3. There is no HW
> > controller drivers in this pull, but some people have already some of
> > them pending which they would like to push as soon as this integrated.
> > I am also working on the acceptance for an TI OMAP one, based on a
> > compatible legacy version of the interface called SSI.
>=20
> Hi Linus,
>=20
> I've noticed that you have not pulled this (yet). I would like to
> confirm that we at Intel are also very interested to have HSI upstream.
>=20
> I believe this code base is more than worth merging since it has many
> users and it has proven itself in real Nokia products. Would you please
> pull it?

Hi,

I think we never got a reply why the HSI framework has not been
pulled into 3.3. So what needs to be done to get it pulled into 3.4?

-- Sebastian

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPVz0zAAoJENju1/PIO/qaN34P/RyWtEVnVMn+8/nwLSdMkjNs
RFL00j2KMjI0O9hzyekkxhHZypntloR9xBuVcQryWA7iLACWi3EEQuL6u5peuJFE
z5/En0JSonnvPJnC9bfTzuc5Rz5CvE9lts1d6mH1vqqe7V2V3gmb8ySkuQKlusYd
PFkx9YbMLZyoOOaDdjApCi1tEhMXVy27p94zMAdWVhXGA76eQJzPA1WkFIursA8I
uzIFpSOAqDYy1iFTjZMWNICfIq5hAUmkakV93WZEeiZZ5fXtsP4mrX9ErioObpZT
rCFE9+HkuExStnySJ9yBatgoICv9mtSVeMQpOnxXSbchH73/rmBIvKCt0Mu5ho34
6SEW8AZO9uoT8kTwoafmo/WfPY7cTCAOx0AHyWUuoMNTpuvJqGtAlRxurS5hPz5l
k6I8CU8x6n86lvNxL1VWfDC6MB4Oy/MmFHMS62XeIEX2Zpp2wRbBo3wpcq0+1Q/V
BsRIPchF7OaDf7jTAd/8l8/J6QSgeI8ZB0+b1iEQyYCyiwHaV6v/1DW7//XsTEn8
SxBztOWTydNu3GVp1M7Uv42eSzh30K7Znggd5o2v6W1HCFoTRnHDz/F7PxyrJmbb
Tl7/tIyNHf0aJo7gupc7ELO4FN02erTNGV9JnQTlsv1QEAC5n6wM9r9W8gkgd5jV
zsxWf9udPBzqxyfg6HUR
=OZZk
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
