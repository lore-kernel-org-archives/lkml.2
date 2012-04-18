Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab2DRBFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:05:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2DRBFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:05:43 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=Qh7Tj8gY4fkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=1XzHP3DZ0q7-qhXZCWQA:9 a=QEXdDO2ut3YA:10 a=znA88lcP4TIvJ8VPP5cA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120418010505.756823546@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 17 Apr 2012 21:05:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][v3.4] tracing: fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 348f0fc238efb441a28e7644c51f9fd3001b228a


Mark Brown (1):
      tracing: Fix build breakage without CONFIG_PERF_EVENTS (again)

Steven Rostedt (1):
      tracing: Fix regression with tracing_on

----
 kernel/trace/trace.c |    8 +++++---
 kernel/trace/trace.h |    4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPjhNiAAoJEIy3vGnGbaoA9VEP/3Q/+FfM9jF+WpjPBZw1CuRE
MVOAOPvAHX9VTuguJCcjCB/nGS2d+adJRmBVNp79Y8QyEM1ZVAhTBJrDAZgI5JfH
v7RmYpWLcUERf46TLjf0vNNph2TZxmR9lEPDToEcCYlpM7hQUwnU2ChUfjJEPthv
2Yjanq2rJKUj2Uhm25T6GtJnn0cuDNukaJud4QfbBPzVaqzaHx3+28dbZ0P09KpR
1JRbkDbWhPfDfRC5WYJpkeo+efttGVT/3M80mZ+dsYNzRneZplCSTCWTy9yk7Kl9
XRY/56aF8eBl1oOXdEOlm2D/MBdahXgmBEbSdQy1CuGdLbshvmbljp412g/1zq+r
1/3FEDoQ4T5XPOvR0T0ddsqIsEoeQ5SmSkHPk4+9ogMib+qcOhWvgBxgjUrWH3m9
4B3rPjErMjT7CfLPzr65N0KtjWpNJ5ygzzRJ/ySLPMjQYTKlynDJnU3nf295V9FF
MvUIGjilHca3UCh+JWxNgHZ7HuqiC1oL4zketYm6Tq3CKiLJNBOFYKlcz8/dh0pc
bF7xli4lHtMRzwvmAZ0QkAuN32dBNUcw2NvS6zijBJNbV4aT6wa2dR3wwcG/LvZN
QK0bU2GhTdoFgnUZyPHNBc6MdupBzmp2Q2MaUPF4G20LK79LF8myJl1govW21QM7
1HGhHIhddPndgOrTaKdF
=Kxaa
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
