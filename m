Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0JGXwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:52:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58208 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0JGXwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:52:42 -0400
Date: Thu, 7 Oct 2010 23:52:24 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, jacob.jun.pan@linux.intel.com
In-Reply-To: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: A function in a header file needs to be marked "inline"
Message-ID: <tip-55572b293b3a5929e8c54bc91d14ae6264186bf6@git.kernel.org>
Git-Commit-ID: 55572b293b3a5929e8c54bc91d14ae6264186bf6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 07 Oct 2010 23:52:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55572b293b3a5929e8c54bc91d14ae6264186bf6
Gitweb:     http://git.kernel.org/tip/55572b293b3a5929e8c54bc91d14ae6264186bf6
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 7 Oct 2010 16:42:54 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 7 Oct 2010 16:45:18 -0700

x86, mrst: A function in a header file needs to be marked "inline"

A function in a header file needs to be explicitly marked "inline", or
gcc will complain if it is not used.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: <stable@kernel.org> v2.6.36
LKML-Reference: <1274295685-6774-3-git-send-email-jacob.jun.pan@linux.intel.com>
---
 arch/x86/include/asm/mrst.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
index 1635074..33fc296 100644
--- a/arch/x86/include/asm/mrst.h
+++ b/arch/x86/include/asm/mrst.h
@@ -26,7 +26,7 @@ enum mrst_cpu_type {
 };
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
-static enum mrst_cpu_type mrst_identify_cpu(void)
+static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
