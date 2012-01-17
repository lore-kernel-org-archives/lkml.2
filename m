Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2AQIdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:33:15 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49119 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab2AQIdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:33:13 -0500
Date: Tue, 17 Jan 2012 11:33:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Herrmann <dh.herrmann@googlemail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [29/48] HID: wiimote: Select INPUT_FF_MEMLESS
Message-ID: <20120117083347.GA10171@mwanda>
References: <20120116184527.GA11972@kroah.com>
 <20120116184518.205969311@clark.kroah.org>
 <CAP=VYLqajuhNY1S3e7Nbw4DiyEDL1uGthC8VswJ9zJxzwy+wOQ@mail.gmail.com>
 <CANq1E4SmBNHnbs9EXoUUTzNf3QuHaLWfcFBO3cLmnOymMzsuQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <CANq1E4SmBNHnbs9EXoUUTzNf3QuHaLWfcFBO3cLmnOymMzsuQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F153236.00BB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 17, 2012 at 07:37:27AM +0100, David Herrmann wrote:
> On Tue, Jan 17, 2012 at 2:55 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > On Mon, Jan 16, 2012 at 1:44 PM, Greg KH <gregkh@suse.de> wrote:
> >> 3.1-stable review patch. =A0If anyone has any objections, please let m=
e know.
> >
> > This one looks like typical patch Makefile/Kconfig "oh, hey this fits a=
nywhere"
> > nonsense, and is completely broken. =A0Original was for a Wiimote, not =
Wacom.
> >
>=20
> Could someone explain to me where this came from? I cannot remember
> writing this patch. I wrote this one:
> http://git.kernel.org/?p=3Dlinux/kernel/git/jikos/hid.git;a=3Dcommitdiff;=
h=3Def6f41157f3864d9bf42671b2ed66062dcafb72e
>=20
> I don't know where you got this "From" line?

The patch command creates it automatically.

Get a copy of linux-3.1.y
git show ef6f41157f38 | patch -p1
git diff

There is the new patch.

regards,
dan carpenter


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPFTJrAAoJEOnZkXI/YHqRQscP/AiczSK80FHuhaHojykLJKw1
kS0SLWYjhHNfvYqyKROwa1/HME4gPWgv0OD9VNx111MpAlq4wjp+SAtIuJh3JhXx
NGVeUuoO91Bx8Gx+RS4wL7TK3L+5PItYaA3bPG4pKtXrJ9fOjhK9PFts6Ulgcmy0
9WmHUsLDA+0dIrN0crTxFU0iq4QQknzYtc4IlFE8EFTKdO6xe2xFkLdp4pRZTOlK
VaPDbdAZN99kPIAns7vclNoWTVDCHUrAMbXwF6MUnD0aCy0AabSsw8FDZg9lpX3K
5Q3X2wPTvew16zgYJhBeUwu51DBvpWVfB78WWIfqZ4DsKx9C6oRsRQzxyRALRNfd
wNknp/ZzA6nCxKuf7nn9pLHEOjygMW/eYwMeDvdwWBgcINnrn2CyyEBSo6sCz0GF
IcD3eGG0Im8Hj9dP/YvKAxOelmqP8tgu0n3wYnLx6UnwVK5RXa9fziPCybJGHOw7
FvqPhLgE5Ff1sDbT+Ij0XdOyImSBWsehYw2mCb5jUcjdSwCGGvqILXaHtEl/BT5c
TuIB/N3eLb6ykDmeVAmb82mGduLR4GQFS7dsh8IBRGNvf0+ymY5X+GBmKCVSmiqM
v+Hhs6lj1j09gMoQduD9W7vZm3FnYohx85k8yUyHiyc2Qa8rbezICxgOHeUUEvN6
EDwyfs1f/0KrPfoeWNRG
=9I9z
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
