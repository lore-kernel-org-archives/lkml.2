Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab2CUQRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:17:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:41222 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758987Ab2CUQRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="131562105"
Message-ID: <1332346804.14983.23.camel@sauron.fi.intel.com>
Subject: Re: [patch] Add design document for UBIFS secure deletion
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-mtd@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Mar 2012 18:20:04 +0200
In-Reply-To: <alpine.DEB.2.00.1203211413240.6054@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>
	  <1329152067.22240.214.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>
	  <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>
	 <1331277476.22872.2.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net>
	 <4F68E420.30801@xenotime.net>
	 <alpine.DEB.2.00.1203211413240.6054@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PCG4EgFpCqY/8yBpH9rl"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PCG4EgFpCqY/8yBpH9rl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-03-21 at 14:26 +0100, Joel Reardon wrote:
> p.s., I'm new to this git; git format-patch gives me one patch per commit=
,
> which is a pity for a commit that e.g, fixes a typo. Format-patch
> doesn't obviously report how to produce unified patches. Creating a new
> branch, applying the patches, committing, and generating a new patch seem=
s
> too much overkill but I've seen it proposed. Simpler way?

The --amend option of git commit allows you to update the current HEAD
commit. I could not really understand which other questions you ask, but
if you have a specific question - I may try to help.

--=20
Best Regards,
Artem Bityutskiy

--=-PCG4EgFpCqY/8yBpH9rl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPaf+0AAoJECmIfjd9wqK09vIP/1Q9Za5B4tm9HjH6dWrhMBAt
nYHkvf5px6x/f2DLUY6Xg05BDtMzik+UnoscHx3XJIoaXbk7jSuG7D8FXFUs88/t
r5ml7cLLuwxEoCtJhJiVA/F8LKxmeuVA4YBNx2cH4gbfVJvuBRapkvF8gAY0ce2o
u2ekfdstOKwKR+3Yu4q8NeboQdWbWVxMlKmWzco+KvBd9CHkxsXFrP+PSjBaTtC7
zrxH68nI9H09u13CWR6FsDRLllrU1aUdrmwoZYGa2TAHBGKXLcdLJ5/Hs9tE5jQK
UU+MRmoeSdRagFrYkpTaQtsBZv0QpGTNMsTWAZ97Q9XO47HWI9tOAOtEGf5azsQH
i1HmEcaYKZqwNYOhP5OtkiwyC/r6AihPmdIqabBbekuJ8Htir8NN5jMtdQB1qt4Y
av4QHXpYn+fby/eh+XesdLlf/m1BK0rHffuGDQCwR5W9ACmc/Yc7z5VxNUsq8GrJ
+f3X14BCAZEs9wrU0UY8LISLgWx3RkUNJT8Qw3dLq3ZfIx0cHDVx/bXkjbyoCQuW
bMyQXgK9pWETfyddg+EqCuf6jbinfxIeiKjCLfp6X33ubk8xfvRrzBj5fApgOhZR
Oqyc9YWeU2IkuYNHXuyIDvR9sdSD8TqnPh4/z2cpoVTqY2SWzbXSK6jVPp6HuoS8
CUPlT7lHc6f5i8n4uTuw
=Irsn
-----END PGP SIGNATURE-----

--=-PCG4EgFpCqY/8yBpH9rl--

