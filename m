Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1JJTTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:19:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42066 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1JJTTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:19:45 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=H1zryveoUAkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=VwQbUJbxAAAA:8 a=3V_rlhLjQevajWywIDUA:9 a=QEXdDO2ut3YA:10 a=hs_c0DZc4ODRiN-ZEdsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111010191706.044816068@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 10 Oct 2011 15:17:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 0/2] [GIT PULL][v3.1] kprobes: can cause perf to crash the system
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Ingo,

I tested and verified that the commends that Masami has shown will
crash the system. These patches do fix the problem.

I also verified that the same commands will crash 2.6.39 and have included
stable in the Cc of the commits.

-- Steve

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 44a56040a0037a845d5fa218dffde464579f0cab


Masami Hiramatsu (2):
      ftrace/kprobes: Fix not to delete probes if in use
      perf probe: Fix to show correct error string

----
 kernel/trace/trace_kprobe.c   |   58 ++++++++++++++++++++++++++++++++++---=
---
 tools/perf/util/probe-event.c |    4 ++-
 2 files changed, 52 insertions(+), 10 deletions(-)


--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOk0VPAAoJEIy3vGnGbaoArgsQAMlDOLIAHmcRpubShnNiMJQI
9Gpzs99zh6ZPvtqlNuVBWGwKEuStw7yk77W6jrjqDEEG3blCHga/irUyBe6Y2+59
I2SKdINRAIxeQ6J/JDEgai0xZYGuZeD2uWo/vRYr/aPbQ96FLbM4SvnbE83beANU
qYAHrKUSCfOzzYAm32FYYcm645fI5I1bxfgfkcST8nCqTEhAZoddVwCa2MLF0fET
jpFFBTvoRlGv0lzfGXRzxW4tF0pCmBt1eRQPF6b63x7ohBi3hEDMtrx/ZAz+eamR
2famYWu8Lhhe+9nTrihpkohr+97KbwaqGG/85WOazkEiOERNQdHIp7UDB0n9EP7U
yU1ZjavG68r5QSllfch1hcTQprXGCuA6zM4ppe9B5vye58mG8D+ByIaWAZKb/9ug
RC3aWpYywXkcs9A75cHl4WQHe3y8fKUZYNhmtYijWbqbbcQ7PAsEcf6FHpdWjkEc
RzjDi+DncoTxjxXvN3t/2Mlbn4HOkn3BEEsVTnXiGARBB8yfmMadJjvLJv65ERA7
1olCAAINKokptLcHV0h1PCT7O+oITDDBLXkW18PCZcTy+JGHGu4Uhnp9QYh/ct3G
6QecPFOWXvo2821gR+bjsjFnGCSl1yEsS5OFWx/eeIOTQqkc1egrCuc8Etw3nqH0
Id18wzzOXShy1MfdZ7QF
=Sn0I
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
