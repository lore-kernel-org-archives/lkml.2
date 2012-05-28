Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2E1LWP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 07:22:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55865 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754095Ab2E1LWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 07:22:12 -0400
Message-ID: <1338204120.20487.160.camel@deadeye>
Subject: Re: [ 002/117] KVM: Ensure all vcpus are consistent with in-kernel
 irqchip settings
From: Ben Hutchings <ben@decadent.org.uk>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, Michael Ellerman <michael@ellerman.id.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 28 May 2012 12:22:00 +0100
In-Reply-To: <20120528041917.GB4873@burratino>
References: <20120528031202.829379252@decadent.org.uk>
	 <20120528031203.152711779@decadent.org.uk>
	 <20120528041917.GB4873@burratino>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-C5dtbcj/4dh3hDtUw16N"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C5dtbcj/4dh3hDtUw16N
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-27 at 23:19 -0500, Jonathan Nieder wrote:
> Ben Hutchings wrote:
>=20
> > From: Marcelo Tosatti <mtosatti@redhat.com>
> >
> > From: Avi Kivity <avi@redhat.com>
>=20
> From Marcelo or Avi?  (Based on [1] it looks like it is by Avi.
> Maybe some script took the extra "From:" from the email header.)
>=20
> Thanks,
> Jonathan
>=20
> [1] http://www.mail-archive.com/stable@vger.kernel.org/msg07852.html

I'll fix up the attribution before applying these in git.

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-C5dtbcj/4dh3hDtUw16N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT8Nf2Oe/yOyVhhEJAQrc7w//agfTgtmIuVQQIinE6x6SYW4kgJVlm9K+
M7aBk5v9+AAMMqkRtIcQS5G/YMQmZ5wR4Ccfoy17BTVSkAgrF5FmIEFX772Cw1xu
aExMVW6L88oCQwGjSvAsDg5iDYGBWk25QpGIpFDXDQC4BLWnWV+StW6sm2W3qXN9
LmPQ8/b+3bupxI0oqYCBBUCtiWT24CG4qIhAwXCTP8R1+2nvOE9U2ZjmnqR+Xipl
RxBM+imPPraLOD4gxA9zK+4WXrbGLKeibL/SWaW23RKM0R+4yxKBqxyQ5GxctFz3
amtyYu+JovLBWf3E2W6BGt0gewKQW2yedZbEvtttsw6vjOvmRGFgaQbqA+nh6GQW
XT75d94CrHF76RdjdiQhzGT0mFY5HG3P0X/XFeDDiDMJYBOhzUNQyNe6J0VPQnme
5kMUJ8goOI9AU5pEmxAzCSxPu2nA5PpZnozT22CANaP/3iKEUl5zA+H5cVux/3hl
rq/QTA/7ks/pl+AoV2ufqmk8cnW/1CSd8O4vucPkGLE9CFm/KwKQ2wadElwousS0
F6hJUzYZk7qh3JFsAqQvqM1LtUun/sEM4BIk+ck/QtlTIEpWKRU7NQehmbjDdN7t
3a4BskLI1JVTEgluAQBBfCBTIURGmRap6UpFU8zVdF9RNJtiBfQ1otZgnmbmYLyw
wFsQGVRO5Qk=
=bHl8
-----END PGP SIGNATURE-----

--=-C5dtbcj/4dh3hDtUw16N--
