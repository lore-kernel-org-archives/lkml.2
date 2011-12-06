Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab1LFRqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:46:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:40775 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1LFRqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:46:09 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=fzZvDqAvlE4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=iivCRQBJSIEt190_c44A:9 a=QEXdDO2ut3YA:10 a=Yg41HxBTxSPRK5vh33YA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111206174537.048874021@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 06 Dec 2011 12:45:37 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] tracing: updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: 39eaf7ef884dcc44f7ff1bac803ca2a1dcf43544


Steven Rostedt (2):
      tracing: Add irq, preempt-count and need resched info to default trac=
e output
      tracing: Add entries in buffer and total entries to default output he=
ader

----
 kernel/trace/trace.c        |   90 ++++++++++++++++++++++++++++++---------=
---
 kernel/trace/trace.h        |    1 +
 kernel/trace/trace_output.c |   16 +++++++-
 3 files changed, 79 insertions(+), 28 deletions(-)


--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO3lTZAAoJEIy3vGnGbaoAyXsP/ia7r3RAW5ubs8ep+CFk0MkF
Cul9Gr0Zwf7ni5aiqxprasBrw8e5ocAl4pp9FfStIBpqdCstD/nVbRGwCTAK4tYf
rESvun5fufTym/PqJ/ZCB7GFbS/swQfvvEtv0bZRk0ijaVRPeAe3hNLJd1Crnq7Z
WTuEb7ERO2MiJbbB4phv85gaLY5oqFR6sMVNGhrZfdiV8pNdNsnwPGLq6EfkN8kI
Dzy+sjT4S+aG5ws7z7BkuQf1BNFUUc6V4bUjnHZnIVjf6pg4UsD5TbGl7BFqeASH
VkHNhCgJIy42Yh4vhAU0IfQ99XLsy8eTT2rj4yXfCG+3e7Um5Lij+O+23s3qOnO1
92q7JnC4sAhrBUWqzrddHgQBKz8QrYI2qyDWK0UuINCq9ZkX4yb/zXcG2323OLQt
rDkUFcK2pPRSDYjMT0TGS7PEPfe52eZgpAcOndbyahskw2t6AVyyz81+5E4pmSNm
DESWiIdSCqTxV4+/k+lYFs9COstPwIKs8NCBXy3AsLc908ZrYLpN2AOcRcD+36Iu
BM5rA0wF5hOLA6A/TAGAOVxqJKgg6FFHvUEoHT/1C4LO8cX9AnhCHyqcPlA+UsUH
jp0oQ2guJA3abv9cOlKEb60Gmch60PaDUatLXxIPoomccpKPm7bcDBZ5EniQCuZN
81YhIzE+6XdLOrIkNrO/
=5LuR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
