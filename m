Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2EPOYK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 10:24:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:34185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab2EPOYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 10:24:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="143915589"
Message-ID: <1337178457.24809.56.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/7] [RFC] UBI: Export next_sqnum()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com, tglx@linutronix.de
Date: Wed, 16 May 2012 17:27:37 +0300
In-Reply-To: <20120516170324.337f2932@pixies.home.jungo.com>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
	 <1337101871-31181-2-git-send-email-richard@nod.at>
	 <20120516170324.337f2932@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-cpCsPEd076ImV11WKFPT"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cpCsPEd076ImV11WKFPT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 17:03 +0300, Shmulik Ladkani wrote:
> Comment above the function should have been changed too.
> (look for the "next_sqnum - get next sequence number" comment)

I do not think we should make these non-static. We should re-use the
entire scan_peb() function instead to scan the fastmap internal volume.

--=20
Best Regards,
Artem Bityutskiy

--=-cpCsPEd076ImV11WKFPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPs7lZAAoJECmIfjd9wqK0CioQAKVRS8T0iOWdoJQdncs2gxYa
qUWXP3vxZnTC8CKkE39URlIvUFKdcWiV97SiSfvNRl+pjKaQ0wmAkR8blJq/i8lm
uQFY+9S/59h8KSJUatPAUjxGZqbyCkzKIustOa3u26ToDKKN2FIaduNecf3jgJWg
fy7nKWp+Zs/RMr93aXrPsPNKKg/2Et/MeK4J35JC939vGpdcPs6AYRRVo4kWZ9yJ
zZIPbD0nezkCHqDZt9hWE6oNg1NSzuPATaIb3pH4Y0g01G1+nmiJkM1s8Nv41V06
+zNIo7y4YOOgFBfyO8RrkdosY2DztWfPCKjXPbUDWJU+XFE04hqg9jEgmcmPiVw8
EO/dj9gbNwc1igbGapACnB65Wvw2v86girqXWBHe2WFN9E4dm0AlUO1aDzt1h0m7
/p80nmayp0b7HSESf57VhAkdgRH9Uorv8/YYy8uxQczcaCBEc8MocXFuSikcI1ip
rEMVQBHuakpfsffnFK9WFa3how/iBzVSviwWvEunxzRDzvJ+WxIAfCViaxI7xRkF
3hfsPbJ5v7nqpX2b4AWkhFnzSnJIbKoJCG3URxQyWanFZ/MvjmN91ThBzKeOfbXP
/OQxSdir9B/tqGNJ88iBtpRwXfZIyMDJw5aW0HrQjFcPKXHLFoUA0JDh4y8ah9oA
xTjkJOOyPZGFi6YrdMx/
=7qFI
-----END PGP SIGNATURE-----

--=-cpCsPEd076ImV11WKFPT--

