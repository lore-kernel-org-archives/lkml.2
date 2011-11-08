Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab1KHBai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 20:30:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35575 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1KHBah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 20:30:37 -0500
X-Authority-Analysis: v=2.0 cv=Pdt9d1dd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=8XkPlEVtC7cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=IaCMvrG4EfIXPwasXacA:9 a=QEXdDO2ut3YA:10 a=Zt83TyRLUvaKA0rBLHUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111108012939.372220547@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Nov 2011 20:29:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/10] [GIT PULL] tracing: various fixes
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

Head SHA1: 7e9a49ef542610609144d1afcd516dc3fafac4d6


Gleb Natapov (1):
      jump_label: jump_label_inc may return before the code is patched

Ilya Dryomov (1):
      tracing: fix event_subsystem ref counting

Jiri Olsa (1):
      tracing/latency: Fix header output for latency tracers

Li Zefan (2):
      tracing: Restore system filter behavior
      tracing: update Documentation on max preds limit

Steven Rostedt (5):
      tracing: Add boiler plate for subsystem filter
      lockdep: Show subclass in pretty print of lockdep output
      ftrace: Remove force undef config value left for testing
      perf: Fix parsing of __print_flags() in TP_printk()
      ftrace: Fix hash record accounting bug

----
 Documentation/trace/events.txt      |    2 --
 include/linux/ftrace_event.h        |    2 ++
 kernel/jump_label.c                 |    3 ++-
 kernel/lockdep.c                    |   30 +++++++++++++-----------------
 kernel/trace/ftrace.c               |    5 +++--
 kernel/trace/trace.c                |   15 +++++++++++++++
 kernel/trace/trace.h                |    1 +
 kernel/trace/trace_events.c         |    1 -
 kernel/trace/trace_events_filter.c  |   33 +++++++++++++++++++++++++------=
--
 kernel/trace/trace_irqsoff.c        |   13 ++++++++++++-
 kernel/trace/trace_sched_wakeup.c   |   13 ++++++++++++-
 tools/perf/util/trace-event-parse.c |    2 ++
 12 files changed, 87 insertions(+), 33 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOuIYyAAoJEIy3vGnGbaoAkdYQAI/ZnTCnwr4AiVddrOBxL5ev
6hxRgzCwGQbM3QRRM2f6zcZOS0/311H/ua2GRozsrMw6vZrNpP1fgohO7x6Xj2Fy
6Yg45oxhCiKegKV8dCw5xzKsNdAijd7RIgN9wcQmc2ibEzhmMq65HymFDrh9VtlX
CDdYCvTzatZBGWQQgiH/KkcBjRdljtxtZEdG6PSQNHyLKH58DvUErCnkiA0bmkZS
dRrkAL8ZgwPH7fuIPM2estvK8CoGK0mjWrFvI3GSvH9+JP5mJM+WTFu9Ec64kB6J
gt1OYjwaEXe667HYzo8QCOruxR4CVpkl8f6GmpZURC+S/qVsz0cipLzBZZl445os
RWP53PsHavxrE/JrOIkPmWMTtIAJdTMoxbOsnJCW8Mqf9j6qGfPDN3wl/S3fQ1Ln
iqJE6ERhdB4Dz7+YL7Aax3PxmzR2RfpiCkS49e2UbzhtARb+Z2wyn8hBtS405zbV
iToL6Vgorde5qUcjn9Eu8jhfIZu8ROJ5Q6PIif+yjuoV54Wc7ZzQquFijE/MkkhQ
5uwTmZzw/4S8SwCajCR1OVPzm0Mt2xMr+sP7BJseRKxV2YcMzqFevPOPAE4tqr61
9DSkjTOqSdQlh3KnRns1DzKNIS67Vro+vANvzw8jiVonpXn0d6rfXkmF6AUejcm4
wx1sc1gOVfhsLWrJ54WA
=UbDJ
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
