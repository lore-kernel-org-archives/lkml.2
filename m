Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2L0Pzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 10:55:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44244 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785Ab2L0Pzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 10:55:33 -0500
Message-ID: <1356623722.17740.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [v3.2-v3.4 stable version][PATCH 1/2] ring-buffer: Fix NULL
 pointer if rb_set_head_page() fails
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 27 Dec 2012 16:55:22 +0100
In-Reply-To: <1354292309.6276.161.camel@gandalf.local.home>
References: <20121130161238.909829067@goodmis.org>
	 <20121130161333.983378567@goodmis.org>
	 <1354292309.6276.161.camel@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bbkX942M1BlA6SJNGvGs"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.210.143
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bbkX942M1BlA6SJNGvGs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-11-30 at 11:18 -0500, Steven Rostedt wrote:
> The function rb_set_head_page() searches the list of ring buffer
> pages for a the page that has the HEAD page flag set. If it does
> not find it, it will do a WARN_ON(), disable the ring buffer and
> return NULL, as this should never happen.
>=20
> But if this bug happens to happen, not all callers of this function
> can handle a NULL pointer being returned from it. That needs to be
> fixed.
>=20
> Cc: stable@vger.kernel.org # 3.0+
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[...]

Added to the queue for 3.2, thanks.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-bbkX942M1BlA6SJNGvGs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNxvaue/yOyVhhEJAQrHYg//Y3CLi1VVv73x495hCVwGa09LNmuwXnwh
8xhPNq6xyfr/YZNOF8lniGK+HVdQFOwXCly0NJMGg6ZMncpqFsaLfxFUqb6coiQk
GgHnkCfKAlhhCEweKH0kXO3+DFPAutOaukq96U/dAr8iV5b3GRGJarPbI376kr2q
1kSDJQ+No+dwWRk6TLgSx9aqL+vW6fT2X6Rzp+wpN7POT8QPbM/W3btdkgNYRQwN
yqfI2NxvmMjRh4xvOwrP116C7SMJKf343Nd8JOzEiR0znNLFFosjObjKVRmqFTHt
IgQsMpZkamJ34a8KfyPW0bZ5ZIb8juq5ZIDPWouvBJUUuZWQMvyStweHM4Cec/vI
VIbllec+JI1D3L0BLr+j4NAvX2teFWOpaJFX0ouOZ97iKkKgK0be/YiPNyngPldP
49lgthQ7X+JJUMT6gbGEUbSwl/l1zz8yNZ0KJ3VjsUCsQ6ykznQe77JUM9cms0V+
xqyv6NXtduZ3VqQhtFsdhqH58eu6gG/wJk+o/o6nOYOUeIUqfnwcTu1zd8qdlBBY
xHV/Peg6Q2IYPiA+wZB+31PqZDHGC9Y6sbK+hOLGZ0nsGhrV1TAjDrVhJycY1LqC
8AI4+HMkiyTkZ4BOu28H4iKWkHVHoNOL3b7IgWjYpOfw84Xjod+A8i320J2robxB
stSuzDBHtJs=
=FOz8
-----END PGP SIGNATURE-----

--=-bbkX942M1BlA6SJNGvGs--
