Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab2ITPLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:11:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab2ITPLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:11:40 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH V2 10/10] SELinux: define mapping for new Secure Boot capability
Date: Thu, 20 Sep 2012 10:41:05 -0400
Message-Id: <1348152065-31353-11-git-send-email-mjg@redhat.com>
In-Reply-To: <1348152065-31353-1-git-send-email-mjg@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

Add the name of the new Secure Boot capability.  This allows SELinux
policies to properly map CAP_COMPROMISE_KERNEL to the appropriate
capability class.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 security/selinux/include/classmap.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index df2de54..70e2834 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -146,8 +146,8 @@ struct security_class_mapping secclass_map[] = {
 	{ "memprotect", { "mmap_zero", NULL } },
 	{ "peer", { "recv", NULL } },
 	{ "capability2",
-	  { "mac_override", "mac_admin", "syslog", "wake_alarm", "block_suspend",
-	    NULL } },
+	  { "mac_override", "mac_admin", "syslog", "wake_alarm",
+	    "block_suspend", "compromise_kernel", NULL } },
 	{ "kernel_service", { "use_as_override", "create_files_as", NULL } },
 	{ "tun_socket",
 	  { COMMON_SOCK_PERMS, NULL } },
-- 
1.7.11.4

