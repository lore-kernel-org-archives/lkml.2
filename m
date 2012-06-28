Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2F1XSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 19:18:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32495 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2F1XSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 19:18:08 -0400
X-Authority-Analysis: v=2.0 cv=StQSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=wAt_MWTBGyIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=fFN1cMVGK_T8MDJQnQAA:9 a=QEXdDO2ut3YA:10 a=Jzcb_x8Mi1_Y0Vb0GSMA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120628231625.869980334@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 28 Jun 2012 19:16:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/4] [GIT PULL][v3.6] tracing: updates
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

Head SHA1: a5fb833172eca69136e9ee1ada778e404086ab8a


Namhyung Kim (1):
      tracing/kvm: Use __print_hex() for kvm_emulate_insn tracepoint

Steven Rostedt (3):
      tracing/selftest: Add a WARN_ON() if a tracer test fails
      tracing: Remove NR_CPUS array from trace_iterator
      ring-buffer: Fix uninitialized read_stamp

----
 arch/x86/kvm/trace.h                 |   12 +-----------
 include/linux/ftrace_event.h         |    2 +-
 include/trace/ftrace.h               |    1 +
 kernel/trace/ring_buffer.c           |    4 ++++
 kernel/trace/trace.c                 |   29 ++++++++++++++++++++---------
 kernel/trace/trace.h                 |    8 ++++++++
 kernel/trace/trace_functions_graph.c |    2 +-
 7 files changed, 36 insertions(+), 22 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7OYmAAoJEIy3vGnGbaoAXS4P/jT8Akoow9Kb7Et+iwv2P3Ii
kRnNxVXlxmNMAdkeLT1iAnNC2dkw/mqETHjyHDcDg1/eyYqotX2GaXNpr5GQYjmi
Bw1JAJg5WCVRY7fu8n8Y/XVnhD7CUHNlpa4mdTnoYgZvyvVlbxSWgyxX3vIiPYRE
NzfvE6ypwo5P9uxUuzs7poZX4YQQ/B0YPQRhz7K8uIvJ9lE/6CyiA6vOCSveWLRy
L1KlWUgnEhSrjr84WH2e9NfMnp3jPxeYpZe5i5jS4xO183D5BaZWHM4ZudQ+0eZX
pIdmuhtsb74elB8w/GeryLvJ+RaCK3w2IjbsqW9tcCZH75JW1iIpdwwZwNbQXIlO
1yIt6RgXQMVMmPB/FKIK/mqE5emn9s/E0QMBzEx/kJ6QUUwczWRY2rkDfz6BL4sL
VeHCV79R3G1U6n2ZXD90LWjud2bTrl+qc8xMiJUZwpLBcAX1TlHb8PWqNDT6j0XY
G7zaWy6BEXnaYYfZPGyHDZNQhtG8okB2cXVw0HJmy/FTfsqmitRx0t9mFX0MDp4w
iGtaGJDcfXRCUBdmQB1BJuiXxn4U0kR/vSsucWlpy9IgD/ye3zKQhM5d4IFvwAU7
lEPQOdIgP/pzCTvskPxilVRI1cg54bfaCsl6eTg8rqB5LZo30ASZ2YRhQXaGmLY3
INa6JwSWg0HSaoTH16qJ
=nJ0v
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
