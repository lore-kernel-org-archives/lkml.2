Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1AYTnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 14:43:13 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38410 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1AYTnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 14:43:12 -0500
Date: Tue, 25 Jan 2011 12:43:05 -0700
From: Eric B Munson <emunson@mgebm.net>
To: Anton Blanchard <anton@samba.org>
Cc: dwg@au1.ibm.com, mel@csn.ul.ie, akpm@linux-foundation.org,
        hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] hugepage: Protect region tracking lists with its
 own spinlock
Message-ID: <20110125194305.GA3041@mgebm.net>
References: <20110125143226.37532ea2@kryten>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
In-Reply-To: <20110125143226.37532ea2@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Jan 2011, Anton Blanchard wrote:

>=20
> In preparation for creating a hash of spinlocks to replace the global
> hugetlb_instantiation_mutex, protect the region tracking code with
> its own spinlock.
>=20
> Signed-off-by: Anton Blanchard <anton@samba.org>=20

Reviewed-by: Eric B Munson <emunson@mgebm.net>

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNPyfJAAoJEH65iIruGRnNwLQH/17T2WJC8w2z70KCfhHpNS1K
5HoO+DTOw+a+j4tJ2STov2nPhv9g8L20dDuPq24EPBVbGuVSAbUXUSE4a44B2Is6
thYdwq86uhQDJtaO/EWjW6ZgwxHjl1umAtKYE0tSyxoVQns5eKZw+qPH1x6ivuBn
cTQKtvqNihul+avFuuAXR6EWA9pknAJlqR94ns4oH9lGDnd8rfAhGYT6ea9ETgKH
UA2OC9eggYa7w7MnVrBao38n5QKVMX9oNXzmHe4WAHqa9xtY8HdR5fvLmm3+yOo0
/Bom28ZI34HYPvKQPQv7/gqpBjpCazn58kB/5pLtxFSm2o5lcZfy/G6DbOBGwYo=
=aOOG
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
