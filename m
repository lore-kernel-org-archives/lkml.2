Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab1KWBNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:13:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1KWBNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:13:30 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=Bbu0zL-2RVd17FYs0TsA:9 a=QEXdDO2ut3YA:10 a=Uampn9N0VKaof-Rmp5cA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: [ANNOUNCE] 3.0.10-rt27
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Clark Williams <williams@redhat.com>,
        John Kacur <jkacur@redhat.com>, Carsten Emde <C.Emde@osadl.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ImDl63aVV+TY23PrSUom"
Date: Tue, 22 Nov 2011 20:13:25 -0500
Message-ID: <1322010805.20742.40.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ImDl63aVV+TY23PrSUom
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm please to announce the 3.0.10-rt27 stable release.


This release is just an update to the new stable 3.0.10 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 834acb9bfe2587dccc9f9ecaaa95edf41cf4a188


Or to build 3.0.10-rt27 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.10.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.10-rt27.=
patch.xz


The broken out patches are available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patches-3.0.10-rt2=
7.tar.xz

Enjoy,

-- Steve



--=-ImDl63aVV+TY23PrSUom
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOzEixAAoJEIy3vGnGbaoAYjMQAIURr+tA+OgljKUUqXyyJBgI
dFfwUaHwUa1/Q3G4S2LpbOgQBxwdTecGJBhCPUjx+FdnPjL8n1UqHTvIGdZMPsDm
YqB5T4gCk5CJ7A6jKAGGcFjH91L1uY2wnr9/gkprC5TMrVvwb5UiTf1czwYY3SlC
6xEEU+ZTqpX0vgx8tg+Jksh8YMRlhjKJNTgx+EO5ltKeF0Ji2CyzNWMszAWzW4Q2
Kq6ucCa5BuIawbWMzW2L3FYqBDO5uR6/vN6EoyDGpqCb1T2X2a7GA8jzmsfYiKGq
lffURD9Y6IlxddUwZknbSfAoVXds+Ya/wFe+zYcrf1VqWIzkhXFy8jUW/EVSYwvE
gK5jAmctZ0fu62jQUmeJg8cZMr8y1Oxr/Qrv7TUyuFkHFI2rDqhFfkthfB9yHchB
59xChjOdqINHeXOg/CRgkSgonw3/4wXROYEwAph6rSYXdd/m5xIPf9bHc2yBrjKS
oYLt/q5iuRBlPfrdS3tErS2wk/jkTl5TCf9XOclNFfCPKteCPmFaO9k3lPfE/1R3
qjKnq/FR5WBPyffsm/PS8uwPbyWwKqwrOFdlWZXO3f9fsfN7pG4raTslmdQ3cnjm
8VVRWjinaTazIPqp0XFhBIoszbo97yv6+rgaC5/tUzojuWgxU+JZMyMr2phctaKb
oicaX3RH8FN8vo3Xgmjf
=lKsy
-----END PGP SIGNATURE-----

--=-ImDl63aVV+TY23PrSUom--

