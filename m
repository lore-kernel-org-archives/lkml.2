Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2HDRX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 13:23:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36065 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816Ab2HDRXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 13:23:53 -0400
Message-ID: <1344101021.4642.187.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 33/73] x86, microcode: Sanitize per-cpu microcode reloading
 interface
From: Ben Hutchings <ben@decadent.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Borislav Petkov <bp@amd64.org>, Sven Joachim <svenjoac@gmx.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kevin Winchester <kjwinchester@gmail.com>
Date: Sat, 04 Aug 2012 18:23:41 +0100
In-Reply-To: <20120804160745.GA17188@khazad-dum.debian.net>
References: <20120731044310.013763753@decadent.org.uk>
	 <20120731044316.585695559@decadent.org.uk> <87y5lw73eh.fsf@turtle.gmx.de>
	 <20120803094314.GB31792@aftab.osrc.amd.com>
	 <20120803122727.GA32299@aftab.osrc.amd.com>
	 <1344094877.4642.183.camel@deadeye.wl.decadent.org.uk>
	 <20120804160745.GA17188@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MrwSXiB4czEW99dYqm80"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MrwSXiB4czEW99dYqm80
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-08-04 at 13:07 -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 04 Aug 2012, Ben Hutchings wrote:
> > On Fri, 2012-08-03 at 14:27 +0200, Borislav Petkov wrote:
> > > On Fri, Aug 03, 2012 at 11:43:14AM +0200, Borislav Petkov wrote:
> > > > On Fri, Aug 03, 2012 at 11:04:06AM +0200, Sven Joachim wrote:
> > > > > On 2012-07-31 06:43 +0200, Ben Hutchings wrote:
> > > > >=20
> > > > > > 3.2-stable review patch.  If anyone has any objections, please =
let me know.
> > > > >=20
> > > > > Alas, this does not build if CONFIG_SMP is unset:
> > > > >=20
> > > > > ,----
> > > > > | arch/x86/kernel/microcode_core.c: In function 'reload_store':
> > > > > | arch/x86/kernel/microcode_core.c:304:19: error: 'struct cpuinfo=
_x86' has no member named 'cpu_index'
> > > > > `----
[...]
> >=20
> > Thanks everyone for working this out.
> >=20
> > If you combine multiple mainline commits like this, the new commit
> > message should refer to all of them.  I've fixed that up this time.
>=20
> Ben, the backport is also needed on 3.0 and 3.4, do you have your patch
> queue available for download/pull somewhere?

This is in v3.2.26, tagged in git
<git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-3.2.y.git>.
I'll wait for Greg to generate tarballs etc. before sending the
announcement.

Ben.

--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-MrwSXiB4czEW99dYqm80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUB1anee/yOyVhhEJAQrhNw//Ypjh3EqgakUM0Js5n/agKrAOsXCguc83
a2Ecx9YmFXCMWKGcLCWTn43eraQucpXJSBqRDk5ShXS8Tf1sKrOnWEMZ3n/KhfrQ
rWq5Pp7C6VgnBwQBmjdw+Gf6vCkKWK6bu9QwMJE/15azW+AGmcv88ouVWBP8V09K
+FYYoWVQ99SAY0Pqsxa8OHOjRWTU/W1l9bXC/uY+0EtW6X6OVkzWKOguP3LIuJfO
P1CIvGwBWHdV6KMrZ+KK2Gaq6OAMJNfk1PlkMQ2Wq3dsfWF7z9E7CXI3jSV23ogj
6D+fC+o0SJDvyapOT6kP0D54btdmG9+lzZeVe9hS+2p/4uG4b2RhVMfKZsJKdpvc
jBkkBiBtTCQGlWkKH8WlEq2jK6D6ka3cf8laZbvYxa7wHqOHSN/1Ka2kzJ6rgA/4
C0qhNrkDMhjOESa4ok1UW08N8FwTs0ej5h/z8UsjxywoVYiSZRgfBKkyt+XBg5ZD
fpdMdOaT1oPRQKf/GvvwFYVi0QUS+1CL22MCV8p7+vcUVOFMTeVxs870PHFhAFY2
LCCtqrhsAFdBuPeJgg3+9BLzUdPBH+gqpDzgYk29KLim4XpBaP6XDl/i6uhfMJKO
VEq5ugB6ZkH4/CP5dkP/TwqDjzhg+gcFl0aBjAw6nnTtrfertGYASHaShwLfoEIM
ElUFky5zUYk=
=JQ4p
-----END PGP SIGNATURE-----

--=-MrwSXiB4czEW99dYqm80--
