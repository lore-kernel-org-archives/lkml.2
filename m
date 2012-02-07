Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2BGSS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 13:18:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41620 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab2BGSSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 13:18:54 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=ajHGbD3qle6C93n9BTwA:9 a=PUjeQqilurYA:10 a=BUzN4RBKcjHdvWWVaR4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328638728.2200.97.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.20-rt35
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 07 Feb 2012 13:18:48 -0500
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-61P5I3orfYqqNUndhiWT"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-61P5I3orfYqqNUndhiWT
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.20-rt35 stable release.


This release is just an update to the new stable 3.0.20 version
and no RT specific changes have been made.

New: As of this release, I am now using signed tags to mark the
versions, for your protection!

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: f1593eb51211386a945c895138db826ada428877


Or to build 3.0.20-rt35 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.20.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.20-rt35.=
patch.xz



Enjoy,

-- Steve



--=-61P5I3orfYqqNUndhiWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPMWsIAAoJEIy3vGnGbaoAe/0P/0G3XE/PUtsm5m0ySjECiCpv
KffsKDnEdBpX+qDWxV33IWumTE67xBN6urf35HQs3CxxfOb16MJh4qwI3i+ZWrqj
hSNZbR79w7Pex1QpACJ7j6TeoAZ6co6gSWLH/6Q4vD38tZc2vZ9hGrmQht9vZ6cJ
ezSoP38oERnbM22WdLZFmx271ZQZfTvl9rPunMr5JuFqbl/+JwRm7NdgO+hU1ITA
qqNkkJL2wEB+nlEv3ZBlKoXfePeia5gq+LIwf2A3PRUWubWguouyv6rfa5lTnoxF
duYq1+NiYvbFahMbIBzC8fPMlSSApe6Clqw6ZYQNb1qGoqJECRmg19Y8PXJKkaN0
YgstspfxzY2hUDn2aDbUB/rdaNOCly2zVvSGV/wwPV2tpTTYWzJYfveQX/3jjT9v
n0my3yLDKuRqE9zCFanwhrqU+wararwLGPawe3ONWggTk/lD7lZ5RfNo9PQBxnL7
l3nsi11PvLi/BPcNlHhaRcnHXZLFH4xiYuFmNrfqkVx4AnhIfBWHAomwCy6RbbE3
whbs/nGbV6isZEQbzU8DHcChmZIbamKOtIZZRQR1tR7HRleFEYlI7Ozr7v7eGurA
3BRuNF7qnGpaYDJzCUGLOymRYLjLYWpzE2hclPBvd5lbrqUj/83xueUCZXtEPRQ8
SHqKP4GRfut1D2vWPU/8
=RoJs
-----END PGP SIGNATURE-----

--=-61P5I3orfYqqNUndhiWT--

