Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2DQUJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:09:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7005 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2DQUJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:09:28 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=7LLBJ7tCDxQ-ODnZV0QA:9 a=rTplhdVaHLhmt8HBU5cA:7 a=PUjeQqilurYA:10 a=mUV92dz4fC1ZTPsJ:21 a=4leRHVxf-KkwwC0-:21 a=e6kc2jDIFLb4p_FKBpsA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334693363.28106.19.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.2.15-rt26
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 17 Apr 2012 16:09:23 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-2NXAdE3WZ+NQH6xr8qUy"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2NXAdE3WZ+NQH6xr8qUy
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.2.15-rt26 stable release.


As this only was the change to prevent open source developers from
getting eye cancer, I did not make an -rc release.


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: e107fca256630137a81c3a41a8713bd287a9287f


Or to build 3.2.15-rt26 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.15.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.15-rt26.=
patch.xz


You can also build from 3.2.15-rt25 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.15-=
rt25-rt26.patch.xz



Enjoy,

-- Steve


Changes from 3.2.15-rt25:

---

Steven Rostedt (2):
      rt: Make migrate_disable/enable() and __rt_mutex_init non-GPL only
      Linux 3.2.15-rt26

----
 kernel/rtmutex.c |    2 +-
 kernel/sched.c   |    4 ++--
 localversion-rt  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
---------------------------
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index b525158..9c4f6e5 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1290,7 +1290,7 @@ void __rt_mutex_init(struct rt_mutex *lock, const cha=
r *name)
=20
 	debug_rt_mutex_init(lock, name);
 }
-EXPORT_SYMBOL_GPL(__rt_mutex_init);
+EXPORT_SYMBOL(__rt_mutex_init);
=20
 /**
  * rt_mutex_init_proxy_locked - initialize and lock a rt_mutex on behalf o=
f a
diff --git a/kernel/sched.c b/kernel/sched.c
index 1cc706d..3b12e0b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4426,7 +4426,7 @@ void migrate_disable(void)
 	p->migrate_disable =3D 1;
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(migrate_disable);
+EXPORT_SYMBOL(migrate_disable);
=20
 void migrate_enable(void)
 {
@@ -4478,7 +4478,7 @@ void migrate_enable(void)
 	unpin_current_cpu();
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(migrate_enable);
+EXPORT_SYMBOL(migrate_enable);
 #else
 static inline void update_migrate_disable(struct task_struct *p) { }
 #define migrate_disabled_updated(p)		0
diff --git a/localversion-rt b/localversion-rt
index c5b71f9..2e9afd4 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt25
+-rt26


--=-2NXAdE3WZ+NQH6xr8qUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPjc3zAAoJEIy3vGnGbaoAnNwP/3gUj8UtQzORzBBdUcJUSDFE
rNakjN5zMDbQnoXiSSTe9ZOd5WCFlkEek++C4TY4/ZrvKkgVTMwuP3L0mhIUzdCV
UpsgLDAKd03Tej+w7KGCImtXlJdtI02Vp+Nzj0uUSL8Dbht123q2r8T/6z2ZmhlK
Y/BnXGkpStI4BQYLyF5H144ku+M8150PZgPnSJ75m9L/mopQZ3NhTkIy6dXZcZZa
VA1+NWDRVztpbJ3Lc6OHBm/X1jdJrkGWQ67LtO4N5V72i1DXbNVst+fIr6YY+4rt
boafLNXCxoUXVhsDuskpm1+Uv3dlhb9aLxURc2+bPfPiPDGkKM36iRHkWRC2jroQ
/Bf7JS2HQiAsWeQaFAJ1hUTI7h/wT0K4dbYqoGkXq+tBLjEYkyw/uNeiVUEWrW8s
nY8A1/8tut0/4WOrPq31nCJXqa4EiJ9vORzVkCkKS6ZkBgdqMjbRLgzGUKsmqoI+
k26ub9m7cUwYQbkeV3HZdSyQkG4yR+znVXUemgBeIUQ1ekos8nzHn51EofZj7SkN
+cg/BmCC3OxvBMAbpuKjpSZAsfnpd69qC4kWHR79teZpHo4YVHE3656MQ+5VhKCF
bXGZ4hRkU14dP2VxGtONuFFqzrYzFW/EFK5t7uUAJqxB1I/fpYP8Vsfby12qdOWN
/X33MdDujn3bSurUXy+g
=oG0M
-----END PGP SIGNATURE-----

--=-2NXAdE3WZ+NQH6xr8qUy--

