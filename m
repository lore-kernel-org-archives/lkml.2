Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2HGWDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:03:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2HGWDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:03:06 -0400
X-Authority-Analysis: v=2.0 cv=Vb91zSV9 c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=Ciwy3NGCPMMA:10 a=THOoekfSB54A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=dJtu6xiJMSMGMT0oQlcA:9 a=QEXdDO2ut3YA:10 a=i4N6s4qCs0cYbZdwA5IA:9 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-Id: <20120807220106.459308722@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 18:01:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL] tracing: updates
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

I based this branch off of my tip/perf/core that I sent a pull request
for earlier.

Please pull the latest tip/perf/core-2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/core-2

Head SHA1: 87abb3b15c62033409f5bf2ffb5620c94f91cf2c


Jiri Olsa (1):
      tracing/filter: Add missing initialization

Steven Rostedt (1):
      tracing: Fix wakeup_rt self test on virtual machines

Wang Tianhong (1):
      tracing/trivial: Fix some typos in kernel/trace

----
 kernel/trace/ring_buffer.c         |    4 ++--
 kernel/trace/trace.c               |    6 +++---
 kernel/trace/trace_events_filter.c |    2 +-
 kernel/trace/trace_selftest.c      |   27 +++++++++++++--------------
 4 files changed, 19 insertions(+), 20 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQIZCUAAoJEIy3vGnGbaoAohMP+weoLActOsjggETnblTLg0MT
HNqJq9d1wNAr7LMgupPN4ccuwzK9l/5PjR4a7c9Af3yV0S+w827YauKHeImMX59e
GjXonoHEfqlCUNwsLKMWn/KS37S9Q5cabZEEkbp6BuWCGg18kMGowE5QLVP98P3R
WvYs0+VNOH9SnAU+4Ieg72TaFbm4p1oHGFfQ5ttTCuVrtOoglghN3Fj5RjGKkIpM
HMZn3JwSk/H+BUZOFG5E/wTgkmPVXH9du5iO/GWOU4W6ZDC+1ejmUTyJrk6SNKsP
FaBjTOkkdp6sbL+O/qiDpiZvphY7zUCE7wgnHUO5H3IeIGif+ufsnqdPnOUocAiY
DYfHft2O2EQOwlln3VWqnQrJRqiZrg8nt09AJfJZdunDTidPulOeJEAlr+BUadYC
6QsUK6K4u/Gg1+MDgZ9UbnrwPlSgKMGl5flKJZxWPPlFHWD0MDTKDRWHLssy8Lmt
zliUF9Ti8ryvsjgSSSjfkg966Yuk840xX+dALt/8VIiYwwDpXmREGC4rsl5RH3lC
LgTuF+PQdMofd+3N1fuQip10exfxx15tTeBp7SAO33LDvN5weZUlBlnPGYB32R7j
NxAyaW3MmDnEp5yycUS5sho55lhHklA8se9S55kuiCMymmghH+cgeyc+uvl/Y5IX
ZTl7dibQVCFFaLyCaTWi
=Ec8n
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
