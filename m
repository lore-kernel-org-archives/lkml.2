Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1ASQBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:01:39 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:50207 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1ASQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:01:38 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Add forward declaration of struct device
Date: Wed, 19 Jan 2011 17:01:21 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
References: <201012201723.30133.eike-kernel@sf-tec.de> <alpine.LNX.2.00.1101191556190.26685@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1101191556190.26685@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8757051.f41mmEFpMG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201101191701.29931.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8757051.f41mmEFpMG
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 19 Januar 2011, 15:56:47 schrieb Jiri Kosina:
> On Mon, 20 Dec 2010, Rolf Eike Beer wrote:
> > This fixes this warning when including linux/dmapool.h first:
> >=20
> > warning: =E2=80=98struct device=E2=80=99 declared inside parameter list
> > warning: its scope is only this definition or declaration, which is
> > probably not what you want
>=20
> In what situation do you see this warning? (the one you have posted
> doesn't show the filename that is being compiled).

Nothing (yet) in tree.

Eike

--nextPart8757051.f41mmEFpMG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk03CtkACgkQXKSJPmm5/E5dCACfQ4NCf+O8bNAKDoMexRrywcdV
c84AnRJgF2b2L7AgH41rTE5rfizqfyo9
=wHha
-----END PGP SIGNATURE-----

--nextPart8757051.f41mmEFpMG--
