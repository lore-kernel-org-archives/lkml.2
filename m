Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0IRUcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 16:32:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48011 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359Ab0IRUci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 16:32:38 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, stable-review@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20100918185958.285024381@clark.site>
References: <20100918185724.290702750@clark.site>
	 <20100918185958.285024381@clark.site>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WHtMtuXrqZgG7NtZlRLK"
Date: Sat, 18 Sep 2010 21:32:28 +0100
Message-ID: <1284841948.5879.301.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [064/123] sched: Protect task->cpus_allowed
 access in sched_getaffinity()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WHtMtuXrqZgG7NtZlRLK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm somewhat disturbed by the number of non-trivial scheduler changes
here.  How well have these been tested as applied to the 2.6.32.y
branch?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-WHtMtuXrqZgG7NtZlRLK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATJUh1+e/yOyVhhEJAQJqiw/+MIm12LIxLtsDAgm307H7bVvVlU1stMts
Muq9S1Vh4gQ5ltv8GdaXTH84HP8VRBB6R62jZktRPIZXrAPK3mtePzi6KZajqp/b
sGuP77I4Vz3f76zSPXa8OL8OesKn7CdHrWIQy5t6NF/eQ7lMEgaaerxUKODmGPmr
Suh8+tlcP3vBkLBy1WYfiQFcxhOm1/mzy34PEyI3C4Q3x7alJalCJW+BqfeNtpSg
t/4ILVzFkBO5yN+HhH07LueN53YMuum6YPIKkwAfVu3RO49ZYgXhhQMSEVnqO/NE
B48hh46NAANLiHV7b+z7x/Oy7z5FYseusRVOZU3Sxi9ZEmnDANBTKFOk2WEAMqoG
WT89mhWHNDP2vN1cM7X48iSpz9d2Y6BfKGRsawsE+Z7g0Q8kkzRQFTTH5HuAFe63
Xg+lliZSh4WZA4IPvKUdv8YluKz7jDiu04XR37fn2rRNjE743hste5U6o0c9uC7G
e7p+OEELQFzM5y/McUWXrZAbrwmYlUnxkQagOLukbyKQrAdAMdgdgQx30GXfYKzG
tmyHqRaXdNI6B5iUBp6EDGmK73fDM4ZmjIeS6AhouWyJ7Q9yGnhlyhUB/sqx22hP
HbPx33vm1EMZnHThPEfyujO9mu/b11coH2IGy3SiKTnr3YTIlzKrVWQdk9ka5m0G
VlzI4nHkjw4=
=46qA
-----END PGP SIGNATURE-----

--=-WHtMtuXrqZgG7NtZlRLK--
