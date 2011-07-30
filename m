Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab1G3EQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:16:07 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51234 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752846Ab1G3EPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:15:25 -0400
Date: Fri, 29 Jul 2011 21:14:41 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] input: mouse/hgpk.c needs module.h
Message-Id: <20110729211441.5de62eca.rdunlap@xenotime.net>
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

hgpk.c uses interfaces from linux/module.h, so it should
include that file.  This fixes build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/input/mouse/hgpk.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110729.orig/drivers/input/mouse/hgpk.c
+++ linux-next-20110729/drivers/input/mouse/hgpk.c
@@ -32,6 +32,7 @@
 #define DEBUG
 #include <linux/slab.h>
 #include <linux/input.h>
+#include <linux/module.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
 #include <linux/delay.h>
