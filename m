Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab2L3KiC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2012 05:38:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:10433 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab2L3KiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2012 05:38:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,381,1355126400"; 
   d="asc'?scan'208";a="271214102"
Date: Sun, 30 Dec 2012 12:38:50 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: 3.8-rc1 build failure with MIPS/SPARSEMEM
Message-ID: <20121230103850.GA5424@otc-wbsnb-06>
References: <20121222122757.GB6847@blackmetal.musicnaut.iki.fi>
 <20121226003434.GA27760@otc-wbsnb-06>
 <20121227121607.GA7097@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20121227121607.GA7097@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 27, 2012 at 02:16:07PM +0200, Aaro Koskinen wrote:
> Hi,
>=20
> On Wed, Dec 26, 2012 at 02:34:35AM +0200, Kirill A. Shutemov wrote:
> > On MIPS if SPARSEMEM is enabled we've got this:
> >=20
> > In file included from /home/kas/git/public/linux/arch/mips/include/asm/=
pgtable.h:552,
> >                  from include/linux/mm.h:44,
> >                  from arch/mips/kernel/asm-offsets.c:14:
> > include/asm-generic/pgtable.h: In function =E2=80=98my_zero_pfn=E2=80=
=99:
> > include/asm-generic/pgtable.h:466: error: implicit declaration of funct=
ion =E2=80=98page_to_section=E2=80=99
> > In file included from arch/mips/kernel/asm-offsets.c:14:
> > include/linux/mm.h: At top level:
> > include/linux/mm.h:738: error: conflicting types for =E2=80=98page_to_s=
ection=E2=80=99
> > include/asm-generic/pgtable.h:466: note: previous implicit declaration =
of =E2=80=98page_to_section=E2=80=99 was here
> >=20
> > Due header files inter-dependencies, the only way I see to fix it is
> > convert my_zero_pfn() for __HAVE_COLOR_ZERO_PAGE to macros.
> >=20
> > Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
>=20
> Thanks, this works.
>=20
> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>

Andrew, could you take the patch?

--=20
 Kirill A. Shutemov

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ4Bm5AAoJEAd+omnVudOMz1oP/3Gv20OjCZOhdYhdsufNiNDN
Hw5t2YwyzXVQ+HtHpqQuMXzdbHJYDWGALwvoyw1QMBxYkD8hVpc6bD7DpL23QHqv
JhV3luv30NrXIFaIhnu2ZPjNST43jVCI1SOrg35hTqCGehYtQIYuIWvDytXNlJtu
6chzAon5KgGS1fY60G7t0uL8CyLzywDZ7Gs0Y5S3TizR0Z/J5kk3R3uHN6oRsN3Y
WWKKebJgLtzq6cWoVjJhFvB+HqAHK7I4+6hpcE7FvC0phjJubCcnLDQ8g7O2XKBY
jOTOVZt4SbOuzsBYvNzVPIkxOW4M9pfy4NUw9MWPR/ilJGWlM6k2dJ+9Zum2fKLE
dJ3J1McnfSgf5HUIR7icPxeklCGUsWl2qjqINP7k0j4bYmlHLdYKV1N0FPdSTb/F
f0nuzbHB1DbvID9OXgyzkrznTdZ7vx67RJSLkR6tFzeaKZJbqlVcGc+l9B+EA6o1
E8VHlXWpyH7kncIHXUOgoY93LESWAMF6/lLjCUZqVIxMZV9/T+bpkcAAuambS10Q
tswy3L5I6oMvkfXviSjUfa7HFxfhkvGPoocDdStS4v8SAlK/aM6K12U/Vlr/Svif
5lfavj8P9S+R0ECyn+4wdzP71zRkmB4MP+eJdG8jSnos0zpZq21nntKCeD+EcWEC
/3r3MPDCqj+vz32O6xke
=VVis
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
