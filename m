Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736Ab2C3MjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:39:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:25102 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759484Ab2C3Miy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:38:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="126958509"
Message-ID: <1333111321.5440.29.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: allow atomic updates to sychronously erase old PEB
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: Matthieu CASTET <matthieu.castet@parrot.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 30 Mar 2012 15:42:01 +0300
In-Reply-To: <alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>
	  <4F748CD6.4080704@parrot.com>
	  <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>
	 <1333110503.5440.24.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xNYMSv0O6nG03DmufvMS"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xNYMSv0O6nG03DmufvMS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-30 at 14:33 +0200, Joel Reardon wrote:
> Just for 'blocking', or also all the 'erase's.

Not sure I can provide a general definition :-) But use it for waiting
for erase of the previous block to finish. It is also coherent with the
'mtd_sync()' name.

--=20
Best Regards,
Artem Bityutskiy

--=-xNYMSv0O6nG03DmufvMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPdaoZAAoJECmIfjd9wqK0mykP/i19z3dbCh6BdLfBv0wJtfYN
CTpzla1fDUD5TrhmwOjRTMH13V8NIYUB2dHdbmS1hqD3d4Fm7CNuHg72cHJZrl78
FEgVgSFjAEaBc+amKv4Aw1Km21LPblnFGYedIZq1evzRcFtlDZ16tcZfiabJdZeT
pOQXHwXW4aBBaBnU0XjSqyMpMeQMnDmJ667L+T8C2tTgTZacmcYMabiac/n/GF1I
Ri41wqaHnegBa2AFR0u+VQFI2hlEK+IKJ3PRIO/raducLF9yBJoX3XfaOlYECmfZ
YAqtUew2OO3BdxDJDXQvj/dxyxWDuDp+WjODTOQF/QcwBVonFN7y5QklSk3RKD3k
yn4aMXYDLjQ44eGPDuW2jtT+vGBjA30EI/i4BpOyP4JBR4q31yd8lK+tUFxFiqeU
Ve1xpUSd+RQdF1WvQa+rKecf/FvQvLMKsFoDyiW7hnWrQU59+jrvSxJ04Y2Lb82S
GziOypnZcJsdBxHLx7LQd6GyDJVnzwmnU+nRoGatCdCyDnipXAwLdA+TmtwXklix
rSsEaMQqGvkG4KeFUD8J06GvkANeJhU1C6P+hCdwTUXDhKI2OhxEgjtMIzsjgdHc
YgZ1P0ktI6rmovHLFpmzVrax10qPq2x7paU8Ho2qpIdMzuu6MhfNIt7IW+mhPsr5
x+DBcSyHD6WvjAMWe/c/
=Qx4i
-----END PGP SIGNATURE-----

--=-xNYMSv0O6nG03DmufvMS--

