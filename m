Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab2GHWfV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:35:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60033 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412Ab2GHWfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:35:19 -0400
Message-ID: <1341786908.25597.241.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Add to stable: tracing: change CPU ring buffer state from
 tracing_cpumask
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Sun, 08 Jul 2012 23:35:08 +0100
In-Reply-To: <1341243809.6578.5.camel@gandalf.stny.rr.com>
References: <1341243809.6578.5.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qKUTIzvThWLhhUSis2nV"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qKUTIzvThWLhhUSis2nV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-07-02 at 11:43 -0400, Steven Rostedt wrote:
> Hi Greg,
>=20
> Thomas pointed out that the buffering for tracing (other than function
> tracer - and other "tracers") is not affected by the tracing_cpumask.
> This goes back to 3.0 (and probably before that).
>=20
> It's fixed with this commit: 71babb2705e2203a64c27ede13ae3508a0d2c16c
> "tracing: change CPU ring buffer state from tracing_cpumask"
>=20
> Which looks to have made it into 3.5-rc1. Can you apply this to all the
> stable trees from 3.0 and beyond.

Added to the queue for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-qKUTIzvThWLhhUSis2nV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT/oLHOe/yOyVhhEJAQq9RRAAzwfE8Qhf6ydd0rOO8qbXguJEVPcbv7xe
064IfbOolOOcVyP3u0sv8cqYrErZNchS1Pzcvy0LAiOOGsT1RYAw5LzO/7rlFCxr
GMn6OXGwJq/6vzkOaYENygoWCnMcqJl35jiUY3gsKv7WGR8ga2uSHoPkGbpivG9I
j5YNyXd/StkHCG4wCjaP7FYCRe3hr0HzuqQW70xhMueU2MaLZyOZJXNRrlgEMADW
z476BsSEfnHCapJNhjSk0xsOmGdM1ygli6oeg03a9A3kPIryJO2QAsrKwTP5BKjq
wAxR8tP8+4kNJaTGlrQ2z1ar+W4AJCgIPoixdfHKTqda2NB/+5hdmvLhdcY/k+/t
YfRaZRrno33g4S6LYkGsNwB+d1G2E5qfhKxLFryk9lueCY5btouB56Y4u2K7vJVP
pskQHtePEL+sMico6q6QNIBqY3DvKAIqo+4mz4NMiA5XuJZqq3lqD6SlwHt8qss7
ZyYEw+SlF8bCWpJPiMEiaqdtK5g0Y+CYbXvsgMPXyKyxWMyzEvDOXbzLVp6O2Ip4
+38oNXItPnjKpWp0qyxVQK4pszsk5AigJGL8QHuTlBDbXWuxwwAU4RKhV522Df9k
yy9yxMsgbW/oP/mubB3XTztqGv8FlOOvaTfPD5em7eGCtT03yZICCddtYpCWw99D
lhvhZlYo+kU=
=BiaE
-----END PGP SIGNATURE-----

--=-qKUTIzvThWLhhUSis2nV--
