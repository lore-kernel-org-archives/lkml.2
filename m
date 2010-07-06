Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0GFM3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 08:29:54 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34600 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0GFM3x (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com:0:0>);
	Tue, 6 Jul 2010 08:29:53 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: remove unused ip_address field in struct TCP_Server_Info
Date: Tue,  6 Jul 2010 17:59:46 +0530
Message-Id: <1278419386-8118-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ip_address field is not used and seems redundant as there is union addr
already and I don't see any future use as well.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/cifsglob.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a88479c..f182fe8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -142,7 +142,6 @@ struct TCP_Server_Info {
 	struct list_head pending_mid_q;
 	void *Server_NlsInfo;	/* BB - placeholder for future NLS info  */
 	unsigned short server_codepage;	/* codepage for the server    */
-	unsigned long ip_address;	/* IP addr for the server if known */
 	enum protocolEnum protocolType;
 	char versionMajor;
 	char versionMinor;
