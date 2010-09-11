Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0IKFp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:45:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56070 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab0IKFpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NyWWhx79/s9U2S5do9hfheiOrvNenpWxSFyjexh4yePDr0mZk33HkhyrROfgvsgJ1q
         TKWdbRX7h6hraT++TonYa0DLuXmm2CONsRUe3yc+M9yCuHKRDLkE1IuSFXXdJd1p7+47
         FfSkGH5ePtl7crZZqVVN4VvFC1unTVrIhkeGE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 09/11]net/ipv4/Kconfig Update broken web addresses.
Date: Fri, 10 Sep 2010 22:46:01 -0700
Message-Id: <1284183963-8474-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
References: <1284183963-8474-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 net/ipv4/Kconfig |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 7c3a7d1..72ea424 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -84,7 +84,7 @@ config IP_FIB_TRIE
 
 	  An experimental study of compression methods for dynamic tries
 	  Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
-	  http://www.nada.kth.se/~snilsson/public/papers/dyntrie2/
+	  http://www.kth.se/csc 
 
 endchoice
 
@@ -271,8 +271,8 @@ config IP_PIMSM_V1
 	  Kernel side support for Sparse Mode PIM (Protocol Independent
 	  Multicast) version 1. This multicast routing protocol is used widely
 	  because Cisco supports it. You need special software to use it
-	  (pimd-v1). Please see <http://netweb.usc.edu/pim/> for more
-	  information about PIM.
+	  (pimd-v1). Information is at: 
+	  http://web.archive.org/web/*/http://netweb.usc.edu/pim/.
 
 	  Say Y if you want to use PIM-SM v1. Note that you can say N here if
 	  you just want to use Dense Mode PIM.
@@ -555,7 +555,7 @@ config TCP_CONG_VENO
 	distinguishing to circumvent the difficult judgment of the packet loss
 	type. TCP Veno cuts down less congestion window in response to random
 	loss packets.
-	See http://www.ntu.edu.sg/home5/ZHOU0022/papers/CPFu03a.pdf
+	See http://www.ntu.edu.sg/Pages/default.aspx 
 
 config TCP_CONG_YEAH
 	tristate "YeAH TCP"
@@ -583,7 +583,7 @@ config TCP_CONG_ILLINOIS
 	throughput and maintain fairness.
 
 	For further details see:
-	  http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html
+	 http://web.archive.org/web/*/http://www.ews.uiuc.edu/~shaoliu/tcpillinois/index.html 
 
 choice
 	prompt "Default TCP congestion control"
-- 
1.7.2.1

