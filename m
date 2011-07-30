Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab1G3BE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 21:04:28 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:56952 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752588Ab1G3BE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 21:04:26 -0400
Date: Fri, 29 Jul 2011 18:04:22 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] x86: devicetree.h needs export.h
Message-Id: <20110729180422.07355fdb.rdunlap@xenotime.net>
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

devicetree.c needs to include linux/export.h to fix build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/kernel/devicetree.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110729.orig/arch/x86/kernel/devicetree.c
+++ linux-next-20110729/arch/x86/kernel/devicetree.c
@@ -2,6 +2,7 @@
  * Architecture specific OF callbacks.
  */
 #include <linux/bootmem.h>
+#include <linux/export.h>
 #include <linux/io.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
