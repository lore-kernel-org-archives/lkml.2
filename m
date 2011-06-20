Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1FTQRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 12:17:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39644 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab1FTQR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 12:17:28 -0400
Date: Mon, 20 Jun 2011 12:17:23 -0400
From: Eric B Munson <emunson@mgebm.net>
To: Chris Forbes <chrisf@ijw.co.nz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: hugetlb: fix coding style issues
Message-ID: <20110620161723.GA9697@mgebm.net>
References: <1308299399-825-1-git-send-email-chrisf@ijw.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1308299399-825-1-git-send-email-chrisf@ijw.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Jun 2011, Chris Forbes wrote:

> Fixed coding style issues flagged by checkpatch.pl
>=20
> Signed-off-by: Chris Forbes <chrisf@ijw.co.nz>

Looks like whitespace/bracing cleanup without any logic changes (intentiona=
l or
otherwise).

Acked-by: Eric B Munson <emunson@mgebm.net>

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/3KTAAoJEH65iIruGRnNg6wH/0YRW3vYfeaNPZj6ou9Po9Ce
NbNYAqZ1dCGAoQj8mcvwATwEBDNVJWH9EkEIjKm1+qSsFuLtriMcHibgRGTbmr4D
a0/EaYR9S1Y9sQON1UGOEeNfpAUUdXCKsMsOf89RoUXVnobjBVATfeasjuL7jRlJ
SFHfupudiX9ummusak2jO3aeS6zrrkcyQOVTAfBL71NqogE0OOXSoO/CM7lTMMUh
qizshKMjO+BN79P75btQ5cUys8DtZxg3irWv3VRewN6GmxEujPKyT2PA7rL5q4oZ
z7zJk02tHfN9uWR1TjR7gLS0/khz5g9Y+fUoC7uoPDwvnCJZxVgtHroOf7FlbFk=
=3y/I
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
