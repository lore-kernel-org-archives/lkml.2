Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1BWPbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:31:51 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43827 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1BWPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:30:58 -0500
Date: Wed, 23 Feb 2011 10:30:52 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/5] pass pte size argument in to smaps_pte_entry()
Message-ID: <20110223153052.GC2810@mgebm.net>
References: <20110222015338.309727CA@kernel>
 <20110222015342.5DD9FC72@kernel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Content-Disposition: inline
In-Reply-To: <20110222015342.5DD9FC72@kernel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Feb 2011, Dave Hansen wrote:

>=20
> This patch adds an argument to the new smaps_pte_entry()
> function to let it account in things other than PAGE_SIZE
> units.  I changed all of the PAGE_SIZE sites, even though
> not all of them can be reached for transparent huge pages,
> just so this will continue to work without changes as THPs
> are improved.
>=20
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Reviewed-and-tested-by: Eric B Munson <emunson@mgebm.net>

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNZSgsAAoJEH65iIruGRnNfjQH/jigfBNihcGhJ6Z9ESvDkQ1C
VxTUjpWt67zxTObErN/TYLn9zZv/MvG4m8+ZmYKesICyydXAqoo/2rjqsm6dUv05
Tczv0gIcgih8XL9EG+TzzHqx4s5iky9DyRcqG4HOOOffa5CIB9BpytMNRu/e/Q5V
i/Fy7qLLYD17wBCN7QZY1BtT+ENPUSvWtARDoizow5ps8v0LgtNEOxL75Qmii7pw
R9TKiTFdrZjx0zwpszXx4QTWDsWortBg3PcQkuvIicMgb48EnvEdOod7TZlmeKpG
NvdMp9DJ/O4CC+SblmVf2FwFYuMWD6UEJO1TXEodxQAyNijToMKyOxPq7M5P69I=
=Sovd
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
