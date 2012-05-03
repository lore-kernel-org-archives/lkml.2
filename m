Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab2ECLiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 07:38:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53685 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510Ab2ECLiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 07:38:09 -0400
Date: Thu, 3 May 2012 12:38:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Johan Hovold <jhovold@gmail.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mfd: add LM3533 lighting-power core driver
Message-ID: <20120503113801.GE3955@opensource.wolfsonmicro.com>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-1-git-send-email-jhovold@gmail.com>
 <1336040799-18433-2-git-send-email-jhovold@gmail.com>
 <20120503103848.GB3955@opensource.wolfsonmicro.com>
 <20120503112803.GA15752@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tMbDGjvJuJijemkf"
Content-Disposition: inline
In-Reply-To: <20120503112803.GA15752@localhost>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tMbDGjvJuJijemkf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 03, 2012 at 01:28:03PM +0200, Johan Hovold wrote:
> On Thu, May 03, 2012 at 11:38:48AM +0100, Mark Brown wrote:

> > I'd expect you can drop these log messages, if there's stuff like this
> > missing we should add it to regmap.  At the minute the regmap logging is
> > via trace points rather than debug logs as you can leave them enabled
> > all the time.

> If such debugging is added to regmap we still need a way to enable them
> per driver (or rather regmap) to not clutter the logs.

This is one of the reasons why we currently use tracepoints (they just
don't have this issue as they're trivial to filter), though
adding some sort of infrastructure for it ought not to be too difficult
even if it's just at the regmap level.

> These three dev_dbg statements are extremely useful during debugging /
> development especially in combination with the other dynamic printks in
> these drivers.

> I'd actually prefer just keeping them for now.

OTOH the whole point in having stuff like this is to factor out repeated
code like this so if the infrastructure isn't working we should fix
that.

> > Might also be worth moving some of the sysfs stuff to live with the
> > relevant drivers.

> Which attributes do you have in mind?

Pretty much all of those on the MFD.

> The boost_freq and boost_ovp affect both backlight devices (i.e. cannot
> be set separately) and as such belong in the parent driver IMO.

> Same with the output_hvled{1..2}, output_lvled{1..5} attributes. The
> chip has four logical LEDs ("control banks") but five low-voltage output
> sinks. The five output_lvled attributes determine the mapping and as
> such belong in the parent driver. The two logical backlight devices can
> likewise be used to control either or both high-voltage outputs and
> belong in the parent driver for the same reasons.

Actually, the other question I had but forgot to ask (or I think punted
on for your response) was why these are in sysfs at all - things like
which things are connected to the backlight are going to be a property
of the board design so should be defined by the machine not tweaked from
userspace.

--tMbDGjvJuJijemkf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPom4FAAoJEBus8iNuMP3dyEMQAJhd3yheCCWE5nb02Xcs5/rw
rrHyGFO6fdwpxp+/j5Nq2/Kb0c5G19PhZo53n3gOBT/9mnsCFKiUyUGYY62KAY3s
z+vgDgXzsQaCs3LWM5aT2FhcDvw0STruiCkTRZON0/AZmKJoy5H7vw8ejnCxo5f8
2pxOPWZqtLq+gISJrZHUCC/9O0aCoG2chennx0+ZUkXK3sWj7lWeTtLzvHwCETCp
Pm1Iqxk6dVsm1zaqZyK1wbfUa6EnYsxK8PmTrJL2FQ9iC4/+8J21wlhVUge/9Mqn
JJ08HXtXX0uYF9p8tPOnCXI6JnsXe6yba/d+IFkHA1vtZ+dvHs/gXTVS6Rg0zSH3
1qgq/LF386JF6WLjZ/2J7ade/2QUe2+zcNz8fNC0+PXOMW3WKu2FXVxN8SHywjnc
qtQW6A8qSuQ1lcNn2XpfGDO3zGryDJgBPP41biJN0n0UBujQZrEHhCQ+7/UGmhtJ
7N/dNWifC8CSj1ITeAyr2JaYymh5Kfo7Qf5g2hlpaC1ksicnzxzWDjy8Z0MaGjsN
FEtJ+xq1x1DYcG5vzeio2HeZEgInm3OFhP1btMAJP4qMlWk4vqp/r20r6j36CEsi
ygk3URbDrxHIgw+QoZIzy9sk0KE5A8AG3/NSUfk2upY4HrObl/M/cV5h4uFScW1u
h4mUJsa7JIcX+z/InmBm
=KD1O
-----END PGP SIGNATURE-----

--tMbDGjvJuJijemkf--
