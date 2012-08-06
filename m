Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2HFRZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 13:25:34 -0400
Received: from nm27-vm8.bullet.mail.sg3.yahoo.com ([106.10.151.135]:22826 "HELO
	nm27-vm8.bullet.mail.sg3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753721Ab2HFRZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 13:25:32 -0400
X-Yahoo-Newman-Id: 914100.30270.bm@smtp161.mail.sg3.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: egmDEZ0VM1kTv3Q0hEx7JZYpdtVxSuH7Kq23vRvCzMmW5xC
 CJJb4urvAJZ_gYVhI6hguJo69hIOR5f3GjkqN_ogZCAjA0ZBicqs_YhdWn3b
 S3SVyM3zXldXsK4lzlMSfsJDKrVq6R_IHb7qVoTq3Gnj3DhioxLt_Gl1XVeT
 vUjSFYNQrFgo5z.i.OpTuz.HcXapz9EScfdE8oQBv4F3KYqignqbds_Kzf4R
 DBnAOlrYkqCRykUKuDZDjskhQLeuAFeK6xy5r4rnm6x01bcCoioAjzgNt6CQ
 LXuPTI2idQaFEwYsIZlnu1sIJs4XKoQhFlZ9pjsnhLJ98aIR6NnCrYfCnn8g
 00U6apAjcHEsEIlHrH8WT3bleYRBBnjkzyULe0LbJdZGPGpfkyq7VrJHhcOE
 uvsacR90UbUzC3rw431Vh_UB7PJza1p3bFjCkM4MLpt4qJ0rD7NPFQ5E4Q8D
 EHbRzKzAcD27ruZA9.Jxacv_VH8th
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: acme@ghostprotocols.net, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeffrin Jose <ahiliation@yahoo.co.in>
Subject: [PATCH] net:appletalk:ddp:fixed coding style issue relating to
Date: Mon,  6 Aug 2012 23:01:38 +0530
Message-Id: <1344274298-4711-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue relating to indentation
in net/appletalk/ddp.c found by checkpatch.pl tool.

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/appletalk/ddp.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index 8685296..4023fca 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1796,7 +1796,7 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 
 	switch (cmd) {
 		/* Protocol layer */
-		case TIOCOUTQ: {
+	case TIOCOUTQ: {
 			long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
 
 			if (amount < 0)
@@ -1804,7 +1804,7 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			rc = put_user(amount, (int __user *)argp);
 			break;
 		}
-		case TIOCINQ: {
+	case TIOCINQ: {
 			/*
 			 * These two are safe on a single CPU system as only
 			 * user tasks fiddle here
@@ -1817,27 +1817,27 @@ static int atalk_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
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

