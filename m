Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758323Ab1KSEto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 23:49:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58339 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab1KSEsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 23:48:32 -0500
X-Authority-Analysis: v=2.0 cv=JOm5Qr2b c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=HgA2DzUFgX0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=E6QszT8yXth5kcjDwrgA:9 a=QEXdDO2ut3YA:10 a=_twGcrsKVrYA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=nnD5aEwFM-1NGth418kA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111119044829.193255499@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 18 Nov 2011 23:45:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, stable-rt@vger.kernel.org
Subject: [PATCH 1/5] softirq: Export in_serving_softirq()
References: <20111119044510.811163517@goodmis.org>
Content-Disposition: inline; filename=0001-softirq-Export-in_serving_softirq.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: John Kacur <jkacur@redhat.com>

ERROR: "in_serving_softirq" [net/sched/cls_cgroup.ko] undefined!

The above can be fixed by exporting in_serving_softirq

Signed-off-by: John Kacur <jkacur@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: stable-rt@vger.kernel.org
Link: http://lkml.kernel.org/r/1321235083-21756-2-git-send-email-jkacur@red=
hat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/softirq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index e8756aa..026a283 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -447,6 +447,7 @@ int in_serving_softirq(void)
 	preempt_enable();
 	return res;
 }
+EXPORT_SYMBOL(in_serving_softirq);
=20
 /*
  * Called with bh and local interrupts disabled. For full RT cpu must
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJOxzUdAAoJEIy3vGnGbaoA5hkP/RXE8dvtcVBBpJyu4QkXQfvM
XkWkzrLe7TgSkllTNgwYGjn2B/No70zEVe7q8Nwl5ng14dfUoBZAmMj3YJ1ILw5Y
k3+C2WOsJ018ZYdNdTm1GAEyvrXU86RV+KNl0TQnWhLbBK8rMVTXmkAOzoP6syAc
wMWqDUw0vGNZ0uCssbmzvu/QJD724Q/+hHKCP1ueW/Y3JNxTAPgJr+X9u+3YzlwV
Q2QeRDPR2H2XKjkKRBVag2Pk4Sz7/RYeM0XNEnIoDZZHK+/9F7jvhWajnQHgGq3+
c5/5cglFbwaWiixSpTsoALQB+d/ThfABO2FJ/KnV2nbV5nBnDxQ9GFrf5HdVr1L5
kJ/UFVz6pW+UoVplLAZNeVPdtRlDxhwNVjPKzHcuwKKexYCD+ztqhvJdLENIi5Wi
BEekFm+MOazanJzGJBQwaVWY36rYEVYLNqXgrWGfe039j/KibJgPJxvOqy91ROaU
GWIyiI2XmkwCm0jgM5U9xesOf5LKpyh3c5QyGDVi1usPsWY0IqB6CkyeKg8H8Viw
4UG26oXhz2EC3ZoxpHZ/1tWf+fz2NC+BQ6nASvNK5jrdEurK5eu1ajgLxyOgPaaE
5FWUqM+yDKsBLj1clkOhBFQ/7WrkZpJWkEBs2OJTTVLhtSMB1gnBQm/sI058t8yO
nPvl65E/lLKY8kT1yzmh
=xs32
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
