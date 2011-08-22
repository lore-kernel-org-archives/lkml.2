Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1HVSE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:04:29 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:40532 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752617Ab1HVSE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:04:27 -0400
Date: Mon, 22 Aug 2011 21:04:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] twl4030: finish threaded IRQ conversion
Message-ID: <20110822180421.GB32342@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309427470-605-1-git-send-email-balbi@ti.com>
 <20110709040900.GI26900@sirena.org.uk>
 <20110818213614.GB20509@legolas.emea.dhcp.ti.com>
 <20110822145436.GW4607@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jho1yZJdad60DJr+"
Content-Disposition: inline
In-Reply-To: <20110822145436.GW4607@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 22, 2011 at 04:54:36PM +0200, Samuel Ortiz wrote:
> On Fri, Aug 19, 2011 at 12:36:15AM +0300, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Sat, Jul 09, 2011 at 05:09:00AM +0100, Mark Brown wrote:
> > > On Thu, Jun 30, 2011 at 12:51:03PM +0300, Felipe Balbi wrote:
> > >=20
> > > > the following patches where boot-tested on beagle xM
> > > > and everything seems fine. MMC root filesystem still
> > > > mounts, /proc/interrupts looks like ps aux | grep irq
> > > > shows our threads, etc.
> > >=20
> > > Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> >=20
> > It has been a long time and nobody complained. Samuel, can you take
> > these patches in for 3.2 merge window ?
> Yes, that sounds like the right time now.
> All 7 patches applied, many thanks.

thanks ;-)

--=20
balbi

--jho1yZJdad60DJr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUpolAAoJEAv8Txj19kN1OiAH/2JmNBBya7ozGPpGkuAqBnBA
PpIxghKpgqevhuzBLiN5hDwgt93kS8Rf0aqdk0g7k9Enwq7bMm3ViK/SUJZl5ApK
uBe+LJSe6J9ERPDC7hAJK3twUtagcACEkrHPjqovoSApJYesKHQnfvQK7cRW9RUg
tvMtryl5LA+7mpT0ogOm62uLR42fzOrW3GY3/jnx2vRmuiliR9qw/ckbGIp0OphQ
qyotVhod2S2uwVMkYWg4FUTNjzOPOElNOxQAIu+xKLujmYsMBNGE8BjGZmY6cUpw
SIullm121QSZkyTGa9t0obS2Bh57F6bgYogHeSth8J9yP304t3GMd89qWf9oLh0=
=GQNE
-----END PGP SIGNATURE-----

--jho1yZJdad60DJr+--
