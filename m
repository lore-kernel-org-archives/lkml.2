Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1BWPbY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:31:24 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43827 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab1BWPbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:31:22 -0500
Date: Wed, 23 Feb 2011 10:30:41 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, akpm@osdl.org,
        Mel Gorman <mel@csn.ul.ie>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/5] break out smaps_pte_entry() from smaps_pte_range()
Message-ID: <20110223153041.GB2810@mgebm.net>
References: <20110222015338.309727CA@kernel>
 <20110222015340.B0D1C3FC@kernel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <20110222015340.B0D1C3FC@kernel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Feb 2011, Dave Hansen wrote:

>=20
> We will use smaps_pte_entry() in a moment to handle both small
> and transparent large pages.  But, we must break it out of
> smaps_pte_range() first.
>=20
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Reviewed-and-tested-by: Eric B Munson <emunson@mgebm.net>

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNZSghAAoJEH65iIruGRnNWd0IANso5VZqEYZ7IuOa8v6pKVIP
3Hp2AnvB2ZuZC/3t/v8xERXsaGSwl1MIWyhdqlvdkQxTNh5Z14Ivwq5EpkOpb5br
+F1gVk3XJCyUatCVj1iL4UTgg9FrBCrdOyvn5nq3/DBanoEjJzSibH3vlLhfX8Z8
D5P/pcim4o7IdWfVlbCwSyMBlnt4lpQVhL0gqRoUdZY7VbcBUMhf3BRnmCIwwPCJ
Y15K0h9WIhWysjmkT7uMFIVhJJiXDZTCDjyY70VDw2VbOCHF51yQr3TBHdXxrA82
Ps3XPrna2+H3fbv7NRCoyjahN6KetQqRrllE1NwdcPuZ6uCf5no+qFUCS5rQav8=
=4KaD
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
