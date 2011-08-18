Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab1HRVgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:36:21 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:55251 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245Ab1HRVgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:36:19 -0400
Date: Fri, 19 Aug 2011 00:36:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] twl4030: finish threaded IRQ conversion
Message-ID: <20110818213614.GB20509@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309427470-605-1-git-send-email-balbi@ti.com>
 <20110709040900.GI26900@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <20110709040900.GI26900@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jul 09, 2011 at 05:09:00AM +0100, Mark Brown wrote:
> On Thu, Jun 30, 2011 at 12:51:03PM +0300, Felipe Balbi wrote:
>=20
> > the following patches where boot-tested on beagle xM
> > and everything seems fine. MMC root filesystem still
> > mounts, /proc/interrupts looks like ps aux | grep irq
> > shows our threads, etc.
>=20
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

It has been a long time and nobody complained. Samuel, can you take
these patches in for 3.2 merge window ?

--=20
balbi

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOTYXOAAoJEAv8Txj19kN1K/IH/jDiN0aHvvFS1D3NIlqMe2hs
q7mYTbPtGhglNNtDb2dF4rgG0CfiSp5RCC81huyEiRbbhynOsM0jGexpkNfG5VTe
Aj8XrjYPm+3F569b43tFNQAeHjMCAI5HUZnkvtyo+4Zk7NOZfPmcLn+MnFsBDBdC
mVsrvPHjff0mnVDCkeyhj1rS2kIHnextxBBGUX+sZs0IWk1D+ynccabJq456peoj
fXuOvc6XcOtJdgy/hpyAd8eDJm21ldLmfQRv7JPeRN+f1rmj1VLSyHqXwWL/plbp
xjXHxpy7FJa65yKKka5ErebafKjVf/8bDAbJRYuisKJV9WZl5WTiqSzv18bJhjM=
=3ZEP
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
