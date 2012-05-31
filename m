Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2EaKcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:32:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:26549 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2EaKcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:32:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="173149405"
Message-ID: <1338460565.2536.126.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] UBIFS: compute KSA size and store in superblock
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 31 May 2012 13:36:05 +0300
In-Reply-To: <1338459575.2536.120.camel@sauron.fi.intel.com>
References: <alpine.DEB.2.00.1205251509220.2989@eristoteles.iwoars.net>
	 <1337952271.30969.37.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205301531220.6465@eristoteles.iwoars.net>
	 <1338391121.2536.94.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1205311211340.15137@eristoteles.iwoars.net>
	 <1338459575.2536.120.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZwsZlK8b0etqFk24ElEZ"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZwsZlK8b0etqFk24ElEZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-05-31 at 13:19 +0300, Artem Bityutskiy wrote:
> Why assert? The point is that if we read the superblock we should check
> that it is sane. See teh validate_sb() function. If any of the above 2
> checks fail - the superblock is insane and we should refuse mounting.

Let me put it this way. You are reading the KSA-related fields from the
flash. You cannot assume they have reasonable values to prevent attacks.

This is the general UBI/UBIFS pattern - we validate everything we read
from the flash. We check the CRC and make sure all the fields we use
have reasonable values.

--=20
Best Regards,
Artem Bityutskiy

--=-ZwsZlK8b0etqFk24ElEZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPx0mVAAoJECmIfjd9wqK09HIP/iKPI5yLLAnzSrwSV7aMh8TH
EEJ0YKBwIF/39SMgaBvHpq8wWLiqC0gAd3cuptre5l8LwdfFEWoYFutofd3vq2DS
wNi1JHMc5lD/TGiwbDdTX59daBQal6JA/BWj+6Mw1B/ZpYGFveK88djmxVnYIRw1
uD7yPouBrn8RVK/s/BZyGOu5dFuvHsRoP6mbOpaT8RmhVs3wpQGFALFCeSTcnYB0
++sVo1i0vk5zvctDOsAeMJKEC70+UlKFDhtHwxoEkyDETcFJehU5hJWWJZI3LLyM
xwWV+6vJ65fLK0DK8nUEu4g8tqs79UHmDkNiJ1eZmt7DW9yZZhSpNjpfyJWnd1vK
Lkh64jCnL/bqHmT8N9xqHIsM9EnwUL5cPtKwqAjeqnfzVkrywImTnCN/eooWbq2O
nplGELhJc7srw2Rud/Yw2rvPBo3fsNt+0tY/Xc2fkIFKGotov3oYOU39/64wXb8z
4EV1ieDjgUJT7Pa15jSZ8YNx0mBtBPPQdYK1IqdoksPxpryhMPlLUx/yOLjdrlP/
cjyoAdyVCFZGYJ/1tYxPNRgWnH0hDmAJJuG26aLC1H7GGOBcSwekM0G0QAhXQG+z
vjUwuVgPU3ShSNOIa3hqERWgJDK1MXnsfhT3eZaBJjs3Ndcz1pCffS+jLQg29p2X
xH4kPtEksueMBPBtkYeI
=tlsV
-----END PGP SIGNATURE-----

--=-ZwsZlK8b0etqFk24ElEZ--

