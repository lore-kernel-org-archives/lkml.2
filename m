Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238Ab2GaOWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:22:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2GaOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:22:23 -0400
Date: Tue, 31 Jul 2012 16:22:17 +0200
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
Message-ID: <20120731142216.GA19591@avionic-0098.adnet.avionic-design.de>
References: <1343390750-3642-1-git-send-email-acourbot@nvidia.com>
 <1343390750-3642-2-git-send-email-acourbot@nvidia.com>
 <50170EA0.1010408@wwwdotorg.org>
 <5017B434.2010706@nvidia.com>
 <20120731105640.GD16155@avionic-0098.adnet.avionic-design.de>
 <20120731141328.GS4468@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20120731141328.GS4468@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:c4bpqT89PoHBgzcaYL1zFftLTasnZ/9Yh+DU6MVRBfZ
 gL97ys696xHyhhAgGrB7WvsoL7D+j7Mc+2xElQM7m+poezPjLZ
 MBcooipPsWGeIae420GboW5vvXlMzt8eVEEmCHr+VmA87CoHaS
 BNYH7sTDi+0L2G4RuRwARRMtNpyn6AAFKlgZwBTJ/3/uTBnyyZ
 P361Y/Ymo/LbESU126TgoOzkS+NqD3MeHJ4P4Zl68dHBIOx1/c
 /NAG9WaMDxk/9wsn+xl4ho8ESB1YA4JmGhnn7fn6EOEI3Ss3IB
 7EGQHxSFX7/ZvPiDdtYWth+vg6j5zypJ8X8UIjIpWAaOscqnPz
 XbMQZPWQfOLqfn8hO+Uzco70yTqwDR36bREeOI+ScMGHzHoXOm
 HTr5DrevObT9pHDt0KATJ9UF/9/rZF/Jah2aWrcRRUtLHLYGwe
 x7y1O
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 31, 2012 at 03:13:29PM +0100, Mark Brown wrote:
> On Tue, Jul 31, 2012 at 12:56:40PM +0200, Thierry Reding wrote:
> > On Tue, Jul 31, 2012 at 07:32:20PM +0900, Alex Courbot wrote:
>=20
> > > The thing is that I am not sure what happens to the platform data
> > > once probe() is done. Isn't it customary to mark it with __devinit
> > > and have it freed after probing is successful?
>=20
> > No, platform data should stay around forever. Otherwise, consider what
> > would happen if your driver is built as a module and you unload and load
> > it again.
>=20
> __devinit can be discarded if you disable enough kernel features,
> HOTPLUG is the main one IIRC, modules might also need to go - drivers
> really ought to take a copy of platform data they plan to use at
> runtime, though practically speaking you have to try to trigger any
> problems.

HOTPLUG is marked EXPERT and explicitly states that it should only be
disabled if you're not using modules or dynamic device discovery. I
think if you've ignored all of that you're no longer entitled to
complain.

Thierry

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQF+oYAAoJEN0jrNd/PrOhJQYP/ixKiwwEFkQ2R0U2+iR5HTuu
4Xd6/Jt2H3IkRPUP5s6xfopgiu6VVQ417qqVi/deA0ny5SXsXE8BjidzpoBtdcTz
mfTB+NGS+QBp69RFr7gJ6wbb07aDFG8B9nOyNbvp2DBrqKBkw/VwZL8uoJZnYmZN
Q/37YS2OnLCZ41dt4/0UUCDZfXDfzoGTqLBFUB95fLddx/WTSBzpfyvmYyVtDSOx
gPXoRBBDkXolkCeyEEk65dUwRLWtKFuUZW05D7H+4VAFsaYo/hRp+ayCMTd3saJ0
yg7F3d3SY9cDuRKseQhVQ31jTvxLRHylKHUxbd9ogH1b4IZQM2lkT8bbWgY4gCBm
PAUGBHOjX1ag8GG4Cw9J1hhVEgEgABJqi2Wmuln0+vAj6Z4sWA/+q/a4g9Orha6+
xmTcEtRrP5tCzdOHDwDoUDtDDTY9H8Y7/OPIsn8rt1rd2piFEHT2T88Ts1Arvlv+
tvNhV4DNnDUxeX1+lv7/rUrUORFzDoYv7ZmRjlqGDagrVnBy2uFhI9FaOrdKEzJB
8FSvN1e0OGXmYwyBvz7JeSzEPVvbi6SydFi1NxIf3Jlv8WsUOPJJMdJLAqFuMG2L
pSs9Fs6L/2UFgauMu+5QEcUZUbgiEvquxmi/xKJn3mgv29psxPWfkLxeOn/xIaTP
YlL371mG3ZWl70qJrufS
=TiF4
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
