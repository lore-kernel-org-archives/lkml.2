Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2ECVos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:44:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56988 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2ECVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:44:47 -0400
Date: Thu, 3 May 2012 16:44:39 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, dustin.kirkland@gazzang.com,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ecryptfs@vger.kernel.org
Subject: Re: ecryptfs: Kernel BUG when closing device
Message-ID: <20120503214439.GC16993@boyd>
References: <1336024803.10945.5.camel@lappy>
 <20120503161736.GA16993@boyd>
 <CA+1xoqeVHH_8MezKFX=gB9o5zFMjajHAVai3SxGpzZpvQ5uUHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AkbCVLjbJ9qUtAXD"
Content-Disposition: inline
In-Reply-To: <CA+1xoqeVHH_8MezKFX=gB9o5zFMjajHAVai3SxGpzZpvQ5uUHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AkbCVLjbJ9qUtAXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-05-03 18:22:01, Sasha Levin wrote:
> On Thu, May 3, 2012 at 6:17 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> > On 2012-05-03 08:00:03, Sasha Levin wrote:
> >> Hi all,
> >>
> >> After some fuzzing using trinity inside a KVM guest, I've stumbled on =
the following:
> >
> > Hi Sasha - Thanks for reporting this issue. Is there any way to get
> > trinity to reproduce this fuzzing sequence?
>=20
> Hi Tyler,
>=20
> Not really, since it's not the result of a single command it can't
> recreate it easily.
>=20
> On the other hand, I'd be happy to add any debugging ideas you have
> into the tested kernel and attempt to recreate the issue.

I appreciate the offer, but I was able to reproduce the issue pretty
easily. Inherited and passed file descriptors of /dev/ecryptfs are not
handled properly. I've opened this bug to track the resolution:

https://launchpad.net/bugs/994247

Tyler

--AkbCVLjbJ9qUtAXD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPovxHAAoJENaSAD2qAscKR1EP/js/9xWND/LzZkF9cLnSzN8v
3nZsBUnmrTNlKAHfQFd3xhbeWWU3KDUYdAU7pLyx8sfAzOU6FnmT5Wp0Eqt0zNB6
BCznytieVpyCLsk5EwLTwhCFN9ZgmOfb03u0e4K1H69jGWYWMLa65lz81h8StH+w
s3MuSFeQ54rD4YeWxrJ82NWlrw2POt24sP8+nlTonKec7hdW108YWLp/PY0Rqinp
KDckw/UOjUP2mwwE5BpeOCxg8Qd3V9IEAQoUzkgQ0DLhSa9nknT53cF1DSyfCxGn
E0vrv2PPeYChK/RSiPmcsuvpjjsUaWZqK3uksBT/iMCktmRnBuTIuHssNDv5yQoF
XgDWDYRUaW8HbbzUfW6JZQq9+eMZRo4eRZGecAmtAxMoPTZ7lntffp1B3hWH36by
JIHICZGaO5VyXkU4R8juFpDpXogHAFIGWn5HIZAISbqQkdgUcNu8NBcu6DTqLQw2
En1kvA65zt22m/dcpBXaOHmzuGl2CWMrr4ctFM9vZjk33z4xipVTsNpwNt8Xrj/u
xi0yK5pVU00yNLZh0cT89LqVVitBBR0holP8ySe7cwlUtQSZy9yMf2rbaanfmKdj
RHwKGN1dclFfUN6VwjkF4sb1GHF2KY3aHaIMrcQe/SVV1OKKcOVlIZcBvWzFDE7R
IPyLu5GrogiNjIF1kt5J
=ENfT
-----END PGP SIGNATURE-----

--AkbCVLjbJ9qUtAXD--
