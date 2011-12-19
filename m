Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1LSThX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:37:23 -0500
Received: from smtp.outflux.net ([198.145.64.163]:41749 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145Ab1LSThV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:37:21 -0500
Date: Mon, 19 Dec 2011 11:32:56 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] security: update security_file_mmap() docs
Message-ID: <20111219193256.GA9709@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This documents the fields added to security_file_mmap() that were
introduced in ed0321895182ffb6ecf210e066d87911b270d587.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/security.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index 256befc..57f4bfe 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -590,6 +590,8 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	@reqprot contains the protection requested by the application.
  *	@prot contains the protection that will be applied by the kernel.
  *	@flags contains the operational flags.
+ *	@addr contains virtual address that will be used for the operation.
+ *	@addr_only contains a boolean: 0 if file-backed VMA, otherwise 1.
  *	Return 0 if permission is granted.
  * @file_mprotect:
  *	Check permissions before changing memory access permissions.
-- 
1.7.0.4

