Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1G3EPc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:15:32 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:50605 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752274Ab1G3EP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:15:28 -0400
Date: Fri, 29 Jul 2011 21:14:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
        linux-pm@lists.linux-foundation.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] x86/platform: mrst/pmu.c needs module.h
Message-Id: <20110729211459.148eb8cc.rdunlap@xenotime.net>
In-Reply-To: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

mrst/pmu.c uses interfaces from linux/module.h, so it should
include that file.  This fixes build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/platform/mrst/pmu.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110729.orig/arch/x86/platform/mrst/pmu.c
+++ linux-next-20110729/arch/x86/platform/mrst/pmu.c
@@ -21,6 +21,7 @@
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/seq_file.h>
 #include <linux/sfi.h>
