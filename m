Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2JCIom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 04:44:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:6155 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479Ab2JCIoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 04:44:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="asc'?scan'208";a="229357298"
Message-ID: <1349253885.2017.125.camel@sauron.fi.intel.com>
Subject: Re: UBI: Fastmap request for inclusion (v19)
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Richard Weinberger <richard@nod.at>
Cc: Heinz.Egger@linutronix.de, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Date: Wed, 03 Oct 2012 11:44:45 +0300
In-Reply-To: <20121003103625.0bbff63c@spider.haslach.nod.at>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
	 <1349252745.2017.120.camel@sauron.fi.intel.com>
	 <20121003103625.0bbff63c@spider.haslach.nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-N2ucnECUcnrYAcEe5xUr"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N2ucnECUcnrYAcEe5xUr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-03 at 10:36 +0200, Richard Weinberger wrote:
> Am Wed, 03 Oct 2012 11:25:45 +0300
> schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
>=20
> > On Wed, 2012-09-26 at 17:51 +0200, Richard Weinberger wrote:
> > > UBI Fastmap is an optional feature which stores the physical to
> > > logical eraseblock relations in a checkpoint (called fastmap) to
> > > reduce the initialization time of UBI. The current init time of UBI
> > > is proportional to the number of physical erase blocks on the FLASH
> > > device. With fastmap enabled the scan time is limited to a fixed
> > > number of blocks.
> >=20
> > Aiaiai complains and linux-next build fails :-( Last time I forgot to
> > enable the fastmap kbuild option so aiaiai checked with that option
> > disabled. Now I enabled it with a simple hack (default n -> default y)
> > and here are aiaiai's complaints - there is a build failure for
> > ARCH=3Di386.
>=20
> Build fix for linux-next is on the way into your inbox.
> I'm currently looking at the aiaiai output.

OK, I see, goto out is missing after line 919. Please, send a short fix
- I'll squash it in. But general error-path rework is needed for this
function, may be separately.

--=20
Best Regards,
Artem Bityutskiy

--=-N2ucnECUcnrYAcEe5xUr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQa/r9AAoJECmIfjd9wqK0zTsQAJU41ufzy8+UBPK+J8JU4Yyv
80bDIzjIZTIHkDyaoHJwtiW9BnmHlK+eg9yBm9AKBV5Uz+u1jWEZqneTgfHyggwd
BPcgJAt2XdY5rzbLj1kg2JX5aJwRhPfarZYBc6Yr0Uz99TOKdZeLNLbe382y6b47
HwbFYQWnAuuxfqN/48HhBN6rEYgEViu2eWBlo9NBOL/otfFdL1fGx4mbNp/71hXM
PmkC72QxjtvuNFO3zD0fHk/S+O9R3WbY8taV1oOa8bM2VbMduebmYFbeQ+UTOOEZ
3ZFiXjFF1JX8mP7mXdgMi1Z5i7q6TqIoT9B0VWktn/lO7ZnL34ODVH5XZwQwxfwG
7A/wclsPzRaiC4k+yafXXOenQh3XvLD/1np6pW7RiFTHSjcto05lPCLi791QmIVN
Y9MuNfCnE5YnvT2GEuRgGmvqUp5euiP2OGJdiKxrs8hm/ZwEls/5O67gONHXxtAS
vvRuMCM78m5AcsenLq5/8twl5/X+JX43mfXQWe+qiJn12aHQz2eQDJJvdCOtRFg3
m+ABtBjXFsmlnJvy4Y8Ue0A9Y4Dj5f4llNs0UTbDqTi7Lp3nnArql4Vf9vLEwzkX
WDxS3uJhUdXWEonZXSDKK9d27u7/CW2uZx4hC/jYhn2ly5tFMps6HqsGUXiNWZgk
8FfxBjLTkwxYQ0uvNBhN
=tUnE
-----END PGP SIGNATURE-----

--=-N2ucnECUcnrYAcEe5xUr--

