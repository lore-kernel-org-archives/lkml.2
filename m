Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab1JQRu0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 13:50:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab1JQRuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 13:50:24 -0400
X-Authority-Analysis: v=1.1 cv=Aw1K5MWCW/IlYLbVHOK2DHmxtnIeftPoAvmBFvlQMWA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=1n_aCQG_HIAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=6mhVOKAK5VsHKCYgvAIA:9 a=QEXdDO2ut3YA:10 a=DuNTH6L0kwtPnYt88s4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111017174938.842273454@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 17 Oct 2011 13:49:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL][v3.2] tracing: various fixes
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

Head SHA1: 436fc280261dcfce5af38f08b89287750dc91cd2


Geunsik Lim (1):
      ftrace: Fix README to state tracing_on to start/stop tracing

Steven Rostedt (1):
      tracing: Fix returning of duplicate data after EOF in trace_pipe_raw

----
 kernel/trace/trace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOnGrbAAoJEIy3vGnGbaoAK5gP/25s6Sk+BL38+gQJyNOLw69f
weiRjJClVsIy9/dV6hnzYPgADmo5F8xIXl3qO8lc+XgOLsSZHyEqtS3T9sr1nyZ2
b1b2cO8FHRHrdX6RiAEzml4LeZnywNXzO19VmVhu0SdvkhSqtZS7+OSTzIoB9QKh
sts8ChG4F3ejS5nrPIgQw5+L3SxPk7AYZM127I3/Vi1eHQeqbmh6ka7qsxs1IGqr
LQq1uQQMuEtZ4CmK2o4uFvqAMmhUXxSijLGHE3LITDVFcxACEngFZ766ndB8Defp
dcFg5mIsaHKJ09gHEQzHcIeSrmk6VJl1SfYhesev2ETXfx5RyJGf9cajF3uvKKkO
m4ZqqrI2ipNBBDCaXWrf4QQmMJofhigrJ8cqWVotS0OxXEeK50leS5BSTVUwSK6A
n5LfvMSDJFphbVM/KaGOC4mvukUM5GZ0BD2yqYmxq94og83G6WzcB/mqtdmnevhl
pVgJJ+bslsPJbfbpvHthIPACBYMN+B9FdOpcgIQQ5BAe4MeItGdcjkOhtdVbwi+d
FcFIRVZLpujk7CPl6lQTKMDAl7CTivfs95ZfpCaNY+WzpCQ86fkbvV65H4XYvl9H
LN9UtVd2Iarur7HDjcR+beOtr6Z5DyRG/ryFuMbJbJX5gTjoArYkQY75KB2VZYIh
kcQBDIUhVTZMa+TNLMyP
=akYR
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
