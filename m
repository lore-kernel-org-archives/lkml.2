Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1G3EPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:15:53 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:50361 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751279Ab1G3EP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:15:26 -0400
Date: Fri, 29 Jul 2011 21:14:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andres Salomon <dilinger@queued.net>, linux-geode@lists.infradead.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] x86/platform: geode/alix.c needs module.h
Message-Id: <20110729211451.b3dd3bfa.rdunlap@xenotime.net>
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

geode/alix.c uses interfaces from linux/module.h, so it should
include that file.  This fixes build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 arch/x86/platform/geode/alix.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110729.orig/arch/x86/platform/geode/alix.c
+++ linux-next-20110729/arch/x86/platform/geode/alix.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/module.h>
 #include <linux/string.h>
 #include <linux/leds.h>
 #include <linux/platform_device.h>
