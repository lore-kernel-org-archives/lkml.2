Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab1G1Pun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 11:50:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537Ab1G1Pui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 11:50:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 07/40] UAPI: Fix AHZ multiple inclusion when __KERNEL__ is
 removed [ver #3]
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Date: Thu, 28 Jul 2011 16:50:31 +0100
Message-ID: <20110728155031.16618.33620.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
References: <20110728154920.16618.89358.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/acct.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/acct.h b/include/linux/acct.h
index 3e4737f..d537aa0 100644
--- a/include/linux/acct.h
+++ b/include/linux/acct.h
@@ -146,6 +146,9 @@ extern void acct_exit_ns(struct pid_namespace *);
  *
  */
 
+#undef ACCT_VERSION
+#undef AHZ
+
 #ifdef CONFIG_BSD_PROCESS_ACCT_V3
 #define ACCT_VERSION	3
 #define AHZ		100

