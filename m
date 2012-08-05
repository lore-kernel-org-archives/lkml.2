Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2HEW0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 18:26:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972Ab2HEW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 18:26:21 -0400
Message-ID: <1344205565.13142.46.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 00/73] 3.2.25-stable review
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Date: Sun, 05 Aug 2012 23:26:05 +0100
In-Reply-To: <1343825716.27983.84.camel@gandalf.stny.rr.com>
References: <20120731044310.013763753@decadent.org.uk>
	 <1343825716.27983.84.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VLgkn0SQrbZgE2SqEdhX"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VLgkn0SQrbZgE2SqEdhX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-08-01 at 08:55 -0400, Steven Rostedt wrote:
> On Tue, 2012-07-31 at 05:43 +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.25 release.
> > There are 73 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Thu Aug  2 10:00:00 UTC 2012.
> > Anything received after that time might be too late.
> >=20
> > A combined patch relative to 3.2.24 will be posted as an additional
> > response to this, and the diffstat can be found below.
>=20
> I tested this against configs I normally test against my own code, and I
> hit this bug:
[...]
> I then checked against 3.2.24 and it bugged too, as well as vanilla 3.2.
> I then checked against 3.3 and it did not bug. I kicked off a 'reverse'
> bisect with ktest (bad is good and good is bad) and found the fix:
>=20
> commit 3f9a5aabd0a9fe0e0cd308506f48963d79169aa7
> Author: Vivek Goyal <vgoyal@redhat.com>
> floppy: Cleanup disk->queue before caling put_disk() if add_disk() was ne=
ver called
>=20
> I applied it against v3.2.24 and it solved the bug. I did not apply it
> against 25-rc1, but I'm pretty sure it should work for that too.
>=20
> I haven't checked 3.0 if that has an issue with my config.
>=20
> Anyway, please apply this patch to stable 3.2. Either for 25 or for 26.
[...]

Added to the queue for 3.2; it will go into 3.2.27-rc1 now.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-VLgkn0SQrbZgE2SqEdhX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUB7y/ee/yOyVhhEJAQp31g//Z0XaGzfJ6hI7Wjze+fPBNGkNhjXCEQ46
rS3FtDoMSooC42pbQgEzuRQ7XrVcUifltt6xa47uuRFwM4Ff/gH0MUYC1HSDGBv9
3sIDx4IwlBNNkXtH8jluwuNrgaiYFwj1n8Xn39mxdQICcFFim7Qrp7haGpdRqEnr
CR6eTpub2EFT8rrkcxITnutN2fUzS3/tEpISlpZBwAt+7xPRLHI/tmfLDZOSNDbE
dT2rvtzTL7X7B8rO10C2rxtxCR8iR0TxQp1GUDW1M6Y/9BG7AO+k59sdx+YauSzf
auU+/KNSvXh7ffrQutbyFyNJ3OVmq2BfHtGzpRXpneLSx9kmh3ZZmR7fVRfOno2s
+mSi+zu+l3dcLU9LZD+IGpzGEBJmfE9H5U8UXyE5kp6lHapzr9/jVilT0DgEUU2M
xhcUTO1EKUWgdlI7BP5gH96AYnR0Y0yUGPhmd0s6J+XnoJalVFyPaWkHQRf34YcQ
ionFx3UMwf5i4FKQMMSjUFjQkseUXYUHWjMxP6ZQqANyqQRc9q4Gtkb290+r2ULh
ZLrgbauQRJ78wbyxv4wA9M5C1rqu/giMo7BCuNUTi0tgkkCi377tG8gqrCepeAc0
Mt4d8v0AT/GgaRI4JZ/igz7+mxtnGRRs9+Rbq/PNElscdID0uW08zqXsCHpfZNRR
86LOR3bTiAA=
=V6Kk
-----END PGP SIGNATURE-----

--=-VLgkn0SQrbZgE2SqEdhX--
