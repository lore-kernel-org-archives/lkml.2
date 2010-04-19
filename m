Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0DSBJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 21:09:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36632 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0DSBJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 21:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VChmq49lF9zgCg6f5Fq41aXj9Gb1Gxd45PWPkKvOzWmSrjirviK6njbcD/JeDvHLUl
         FlFxM9H7rumtdloRdbkaSdGr5F+s+NLOm81uBpUGlMjf0vLYJ13QOX+cXb51pPY687Yq
         nc+4tAMBgZyj1XD6YNudYUbwUzlRY4KZIi+pg=
Date: Mon, 19 Apr 2010 09:16:17 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, eparis@parisplace.org,
       jmorris@namei.org
Subject: [PATCH] Security: Fix the comment of cap_file_mmap()
Message-ID: <20100419011617.GB22615@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the comment of cap_file_mmap(), replace mmap_min_addr to be dac_mmap_min_addr.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/commoncap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 6166973..c45c4d2 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -931,7 +931,7 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
  * @addr: address attempting to be mapped
  * @addr_only: unused
  *
- * If the process is attempting to map memory below mmap_min_addr they need
+ * If the process is attempting to map memory below dac_mmap_min_addr they need
  * CAP_SYS_RAWIO.  The other parameters to this function are unused by the
  * capability security module.  Returns 0 if this mapping should be allowed
  * -EPERM if not.
-- 
1.6.5.3

