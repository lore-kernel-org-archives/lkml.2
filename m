Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab0IBVQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 17:16:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59003 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab0IBVOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 17:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=XnkuzwIX4560akg5y3gTgMq7u/ntJdQ2BHsz294iPoK7fOVVtZhblohfj9tkEbmBzs
         ideSJ9Zj6EAWytn6+2ZKzrGJ8CDCP/6HlQ8NzKj0FlCASoHZAtw8ETbDsMioA+1aOmxl
         8Oyun3QbcErK43OUK0LmXnhN/LaLcmcb1mqhY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, jkosina@suse.cz,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=2083/91=5D=20arch/powerpc/include/asm/hydra=2Eh=20Update=20broken=20web=20addresses=20in=20the=20arch=20directory=2E?=
Date: Thu,  2 Sep 2010 14:13:34 -0700
Message-Id: <1283462022-8024-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
References: <1283462022-8024-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch updates a broken web address that is no longer
working due to company buyout, and/or change of location.
(Please have a look through, and let me know if any of them
need to be changed, and I'll resend an updated patch).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/powerpc/include/asm/hydra.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/hydra.h b/arch/powerpc/include/asm/hydra.h
index 1ad4eed..d529a2c 100644
--- a/arch/powerpc/include/asm/hydra.h
+++ b/arch/powerpc/include/asm/hydra.h
@@ -10,7 +10,7 @@
  *
  *	© Copyright 1995 Apple Computer, Inc. All rights reserved.
  *
- *  It's available online from http://chrp.apple.com/MacTech.pdf.
+ *  It's available online from http://www.cpu.lu/~mlan/ftp/MacTech.pdf.
  *  You can obtain paper copies of this book from computer bookstores or by
  *  writing Morgan Kaufmann Publishers, Inc., 340 Pine Street, Sixth Floor, San
  *  Francisco, CA 94104. Reference ISBN 1-55860-393-X.
-- 
1.7.2.1

