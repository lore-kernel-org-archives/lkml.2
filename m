Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab2DKQBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:01:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:41897 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab2DKQBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:01:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="131240868"
Message-ID: <1334160265.13842.23.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: allow atomic updates to sychronously erase old PEB
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joel Reardon <joel@clambassador.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Apr 2012 19:04:25 +0300
In-Reply-To: <alpine.DEB.2.00.1204111513230.10181@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1203291653210.912@eristoteles.iwoars.net>
	    <4F748CD6.4080704@parrot.com>
	    <alpine.DEB.2.00.1203301413080.10066@eristoteles.iwoars.net>
	   <1333110503.5440.24.camel@sauron.fi.intel.com>
	   <alpine.DEB.2.00.1203301433270.10066@eristoteles.iwoars.net>
	 <1333111321.5440.29.camel@sauron.fi.intel.com>
	  <alpine.DEB.2.00.1203301709080.10066@eristoteles.iwoars.net>
	 <1334147205.13842.8.camel@sauron.fi.intel.com>
	 <alpine.DEB.2.00.1204111513230.10181@eristoteles.iwoars.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Qwrin9GrUl87QEiSJrHf"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Qwrin9GrUl87QEiSJrHf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-04-11 at 15:14 +0200, Joel Reardon wrote:
> This is a proposal for adding an immediate mode for atomic updates of LEB=
s in
> UBI. The idea is that, if the erase parameter is non-zero, then the old P=
EB
> will be erase after the new PEB is written, but before the function retur=
ns. It
> will not go into a work queue. This is for security-relevant situations w=
here,
> for instance, the user needs assurance that sensitive information on an
> eraseblock is actually gone after the update.

Amended the commit message, and actually squashed 2 patches to preserve
bisectability.

I've pushed this to the master branch.

I've also re-based your 'joel' branch on top of the master branch.

Your old branch is saved in 'joel_old'.

I did this because there were minor a minor conflict with other UBIFS
changes, so I thought it makes sense to rebase now.

Some tips.

1. save all your changes.
2. checkout the 'joel' branch
3. git fetch -f
4. git reset --hard origin/joel

This will let you update to the latest joel.

git checkout -b jeol_old origin/joel_old

will give you your old stuff.

Yes, sorry, I told you I won't rebase but then I noticed small conflicts
and decided that it is better if you are up-to-date. If you are unhappy
- let me know and I'll return you to the old stuff and will apply this
patch there.

Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Qwrin9GrUl87QEiSJrHf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPhauJAAoJECmIfjd9wqK0ji0QAIy4t6ATaWcfmhA0iVXnH3GS
Bx1QyHBjpe7ymo1PJOt9xh5oMyKP8urVtB7De6QOsr2J6QpsTvJJTuOGkA3ca3Ut
D9jNOOofVK7llJt7PdghBHWPGFZCtgOV42rPumhydl9LIuOzMF2HKrbrylSkrL/d
gacOAd+dyyHv46FV5sLXVwI3O/QcUzrxJpPSjWSZls3Sr/ASJzfPdF6l+9uEx1Gl
FNpRkMtQ1ggvFL8ylbpLG0aMvs7+/oH1JtKnOsT8o6WAJlmGct6qzquCzMSGja3C
JqkjK842rBAXZXwYiEdnwYP4mWQCBR4WqHUabpf8OxVEPV5UnaHHCEH4NtDZNX+N
98jcS2UW6sNoI4NwpY2McoAuTJR0IzFvnpb1EAWu6kEwZkUozZzfz7M4OliJKNgA
ZTGaJGzainZz4RdiJ6KC0pZV6ZS8xjPZ0WnsUomF0GRZKe+2cWQZ/0JOLJdQcIF5
F0SqgG7o4YxCY1Z3OUq0QMrItZJWJwFVMrCt6GQoJRciVipjwL9cCKGT68UFO+PB
X2niL6WNnzo/kFXTjbWpwDb2w165otjjDRxZ3aI9j2C4PWqHB09ZBFeOKTPEyt7V
LtCivtLY9jJBKX2snrGljiMNVGINhVyc9IEavSGU5Zuy80PC0jTdrSJuZk6zQhb0
aXCZMjUuNOUWlHsBmzDa
=53tp
-----END PGP SIGNATURE-----

--=-Qwrin9GrUl87QEiSJrHf--

