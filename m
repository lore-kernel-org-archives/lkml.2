Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab2GLBP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 21:15:28 -0400
Received: from systemlinux.org ([79.140.41.46]:55549 "EHLO
	v3-1046.systemlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab2GLBP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 21:15:27 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2012 21:15:26 EDT
Date: Thu, 12 Jul 2012 03:08:04 +0200
From: Andre Noll <maan@systemlinux.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/16] sched: normalize tg load contributions against
 runnable time
Message-ID: <20120712010804.GN32601@systemlinux.org>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
 <20120628022414.30496.11931.stgit@kitami.mtv.corp.google.com>
 <1341431285.19870.15.camel@laptop>
 <1341575532.7709.47.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d1TbJDQJIIsIsPGO"
Content-Disposition: inline
In-Reply-To: <1341575532.7709.47.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d1TbJDQJIIsIsPGO
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 06, 13:52, Peter Zijlstra wrote:
> This then yields:
>=20
>   P(\Union_{i=3D1..n} u_i) ~=3D \Sum_{k=3D1..n} (-1)^(k-1) (n choose k) u=
^k
>=20
> Which unfortunately isn't a series I found a sane solution for, but
> numerically (see below) we can see it very quickly approaches 1 when n
> >> 1.

Isn't this series just 1 - (1 - u)^n? So yes, it converges quickly to 1
if u is a probability.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--d1TbJDQJIIsIsPGO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/+I3QACgkQWto1QDEAkw9MRQCgjbBcFHGJRWBBic4ujM6N4JGW
8XUAnj1cAp9ohrgVF0UnP1WKF5l7qyyy
=4HL/
-----END PGP SIGNATURE-----

--d1TbJDQJIIsIsPGO--
