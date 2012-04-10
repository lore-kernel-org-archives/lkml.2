Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab2DJWh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 18:37:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56457 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072Ab2DJWh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 18:37:27 -0400
Date: Tue, 10 Apr 2012 23:37:23 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: Re: [PATCH RESEND] x86, intel_mid: ADC management
Message-ID: <20120410223722.GY7499@opensource.wolfsonmicro.com>
References: <20120410131206.GB31551@sirena.org.uk>
 <20120410142501.6045c6c0@pyramind.ukuu.org.uk>
 <20120410133339.GK7499@opensource.wolfsonmicro.com>
 <20120410144235.1e05efd4@pyramind.ukuu.org.uk>
 <20120410140749.GL7499@opensource.wolfsonmicro.com>
 <20120410151529.5bcc5ce6@pyramind.ukuu.org.uk>
 <20120410151943.GM7499@opensource.wolfsonmicro.com>
 <20120410175632.5c11c36e@pyramind.ukuu.org.uk>
 <20120410175846.GQ7499@opensource.wolfsonmicro.com>
 <4F848C7C.5040703@cam.ac.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dnBRaVjvtun1Q0Od"
Content-Disposition: inline
In-Reply-To: <4F848C7C.5040703@cam.ac.uk>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dnBRaVjvtun1Q0Od
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 08:39:40PM +0100, Jonathan Cameron wrote:

> 1)  Review of code.  This is crucial. If people have a little time
> ripping holes in the core IIO code is what we need.  Arnd did a good job
> of this a while back. Others have done bits of it since.

> 2) Getting the push code tidied up and pushed out.  I'll post it as an
> updated rfc to linux-iio shortly.  All I had left that definitely
> wanted doing here was cleaning up the example iio to input bridge
> driver.  That can happen later.

For these two can we refactor in place?  That's pretty much what seems
to have been happening anyway...

> * Event passing to consumers else where in the kernel. Right now an
> input driver can readings from a sensor, but there is no way of
> requesting threshold interrupts.

> * Interaction between consumer drivers (e.g. hwmon or input) where some
> are requesting data by polling when they want it and others want a

These sound like something that can be added incrementally?

> > If the code was moved out of staging today what would go wrong?

> Churn in interfaces is probably about it.  Maybe a good use of any time

I guess the big question is then if we can live with that.

> would be for people to take their non IIO drivers that they think might
> fit (or data sheets!) and see whether there are things that they would
> like to be different.

In tree there's a few auxadc and comparator drivers in drivers/mfd, plus
things like arch/arm/plat-samsung/adc.c in the arch direcories.  These
are all broadly similar to the at91 code that's been sent to IIO
already.  There's also the code Alan posted at the top of this thread.

--dnBRaVjvtun1Q0Od
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhLYcAAoJEBus8iNuMP3d7w4QAJ44UPclEpAB6lkA2Ak1X1Lp
7G/e5M8lKAhMos3LTr5l9EJEu/owCcKuvEroCZUpRJms6nGukJ/eWH14gnjSZPEU
WK6+WRDcTngGG1O+evDBoHqtGv6nCHZyLg7IUHw0BzPm0C7SY3Zj+eB5o0syo6iC
aLhKtGP/orsccDTd+SKlZgLQccM4jvbMBaR1xMbl0L81eoP9h4XbY7i1Sfj3xgDe
sfwrpW551aJMaGrOQ0aqv2wA3BPAAUdqr63e2broya30Vrr/pj6HvvY75qw5rTsI
WxKK/pAvFupkrMYGei9j546cWT+g0qV/KRxdz0qEVJ/OIes+lPeFV+ghwuL72+q5
swzQ/RHb9kzn66YhPwlUSnbiw/2bWv3uLVHZ1mtP/RzlhOP5HNGFstM6WzTNIN2x
IxSrvN3AzPn7nGRgxijIT+pCPh3BO/L9d+w4YjRXlukm72PPfAGYEG0pYixVtUmm
qgBZdfTk6k7USqczrxnSX/RVMK8brlRB1WPF8Y9lVHKNbaM2vdowQA5+QHfwE+56
/XIKIYxYxIYeB+rMVJMpJxq/O9+xdlgQM/HM5a4FbU6ub8KZpOYYU5MZhJPi+Mvz
1Iw+ghgacViGueSRKMwvGArBZrjHXrGOuD/JbJmWj8SduCAOo7O5vXhVkdqOTMnW
5gKYj7eAYxWXIhkSoQk0
=bHmv
-----END PGP SIGNATURE-----

--dnBRaVjvtun1Q0Od--
