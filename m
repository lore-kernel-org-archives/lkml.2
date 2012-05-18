Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967232Ab2ERNKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:10:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11861 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab2ERNKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:10:49 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=PBMTFcUQrH0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=xhxp10SrCP8l0B6zuM0A:9 a=Bn5ogaBAa_D6PcerJFMA:7 a=QEXdDO2ut3YA:10 a=8Zei_r7EaOSdfo0PWvkA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120518130858.392919640@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 09:08:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 00/15] [GIT PULL] tracing: Updates for 3.5
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

This should be my last set of changes for the next merge window.

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core

Head SHA1: b732d439cb43336cd6d7e804ecb2c81193ef63b0


Namhyung Kim (1):
      tracing: Check return value of tracing_dentry_percpu()

Steven Rostedt (11):
      tracing: Clean up tracing_mark_write()
      ring-buffer: Add integrity check at end of iter read
      ring-buffer: Reset head page before running self test
      ftrace: Sort all function addresses, not just per page
      ftrace: Remove extra helper functions
      ftrace: Speed up search by skipping pages by address
      ftrace: Consolidate ftrace_location() and ftrace_text_reserved()
      ftrace: Return record ip addr for ftrace_location()
      ftrace: Make ftrace_modify_all_code() global for archs to use
      ftrace/x86: Have x86 ftrace use the ftrace_modify_all_code()
      ftrace: Remove selecting FRAME_POINTER with FUNCTION_TRACER

Vaibhav Nagarnaik (3):
      ring-buffer: Make removal of ring buffer pages atomic
      ring-buffer: Make addition of pages in ring buffer atomic
      tracing: change CPU ring buffer state from tracing_cpumask

----
 arch/x86/kernel/ftrace.c          |   15 +-
 include/asm-generic/vmlinux.lds.h |    2 +-
 include/linux/ftrace.h            |    5 +-
 kernel/trace/Kconfig              |    1 -
 kernel/trace/ftrace.c             |  198 ++++++++++---------
 kernel/trace/ring_buffer.c        |  394 +++++++++++++++++++++++++++++----=
----
 kernel/trace/trace.c              |   49 ++---
 7 files changed, 446 insertions(+), 218 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPtkpTAAoJEIy3vGnGbaoA4Q0QAIvKzRwzMjAdS6bvYJFmnwX2
z/PsgwxX7yeDIzS+ojMXOkwE804jNUbYS3ksRfTSsyNeEXCrByNzL7sn86dGN2zK
qBcgs+UOCn/UUbkZRfASnMdE5yIWHiMY9gqunTI4Xs9bM+fjI5J3+bBJl1S3FNMQ
Gr6Er3CWqD9JpyQtIRwzDTRwFpUDfGLEJWMlLGLkslFWD6l4itFFpIjvdQJPa/8S
I/BQwXIEk4YmBnIHEkofmgCIdcyjbMpx57+X79ub+ZNqkH4X3idKqGkU3lChgkbS
ujKpLKgE+Wf21Qy/ql9us+FMmXPKCBkzgxoJqfeRnajlsSHncosRPgEtzwLDKkwo
H2XK6vYyNfp+G+078NhurL+y/mk/8tHFVQ6YxNU7fs8t7eg55xVa6amyQ5iUj/NR
7wUBP95zB7hp7hzraertPqs0OajHnRRH300eIxUD/zQ8JH6BwuvUVHKDgnroNRKC
0U6nT0gd8HVZ4vycIDBzCZokWoBIT6SE7s6OEzkJbsqCXM+LsG7bSyXGz60wTZ1A
F9YUcnC0BLz4qprf09KKCcZOnBXUdZLqtUz6ir5hKG6UHQHrm3qoX726auAoJWNG
D1HujeDlPI5sPNIQ1R4ucgdnEBGjfI+SF3Lyi3/hPH5jMfTs0i7NFvhAXeBtmwe5
OMZr9zosMYwdqxAtcvdr
=7tk6
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
