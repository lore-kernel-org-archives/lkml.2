Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1BWPbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:31:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54489 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1BWPbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:31:10 -0500
Date: Wed, 23 Feb 2011 10:31:04 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/5] teach smaps_pte_range() about THP pmds
Message-ID: <20110223153104.GD2810@mgebm.net>
References: <20110222015338.309727CA@kernel>
 <20110222015343.41586948@kernel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <20110222015343.41586948@kernel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Feb 2011, Dave Hansen wrote:

>=20
> v2 - used mm->page_table_lock to fix up locking bug that
> 	Mel pointed out.  Also remove Acks since things
> 	got changed significantly.
>=20
> This adds code to explicitly detect  and handle
> pmd_trans_huge() pmds.  It then passes HPAGE_SIZE units
> in to the smap_pte_entry() function instead of PAGE_SIZE.
>=20
> This means that using /proc/$pid/smaps now will no longer
> cause THPs to be broken down in to small pages.
>=20
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Reviewed-and-tested-by: Eric B Munson <emunson@mgebm.net>

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNZSg4AAoJEH65iIruGRnNvSsH/AtwBQIVUaJi8Uvm59aCnIiu
ignraJxSzfqLoUkbGbA2prdsZwY0rk5Dn0Zdm1kzjpD+26YsA9n5JSdPFdzR7TXP
Srr/Yqs+rgPJPvKE6gJt1jXN8Rtxg1nE1TKxNKHJYHVnH/sLN1MQeSOFrbtBM7sq
Pil5w7FUII1ZpR/4BAq6fFEohyveXAGVHxZjfHkQNgfW6wP8Wxfulbb/QAf5W4/y
2FzSIrcDB45IT7c1drWX6zCqURXxOQHuJbye1xNK8XMANOWyfPeUJQeGj0yVd4T1
5cTXlP2pvYCB49dKmGRJSrtMXEHrF/F6Yv7NEw4M1PYHVLWbV96AevInnin8CNU=
=zbue
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
