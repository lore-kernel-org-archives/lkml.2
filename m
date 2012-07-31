Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2GaOcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:32:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54174 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab2GaOcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:32:46 -0400
Date: Tue, 31 Jul 2012 16:32:35 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC][PATCH v3 1/3] runtime interpreted power sequences
Message-ID: <20120731143235.GA21126@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <5017B434.2010706@nvidia.com>
 <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
 <20120731141328.GS4468@opensource.wolfsonmicro.com>
 <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
 <20120731142607.GV4468@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20120731142607.GV4468@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:bDzYA9hTNw541UJsk3MviB/5GHgOPg2R1l5LoEJB0e4
 Y+AuLbUghbKHugzbfU0PyPA88p/dKaj1atAPN0I2HquODOJQtx
 WRCq2ScM+0MQF0ZZwdmZZmqWpwmJg+XAAsFZVYr0v3xsf+jDwQ
 /YyMUR7Qh/PU/jK6pQGEDNMHHLpKQJTwz0f3FzezC5+TQq7y+l
 zfZ7+xDiMJxY/2SPW59IOshhwUVtfkoplQl+r78daI+avXytzs
 TpdP3hDtGdmpyCsgx6+W1RPAqskzfG76Z9bGDFhCMc6xTy+/zJ
 l1j7KEisYhfG5kKuIG9LJVIm+4TdQUYPs3Sdt0FIBu9nI71j8k
 bKKC3wExrD1i8IkbdNdOCaGmv+5lBKLo5iaSe/sSurv5/X7EDF
 nNSZ1lPGMA1mtSSJGlFyzyJt2v7n0FnSaRgDG9ggXnEktJFHcx
 nayNr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 03:26:07PM +0100, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 04:22:17PM +0200, Thierry Reding wrote:
> > On Tue, Jul 31, 2012 at 03:13:29PM +0100, Mark Brown wrote:
>=20
> > > __devinit can be discarded if you disable enough kernel features,
> > > HOTPLUG is the main one IIRC, modules might also need to go - drivers
> > > really ought to take a copy of platform data they plan to use at
> > > runtime, though practically speaking you have to try to trigger any
> > > problems.
>=20
> > HOTPLUG is marked EXPERT and explicitly states that it should only be
> > disabled if you're not using modules or dynamic device discovery. I
> > think if you've ignored all of that you're no longer entitled to
> > complain.
>=20
> This is framework code - it doesn't have much option.  Disabling HOTPLUG
> is totally reasonable on space constrained systems, there's no reason
> for the code to break things for people.

Still if you use this code and disable HOTPLUG, then you shouldn't be
using modules either. I mean there is no way you can write a driver that
can gracefully handle its platform data being discarded.

Thierry

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQF+yDAAoJEN0jrNd/PrOhIpYP/RGtCYPGFbjPsFEOram+N7vC
XSZsdrYm+dm32kQwmsRzysngMX6O/NkQmHupgEIxzlIK5nQIcFTqS55GJqigzRcJ
RKP9K1BxwmqDGH64nVb55K5V1HFvZJ3g1l0+gi8yUgqll11htwpdz3l6bJXBDS/P
xLg7z5HuaCsU6fbbz/XYVhuvWUKVLNAoaJE7/p6pLKUINu2ePp1Vxd0lcwh9Sdyt
xrYOZ6tIKkKwq1+dJ8VmC1ejNfvJeNmvKzLPjF2yxlbQ8ZaaEGywRUuCoRAanAyJ
D4Q5oB4ATCNBqH6ecc+iMawnJEvowLvzm/xJ6Agg1n5mFTyVmCzPhxjoAn9CY2Km
ALofyf1zK+b6tSoXWYyGLv4667HjiaL/pLsn4wKlb/6Bqc/n6lcYoqTM9dHxwyTw
W7a3NqR5dGhMgcRS/Yf6tcyFsVEGMyJlO99fiTMpZvStTDwrWK0LnC5KS5qTvrru
tnJdVZbM6SHNNKW/cjVewrwbDjoB1oMu98UmbiqKrasg8FGjE50YO74XspeOU0mW
62wczDzfv7tLIBw4qC4eFjrW+v4bkO6kvGeFWEPL74kwAKkrllnMEFB678RVGCDS
E3FwCBXootTMR7Zzw8R7RCbh3oA8UB5Z4u/H8Wm3a2+ctiN91jlydcMaOM1CQez7
3V2DaRg8eVUQwmXbGUn4
=mK8S
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
