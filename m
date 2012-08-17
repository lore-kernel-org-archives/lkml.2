Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525Ab2HQBQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:16:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:48434
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933117Ab2HQBPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:15:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        olaf@aepfle.de, apw@canonical.com, ben@decadent.org.uk
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V3 13/14] Tools: hv: Get rid of some unused variables
Date: Thu, 16 Aug 2012 18:32:24 -0700
Message-Id: <1345167145-5513-13-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1345167145-5513-1-git-send-email-kys@microsoft.com>
References: <1345167068-5461-1-git-send-email-kys@microsoft.com>
 <1345167145-5513-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unused variables.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 tools/hv/hv_kvp_daemon.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index e7db9ac..4a1428c 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -211,7 +211,7 @@ static void kvp_update_mem_state(int pool)
 }
 static int kvp_file_init(void)
 {
-	int ret, fd;
+	int  fd;
 	FILE *filep;
 	size_t records_read;
 	__u8 *fname;
@@ -327,7 +327,6 @@ static int kvp_key_add_or_modify(int pool, __u8 *key, int key_size, __u8 *value,
 			int value_size)
 {
 	int i;
-	int j, k;
 	int num_records;
 	struct kvp_record *record;
 	int num_blocks;
-- 
1.7.4.1

