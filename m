Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab2GZN65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:58:57 -0400
Received: from nm5-vm1.bullet.mail.sg3.yahoo.com ([106.10.148.144]:29415 "HELO
	nm5-vm1.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751040Ab2GZN64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:58:56 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2012 09:58:55 EDT
X-Yahoo-Newman-Id: 398355.98879.bm@smtp159.mail.sg3.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: dPx0dNIVM1kC8fj1lWJ9pvTXK5MSaj7yd0pnuOcK457HX2E
 Wnk0loYs2W.i7_HO0AoTK9NMZfx3YC27LctMKmH0S5KteQzBpLQtND1d3qds
 RASHAA5Ws2DvjQYnFjbLf77ey5TyilQQFqzI.Al4uO6_J7vGiyg8Jpu4CgUp
 BOWp3g6AZrexeVEzbWpqmrdxxSsHUAKHGYUlXcRNigkt1..zrfQA5Dr91vJm
 PAybU9n0BA1dhK.z8zZSnC9wkb7s0RbyENQNMIz5AAC0aVZKB5WApwEQdqYU
 VtqcenE5EeLqYj_CyZ0iCAgfjoKxV0oDOt58bo8EffTqjHXSVSGFA7L2OHkC
 aoq8V.v8wv5FXwXjNntDtcAG03MEIZE892O8MRM2RH6G9KRKSFks5Pj1pRV5
 TBv76Yz7O3j5IksRDKI5O
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: acme@ghostprotocols.net, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH]net:appletalk:ddp:fixed coding style issue in net/appletalk/ddp.c
Date: Thu, 26 Jul 2012 19:29:02 +0530
Message-Id: <1343311142-4539-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue relating to switch  and case
statement in file net/appletalk/ddp.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/appletalk/ddp.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 0301b32..c8bbcd2 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1798,7 +1798,7 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 		/* Protocol layer */
-		case TIOCOUTQ: {
+	case TIOCOUTQ: {
 			long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
 
 			if (amount < 0)
@@ -1806,7 +1806,7 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			rc = put_user(amount, (int __user *)argp);
 			break;
 		}
-		case TIOCINQ: {
+	case TIOCINQ: {
 			/*
 			 * These two are safe on a single CPU system as only
 			 * user tasks fiddle here
@@ -1819,27 +1819,27 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			rc = put_user(amount, (int __user *)argp);
 			break;
 		}
-		case SIOCGSTAMP:
+	case SIOCGSTAMP:
 			rc = sock_get_timestamp(sk, argp);
 			break;
-		case SIOCGSTAMPNS:
+	case SIOCGSTAMPNS:
 			rc = sock_get_timestampns(sk, argp);
 			break;
 		/* Routing */
-		case SIOCADDRT:
-		case SIOCDELRT:
+	case SIOCADDRT:
+	case SIOCDELRT:
 			rc = -EPERM;
 			if (capable(CAP_NET_ADMIN))
 				rc = atrtr_ioctl(cmd, argp);
 			break;
 		/* Interface */
-		case SIOCGIFADDR:
-		case SIOCSIFADDR:
-		case SIOCGIFBRDADDR:
-		case SIOCATALKDIFADDR:
-		case SIOCDIFADDR:
-		case SIOCSARP:		/* proxy AARP */
-		case SIOCDARP:		/* proxy AARP */
+	case SIOCGIFADDR:
+	case SIOCSIFADDR:
+	case SIOCGIFBRDADDR:
+	case SIOCATALKDIFADDR:
+	case SIOCDIFADDR:
+	case SIOCSARP:		/* proxy AARP */
+	case SIOCDARP:		/* proxy AARP */
 			rtnl_lock();
 			rc = atif_ioctl(cmd, argp);
 			rtnl_unlock();
-- 
1.7.10

