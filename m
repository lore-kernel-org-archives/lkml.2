Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1G3EP2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 00:15:28 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:45388 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752091Ab1G3EPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 00:15:21 -0400
Date: Fri, 29 Jul 2011 21:14:12 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH -next] sound: rtctimer.c needs module.h
Message-Id: <20110729211412.f064a06c.rdunlap@xenotime.net>
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

rtctimer.c uses interfaces from linux/module.h, so it should
include that file.  This fixes build errors.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 sound/core/rtctimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110729.orig/sound/core/rtctimer.c
+++ linux-next-20110729/sound/core/rtctimer.c
@@ -22,7 +22,7 @@
 
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/moduleparam.h>
+#include <linux/module.h>
 #include <linux/log2.h>
 #include <sound/core.h>
 #include <sound/timer.h>
