Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0GMKa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:30:28 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:49114 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0GMKa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:30:26 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: stable? quality assurance?
Date: Tue, 13 Jul 2010 12:30:06 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.6-tp42-toi-3.1.1.1-04982-g768d8a0; KDE/4.4.4; i686; ; )
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <201007110918.42120.Martin@lichtvoll.de> <201007122156.21725.Martin@lichtvoll.de> <4C3B9F56.5090806@s5r6.in-berlin.de> (sfid-20100713_090918_008550_637007C3)
In-Reply-To: <4C3B9F56.5090806@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart11525793.IYDpyIf8R0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007131230.23039.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart11525793.IYDpyIf8R0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 13 Juli 2010 schrieb Stefan Richter:
> ...
>=20
> > Is the Linux kernel development really in balance with feature work
> > and  stabilization work? Currently at least from my personal
> > perception it is not. Development goes that fast - can you all cope
> > with that speed? Maybe its just time to slow it down a bit?
>=20
> If those who added the regressions are found out and asked to debug and
> fix them, the balance should be corrected and perhaps more precautions
> being taken in the future.  Alas, finding the point in history at which
> the kernel regressed might take a lot more time than to actually fix it
> then.  In that case, maybe give the author of the bug an estimate of
> the volunteered hours that were spent on reporting this bug, to put
> the repercussions into it into perspective.  OTOH I suspect a lack of
> responsibility at the developers is not so much an issue here, more so
> that the number of people who take the time for -rc tests (not to
> mention linux-next tests) and to file reports is rather low.  Plus, a
> good bug report often requires experience or good intuition, besides
> patience and rigor.
>=20
> There were discussions in the past on how more enthusiasts who are
> willing and able to test prereleases could be attracted.  But maybe
> (just maybe) there are more ways in which the developers themselves
> could perform more extensive/ more systematic tests.

Well I reported it now, although it contains not nearly as much=20
information on how to reproduce it or any other debug information either.=20
I just did not report it before cause I didn't find the information I can=20
provide very helpful and until yesterday I thought it might just have been=
=20
these two freezes and thats it. But maybe report it early is better than=20
not to report it at all.
=20
Bug 16376 -  random - possibly Radeon DRM KMS related - freezes
https://bugzilla.kernel.org/show_bug.cgi?id=3D16376

I will look in the logs whether I might have luck and find anything this=20
afternoon when my students learn vi/vim, but I doubt it.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart11525793.IYDpyIf8R0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw8QC8ACgkQmRvqrKWZhMdWkACeNihteUmziFjpAo88yPvghR1I
yxsAnjNhMrj5Ka5pk1jGkYg5aAGX7SK6
=fYBc
-----END PGP SIGNATURE-----

--nextPart11525793.IYDpyIf8R0--
