Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2EOMTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:19:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:48033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab2EOMTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:19:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="166530980"
Message-ID: <1337084568.2528.194.camel@sauron.fi.intel.com>
Subject: Re: determining if a block erasure failed
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 15 May 2012 15:22:48 +0300
In-Reply-To: <alpine.DEB.2.00.1205151349580.18866@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1205150944550.17750@eristoteles.iwoars.net>
	 <1337082053.2528.182.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205151349580.18866@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-O8mTrPFGE77gIpHIDcQg"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O8mTrPFGE77gIpHIDcQg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-05-15 at 13:56 +0200, Joel Reardon wrote:
> Ah yes, if wl_wrk is freed in schedule_erase, theres no way to pass it
> back that way.
>=20
> The reason is that, if erasing a block of keys fails, then those keys may
> remain on the flash device for eternity. While a rare occurance, it may b=
e
> nice to have ubifs perform GC on all main LEBs storing the data nodes tha=
t
> can no longer be deleted through key erasure / reencrypt the valid data
> nodes.

Erasure is asynchronous and I do not see an good way to implement your
idea. Do you have a good plan?

--=20
Best Regards,
Artem Bityutskiy

--=-O8mTrPFGE77gIpHIDcQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPskqYAAoJECmIfjd9wqK0hK4QAIlHuTQKVnK7m5I+QYqbq8oz
RNvookf93HBHeQBPkQM4rEcdRs/0ev9eFARW5U0AJNjETHB5yitDtQlmIwhBoyZC
RjhNJudL7jXV9RIZGdZrlVe7AjKejJ0rQO1OWG2kYy0Tc5yZC2aGLDjkWK8J6Kbj
sQQB3xO0fTtQPu6WLdAqGi9xqi21nJ087EoQKoELRgOLxuCkQmNytidOgPSdnIUt
33rVl2bhGj3y0tLQJ7azOaQPtOmpbrEvUnCJVlW4bB2qPhWfLmTzaRyhT3sfpTfj
DshX42wC029WOYTAbkZyglLSLJrtDzv3Ph5GCGlEha3ush5DCFRuJhJAqzUTnvwI
N5PaMawY2qxeKFAVtR7KwuSI/VhbsRyw5KmwVBZuCTcC0FJrMVBsk0ch7z0puz/w
0xVeAcelYZt/xIGnNGyX8bsY3UQC29IflysdxdmT/lqh9wjuLnNpxoSDHl2fiTMu
p31mDqCQkx747j0oA70u8pwd4YvurCjorlZmeWxWFhnTiGVk5t3eXlRAKQYZHH8i
1e7HeZTyWuMEZ45db3uBHZdngQ4flO4zs1QfHnmJglqNIxRO2Xot36W+3z72c/IK
+9pCi8ueKa98mUOwkiVNE/BzRDlpz0FwSLfXhZat7qw+SCM2xP6fNgmSIzxdrF/l
HlQXSM5RFtpKzWHttsbP
=+F5v
-----END PGP SIGNATURE-----

--=-O8mTrPFGE77gIpHIDcQg--

