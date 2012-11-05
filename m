Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2KELNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:13:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52787 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157Ab2KELNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:13:53 -0500
Date: Mon, 5 Nov 2012 12:13:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rafael.j.wysocki@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105111349.GF1385@opensource.wolfsonmicro.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <1351928793-14375-3-git-send-email-mika.westerberg@linux.intel.com>
 <20121105105455.GD1385@opensource.wolfsonmicro.com>
 <20121105110322.GD24532@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CGDBiGfvSTbxKZlW"
Content-Disposition: inline
In-Reply-To: <20121105110322.GD24532@intel.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CGDBiGfvSTbxKZlW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 01:03:22PM +0200, Mika Westerberg wrote:
> On Mon, Nov 05, 2012 at 11:54:55AM +0100, Mark Brown wrote:
> > On Sat, Nov 03, 2012 at 09:46:32AM +0200, Mika Westerberg wrote:

> > > +	strlcpy(spi->modalias, acpi_device_hid(adev), sizeof(spi->modalias));
> > > +	if (info.gsi >= 0)
> > > +		spi->irq = acpi_register_gsi(&adev->dev, info.gsi,
> > > +					     info.triggering, info.polarity);
> > > +	request_module(spi->modalias);

> > request_module()?  Why?

> The DT code does the same. I have no idea why it is there, really :-)

> I can remove it in the next version if you think it is not needed.

Well, if you can't identify what it does...

--CGDBiGfvSTbxKZlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQl59TAAoJELSic+t+oim9KJUQAI72B4SNWPOUKXNQuRFg3jaS
e1h+nXga9WzvxCkEY9LEqrmk2AmY4xrLlmk+NfL1UwwvabK5C+tQjrs/eICy6t10
H/biQViVZITzlA8PWgiEHIpseQi/4PKqxlAIqFH9RqBjEDUUhVvDwcbVXP+a9JHX
80qpEg7dTS4EHjhfjdPNMt9fK2bCcRNXuL0BZl5ywhzgWU+qbFyywoVpsDTubava
Z01hmsxAJcPCgb9JSnbKuiEEkcWkpE7Br35ev2VmwNo8cswBqYOjzjvTdKMe/Wq1
AzGJYKacvqwJZPY5jOZozihWgRezwNqT4pFtXvc2l7TzmjlCpIVRBH9Z3E7ospi5
rNu8CInZBQBVBjJvinazaJ6G/i/iP6iFmiGjyVrW8LS8fuwXuDhySW2HhooOoTr4
lu3L4ZgivMzSO/AaXNsh5qjO/RGY0PIfh5+7oRd360+T/f5ckcT6uHrMsDa77Jlg
fae5WQIlMlnuIjxM84vArnGLhIj9Ba3cAnchoDxtFPsrys9/tWnXQNGVf8z82dUG
UZYu2PD8+E/mMGpwYvDCgkbyELg3VCacXfJQqO1e+JS5xFTvlSfIpIZ0dFxhnHv2
iCKdzDnBOo57CAXsmg2IkH/pgsDq5q8GAQzkDw8EMrZf+R2u0O3q8o/PxiIafKNT
dCETI2OLLYey+7dwbl55
=7QEe
-----END PGP SIGNATURE-----

--CGDBiGfvSTbxKZlW--
