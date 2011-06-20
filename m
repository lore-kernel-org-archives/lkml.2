Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1FTPgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:36:53 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56319 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383Ab1FTPgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:36:52 -0400
Date: Mon, 20 Jun 2011 18:36:47 +0300
From: Felipe Balbi <balbi@ti.com>
To: Skacore Systems <skacore.systems@gmail.com>
Cc: balbi@ti.com, Alan Stern <stern@rowland.harvard.edu>,
        Viliam Mateicka <viliam.mateicka@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
Message-ID: <20110620153645.GQ14262@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
 <Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
 <20110620151522.GN14262@legolas.emea.dhcp.ti.com>
 <BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aTHdXM4WpLndGb15"
Content-Disposition: inline
In-Reply-To: <BANLkTi=5S6bWs3jr9hTsg2=LXh4xKAprUA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aTHdXM4WpLndGb15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 20, 2011 at 05:20:02PM +0200, Skacore Systems wrote:
> I've been exactly following
> http://www.kernel.org/doc/Documentation/SubmittingPatches:
>=20
> To create a patch for a single file, it is often sufficient to do:
>=20
> 	SRCTREE=3D linux-2.6
> 	MYFILE=3D  drivers/net/mydriver.c
>=20
> 	cd $SRCTREE
> 	cp $MYFILE $MYFILE.orig
> 	vi $MYFILE	# make your change
> 	cd ..
> 	diff -up $SRCTREE/$MYFILE{.orig,} > /tmp/patch
>=20
> And that's what I've done. What do you think is wrong with it ???

patch should be in 'p1' format to start with, not 'p0'!!

Your commit log shouldn't include your "regards" or anything like that,
or that will go into the git history.

> Subject: [PATCH] s3c2410_udc: fix custom UDC command handling

this should be something like:

[PATCH] usb: gadget: s3c2410_udc: fix custom UDC command handling

we generally put the subsystem on the subject to help maintainers
filter patches related to them.

> There is a bug in Samsung's UDC driver, which is completely disabling
> the USB device when a custom UDC command is used.
> Following patch seems to get the right?behavior (e.g. enabling pull-up
> instead of disabling then Vcc is applied).

"seems to get the right behavior" makes me wonder if you really tested
this properly. Either it fixes the problem, or it doesn't. Have you
tried with other possible commands to see if also helps ?

> Also I'm not in mailing list so please CC me.

this would go to commit log, shouldn't be here.

> Greetingz,
> Vilo

this shouldn't be here either.

> Signed-off-by: Viliam Mateicka <viliam.mateicka@gmail.com>

there should be a tear line here. (---)

> --- drivers/usb/gadget/s3c2410_udc.c.orig ? ? ? 2011-05-19
> 06:06:34.000000000 +0200

this line break is bogus.

you could have looked at any mailing list archive for properly formatted
patches, but instead you chose to be unpolite with the persons who are
giving you a "service" free of charge.

At [1] you can find an example of a proper patch

[1] http://marc.info/?l=3Dlinux-usb&m=3D130833192703040&w=3D2

--=20
balbi

--aTHdXM4WpLndGb15
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/2kNAAoJEAv8Txj19kN1uboH/R+zIrHB4oPI+/oSvR8fyhIS
+oFasydiCaxKJ0EpWK9NOLtPMz+KDfYxANgqfjyXIopGQah8XOw+QkBMqQS6SeRr
w3wEzI6QpzRql/kDraQLntJUpsTHKnlUMVhjyOWLPO64yUf7QLV9vcl0acY9aivZ
X2TzzatELfLX/yRPSZpPOn8Rl6Cl+MCqDOSyUs/YN98yjYP2u57Flxrk+mzXwwQe
KGSGgby3umMeYvCUrvuG/n8svhsM087Dn3LlCLzKYBoifnku4LtWJQbJo4SKGAg7
0O7i08suHr74GJFA89whiNMuoJcURM05U46WgfZVTVe93HdREgZWuxNN6XJpEnw=
=YYd+
-----END PGP SIGNATURE-----

--aTHdXM4WpLndGb15--
