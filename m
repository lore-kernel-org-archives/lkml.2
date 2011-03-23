Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab1CWRkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:40:17 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:50142
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752378Ab1CWRkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:15 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/16] Staging: hv: Add the inclusion guard for vstorage.h
Date: Wed, 23 Mar 2011 10:50:19 -0700
Message-Id: <1300902635-1347-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902537-1290-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for getting rid of the inclusion of storvsc.c from
blkvsc.c, add inclusion guard to vstorage.h

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vstorage.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/vstorage.h b/drivers/staging/hv/vstorage.h
index ebb4d67..83060cd 100644
--- a/drivers/staging/hv/vstorage.h
+++ b/drivers/staging/hv/vstorage.h
@@ -25,6 +25,9 @@
 /* to alert the user that structure sizes may be mismatched even though the */
 /* protocol versions match. */
 
+#ifndef _VSTORAGE_H_
+#define _VSTORAGE_H_
+
 #define REVISION_STRING(REVISION_) #REVISION_
 #define FILL_VMSTOR_REVISION(RESULT_LVALUE_)				\
 	do {								\
@@ -190,3 +193,5 @@ struct vstor_packet {
 
 /*  This is the set of flags that the vsc can set in any packets it sends */
 #define VSC_LEGAL_FLAGS		(REQUEST_COMPLETION_FLAG)
+
+#endif /* _VSTORAGE_H_ */
-- 
1.7.4.1

