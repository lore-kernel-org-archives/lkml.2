Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab2JWUGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:06:03 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46551 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814Ab2JWUGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:06:00 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: [PATCH 168/193] net/ipv4: remove CONFIG_EXPERIMENTAL
Date: Tue, 23 Oct 2012 13:04:01 -0700
Message-Id: <1351022666-6960-169-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351022666-6960-1-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config item has not carried much meaning for a while now and is
almost always enabled by default. As agreed during the Linux kernel
summit, remove it.

CC: "David S. Miller" <davem@davemloft.net>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: James Morris <jmorris@namei.org>
CC: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/ipv4/Kconfig |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 5a19aeb..7944df7 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -488,7 +488,6 @@ config TCP_CONG_HTCP
 
 config TCP_CONG_HSTCP
 	tristate "High Speed TCP"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	Sally Floyd's High Speed TCP (RFC 3649) congestion control.
@@ -499,7 +498,6 @@ config TCP_CONG_HSTCP
 
 config TCP_CONG_HYBLA
 	tristate "TCP-Hybla congestion control algorithm"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP-Hybla is a sender-side only change that eliminates penalization of
@@ -509,7 +507,6 @@ config TCP_CONG_HYBLA
 
 config TCP_CONG_VEGAS
 	tristate "TCP Vegas"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Vegas is a sender-side only change to TCP that anticipates
@@ -520,7 +517,6 @@ config TCP_CONG_VEGAS
 
 config TCP_CONG_SCALABLE
 	tristate "Scalable TCP"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	Scalable TCP is a sender-side only change to TCP which uses a
@@ -530,7 +526,6 @@ config TCP_CONG_SCALABLE
 
 config TCP_CONG_LP
 	tristate "TCP Low Priority"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Low Priority (TCP-LP), a distributed algorithm whose goal is
@@ -540,7 +535,6 @@ config TCP_CONG_LP
 
 config TCP_CONG_VENO
 	tristate "TCP Veno"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP Veno is a sender-side only enhancement of TCP to obtain better
@@ -552,7 +546,6 @@ config TCP_CONG_VENO
 
 config TCP_CONG_YEAH
 	tristate "YeAH TCP"
-	depends on EXPERIMENTAL
 	select TCP_CONG_VEGAS
 	default n
 	---help---
@@ -567,7 +560,6 @@ config TCP_CONG_YEAH
 
 config TCP_CONG_ILLINOIS
 	tristate "TCP Illinois"
-	depends on EXPERIMENTAL
 	default n
 	---help---
 	TCP-Illinois is a sender-side modification of TCP Reno for
@@ -631,8 +623,7 @@ config DEFAULT_TCP_CONG
 	default "cubic"
 
 config TCP_MD5SIG
-	bool "TCP: MD5 Signature Option support (RFC2385) (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "TCP: MD5 Signature Option support (RFC2385)"
 	select CRYPTO
 	select CRYPTO_MD5
 	---help---
-- 
1.7.9.5

