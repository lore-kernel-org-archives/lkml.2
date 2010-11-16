Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab0KPFRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:17:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1419 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab0KPFR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:17:29 -0500
Subject: [PATCH] kernel/sysctl.c: Fix build failure with !CONFIG_PRINTK
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201011160259.oAG2x1UX012045@hera.kernel.org>
References: <201011160259.oAG2x1UX012045@hera.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 21:17:27 -0800
Message-ID: <1289884647.16461.186.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sigh...

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b65bf63..5abfa15 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -702,7 +702,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
-#endif
 	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
@@ -712,6 +711,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,


