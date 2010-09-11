Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0IKFqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 01:46:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44991 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0IKFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 01:45:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aHqMQVS6T7+SR6Pnfpqhsr8WhUAJwI8hTdpdbzlzd0QGVAZF89JFbaIRyGvZaLQUDV
         +5WsLW9kQXKu2EjsdhQs0T88LOUrmo5lGZIFQiotGNqefRNZFI7uPnVvHpA8T0B1g+x4
         uOP23dksHDgu9JCSgx6MhPK28wNdHDkkrWdwQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 10/11]net/ipv4/tcp_westwood.c Update broken web addresses.
Date: Fri, 10 Sep 2010 22:46:02 -0700
Message-Id: <1284183963-8474-10-git-send-email-justinmattock@gmail.com>
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
 net/ipv4/tcp_westwood.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/tcp_westwood.c b/net/ipv4/tcp_westwood.c
index 20151d6..bbf0e99 100644
--- a/net/ipv4/tcp_westwood.c
+++ b/net/ipv4/tcp_westwood.c
@@ -3,7 +3,7 @@
  *
  *      Angelo Dell'Aera: author of the first version of TCP Westwood+ in Linux 2.4
  *
- * Support at http://c3lab.poliba.it/index.php/Westwood
+ * Support at http://www.cs.ucla.edu/NRL/hpi/tcpw/ 
  * Main references in literature:
  *
  * - Mascolo S, Casetti, M. Gerla et al.
-- 
1.7.2.1

