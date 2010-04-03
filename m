Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0DCBnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 21:43:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34783 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831Ab0DCBne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 21:43:34 -0400
Date: Sat, 3 Apr 2010 12:43:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05a/17] v4l-dvb: update gfp/slab.h includes
Message-Id: <20100403124331.f6d073cb.sfr@canb.auug.org.au>
In-Reply-To: <20100403123629.d1148066.sfr@canb.auug.org.au>
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
	<1269885165-18617-6-git-send-email-tj@kernel.org>
	<20100403123629.d1148066.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
gfp.h or slab.h is included as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---
 drivers/staging/tm6000/tm6000-alsa.c             |    1 +
 drivers/staging/tm6000/tm6000-cards.c            |    1 +
 drivers/staging/tm6000/tm6000-core.c             |    1 +
 drivers/staging/tm6000/tm6000-dvb.c              |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

Just the v4l-dvb split our part of what was the staging tree patch.

diff --git a/drivers/staging/tm6000/tm6000-alsa.c b/drivers/staging/tm6000/tm6000-alsa.c
index bc89f9d..3404516 100644
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@ -15,6 +15,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/usb.h>
+#include <linux/slab.h>
 
 #include <asm/delay.h>
 #include <sound/core.h>
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 2053008..2935533 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -24,6 +24,7 @@
 #include <linux/i2c.h>
 #include <linux/usb.h>
 #include <linux/version.h>
+#include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 #include <media/tvaudio.h>
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index d9cade0..2ae7ae0 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -22,6 +22,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include "tm6000.h"
diff --git a/drivers/staging/tm6000/tm6000-dvb.c b/drivers/staging/tm6000/tm6000-dvb.c
index 1072206..dfba5e6 100644
--- a/drivers/staging/tm6000/tm6000-dvb.c
+++ b/drivers/staging/tm6000/tm6000-dvb.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 
 #include "tm6000.h"
-- 
1.6.4.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
