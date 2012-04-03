Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2DCDBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 23:01:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42197 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753391Ab2DCDBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 23:01:46 -0400
Message-ID: <1333422093.443.32.camel@deadeye>
Subject: Re: [ 101/175] mm: vmscan: forcibly scan highmem if there are too
 many buffer_heads pinning highmem
From: Ben Hutchings <ben@decadent.org.uk>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stuart Foster <smf.linux@ntlworld.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 03 Apr 2012 04:01:33 +0100
In-Reply-To: <20120330194845.531765417@linuxfoundation.org>
References: <20120330194845.531765417@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cdBgVJGJKkohJHEAaEc0"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cdBgVJGJKkohJHEAaEc0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-30 at 12:50 -0700, Greg KH wrote:
> 3.3-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Mel Gorman <mel@csn.ul.ie>
>=20
> commit cc715d99e529d470dde2f33a6614f255adea71f3 upstream.
>=20
> Stuart Foster reported on bugzilla that copying large amounts of data
> from NTFS caused an OOM kill on 32-bit X86 with 16G of memory.  Andrew
> Morton correctly identified that the problem was NTFS was using 512
> blocks meaning each page had 8 buffer_heads in low memory pinning it.

I notice that this was not applied to 3.0.26 or 3.2.14.

[...]
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=3D42578
[...]

but this bug was reported against 3.1.9, so the fix is presumably needed
for 3.2 at least.

Presumably the upstream change doesn't apply cleanly and would need to
be backported.  Is anyone planning to do that?

Ben.

--=20
Ben Hutchings
Reality is just a crutch for people who can't handle science fiction.

--=-cdBgVJGJKkohJHEAaEc0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT3poDee/yOyVhhEJAQonXhAAwrCxHRjy5oef5bTEC+tj0Lu3Ve/bUfTW
V3pFuiAK4FUZMpbDf1XIYk9Cu6EYmooJXpsIB6csO/C9g4INHYcnRnqNHaLoCCv0
VML3vSKv8iSIUF7VmSgCGWncEEl/OOH6i56C2ZEwWdC4UVEFtjvDAtji90j7AhX+
14PCDMeZxkSKMgDLaXnWwTh08llIX3P7rDZek635Z952bM3rGlzMNaBcj5N4yn+h
XZ/AWbhqezLGJnWhqkSbS1d2tmlqBjNCBku5dekwUsonJ5L4xMF4bkDGbUiXTnNb
Gbiits9e3SsMgV/+b96WDpDanvKhRq+cgTNV7NBVjFQ4mFrgVofGls9x/AEjX0rq
WCw7GitS4iGbpwGuhVGe492KBD0xtO9opP0kDhYUZ2hEV9ZBJUpFCwjcMid0blDk
yOaU6puOS6UX4F0bMIIAM3p1ctPU1jVE2pVx6n6ZLhO2dzbex91JdWtBrMOUj+BU
yqAzRzv3ukD6mO4qsMCJSPIjDovVbuwex11zL4xcgO53yiwiE+hF5vWOSGLPAr2Q
0vLKagEM4LeL8YmxtdbD3mYWkmOCKawUlPq0nWlSBxCr7O1UoRBk0F/lzi3dTYIN
hcQo8tiyT5oqZGmQlQPKFC7B1sMHSB3/LZu4JLnt8DYvQcr5MZPj/4IvBV+B3ppr
DlgSuGDgJD8=
=/aDQ
-----END PGP SIGNATURE-----

--=-cdBgVJGJKkohJHEAaEc0--
