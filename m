Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2DZPst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:48:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35861 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729Ab2DZPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:48:48 -0400
Date: Thu, 26 Apr 2012 16:48:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Nychis <gnychis@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: what determines how firmware is loaded? (Q. on request_firmware
 details)
Message-ID: <20120426154844.GL3207@opensource.wolfsonmicro.com>
References: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
 <20120423212144.GA3378@kroah.com>
 <CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
 <20120423225603.GA23276@kroah.com>
 <20120426152310.GB26692@sirena.org.uk>
 <20120426152742.GB15674@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j3olVFx0FsM75XyV"
Content-Disposition: inline
In-Reply-To: <20120426152742.GB15674@kroah.com>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j3olVFx0FsM75XyV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 26, 2012 at 08:27:42AM -0700, Greg KH wrote:
> On Thu, Apr 26, 2012 at 04:23:10PM +0100, Mark Brown wrote:

> > Unfortunately 3.0 is what ICS is based off so the overwhelming majority
> > of vendor code is going to be based on it until the next Android
> > release.  With my vendor hat on I have to say that we find our upstream
> > first policy extremely effective so we shouldn't be part of the issue.

> That's great, and understandable, but the original poster said they were
> using an old Ubuntu release, and the ability for the community to
> support bugs in older kernel releases like this is very difficult as you
> well know.

Oh, I missed that bit of the thread - if they're using a desktop distro=20
then upgrading should be much less painful than it would be with a
typical vendor kernel.

> The next Android release should be "any day now" so hopefully we move on
> from 3.0 soon...

Well, by the end of the summer or something - even when the release
drops there's always lag while the releases propagate out to the wider
market.

--j3olVFx0FsM75XyV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmW4fAAoJEBus8iNuMP3diJYP/0Vl4uoxedvF/YmRPzEvgy5C
Gam1o3cJVPiiVkM40D4zCvx/iwKINTTJRY/ZvwkumU0CLbh0QNMTpMMbxI2wewDV
2dBUo+VxcPSwyUTayo3WWt79bmnsmS1DhxfK8iI+nFzWeHhZkA0XjUZSNvBmHo2R
Gvry/GtyIDqlrWanTh93gr7gfNsQkSOq3OsiPJhhwZVjfjxwUDEK26ltlrnT70NY
L63/8yVVLSEyKTKRZt2zMfoA20dXz5X2x5CeDx8HJZ8QNfBrIYuPds1yQlQgt117
3aK/BcU4tpluPjFvvWCXEoWWAjVyNwWu5dBZNVv9d4AmxVbjsEWh6uf8xvHRh/uq
PKQ62YJTU3KcLOO895pt2a0rlLxZ2UJwpN6e+FpChwHB44TnCaycHwXfYyhOV8hF
xrg6AVg1/5ipng4lpR2iFsAgO8Q9Io70PIFgpEVKJxQ+ZLkBI6137qZZd4G7TeN+
rIFFkIeYhORnkoBgnBWv4zD0vuC08b7s7l2t3nIcYFZgj0Nn3gNZKgMwYjntF7lh
A7DVVeFpmyuNQhNfKUQcXquR/4aU1iQ7UDLIkVmEp49gNeetF2XJfXha+GRhoL0Y
FxWHY1UJtlms1lxRxzzKjCaluYR8Yz2jiQoNLzOGVruwTI7H37ptRLtHZ1XiCbbo
zmm4shx9v1I8IebCV3hB
=kFV/
-----END PGP SIGNATURE-----

--j3olVFx0FsM75XyV--
