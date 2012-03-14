Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab2CNQ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:27:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8449 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2CNQ1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:27:09 -0400
X-Authority-Analysis: v=2.0 cv=M9vP2lMs c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=ionfnHfdktEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=TH1ro5v78ME8-8FJhMkA:9 a=QEXdDO2ut3YA:10 a=xakzpCPHOE5cBoZ3_boA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120314162629.118638243@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 12:26:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/6] [GIT PULL] tracing: updates
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

Head SHA1: 37d73998920859784e6504462a2fd5f52cc08051


Gerlando Falauto (1):
      tracing: Do not select FRAME_POINTER on PPC

Jiri Olsa (1):
      perf: Add ifdef to remove unused enum switch warnings

Mark Brown (1):
      tracing: Fix build breakage without CONFIG_PERF_EVENTS

Rajesh Bhagat (1):
      ftrace: Fix function_graph for archs that test ftrace_trace_function

Steven Rostedt (2):
      tracing/ring-buffer: Only have tracing_on disable tracing buffers
      tracing: Keep NMI watchdog from triggering when dumping trace

----
 include/linux/ftrace_event.h |    2 +
 include/linux/ring_buffer.h  |    3 +
 kernel/trace/Kconfig         |    2 +-
 kernel/trace/ftrace.c        |    3 +-
 kernel/trace/ring_buffer.c   |  157 ++++++++++++++++----------------------=
----
 kernel/trace/trace.c         |  109 +++++++++++++++++++++++++++++
 kernel/trace/trace.h         |    3 +-
 7 files changed, 178 insertions(+), 101 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPYMbYAAoJEIy3vGnGbaoAC1QQAI+gPV2ZPeYOcWF07h/oomAa
BPNz0m/BeukEaaFQ2QdxYVdc82e7ZdMcy2Ong2EKmQJDsaC9kIaRnkLu5+Q4te8Y
+40VyYPhbAKF3yWKO4oqc1655gdFvvgWBozY7HXndKz9FDCM0dJD7QLk9lciWmb5
qw+4ECfhrnb8PpiIV6YjOwHkEUcsY7xrXB3eoRkwOMeU/bzl7TEsRY0xFPBbMDg+
J8Z6XO/QVMm6Cm9Br/bHAodShTwMDE/bqlErbq4F77yWB1/z+yZbgXnTPVMDRMAi
e4awziF7SnJwjOpiPpYeuvKQDOGj3KFp3cdo33XFjMQNAs2yAYTDGxjLx1nbO7ys
fE+swnyWY+1JXvBQ7IRtxd4sNmUvoawGpXdfknUso1PZeM02FV9OSum1NM6FQxw9
mJTnlNLAFQWLSBaMKA3M6XTRDiBqekF6QqTlF3zIO2SBAWQ5brNcHPajabHamX2v
uGMbidi4S5TghpKc55OBXAO05yClb75aSjPAcV5iuH0cZByKJsnqWLZDhWBJmrTx
xCdSK4oksTOLPelB/DEiUTaceAkxOF+dWevkSfdxTGOzcTChNhq9TXDRScYrovRP
qUIUj02A8bvQ0OenZG2GIZS9gwPfUDSno1NTyhQqvWjP5vJ9Q96dFVfQoJzcRLSB
N6peRGnwskQPw7s4sfIO
=+n01
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
