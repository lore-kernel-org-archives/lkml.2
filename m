Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2BVOmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:42:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29839 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab2BVOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:42:10 -0500
X-Authority-Analysis: v=2.0 cv=Xp94yC59 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=Sim2o-h5SvAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=1Yr9rlLm2uZnw1dXXAUA:9 a=QEXdDO2ut3YA:10 a=VonN6afZ2SQz4VIQT40A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120222144036.824378742@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 22 Feb 2012 09:40:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/9] [GIT PULL] perf/tracing: fixes and add function trace to perf
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

Head SHA1: 5500fa51199aee770ce53718853732600543619e


Andrey Vagin (1):
      tracing: Don't print an extra separator of flags

Jiri Olsa (7):
      ftrace: Add enable/disable ftrace_ops control interface
      ftrace, perf: Add open/close tracepoint perf registration actions
      ftrace, perf: Add add/del tracepoint perf registration actions
      ftrace: Add FTRACE_ENTRY_REG macro to allow event registration
      ftrace, perf: Add support to use function tracepoint in perf
      ftrace: Allow to specify filter field type for ftrace events
      ftrace, perf: Add filter support for function trace event

Steven Rostedt (1):
      tracing: Don't use p->len field to determine output in __print_*() fu=
nctions

----
 include/linux/ftrace.h             |   73 ++++++++++++-
 include/linux/ftrace_event.h       |    9 ++-
 include/linux/perf_event.h         |    3 +
 kernel/trace/ftrace.c              |  117 +++++++++++++++++++--
 kernel/trace/trace.h               |   38 +++++--
 kernel/trace/trace_entries.h       |   54 +++++++---
 kernel/trace/trace_event_perf.c    |  208 ++++++++++++++++++++++++++++----=
---
 kernel/trace/trace_events.c        |   12 ++-
 kernel/trace/trace_events_filter.c |  168 ++++++++++++++++++++++++++++-
 kernel/trace/trace_export.c        |   64 ++++++++----
 kernel/trace/trace_kprobe.c        |    8 ++-
 kernel/trace/trace_output.c        |   12 ++-
 kernel/trace/trace_syscalls.c      |   18 +++-
 13 files changed, 667 insertions(+), 117 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPRP6+AAoJEIy3vGnGbaoASd0QALfueD4+iO1HCs7pagZvcxld
aNskSg5UktNnSTx9s+SPNHDHVAasARgeKgJOvl3DEritnwgt+LtvIjwZwbGR60Hi
S9CtXCpLWukY132OzfUvalFLbh/SnhbMSv6BTAp+A/iixt2172byTJ1rNT8SQSn5
dy4LcuhAtiPMha0qA2xQHU4K0fTZg0XQNYzBqieLjX8IHYgbZNKDXzNMKeeIaEvG
1ZL/CbJDvQ18ld0LA+sLTeiIONgFFvbwzSr7rrkGO94XKS8DO5x2MY2f7RDjfcm4
0QgE14DDS+Cvlpl7gPO7pdrkrFFgWFF/yuO9TYS+3LWQq0C5pThP8QKaZRkCYBxN
EUO3Kcrji5H+eHUNW5ULtkCLs0J1ZKnEOwnm/7F40mtGPTYETEtV+OlWAfz/R8q4
lOfWyW3VCka4BEIaMTpqryNBLc2OwFuy/v8mQ5qpXIzTe/C42nhlaZZ5lKF6zktW
XrcDOUOFxWyk9HG8qv5nF2RqfnHmXiGqrTvui9dRcMRHGVV/N08yFbRMlzA4Tbcz
eaTPKe1rBTqrLHIT17pqkmHVbl/di2IhQS3FAvk5GNVt+Ls69mu+uMRedMYdyHsA
LT3/HHgKvg5RCK5SEOHLrEoqszy1U60Ds1ozENCsSXQ2qRBAsVDV/NGtSvnFKLVm
WW7e1UvROgrfd/7vAC8D
=NiKx
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
