Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2ISJbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 05:31:32 -0400
Received: from mailout3.hostsharing.net ([176.9.242.54]:48120 "EHLO
	mailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2ISJba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 05:31:30 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 05:31:30 EDT
Date: Wed, 19 Sep 2012 11:20:39 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression] __d_unalias() should refuse to move mountpoints
Message-ID: <20120919092039.GA4387@galadriel.home.lxtec.de>
Mail-Followup-To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	al viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <504F692C.7050902@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <504F692C.7050902@canonical.com>
Organization: LXTEC
User-Agent: Mutt/1.5.21+lxtec (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Maarten Lankhorst <maarten.lankhorst@canonical.com> [2012-09-11 18:39 +02=
00]:

> Hey Al,
>=20
> Your vfs commit ee3efa91e240f513898050ef305a49a653c8ed90 caused my laptop
> with a nfs root filesystem to stop working.
>=20
> My testcase is simply booting through netboot with / and ~/nfs as separate
> nfs filesystems, then doing 'ls ~/nfs' followed by 'ls ~' in a gnome-term=
inal
> window, then I get:
>=20
> ls: cannot access nfs: Device or resource busy
>=20
> Similar things seem to happen with ls /, /dev /proc and /sys will no long=
er work.
>=20
> Reverting this patch seems to make things work again.

I have to revert the commit as well to get my mounts working.
Without I have the same probs as described here [0].

There is no fix in 3.6-rc6. There should be one before final
release?

Thanks
Elimar

[0] http://www.spinics.net/lists/linux-nfs/msg32378.html

--=20
  The path to source is always uphill!
                                -unknown-

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWY5mAAoJED2rN0233PG7ui0QAKMAlkhmVhQXmvB5Fm8VS0++
zecU9sjenlvx/YkKXC87X/TBgmbdQNwTPqghNwEwZlmLhley/X5vgTwEwIBuAG7w
KqJrfRPtYX1grvpI8ASeHzSVqbgoHyexdsN887CxJMiGDzt+6Dxr5HZ0N/d5RHxR
9tEEujgLK1TG5fdIT03uYb6xzE+gk4JUHfEE//aEDNbf22sqn9YdUB5NssXUl+va
MfyOfgW3JPfwgWSt/lknLVY9IiZlFhodLVHW/jBCY0eU9DZDiEDYwWasPekEJFtt
st8rkwkslgJuImrdVVXOJ6jtkO2NwVOOqQ8RtEzbiVZCv7c12WJ9HtKLK2nB56B9
XYiDsXRe3zLQjBiCPeIMFCtlGRGnoUUfe5soEY4wyaUfwy+5n6T//2TspvazSYuw
qIM6NR5jY9JVQlJ4RSVcFjA5zvU46vMZdBLsQd062RX9kAIHFE24S6cg3TuCgPRy
Vn8thcU9/YoNWId0uslHrCdSgTXWofBj3SPXNmieaFsC7akMBsOuF9Knd6HwmLka
+fZy3HOYL6ZrURWdePuhZlo3SJDQ5VY0ccQKjTPULcsV4LHaLrvpA536gaV1cJ/4
CkvFol1bf+rslDMBCQMd28YbDBmr6XAP/rpxJAhpAENAiAQmmvZ50ZoBuI1oF6uY
+S9OvsS+8jFTdBIrxtMP
=Rsom
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
