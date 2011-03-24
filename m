Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab1CXUTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:06 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56204 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1CXUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:18:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wzDrui4olStqWkA2R46Flu1zTchLZSF/9COrMPoCJlYFCAcPUmm/Mg8jrLmwUjEUkt
         WhsmB00FSL+GO9UjAeyB2f8oTQQem6jZcYQRX6pJFBoS5PBfrQySw6VU8o/rxFmuvUmi
         qy0/Z0w7t+ZhRSwy+0cuidz/uedgV91Cm4gJ8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 04/21]arch:s390:hypfs:hypfs.h Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:23 -0700
Message-Id: <1300997920-31573-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/s390/hypfs/hypfs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/s390/hypfs/hypfs.h b/arch/s390/hypfs/hypfs.h
index 80c1526..d9df5a0 100644
--- a/arch/s390/hypfs/hypfs.h
+++ b/arch/s390/hypfs/hypfs.h
@@ -47,7 +47,7 @@ struct hypfs_dbfs_data {
 	void			*buf;
 	void			*buf_free_ptr;
 	size_t			size;
-	struct hypfs_dbfs_file	*dbfs_file;;
+	struct hypfs_dbfs_file	*dbfs_file;
 	struct kref		kref;
 };
 
-- 
1.7.4.1

