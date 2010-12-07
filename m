Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0LGVEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:04:40 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55701 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab0LGVEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:04:39 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: bugs/regressions: report in LKML or in bugzilla?
Date: Tue, 7 Dec 2010 22:04:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-tp42; KDE/4.5.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201012071639.58884.Martin@lichtvoll.de> <20101207094121.364745f9.randy.dunlap@oracle.com> (sfid-20101207_215900_655285_99A34680)
In-Reply-To: <20101207094121.364745f9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1716930.CzPIuY4uGz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012072204.36581.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1716930.CzPIuY4uGz
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 07 Dezember 2010 schrieb Randy Dunlap:
> On Tue, 7 Dec 2010 16:39:46 +0100 Martin Steigerwald wrote:
[...]
> > I reported some regressions to bugzilla that did not receive any
> > attentation so far:
> >=20
> > [Bug 23792] New: openvpn: failure to unregister tap1 device, possibly
> > related to some netconsole issue
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D23792
> >=20
> > [Bug 23642] New: easycap driver fails to compile in 2.6.37-rc3
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D23642
>=20
> That one has received attention.  I commented on it and I have posted
> a patch that fixes that particular build problem.

Sorry, I somehow missed that reply. Thanks.

> > A participant of a linux performance training I hold found a bug with
> > window scaling which did not receive any reply as well:
> >=20
> > Bug 20312 -  System freeze with multiples of 32 in
> > /proc/sys/net/ipv4/tcp_adv_win_scale
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D20312
> >=20
> >=20
> > Is it better to report on LKML? I have the impression that bug
> > reports onto the mailinglist are more easily recognized.
>=20
> They are generally more visible and get more attention if they are
> posted on an appropriate mailing list.  #20312, e.g., should be posted
> on the netdev mailing list (netdev@vger.kernel.org)
> Probably same for #27392.

Thanks for your hints.

> > I also find it difficult to find the right component when reporting a
> > problem in bugzilla. Thus reports might not go to the right persons.
> >=20
> > Please advice.
>=20
> Bugs that are posted to LKML usually are added to the kernel bugzilla
> by one of the bugzilla maintainers.  They would also select the
> component, so you could just try that route to see if it works better.

Or I create a Bugzilla to save bugzilla maintainers some work and post a=20
hint on the mailinglist, too?

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1716930.CzPIuY4uGz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkz+oV8ACgkQmRvqrKWZhMepswCgjufQr6PDz8Y0dmv+7HGdEqPx
V+AAoKOcNQ4dcVP2+XkGe/aFSafFouUa
=K7VB
-----END PGP SIGNATURE-----

--nextPart1716930.CzPIuY4uGz--
