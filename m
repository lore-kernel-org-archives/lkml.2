Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab2ENSKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:10:22 -0400
Received: from nm29-vm2.bullet.mail.ne1.yahoo.com ([98.138.91.129]:37274 "HELO
	nm29-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757033Ab2ENSKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:10:21 -0400
X-Yahoo-Newman-Id: 960874.79407.bm@smtp203.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IuLr8qsVM1l7wypVl46VA7gJojJ4jMMkfsgYP.vWOjQ8YqZ
 Xlzx3nqhVufHCAGSsx07TMcBVHRyZFA4oayvfzb7nkH3wcQFK1meUeNrnfVM
 5.WXfpNyrQ5LkiUxpv5KTNqUJx4qL4Vi5amJ2ESgs_StvttI4WUMqXReeZct
 lEHPwXIsEsPeUMijlaoGSNTmzK192zXf_etJp6lFcs6_50DfX2iy_6lQ3QLO
 NBN8hGQYig.G84r9yDgU2vpL18M6T3ntlKU.RRm8vmvKSkZx0AsyhYuw75Xw
 Pn4S1OyDJyHOZ4FHX8QWIj2RrSoDd4YioE0FR9GQgyqKzrLKwDeRH_99YxbF
 WS5jA5Lxt0nXEZhqTcp2vnlzpEFZDXvQreWP9yUO72oNucBMUc4DPkhfbnHh
 LM4PBSiztn3GeVnX74OlJHqxB0L75IXsT2A--
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
Date: Mon, 14 May 2012 23:43:10 +0530
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: oleg@redhat.com
Cc: tj@kernel.org, akpm@linux-foundation.org, serge.hallyn@canonical.com,
        matt.fleming@intel.com, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: Coding Style fixes
Message-ID: <20120514181310.GA29674@debian.Jeff>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hello ,

I have worked to fix coding style issues
relating to spaces in kernel/signal.c


>From 9bc77e7c5c6a5c8cefb0ed560a97ed3b2df3d269 Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Mon, 14 May 2012 19:38:55 +0530
Subject: [PATCH] kernel:Coding Style Fixes in kernel/signal.c

Fixed coding style issues which includes ~ and &
operators in kernel/signal.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 kernel/signal.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d9bcff9..664df40 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -104,20 +104,20 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = _NSIG_WORDS, ready = 0; --i >= 0 ;)
-			ready |= signal->sig[i] &~ blocked->sig[i];
+			ready |= signal->sig[i] & ~blocked->sig[i];
 		break;
 
-	case 4: ready  = signal->sig[3] &~ blocked->sig[3];
-		ready |= signal->sig[2] &~ blocked->sig[2];
-		ready |= signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 4: ready  = signal->sig[3] & ~blocked->sig[3];
+		ready |= signal->sig[2] & ~blocked->sig[2];
+		ready |= signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 2: ready  = signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 2: ready  = signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 1: ready  = signal->sig[0] &~ blocked->sig[0];
+	case 1: ready  = signal->sig[0] & ~blocked->sig[0];
 	}
 	return ready !=	0;
 }
-- 
1.7.10





I have also added patch as attachment.


-- 
software engineer
Bohr Lab
department of computer science
Rajagiri school of engineering and technology.

--4Ckj6UjgE2iN1+kY
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-kernel-Coding-Style-Fixes-in-kernel-signal.c.patch"

>From 9bc77e7c5c6a5c8cefb0ed560a97ed3b2df3d269 Mon Sep 17 00:00:00 2001
From: Jeffrin Jose <ahiliation@yahoo.co.in>
Date: Mon, 14 May 2012 19:38:55 +0530
Subject: [PATCH] kernel:Coding Style Fixes in kernel/signal.c

Fixed coding style issues which includes ~ and &
operators in kernel/signal.c
Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 kernel/signal.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index d9bcff9..664df40 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -104,20 +104,20 @@ static inline int has_pending_signals(sigset_t *signal, sigset_t *blocked)
 	switch (_NSIG_WORDS) {
 	default:
 		for (i = _NSIG_WORDS, ready = 0; --i >= 0 ;)
-			ready |= signal->sig[i] &~ blocked->sig[i];
+			ready |= signal->sig[i] & ~blocked->sig[i];
 		break;
 
-	case 4: ready  = signal->sig[3] &~ blocked->sig[3];
-		ready |= signal->sig[2] &~ blocked->sig[2];
-		ready |= signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 4: ready  = signal->sig[3] & ~blocked->sig[3];
+		ready |= signal->sig[2] & ~blocked->sig[2];
+		ready |= signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 2: ready  = signal->sig[1] &~ blocked->sig[1];
-		ready |= signal->sig[0] &~ blocked->sig[0];
+	case 2: ready  = signal->sig[1] & ~blocked->sig[1];
+		ready |= signal->sig[0] & ~blocked->sig[0];
 		break;
 
-	case 1: ready  = signal->sig[0] &~ blocked->sig[0];
+	case 1: ready  = signal->sig[0] & ~blocked->sig[0];
 	}
 	return ready !=	0;
 }
-- 
1.7.10


--4Ckj6UjgE2iN1+kY--
