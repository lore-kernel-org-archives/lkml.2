Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2CEMHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:07:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58744 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400Ab2CEMHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:07:50 -0500
Date: Mon, 5 Mar 2012 12:07:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        Arve =?iso-8859-1?Q?Hj=F8nnevag?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PULL-REQUEST] EXTCON Patches (Re: [PATCH v6 0/5] Introduce
 External Connector Class (extcon))
Message-ID: <20120305120743.GE3224@opensource.wolfsonmicro.com>
References: <CAJ0PZbRsh_Cnqy8Vtf1FWLajBr=R5iQ=Jog+w+qPE-uKrh5XQA@mail.gmail.com>
 <20120228164413.GA11021@kroah.com>
 <20120228165727.GO3683@opensource.wolfsonmicro.com>
 <20120228170246.GA11415@kroah.com>
 <20120228174505.GP3683@opensource.wolfsonmicro.com>
 <CAJ0PZbT=yD3SFBVYbcL37Dgyc3UVzk2LRQ_VWABW4cY_hfDuHA@mail.gmail.com>
 <20120229123511.GA7730@opensource.wolfsonmicro.com>
 <CAJ0PZbQVO-NMO_DxuSuY5xU3zXus=x+x3SFpXZEcA7n-CGX9Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
Content-Disposition: inline
In-Reply-To: <CAJ0PZbQVO-NMO_DxuSuY5xU3zXus=x+x3SFpXZEcA7n-CGX9Uw@mail.gmail.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 05, 2012 at 04:59:42PM +0900, MyungJoo Ham wrote:
> On Wed, Feb 29, 2012 at 9:35 PM, Mark Brown

> > For things like headphone detection the actual switch they're providing
> > has issues too even just within the switch API - it's called "h2w" with
> > magic values.

> Reading an H2W switch device driver
> (http://git.ziggy471.com/frankenstine.git/plain/arch/arm/mach-msm/htc_headset_mgr.c),
> I don't see why it won't be compatible after replacing the name from

That's not the only such driver, that's one example of a machine
specific accessory detection driver.  There's others out there such as
the sec_jack driver which you converted into the ADC driver in your
patches (if you look at how that gets deployed the overwhelming majority
of users are headsets).

The issue is the combination of the naming (h2w isn't very meaningful
and only works with a single jack) and the magic numbers used for
reporting state, plus the registration collisions.  Existing code can be
ported over fairly easily but it's got issues as an ABI which we'd want
to fix.

--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVKxFAAoJEBus8iNuMP3d0pEP/3hTWmyzSwmm0HeemBv+zD0A
YHZ/Oj3OVE9inLu1sF253hMRGOtLBpBHCbouw1HafM4VJ6f5RCpyY0DXyLCxKrlj
SXDPlz9bet5Pswm9GPD2pXL/B/tVJo2WPaYaSrRGc8DvQVg+MNUTLzDhrOTxtSpi
7u67LVz/V4NRh1Gpcis4XNI5GQtByO+DMPAbEA+jNWFPLYc9EA/O6rHff74SnfDr
49R3yrfxfJE/PB97c+OvYILe5qICDP6lYakoPG/lw4LdW1joZi61F27vtnzpWgHD
0P6EqEvc3JxgEovR6BAeAdFtbvExxAJw15CgWc5uGOJpFPSE+AJ9+VuGx789WNlx
RI9fxCzHPJiIEgv/fJUP02YleyuaffkQavzfv1JJVNfnPR5f2wwpoaZAzszcfPfs
IUagS3F6G68qeRh+4KJNxWCoHetweuL5ifZQcugbEhkvEhhco94n5bPuORpvZtk+
M7CF7P2MpnG+yl6q/dlhbyiXHn6/KPEtbr9NwKmTjzJLeIUq1+hEOXLz8K7h5uNs
AZMnWLdSUzvswhlsl++EscNBWJI38iGDU1ZwevtZxtloMxJVK1UigGXdlwBByFJF
T2RvsZcyTm3bW2CkfAB4/28gYDfMXu6MYkhi/yNIBckeU5RKmix1ggl4n87VJ4sl
5SHV6ORDlCMYZJj93mwU
=FvCj
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
