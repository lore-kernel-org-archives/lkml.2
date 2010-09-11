Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0IKFpu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:45:50 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56070 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab0IKFpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cr0rd4qY7/73n8a0oQUVWAdOz3U1oY3XNttVRs1ZE4rsMuR6yu9GTPugpnmijM/P8S
         LzahOnygQaacNvGpyij510LBo1XeRHZe7lGbgzCrqubAac86e0pdjLOErvbzULNrCIIG
         LYIRfnsZG/YhIOTUhZPfW4qJZPQS1XBTyPsdw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 05/11]net/ipv4/tcp_lp.c Update broken web addresses.
Date: Fri, 10 Sep 2010 22:45:57 -0700
Message-Id: <1284183963-8474-5-git-send-email-justinmattock@gmail.com>
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
 net/ipv4/tcp_lp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp_lp.c b/net/ipv4/tcp_lp.c
index de87037..b88c17b 100644
--- a/net/ipv4/tcp_lp.c
+++ b/net/ipv4/tcp_lp.c
@@ -22,7 +22,7 @@
  * Original Author:
  *   Aleksandar Kuzmanovic <akuzma@northwestern.edu>
  * Available from:
- *   http://www.ece.rice.edu/~akuzma/Doc/akuzma/TCP-LP.pdf
+ *   http://web.archive.org/web/*/http://www.ece.rice.edu/~akuzma/Doc/akuzma/TCP-LP.pdf 
  * Original implementation for 2.4.19:
  *   http://www-ece.rice.edu/networks/TCP-LP/
  *
-- 
1.7.2.1

