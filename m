Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2BONri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:47:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34568 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759212Ab2BONre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:47:34 -0500
Message-ID: <1329313649.3048.72.camel@deadeye>
Subject: Re: [PATCH v2] kbuild: Fix link to headers in 'make deb-pkg'
From: Ben Hutchings <ben@decadent.org.uk>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        maximilian attems <max@stro.at>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org
Date: Wed, 15 Feb 2012 13:47:29 +0000
In-Reply-To: <20120215112009.GD2238@amd.com>
References: <1329144538-21444-1-git-send-email-joerg.roedel@amd.com>
	 <1329187753.3048.44.camel@deadeye> <20120215112009.GD2238@amd.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wNx4q1v3Dll7Dftb72Y3"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wNx4q1v3Dll7Dftb72Y3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-15 at 12:20 +0100, Joerg Roedel wrote:
> On Tue, Feb 14, 2012 at 02:49:13AM +0000, Ben Hutchings wrote:
> > On Mon, 2012-02-13 at 15:48 +0100, Joerg Roedel wrote:
> > > The Link to the kernel header files in the debian packages
> > > point to the original build directory. This is a bad choice
> > > if the packages were installed on a different machine. Fix
> > > this in by manually re-creating the link in the builddeb
> > > script.
> > >=20
> > > Cc: Michal Marek <mmarek@suse.cz>
> > > Cc: maximilian attems <max@stro.at>
> > > Cc: Ben Hutchings <ben@decadent.org.uk>
> > > Cc: debian-kernel@lists.debian.org
> > > Cc: linux-kbuild@vger.kernel.org
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >=20
> > This looks good for !UML.
> >=20
> > I wonder about the UML case though.  Did you test it?  In 3.3-rc3,
> > 'make headers_install' is broken.  But if I suppress the header check,
> > the resulting packages have links in the right places.
>=20
> I havn't tested UML, I am not really familiar with using it. You are
> probably right that for UML only the linux-image package is needed. I
> can remove the UML check from this patch and post another one which
> changes the script to only build linux-image for UML, how does that
> sound?

Sounds good to me.

Ben.

--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-wNx4q1v3Dll7Dftb72Y3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATzu3cee/yOyVhhEJAQpPvg//eyFlN5I5yb6zpacH0q4FazelmsDnila3
CrOU2pzlQa0avikOAsb7igNWna8fDcuz0kn/NS9f/29cnKY6391uV0Og7hxmqS3P
ozDKED1qy2epbguYYaqH408jQ6JAMKb/oSL643ZahqOPzUqC7kgejMgIRu/vuGzF
jHIGPkH+LmvtOm6USfDlSooa9QiCe+oa1TpWr5sFfLUkyVnLC7teVEm+rlmrubGV
LP92o4LbUzLH3bq97Ui/NT7eaaOqp1atkb8U0JGqPPFLnBDwmakzxC60jKdK1eIJ
Y5FElPKJVTI9FCtOqfBViXRE4PTZo+0tSZ9xNSFX4NVb68FwNS1kkU2TWTfwntjo
giEvVOEgN9KAFZHWae5bN21OGpCOa9pWsIvl0y2Mxa8dHrDxX9mFRI09QUmSRXeN
stjqcIOykaP38Qdc6ugv+mKsNLsOsL/jpkXYvcYuhOecXgzuBiHfe+5wHEgSk3JX
4LPKd4l6AB6s8nfDQ12LQvSDV8uz3D/sTFkeB8YfEq3SvOOh0Lhn2HYQCww2B7e9
WH1sWGHUYbpDDiPMeVSOpdp5Wqg+vEHxGgT/3XosQWaIWt14tBzuaVNGJE/4GFe6
mGR9vcYyzQmi5gj+xWE6q+WVjzpY+/VxndbAdTElaiYk9ia4Ca3IeFWbSuZctxBb
hqnEEa07iWE=
=tKAE
-----END PGP SIGNATURE-----

--=-wNx4q1v3Dll7Dftb72Y3--
