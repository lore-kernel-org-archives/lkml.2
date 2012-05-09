Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab2EIQ6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:58:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20353 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760328Ab2EIQ6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:58:40 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=Ciwy3NGCPMMA:10 a=THOoekfSB54A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=CyipOWeqcK1U5_xI49EA:9 a=38cZUK1O1tx6n8gYIBYA:7 a=QEXdDO2ut3YA:10 a=F9HfRdTyXtjHE_3f3voA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120509165751.114716410@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 12:57:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL] tracing: cleanups
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

Head SHA1: 68179686ac67cb08f08b1ef28b860d5ed899f242


Jiri Olsa (1):
      tracing: Use seq_*_private interface for some seq files

Minho Ban (1):
      tracing: Prevent wasting time evaluating parameters in trace_preempt_=
on/off

Steven Rostedt (1):
      tracing: Remove ftrace_disable/enable_cpu()

----
 include/linux/ftrace.h |    8 ++++--
 kernel/trace/ftrace.c  |   44 +++++++---------------------
 kernel/trace/trace.c   |   74 +++++---------------------------------------=
----
 3 files changed, 24 insertions(+), 102 deletions(-)

--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPqqI4AAoJEIy3vGnGbaoAgvIQAKvE9UDu6q9Vmp5j4ONz4Ksf
PyU3eL67MfpNQfQO9kHoQIIM62mwHJE7oVHmRc6gZUOJHl11Fg2rx2YeB51oiP9d
7wUszk/pFvAFXOIIktztxOkBOljY/H0/7h5yWb1uOOKbXodaGrS+QIlaXV79fpib
sqSShNyJUZ8UntrjyR3r5phk25atUXdMOFJlC5b2BQnRaazJEbDgWxnvAMhgU6O1
KuOG+0ruO3IAe+0hhvC1jQBlbajBDSds5SIP41McM+pr/Z8sqrEwVDXqdTpPrzOe
OoOrL9mY3rd5TQ3pmnRO87NFXpGUUmycE3ib+cw+wuLku9bgsKhHJmEymDeGZvcm
7PHLuAEtYijpEAUHLQT8PhArUgAEqka6PyNbVlk8wnelbgkP0odGeDflbMDohmWN
WXRc2l2wBRBApcucqGWaTRl8rOSaDu4DbtMphxObPRahhAoJaJ9abBbTwh7eAmGK
2IEzmJfqjVSeAxyXtCdPoqxKkXzctdWFhyGCICffSxEDVBncbS59qoPXk/ofNrQO
kzI3WwzGCaT2NObboQBkQsQxFPdMYgantkaEiyrgdvKtVikQlCJx+n+mfs32zPly
P6GAQALQZ9AGTTxcmfnvTQalTDsbXYqKaYuV96xm3TXoHE8dsPukX603oLl4ZzNC
Nzg53EzOZVZ8LMYacVx9
=Yzcn
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
