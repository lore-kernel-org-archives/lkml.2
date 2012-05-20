Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2ETS01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 14:26:27 -0400
Received: from nm24-vm1.bullet.mail.ne1.yahoo.com ([98.138.90.45]:28331 "HELO
	nm24-vm1.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754402Ab2ETS0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 14:26:25 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 May 2012 14:26:25 EDT
X-Yahoo-Newman-Id: 577193.26313.bm@smtp107.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ILor_dMVM1nm6CK1Wp4f7Y1uKQTBHGOrYLxXa_ZOS8USwGu
 ZQA65zhI.I3h6YMr42mYoUhwDWVg6ZfZPJ02w_eE4ifVAAtBZqnvGw37pJyx
 YYVGY4bMLaqm6u6imM6WkrC2lTrkwYTFLwfhR1VbEt.FJcQDrA838O2uYwU2
 N3PfYMQYQrUyEGlPZajE4EGHfkIXt9OJnPX2rJ16a7SPxTt4EPJkRdQMnFte
 kH_nBo6AQh3S3p.6yafocPjzBpfWiEDnYiub.d_VQ9V4ZQp3hQpc.1UY2Rpw
 4fv8K0iP534DTZABM6Bg1Vx7kM43R_Q0o27cTHgSSQFkIHSco57z4ryaq8HF
 cSDpqRHytanHKu5EeRT5AQiUmuVRJ8cvP7kL8.84sBYJrJqmOaj4no3ZQxyJ
 OQjdBmsBbrTzeovAJzoyz7TdIS1Fci4jyXzyf1B2PhXSJngnSzl2xP1zHLSY
 tB2uPimloaBpi.B6jVzppOn9cOxOJ1NQrycVffOpW
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: sds@tycho.nsa.gov, james.l.morris@oracle.com, eparis@parisplace.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH]security:selinux:fixed spacing issues relating to : and ? operators.
Date: Sun, 20 May 2012 23:53:49 +0530
Message-Id: <1337538229-4784-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing issues of : and ? operators found by
checkpatch.pl in security/selinux/xfrm.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 security/selinux/xfrm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
index 48665ec..a3cb878 100644
--- a/security/selinux/xfrm.c
+++ b/security/selinux/xfrm.c
@@ -140,7 +140,7 @@ int selinux_xfrm_state_pol_flow_match(struct xfrm_state *x, struct xfrm_policy *
 
 	rc = avc_has_perm(fl->flowi_secid, state_sid, SECCLASS_ASSOCIATION,
 			  ASSOCIATION__SENDTO,
-			  NULL)? 0:1;
+			  NULL) ? 0 : 1;
 
 	/*
 	 * We don't need a separate SA Vs. policy polmatch check
-- 
1.7.10

