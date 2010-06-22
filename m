Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0FVPnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 11:43:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41538 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0FVPn2 (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com:0:0>);
	Tue, 22 Jun 2010 11:43:28 -0400
From: Suresh Jayaraman <sjayaraman@suse.de>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [RFC][PATCH 02/10] cifs: guard cifsglob.h against multiple inclusion
Date: Tue, 22 Jun 2010 20:52:50 +0530
Message-Id: <1277220170-3442-1-git-send-email-sjayaraman@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add conditional compile macros to guard the header file against multiple
inclusion.

Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
---
 fs/cifs/cifsglob.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a88479c..6b2c39d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -16,6 +16,9 @@
  *   the GNU Lesser General Public License for more details.
  *
  */
+#ifndef _CIFS_GLOB_H
+#define _CIFS_GLOB_H
+
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/slab.h>
@@ -733,3 +736,5 @@ GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
 GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
 extern const struct slow_work_ops cifs_oplock_break_ops;
+
+#endif	/* _CIFS_GLOB_H */
-- 
1.6.4.2

