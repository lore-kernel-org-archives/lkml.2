Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab2GKIEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:04:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:47836 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2GKIES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:04:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="170334992"
Message-ID: <1341994106.2963.138.camel@sauron>
Subject: Re: mmotm 2012-07-10-16-59 uploaded
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Date: Wed, 11 Jul 2012 11:08:26 +0300
In-Reply-To: <20120711005926.25acc6c6.akpm@linux-foundation.org>
References: <20120711000148.BAD1E5C0050@hpza9.eem.corp.google.com>
	 <1341988680.2963.128.camel@sauron>
	 <20120711004430.0d14f0b6.akpm@linux-foundation.org>
	 <1341993193.2963.132.camel@sauron>
	 <20120711005926.25acc6c6.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X0U5uJVxq+VmyXc+Btqt"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X0U5uJVxq+VmyXc+Btqt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-11 at 00:59 -0700, Andrew Morton wrote:
> > > I looked at them, but they're identical to what I now have, so nothin=
g
> > > needed doing.
> >=20
> > Strange, I thought they had the white-spaces issue solved.=20
>=20
> They did, but I'd already fixed everything.  That's what those emails
> in your inbox were about.

Sorry Andrew, you did not squash your changes in, and your fix-up patch
did not have a nice commit message last time I looked, which made me
think that it is temporary and you expect an updated version of my
patches. It is fine with me if to have it separately, I was just
confused.

--=20
Best Regards,
Artem Bityutskiy

--=-X0U5uJVxq+VmyXc+Btqt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/TR6AAoJECmIfjd9wqK0kV4QAJW6hUvwxaa0RPz/tO7UQBhk
BMyBe5wkaoJ4nsbRmP8LRfhzHajRnhYhmvPEEagHl3XuBNl/Stij0y+zwBkbY4gt
Qa89ikgoVlIOxEtE7LH2MaK+IeDP73C/7wNLQqdj8fI8Sm9edJaF+SlDTlHq+ugi
k6Ji94L1bt2nnoGn702YwnpQJffzoar4pIs5tNPuDqc6hLkZqJoKwuK2eGGTyvG3
wrVNs+EasBKSMTcyG/2TmokCmmIqcuLCungrSZbN+ucgk9+j3B0UI3UOOwSYxBGs
0EFSIMElL/B/NMzfU5bjg+uvDbDqxIcbsKHPB0YVZ2CAZ/aghXzvHZgjHc028e8M
RRu7xEYTvNsrJBri99w+avRY7ltqhEkxqyUMX5dCp/s0Us4XhDbqa7Al/nYAsDD8
VycxSQWW/pSrsGd09FHBQZIF1swCe2Jv4fS964UcgC2IbjJQW5I/YUisLc+sxCJq
TuX26UNhz9eozie1rnvUEGtZu/bzUoad2zAfFZX3wfE9CKtx9URmPmKdSyYc5am3
TP7ea5QS14deC/hs4BD0QSKA+MzUT8eA4qn90IVjubl4cu4/qHbTCKCFhiQwOYGY
FvPKFRTkZZmdUNvg0DpBLiF06bOEVJyJt2gIuoDKvLVFugihEsbpC4wBkyscpVxf
FFZaJPa8ZdmLs2w5mbR3
=wEXM
-----END PGP SIGNATURE-----

--=-X0U5uJVxq+VmyXc+Btqt--

