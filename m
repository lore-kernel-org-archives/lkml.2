Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2IFMeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 08:34:19 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:49385 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752182Ab2IFMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 08:34:13 -0400
Date: Thu, 6 Sep 2012 15:29:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Felipe Balbi <balbi@ti.com>, alan@linux.intel.com,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>
Subject: Re: [PATCH v3 03/23] serial: omap: don't access the platform_device
Message-ID: <20120906122948.GC29202@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345717983-18179-1-git-send-email-balbi@ti.com>
 <1345717983-18179-4-git-send-email-balbi@ti.com>
 <20120905202721.GA2430@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <20120905202721.GA2430@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05, 2012 at 01:27:21PM -0700, Greg KH wrote:
> On Thu, Aug 23, 2012 at 01:32:43PM +0300, Felipe Balbi wrote:
> > The driver doesn't need to know about its platform_device.
> >=20
> > Everything the driver needs can be done through the
> > struct device pointer. In case we need to use the
> > OMAP-specific PM function pointers, those can make
> > sure to find the device's platform_device pointer
> > so they can find the struct omap_device through
> > pdev->archdata field.
> >=20
> > Tested-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> > Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > Acked-by: Tony Lindgren <tony@atomide.com>
>=20
> This series fails when applying to my tty-next branch at this patch :(
>=20
> Care to refresh it, and resend it, with Tony's acks added, so I can
> apply it?  Note, I've already applied the first two.

Sure, will do and reply to this mail with the new series. Thanks

--=20
balbi

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSJc8AAoJEIaOsuA1yqRE7ZMP/0NG31jOh4NwF5d7nK2xxMWg
fdYD4T68uGW2hLjGFqeqxTJUIo98+q45jcc0ZyC5mGRb1Tq4k5CWaB7DiL5b2UfQ
eGfR6cb7fMzKIMhQ+I07HOQW5uBQxO5Cv3cQvDfwUqiduEpZJoU3MGlzsAQXZxev
/AWYhXmUonhm83Bt0SoO+0oa0Yp4+BFEh4bEN5exPocwH16Zkv3A8c1UNH0qaBmE
wbG0EzK8NORqx+v43uIfrDdQMN/ZYXXikqnjkJUnXkL/t7h+qpTPejiLYjm8EkKW
BjsByPezjOXGrx+7dnJ83YV5gQQfLk2nNuSqP36ZyVCpzHP4/UW2pz8jEcLks/mW
6zU02DKR7HbuYNhMgjb3mLUSg57Ry2PcY3kgFLTU/XcF0hueVD4arLq8uue1dljW
ymHFUvV+7SBppvfRmd5WSU9/s+ipslmZqO2AQt+DuEB3HlB3QLx+l2bN3fm0tHLt
YW6Tne4Dj6hx02d4JEaqWPYhwIoV61Un5eyRFdKB8JCWnHMJ+qKXKvmEJe1TH3JD
KZOw/RmqcKOLhvxIRGu5HOcXp4vXD9WVzKDEETrWo5X3wB+XBQ2vm+whW6jPrgVA
imjqJbmxjcwguGPPCslNR/WERVuczfJE+oTbQWi8iqnSm2p6g2Qss95LSBguxpoa
ho9wCqVTW4zl9PAc2WMZ
=s6jI
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
