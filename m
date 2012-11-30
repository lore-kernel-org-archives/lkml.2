Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab2K3QNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:13:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19490 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2K3QNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:13:35 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=fdtXn3S6amMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=aDA3pSgLrtQA:10 a=VwQbUJbxAAAA:8 a=18heT4DauCcgxvD42rcA:9 a=QEXdDO2ut3YA:10 a=jn8PyOhqdslawfSEV38A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20121130161238.909829067@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 30 Nov 2012 11:12:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][v3.7] ring-buffer: Bug fixes
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This is based off of my last urgent pull request.

Please pull the latest tip/perf/urgent-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent-2

Head SHA1: 9366c1ba13fbc41bdb57702e75ca4382f209c82f


Steven Rostedt (2):
      ring-buffer: Fix NULL pointer if rb_set_head_page() fails
      ring-buffer: Fix race between integrity check and readers

----
 kernel/trace/ring_buffer.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJQuNsrAAoJEOdOSU1xswtMxVkH+gOSJdjVa0PBgnhh5XHMqFn4
UcJG7FElYuB0t3J3kX4ZuFd4bThvF+PByE2Up6qbnQ1EgLQdhZ0QBX26qtU1o/l6
xEexNXyD6q650+Hh8Uq/WKaPf22QXX17X7EIgSwMsq0Ngqaslo1IJBpvTMvSFw+F
31xdluvW2gOaRInFmimW+CVwd3TAmxxqftt/g1Sa+OiIP2gtPlrI+Ar90o6ipOnZ
101Kjk4VHMoeeE0GLlv3wsXvydvKRBeQSxDNJwq97k4ybQ2kEBe33t0OMJ7t+/Qu
n/NLN+XL+waSnKS0yd0LPr/z6vLMW7+1MezuQ7F6hTj38qbhy40XBqN1FcJSSXU=
=m20B
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
