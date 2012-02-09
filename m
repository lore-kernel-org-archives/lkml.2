Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811Ab2BIORu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:17:50 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37525
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757787Ab2BIORs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:17:48 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: venkat.x.venkatsubra@oracle.com, rds-devel@oss.oracle.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] rds: Fix typo in iw_recv.c and ib_recv.c
Date: Thu,  9 Feb 2012 23:17:15 +0900
Message-Id: <1328797035-1650-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "inclue" to "include" in
net/rds/iw_recv.c and net/rds/ib_recv.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 net/rds/ib_recv.c |    2 +-
 net/rds/iw_recv.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 744a00d..8d19491 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -826,7 +826,7 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 
 	if (data_len < sizeof(struct rds_header)) {
 		rds_ib_conn_error(conn, "incoming message "
-		       "from %pI4 didn't inclue a "
+		       "from %pI4 didn't include a "
 		       "header, disconnecting and "
 		       "reconnecting\n",
 		       &conn->c_faddr);
diff --git a/net/rds/iw_recv.c b/net/rds/iw_recv.c
index 0bd9b5e..4503335 100644
--- a/net/rds/iw_recv.c
+++ b/net/rds/iw_recv.c
@@ -661,7 +661,7 @@ static void rds_iw_process_recv(struct rds_connection *conn,
 
 	if (byte_len < sizeof(struct rds_header)) {
 		rds_iw_conn_error(conn, "incoming message "
-		       "from %pI4 didn't inclue a "
+		       "from %pI4 didn't include a "
 		       "header, disconnecting and "
 		       "reconnecting\n",
 		       &conn->c_faddr);
-- 
1.7.6.5

