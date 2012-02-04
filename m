Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab2BDOFj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 09:05:39 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab2BDOFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 09:05:38 -0500
Message-ID: <4F2D3B2B.206@nod.at>
Date: Sat, 04 Feb 2012 15:05:31 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] um: Cleanup headers files
References: <20120130192552.GL23916@ZenIV.linux.org.uk> <1328311063-17630-1-git-send-email-richard@nod.at> <20120204001431.GY23916@ZenIV.linux.org.uk>
In-Reply-To: <20120204001431.GY23916@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7857CC569163458946A6691D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7857CC569163458946A6691D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 04.02.2012 01:14, schrieb Al Viro:
> On Sat, Feb 04, 2012 at 12:17:43AM +0100, Richard Weinberger wrote:
>> Many header files can be replaced by generic variants.
>=20
> Umm...  I suspect that for auxvec.h the right thing is to simply
> remove it - it's never used on uml builds.
>=20
> FWIW, I've rebased my local queue to current and pushed it to kernel.or=
g
> again; it's on git.kernel.org/pub/scm/linux/kernel/git/viro/um-headers.=
git

BTW: You changed a lot in line.c.
Have you seen this thread?
http://permalink.gmane.org/gmane.linux.uml.devel/13329

At first I thought moving to tty_port solved all problems
but later I've realized that this is not the case.

Thanks,
//richard


--------------enig7857CC569163458946A6691D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPLTsvAAoJEN9758yqZn9ecc4IAKEMFiH5/lidVWcd6e062svv
KQiYwFtPe/fc+vbGcT9kBBZZrCenw+qPpVDEbwWl03oornlzHtF4iWqGY5nyfzXf
ACXNSvvqdyPfOXMKW7w3E8B8ZUvffJGuBXVMwbdiRDdVPqacLa11zoB9cV09uB5P
vfNrqxqz8gqYsKi3FOQ//LHHvV91holGH5LqCzjeRG6APx6Y5C4z/CbGChytFdAZ
1NRQ+Dy7e+zb5n4LhZejldPWB4MXlY9qWxSO1vcdrnc3Zb6SgF6ec7eNLYDym5L6
B9asLLCtBAvoC4PHA9EBiXjWPnkxh78fIf9Y42OCLgXQ9iE6Q8FrH9dktxZ33kk=
=QD6K
-----END PGP SIGNATURE-----

--------------enig7857CC569163458946A6691D--
