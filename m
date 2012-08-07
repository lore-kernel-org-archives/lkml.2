Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab2HGOAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:00:07 -0400
Received: from nm21-vm6.bullet.mail.sg3.yahoo.com ([106.10.151.37]:31157 "HELO
	nm21-vm6.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751982Ab2HGOAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:00:05 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Aug 2012 10:00:05 EDT
X-Yahoo-Newman-Id: 152365.46462.bm@smtp161.mail.sg3.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: kZehevkVM1mPpn7FM48qUIIFJU9ze9O23fscGjYpbP.Nta1
 epWpmOkLkPPZxiAMl0abdSHO1o7ORFcZCp8rt_O5ko4FfGVf3q_DQhhnaZwE
 2xMG.HrtgoC9uMhaBGTc1GARSOzfjJs7ZFSmpVJSAOrdhL5e9mIm7B27ryrf
 hdzgsgZD1H_LreEwsldQ9Lps7Hf0NfCw9U7.v7V_Rc3f25eJpLEL9s7txM9R
 9j_MShyrKtDvCZeqAG9LqLfUbX8XSZON6Mnzmv0H3GhCCDy7a7T9rLoSH.Vj
 Us1cdW1mm3zGd.CyKA5wz25qsGMv7Eotaf7qMbI0FSaOMf3ewkVkRScHQarR
 1ln4umvGfaOIaafbghSneBbk4zESMqahwGPQLrTKKIy0REetM8Zr0U8Hvz4_
 5x.SEL7K3_NAbdGwHYFK5_kyx7Ux.I7l_15esU51nVr52zfdCnYd6i48tTBg
 S1VJyJdHjy8VrR2iDju_z3DRvVauO
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: acme@ghostprotocols.net, davem@davemloft.net, bhutchings@solarflare.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeffrin Jose <ahiliation@yahoo.co.in>
Subject: [PATCH] net:appletalk:ddp:fixed coding style issue again relating to
Date: Tue,  7 Aug 2012 19:30:20 +0530
Message-Id: <1344348020-4966-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue relating to indentation in
net/appletalk/ddp.c found by checkpatch.pl tool

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/appletalk/ddp.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 4023fca..2cf1054 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1797,39 +1797,39 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 		/* Protocol layer */
 	case TIOCOUTQ: {
-			long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
+		long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
 
-			if (amount < 0)
-				amount = 0;
-			rc = put_user(amount, (int __user *)argp);
-			break;
+		if (amount < 0)
+			amount = 0;
+		rc = put_user(amount, (int __user *)argp);
+		break;
 		}
 	case TIOCINQ: {
 			/*
 			 * These two are safe on a single CPU system as only
 			 * user tasks fiddle here
 			 */
-			struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
-			long amount = 0;
+		struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
+		long amount = 0;
 
-			if (skb)
-				amount = skb->len - sizeof(struct ddpehdr);
+		if (skb)
+			amount = skb->len - sizeof(struct ddpehdr);
 			rc = put_user(amount, (int __user *)argp);
 			break;
 		}
 	case SIOCGSTAMP:
-			rc = sock_get_timestamp(sk, argp);
-			break;
+		rc = sock_get_timestamp(sk, argp);
+		break;
 	case SIOCGSTAMPNS:
-			rc = sock_get_timestampns(sk, argp);
-			break;
+		rc = sock_get_timestampns(sk, argp);
+		break;
 		/* Routing */
 	case SIOCADDRT:
 	case SIOCDELRT:
-			rc = -EPERM;
-			if (capable(CAP_NET_ADMIN))
-				rc = atrtr_ioctl(cmd, argp);
-			break;
+		rc = -EPERM;
+		if (capable(CAP_NET_ADMIN))
+			rc = atrtr_ioctl(cmd, argp);
+		break;
 		/* Interface */
 	case SIOCGIFADDR:
 	case SIOCSIFADDR:
@@ -1838,10 +1838,10 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	case SIOCDIFADDR:
 	case SIOCSARP:		/* proxy AARP */
 	case SIOCDARP:		/* proxy AARP */
-			rtnl_lock();
-			rc = atif_ioctl(cmd, argp);
-			rtnl_unlock();
-			break;
+		rtnl_lock();
+		rc = atif_ioctl(cmd, argp);
+		rtnl_unlock();
+		break;
 	}
 
 	return rc;
-- 
1.7.10

