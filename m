Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab2A0VYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:24:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34605 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab2A0VYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 16:24:44 -0500
X-Authority-Analysis: v=2.0 cv=fNy7LOme c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=rSluXeX2CziIbHGJI_sA:9 a=PUjeQqilurYA:10 a=U62fhAwekXMA:10 a=nWoMcjXs0wmsNuVwmGUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1327699469.22710.144.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.18-rt34
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Fri, 27 Jan 2012 16:24:29 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YdON/u94hsA/cBF2dJMZ"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YdON/u94hsA/cBF2dJMZ
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.18-rt34 stable release.


This release is just an update to the new stable 3.0.18 version
and no RT specific changes have been made.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 913ca76d1bef978d0436da005aa378fbe2d3a0f3


Or to build 3.0.18-rt34 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.18.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.18-rt34.=
patch.xz


[

  Note: There seems to be a technical difficulty on kernel.org where
  deleted files are not propagating to the web interface. Expect to see
  old revisions on the main directory until this issue is resolved.
]=20

Enjoy,

-- Steve



--=-YdON/u94hsA/cBF2dJMZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPIxYNAAoJEIy3vGnGbaoAPPwP/0wpPFLlPlTJcpHuVka8CcHe
zoE2SbiA6Rn/fATW64L8tCaaWMzfQl/1yuqzWh4aLSgIpzwJBdI1yZjxNzzBseW5
/gGv5q8mwFiOYp2lz+lIxhV9DWqaCJa7LzLXVaDtuNqt4uwp3vh1nnvM54LZtAK+
eqcNuQJVzPQSK9BPJVmA1vqDhlbD7ohpYJ/huN/8s0bEvV8ysLm44c2hB02O8Rmb
o12nWy6aeKc2k4JI3yn2cbN1NY6JJP0KgLnR/hGUQ4CqvLzPnpBedT0vt3dtciDi
Y/TVDkY8gUDUkcRDlYx1ic7kaqWoUQRKyStaNdaJ23uuv+BzQwBTyi2Wk/dxBHqf
Hvko7ewfvE1IyXqhP7ruCvjHcFqDjHefQLctfE0FsrRlBxixJ2ldyvZIsLRNWsWS
8FHabxxh9t/7FNVnU24DNxJrUqQSr5f5F7JbVzLHrdKDHZrk0S07xospsXRGtQyi
7/JOZ0A3afb2/AYh904S5kvG+YKSubf8O3jalSBWpwDm7cxirpIlZgl6cneqz3G8
gI+yTGqH5GTE8rqFF0JYIwrE6766acJgu8nAyFaM+fuPpvSJeftJu+Ronoi0hbFy
uEY4EXcFoPDfEsO3EfJ51bhNrEln/5BImjnl9dDg1/RspNpfH0Z8xsTfZ83UHqRR
5rwCgybyQnDpYtsJN5Vk
=V1TV
-----END PGP SIGNATURE-----

--=-YdON/u94hsA/cBF2dJMZ--

