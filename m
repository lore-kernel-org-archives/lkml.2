Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2DQXbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:31:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6100 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab2DQXbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:31:41 -0400
X-Authority-Analysis: v=2.0 cv=V/z/IJbi c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=7v9e2qeAc1Dr3LQNlgkA:9 a=rTplhdVaHLhmt8HBU5cA:7 a=PUjeQqilurYA:10 a=la6zTIh4MPTC56xj:21 a=_JPNA_ktIFAgdV_X:21 a=MH3kH2RzuZkR67EXJs4A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334705497.28106.21.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.28-rt48
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 17 Apr 2012 19:31:37 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-i24BVVYCfuJln+0fVXco"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i24BVVYCfuJln+0fVXco
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.28-rt48 stable release.

As this only was the change to prevent open source developers from
getting eye cancer, I did not make an -rc release.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: 66fa19445508970d68bb4b0ee3418be3af8378fd


Or to build 3.0.28-rt48 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.28.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.28-rt48.=
patch.xz


You can also build from 3.0.28-rt47 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.28-=
rt47-rt48.patch.xz



Enjoy,

-- Steve


Changes from 3.0.28-rt47:

---

Steven Rostedt (2):
      rt: Make migrate_disable/enable() and __rt_mutex_init non-GPL only
      Linux 3.0.28-rt48

----
 kernel/rtmutex.c |    2 +-
 kernel/sched.c   |    4 ++--
 localversion-rt  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
---------------------------
diff --git a/kernel/rtmutex.c b/kernel/rtmutex.c
index a02fbd9..d58db99 100644
--- a/kernel/rtmutex.c
+++ b/kernel/rtmutex.c
@@ -1282,7 +1282,7 @@ void __rt_mutex_init(struct rt_mutex *lock, const cha=
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
index df30481..ed34335 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4255,7 +4255,7 @@ void migrate_disable(void)
 	p->migrate_disable =3D 1;
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(migrate_disable);
+EXPORT_SYMBOL(migrate_disable);
=20
 void migrate_enable(void)
 {
@@ -4307,7 +4307,7 @@ void migrate_enable(void)
 	unpin_current_cpu();
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(migrate_enable);
+EXPORT_SYMBOL(migrate_enable);
 #else
 static inline void update_migrate_disable(struct task_struct *p) { }
 #define migrate_disabled_updated(p)		0
diff --git a/localversion-rt b/localversion-rt
index 8a777ac..2470798 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt47
+-rt48


--=-i24BVVYCfuJln+0fVXco
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPjf1ZAAoJEIy3vGnGbaoA834P/1dbBh507ARFLqYehNEMNKUC
gke8vt23FlEV3poHPTAN/fbULEnvX0K9Czus77Vcy3CL/gwNbtIDVrV3hA28N4XN
OISt7Q5tUmtzhZNr0QL39Iig2HFecHrtD5xLnMtNxqNFaK6/xOIFPMiMkrmXOEFg
Wd/L/TUdNMWrA6tegWinPH16fKUfWfC1GKlhruaG7aQzMdJKWKNtsuGouFT7y+IP
94wS4wEAi+u46jwhRnaKC2wj/0MB/iHyquXORsFIB6lvWmEJxBMq0SvLuHns6gnt
vSbTnICYA4hs/UPY7nQtpceA/su/ksMiPOYgRmhBKs6chGGrN/6ym88DtPj3K2kA
Oh/PW9UkX3B8YhvjyxPLeGqPuOcrDevMQ49haQakQyQlP6DEZacB4XaQRdKLEvlP
b+2OiDPV0EGarW13tLaT5V5RIWD6T0HdSOF1Xfh4Uma2ZBXt70/hFeFKQE42eaQz
n02QMzTOIxCYM5YmQ+rr7nU0AJ0spbHGamGvh5SirvnKCDoBMY5RTY9w4KQlwgSQ
BK8u2JTBGkmFq3u6pwzyL8goBHDBn2EEJIvAEfV5FcW8CPPHJJcvB34RTo+gdYi4
0XcHTq8HhAhW/thIjit55ITnA8EZ1CYuZw5bDYl/VSsY4TFqba+kF9cOYTnvhYCd
tT6RRrZ7ipZqcsZa+izQ
=7Dlg
-----END PGP SIGNATURE-----

--=-i24BVVYCfuJln+0fVXco--

