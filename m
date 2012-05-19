Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab2ESNgj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 09:36:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29159 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2ESNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 09:36:37 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=vidSgnMW4lsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=ZWxbHiaZoFvUiD13FUgA:9 a=QEXdDO2ut3YA:10 a=byh6GYkV50fI8VNPh_wA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120519133551.942867137@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 19 May 2012 09:35:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing: Some more updates for 3.5
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core-2

Head SHA1: 895b67fd5830ce18a6f1375a7c062fcf84b4b874


Richard Weinberger (1):
      tracing: Remove kernel_lock annotations

Vaibhav Nagarnaik (2):
      ring-buffer: Merge separate resize loops
      tracing: Fix initial buffer_size_kb state

----
 kernel/trace/ring_buffer.c |   41 +++++++++++++++--------------------------
 kernel/trace/trace.c       |    5 ++---
 2 files changed, 17 insertions(+), 29 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPt6HgAAoJEIy3vGnGbaoApTIP/29iHb0wIBv4qKmNI827z0Hu
XNfupNi22e0IZch4jlOJQK2XYbedkqzLUw0rLa/bzg+ZYY6Q9ywBPoGd4OUIQU5D
CtQ1612x+pP+dZR4gIIo6BWNcK31Poh/XbPgp1r94YW8DVUBlypAqady0b51c5b/
YOVmBgxKNBmW1VU7ZqpYaMoUunMYFN8bCst+aeIk+cEClxhWFeq+H9+VmpqEmDNP
nmPSCLLJGa4Cdzbwgcr8csci+GXG3e4hYFrOXfAQcsyfUW8Z+kAYD4+P+HUTHINd
3fI7SWBaPRc5kBl1Qt5YEXYK+qllKjafxrnRFaamcvJ8FlL5NtDCKlWKc6RSjQSt
tTrxyuka/Cqc9Fyx0p6uiOPYC237vA3Ynoi9AMIqPAyTmwBP2ysOJVwaXXoIbUIP
8ctq9eWWR3UFff+MLdg+81h3IPjrG+wBn3fyZMyC7YTFspAYaE8J208edGvWQeR/
2cnmmD3RM7AAq6+Ur1k+Pg8GyN21c/rr+/PxokeJJB2HUI5gTNeemq0ugMkquQrP
q4xE8JWSXczmz7UN8ZXWmk49fKLY3NY/i9skCh9klabxRtS5dcFuHmX7MuLoLnSI
uwcJAT5Rrdpy3tVghmEZnrsmTVLJ7VzkQVxiNYt8GdcQZJq+/Gmk2cHuNUeZIdL+
7MDl7yFr9kuCn/GxHDYV
=iSXs
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
