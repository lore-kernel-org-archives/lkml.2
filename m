Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2BBOx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:53:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48203 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2BBOxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:53:55 -0500
Date: Thu, 2 Feb 2012 15:53:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rtc-linux] Re: [PATCH v3] rtc: ds1307: generalise ram size
 and offset
Message-ID: <20120202145353.GC9648@pengutronix.de>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
 <20120111110650.GC2605@pengutronix.de>
 <1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
 <20120119194541.GA32483@pengutronix.de>
 <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Content-Disposition: inline
In-Reply-To: <1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Austin,

> I'm sorry about the slow response - I was away at linux.conf.au and then
> haven't found enough time since I got back.=20

Don't worry, I understand.

> > ... that nvram is static and we are changing it. Yeah, it is very unlik=
ely but
> > if we have two RTC with different nvram sizes, one of them will not wor=
k correctly.
> I see the issue. Am I right that it would only occur when you have two
> I2C buses, each with one of the RTC chips supported by this driver?

Basically yes. They could be on one bus, though, using different addresses.

> The fix I thought of would be to add a 'struct bin_attribute' pointer to
> 'struct ds1307' and then in the probe function allocate the structure,
> set the size & callbacks, and pass it as an argument to
> sysfs_create_bin_file. Do you think this is viable?=20

Yes.

> It looks like Andrew Morton has already added this patch to the -mm
> tree. Has he also grabbed the patches that this depends on?

I will check that and mail him later today.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8qo4EACgkQD27XaX1/VRuueACfWhnJs4RbS+fAIowCA5TewxkE
J3sAniRogPY2SRVAhAWP4dg3rYuyhZUi
=z70c
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
