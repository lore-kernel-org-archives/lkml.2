Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2BDA0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 19:26:25 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756308Ab2BDA0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 19:26:24 -0500
Message-ID: <4F2C7B27.6020707@nod.at>
Date: Sat, 04 Feb 2012 01:26:15 +0100
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
 boundary="------------enigA7508D302424D1A487BC3CC8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA7508D302424D1A487BC3CC8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 04.02.2012 01:14, schrieb Al Viro:
> On Sat, Feb 04, 2012 at 12:17:43AM +0100, Richard Weinberger wrote:
>> Many header files can be replaced by generic variants.
>=20
> FWIW, I've rebased my local queue to current and pushed it to kernel.or=
g
> again; it's on git.kernel.org/pub/scm/linux/kernel/git/viro/um-headers.=
git

Hmm ok, you did already the cleanup...

Thanks,
//richard


--------------enigA7508D302424D1A487BC3CC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPLHstAAoJEN9758yqZn9eOUwH/2+AsOzHgDuQrtjahWgAk9xo
I3WcBDhj9BNDphGoHWvzEhpZ5IV1Y6MVqbdHhX++ARLEaIyn+QU8mj9tj4nou4Wf
5KaheRglMJV4nSEX8Cz33iPOhia8JZfyIHIvqZ4m0Ljv1KhgMfxRY5wYBQNxl1d4
qCHxVZwfcEREdVvHJdNCV04Dby5y22i0SXcDALdcLYiC8+TB95Mkp3oDArmiYfTR
ozyHQH8UaMm44usFEi6qbOGbKQCpmc2nyss2kFRLHi7hfsFU68QTgg5riCXrptr4
Tq14H0vVlyrgdym60wA1V7PgZxYtFUZglco8pnrzoz1OvPDlAsMMNA5YyvRNp5g=
=o9sp
-----END PGP SIGNATURE-----

--------------enigA7508D302424D1A487BC3CC8--
