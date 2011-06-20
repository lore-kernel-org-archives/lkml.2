Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab1FTWNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:13:40 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:54922 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167Ab1FTWNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:13:38 -0400
Date: Tue, 21 Jun 2011 01:13:31 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kevin Hilman <khilman@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Keshava Munegowda <keshava_mgowda@ti.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gadiyar@ti.com, parthab@india.ti.com
Subject: Re: [PATCH] mfd: omap: fix the crash during omap ehci or ohci driver
 initialization
Message-ID: <20110620221330.GD28225@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307367739-20110-1-git-send-email-keshava_mgowda@ti.com>
 <20110620132626.GJ22420@sortiz-mobl>
 <20110620132851.GJ14262@legolas.emea.dhcp.ti.com>
 <20110620145941.GQ22420@sortiz-mobl>
 <87liww6tva.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <87liww6tva.fsf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 20, 2011 at 03:06:01PM -0700, Kevin Hilman wrote:
> Samuel Ortiz <sameo@linux.intel.com> writes:
>=20
> > Hi Felipe,
> >
> > On Mon, Jun 20, 2011 at 04:28:52PM +0300, Felipe Balbi wrote:
> >> Hi,
> >>=20
> >> On Mon, Jun 20, 2011 at 03:26:26PM +0200, Samuel Ortiz wrote:
> >> > On Mon, Jun 06, 2011 at 07:12:19PM +0530, Keshava Munegowda wrote:
> >> > > From: Keshava Munegowda <Keshava_mgowda@ti.com>
> >> > >=20
> >> > > Oops are produced during initialization of ehci and ohci
> >> > > drivers. This is because the run time pm apis are used by
> >> > > the driver but the corresponding hwmod structures and
> >> > > initialization is not merged.=20
> >> > You mean they're currently checked in a different tree ? Is that a
> >> > public one?
> >>=20
> >> it was supposed to go via linux-omap tree but the patches got lost in
> >> the limbo :-(
> > Then shouldn't those patches be the ones to be sent to Linus as a fix f=
or 3.0 ?
>=20
> If they were ready, maybe.  But those patches still need important work
> (and review) and are not "fix" material but need to wait until the next
> merge window.
>=20
> Basically, the original patch should not have been submitted to mainline
> until the runtime PM support was ready, so the correct short term fix is
> to simply revert.
>=20
> Also, to echo the question from Dima Zavin:
>=20
> Why isn't this just a simple revert of the original patch?

good question. git revert 7e6502d577106fb5b202bbaac64c5f1b065e6daa
is much better.

--=20
balbi

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/8YKAAoJEAv8Txj19kN1Re4H/iXjDe9MOuWe8Rm1eWROEVqC
C4fb5nrjUBO5P8F/b+TobhONMkUC1HARNZRbKoq03s8yNSP2Qohz9d/cqclZaqjn
YMwfFcnM5KMbudJhzSxfqKsRNQcNzdrDL9Q/2pC0DoTDnpXXhj/BsIu8JKGMEtsZ
47ct9mz+uX033Noq42lMHItM1m8X0/R0WcGfooOCjZgw7AXKnHEtxuEBrjBOm0rA
aZsSNODdaa7jRCRUkGeYcrnEgREhppLwuA54SWDM6yBUp37r0ZOJzo2070j1FLWk
pBtsMxoEvpR3KkWuNrwzp2X/jzoUxltaLh8njMkEMDgNxiG4d0RhVMPseMwm/nE=
=lMVi
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
